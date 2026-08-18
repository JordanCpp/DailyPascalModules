{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMoireDemo;

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
  WinLiteSoftwareWindow,
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
  Renders the Colorful Moire interference pattern effect via TPixelPainter
==============================================================================}
procedure RenderMoire(var Painter: TPixelPainter; Frame: Integer);
var
  I: Integer;
  CX1, CY1, CX2, CY2: Integer;
  W, H: Integer;
  X, Y: Integer;
  Angle: Double;
  R, G, B: Byte;
begin
  // Clear the screen with solid black to make neon colors pop out
  Painter.SetColor(MakeColor(10, 10, 15));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;

  // 1. The first light center is static, positioned at the left third of the screen
  CX1 := W div 3;
  CY1 := H div 2;

  // 2. The second center rotates dynamically in an orbit around the screen center
  CX2 := (W div 2) + Round(Cos(Frame * 0.020) * 140.0);
  CY2 := (H div 2) + Round(Sin(Frame * 0.020) * 140.0);

  // Draw a fan of thin rays from both centers to full length.
  for I := 0 to 179 do
  begin
    Angle := DegToRad(I * 2.0);

    // Calculate line end offset (1200 pixels guarantees lines extend past screen bounds)
    X := Round(Cos(Angle) * 1200.0);
    Y := Round(Sin(Angle) * 1200.0);

    // --- Dynamic Color Generation ---
    // Calculate smooth RGB shifts based on the ray's angle and current frame
    R := Round((Sin(Angle + Frame * 0.03) + 1.0) * 127.5);
    G := Round((Sin(Angle + Frame * 0.02 + 2.0) + 1.0) * 127.5);
    B := Round((Cos(Angle - Frame * 0.01 + 4.0) + 1.0) * 127.5);

    // Draw ray from the first (stationary) center
    Painter.SetColor(MakeColor(R, G, B));
    Painter.Line(CX1, CY1, CX1 + X, CY1 + Y);

    // Draw ray from the second (moving) center with slightly inverted colors for extra depth
    Painter.SetColor(MakeColor(B, R, G));
    Painter.Line(CX2, CY2, CX2 + X, CY2 + Y);
  end;
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

  Window.SetTitle('WinLite Software Render - Colorful Moire Pattern');

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

    // Call the procedural optical effect renderer
    RenderMoire(Render, FrameCounter);

    // Swap buffers: Present the complete PixelBuffer to the physical screen
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up resources and close window subsystems
  Window.Done;
end.
