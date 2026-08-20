{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMatrixRainDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Min
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
  MaxDrops      = 45; // Maximum number of simultaneously falling rain drops

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Renders the Matrix digital rain falling stream effect via TPixelPainter
==============================================================================}
procedure RenderMatrixRain(var Painter: TPixelPainter; Frame: Integer);
var
  I, DropX, DropY, Len, Bright, Step: Integer;
  FinalGreen: Integer;
begin
  // Clear the canvas with a very deep dark green tone to simulate monitor glow
  Painter.SetColor(MakeColor(0, 4, 1));
  Painter.Clear;

  // Fix the random number generator seed at the beginning of each frame.
  // This is critical to ensure the same drops consistently move down the columns
  // instead of randomly flashing and teleporting all over the screen.
  RandSeed := 1999;

  for I := 0 to MaxDrops - 1 do
  begin
    // Align drops horizontally to a discrete grid with 16-pixel increments plus offset
    DropX := Random(Painter.GetWidth div 16) * 16 + 8;

    // Randomize the length of the trailing fade tail for each drop
    Len := 60 + Random(140);

    // Calculate the Y coordinate based on time.
    // Multiplying by (3 + Random(4)) injects a unique falling velocity per drop.
    Step := Frame * (3 + Random(4));
    DropY := (Random(Painter.GetHeight) + Step) mod (Painter.GetHeight + Len) - Len;

    // Draw the decaying trail segments with a green color gradient
    for Bright := 0 to Len div 5 do
    begin
      // Safely clamp color intensity to prevent Byte overflow range errors
      FinalGreen := Min(255, Bright * 6);
      Painter.SetColor(MakeColor(0, FinalGreen, 0));
      Painter.Line(DropX, DropY + Bright * 5, DropX, DropY + Bright * 5 + 4);
    end;

    // Draw a bright, almost pure white leading "head" at the very tip of the stream
    Painter.SetColor(MakeColor(190, 255, 200));
    Painter.Line(DropX, DropY + Len, DropX, DropY + Len + 3);
  end;
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  // 1. Initialize the graphical window sub-system
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Matrix Digital Rain');

  // 2. Allocate memory array for the screen pixel architecture
  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // 3. Initialize the painter engine linked to the allocated frame buffer
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  // 4. Main loop rendering graphic nodes and intercepting system events
  while Window.IsRunning do
  begin
    // Poll active input messages from the operating system queue
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            // Close the application immediately if Escape is pressed down
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;
      end;
    end;

    // Step the simulation frame counter
    Inc(FrameCounter);

    // Invoke procedural matrix code rain generator
    RenderMatrixRain(Render, FrameCounter);

    // Present the completed buffer modifications to the physical screen structure
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up display objects and terminate runtime window handles
  Window.Done;
end.
