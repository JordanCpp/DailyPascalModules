{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteDigitalSilkDemo;

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
  MaxWaves      = 40; // Total number of wave layers to generate the fabric texture

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Renders the animated Sine Wave Fabric (Digital Silk) effect via TPixelPainter
==============================================================================}
procedure RenderDigitalSilk(var Painter: TPixelPainter; Frame: Integer);
var
  Wave, X, Y: Integer;
  W, H: Integer;
  RadX, WaveOffset: Double;
begin
  // Clear the screen with deep cosmic black to let neon lines glow
  Painter.SetColor(MakeColor(5, 5, 8));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;

  // Render multiple overlapping wave layers to form the fabric texture
  for Wave := 0 to MaxWaves - 1 do
  begin
    // Generate a smooth gradient transitioning from deep indigo to cyan for each layer
    Painter.SetColor(MakeColor(Wave * 2, Wave * 5, 140 + Wave * 2));

    // Calculate a unique phase offset for the current wave layer based on time
    WaveOffset := (Wave * 7.5) + (Frame * 1.8);

    for X := 0 to W - 1 do
    begin
      // Map X screen coordinate to radians (creates exactly 3 full sine wave periods)
      RadX := (X / W) * Pi * 3.0;

      // Calculate Y coordinate using combined sine (base wave) and cosine (torsion distortion)
      Y := (H div 2)
           + Round(Sin(RadX + DegToRad(WaveOffset)) * 90.0)
           + Round(Cos(X * 0.012 - Frame * 0.025) * (Wave * 3.2));

      // Only paint the pixel if it lies within the visible vertical screen bounds
      if (Y >= 0) and (Y < H) then
        Painter.Pixel(X, Y);
    end;
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

  Window.SetTitle('WinLite Software Render - Animated Digital Silk Fabric');

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

    // Call the procedural digital silk renderer
    RenderDigitalSilk(Render, FrameCounter);

    // Swap buffers: Present the complete PixelBuffer to the physical screen
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up resources and close window subsystems
  Window.Done;
end.
