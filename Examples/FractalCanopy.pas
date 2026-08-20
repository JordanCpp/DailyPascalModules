{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteFractalTreeDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, DegToRad
  PixelPainter,
  PixelCopier,
  WinLiteEnums,
  WinLiteEvents,
  WinLiteWindow,
  BmpLoader;

const
  WinWidth      = 800;
  WinHeight     = 600;
  BytesPerPixel = 4;

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Recursive helper procedure to calculate and draw individual branches
==============================================================================}
procedure DrawBranch(var Painter: TPixelPainter; X, Y: Double; Angle, Length: Double; Depth: Integer);
var
  XEnd, YEnd: Double;
  R, G, B: Byte;
begin
  // Base case: stop recursion when maximum depth is reached
  if Depth = 0 then Exit;

  // Calculate the end coordinates of the current branch
  // Note: Y decreases because in computer graphics Y goes down from the top
  XEnd := X + Cos(Angle) * Length;
  YEnd := Y - Sin(Angle) * Length;

  // Procedural coloring: branches fade from brown (trunk) to vibrant green (leaves)
  if Depth > 4 then
  begin
    R := 139 - (Depth * 5);
    G := 69 + (Depth * 2);
    B := 19;
  end
  else
  begin
    R := 34 + (Depth * 10);
    G := 139 + (Depth * 20);
    B := 34;
  end;

  Painter.SetColor(MakeColor(R, G, B));

  // Draw the actual branch line
  Painter.Line(Round(X), Round(Y), Round(XEnd), Round(YEnd));

  // Recursively spawn left and right branches with reduced length and specific angles
  DrawBranch(Painter, XEnd, YEnd, Angle + 0.38, Length * 0.76, Depth - 1);
  DrawBranch(Painter, XEnd, YEnd, Angle - 0.32, Length * 0.72, Depth - 1);
end;

{==============================================================================
  Renders the Animated Fractal Tree canopy effect via TPixelPainter
==============================================================================}
procedure RenderFractalTree(var Painter: TPixelPainter; Frame: Integer);
var
  WindAngle: Double;
begin
  // Clear the screen with a smooth dark slate background
  Painter.SetColor(MakeColor(15, 18, 24));
  Painter.Clear;

  // Simulate wind forces slightly swaying the base angle using a sine wave over time
  WindAngle := DegToRad(90.0) + Sin(Frame * 0.04) * 0.06;

  // Start drawing from the bottom-center of the screen
  // Initial branch length = 135.0 pixels, recursion depth = 11 levels
  DrawBranch(Painter, Painter.GetWidth div 2, Painter.GetHeight - 15, WindAngle, 135.0, 11);
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  // 1. Initialize the graphical window
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Generative Fractal Canopy');

  // 2. Allocate memory for the pixel buffer array
  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // 3. Initialize the painter object linked to the allocated buffer
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  // 4. Main render loop and system event handling
  while Window.IsRunning do
  begin
    // Process the operating system message queue
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            // Exit application when the Escape key is pressed
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;
      end;
    end;

    // Increment animation frame step
    Inc(FrameCounter);

    // Call the procedural fractal tree renderer
    RenderFractalTree(Render, FrameCounter);

    // Swap buffers: Present the complete PixelBuffer to the physical screen
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up resources and close window subsystems
  Window.Done;
end.
