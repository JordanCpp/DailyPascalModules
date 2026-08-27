{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteSynthwaveGridDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for the Power function to calculate 3D perspective spacing
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
  Renders the 3D Synthwave Grid perspective effect via TPixelPainter
==============================================================================}
procedure RenderSynthwaveGrid(var Painter: TPixelPainter; Frame: Integer);
var
  I, Horizon, Y, W, H, CX: Integer;
  Offset: Double;
begin
  // Clear the screen with a deep neon-purple background
  Painter.SetColor(MakeColor(24, 4, 36));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;
  CX := W div 2;
  Horizon := H div 2 - 20; // Define the vanishing point line (horizon)

  // 1. Draw perspective vertical rays converging at the center of the horizon
  // Neon pink color for the main structural grid lines
  Painter.SetColor(MakeColor(255, 0, 128));
  for I := -16 to 16 do
  begin
    // Lines expand outward as they travel from the horizon to the bottom of the screen
    Painter.Line(CX + (I * 6), Horizon, CX + (I * 135), H - 1);
  end;

  // 2. Draw horizontal lines moving continuously toward the viewer
  // Normalize the animation offset to a smooth 0.0 to 1.0 range based on a 30-frame cycle
  Offset := (Frame mod 30) / 30.0;

  for I := 0 to 14 do
  begin
    // Exponential formula creates a non-linear spacing to simulate true 3D depth.
    // Lines closer to the horizon are tightly packed, while closer lines spread out.
    Y := Horizon + Round(Power(I + Offset, 2.3) * 1.3);

    // Only render the line if it falls within the visible screen area below the horizon
    if Y < H then
    begin
      // Fade out the lines as they approach the horizon for a realistic atmospheric depth effect
      // Lines near the horizon (lower index I) will be dimmer than lines near the bottom
      Painter.SetColor(MakeColor(100 + I * 11, 0, 150 + I * 7));
      Painter.Line(0, Y, W - 1, Y);
    end;
  end;

  // 3. Draw a glowing sun or horizon line separator
  Painter.SetColor(MakeColor(255, 180, 0));
  Painter.Line(0, Horizon, W - 1, Horizon);
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

  Window.SetTitle('WinLite Software Render - Synthwave 3D Grid Depth');

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

    // Call the procedural 3D grid renderer
    RenderSynthwaveGrid(Render, FrameCounter);

    // Swap buffers: Present the complete PixelBuffer to the physical screen
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up resources and close window subsystems
  Window.Done;
end.
