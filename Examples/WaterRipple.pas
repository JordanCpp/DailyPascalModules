{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteWaterRippleDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  Math,
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
  BmpLoad     : TBmpLoader;
  BmpImage    : TImage;
  BmpError    : TBmpError;

  // Wave center coordinates (driven by animation or mouse)
  WaveX       : Single;
  WaveY       : Single;

  // Temporary variables for per-pixel calculations
  X, Y        : Integer;
  Dx, Dy      : Single;
  Distance    : Single;
  Offset      : Single;
  SrcX, SrcY  : Integer;
  DestIdx     : Integer;
  SrcIdx      : Integer;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Water Ripple', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Water Ripple - Move Mouse or Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Load the background texture.
  // Recommended search query: "pool mosaic texture bmp" or "pebble water texture bmp"
  // Save it in the executable directory as 'water_texture.bmp'
  BmpLoad.Load('water_texture.bmp', BmpImage, BmpError);

  while Window.IsRunning do
  begin
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;

        MouseMove:
          begin
            // Optional: If your WinLiteEvents structure contains mouse coordinates,
            // you can lock the wave center to the mouse cursor here:
            // WaveX := Event.Mouse.X;
            // WaveY := Event.Mouse.Y;
          end;
      end;
    end;

    Inc(FrameCounter);

    // If mouse tracking is idle, move the wave center in a smooth procedural circle
    WaveX := (WinWidth div 2)  + Cos(FrameCounter * 0.03) * 150.0;
    WaveY := (WinHeight div 2) + Sin(FrameCounter * 0.02) * 100.0;

    // Per-pixel CPU software rendering for the water ripple distortion
    for Y := 0 to WinHeight - 1 do
    begin
      for X := 0 to WinWidth - 1 do
      begin
        // Calculate the displacement vector from the wave center to the current pixel
        Dx := X - WaveX;
        Dy := Y - WaveY;
        Distance := Sqrt(Dx * Dx + Dy * Dy);

        // Ripple formula: decaying sine wave based on distance and elapsed time
        // 0.08 is wave frequency, 0.2 is propagation speed, 15.0 is wave amplitude
        Offset := Sin(Distance * 0.08 - FrameCounter * 0.2) * 15.0 * Exp(-Distance * 0.004);

        // Distort source texture lookup coordinates based on wave intensity
        if Distance > 0.001 then
        begin
          SrcX := X + Round((Dx / Distance) * Offset);
          SrcY := Y + Round((Dy / Distance) * Offset);
        end
        else
        begin
          SrcX := X;
          SrcY := Y;
        end;

        // Texture boundaries clamping to prevent array index out of bounds exceptions
        if SrcX < 0 then SrcX := 0;
        if SrcX >= BmpImage.Width then SrcX := BmpImage.Width - 1;
        if SrcY < 0 then SrcY := 0;
        if SrcY >= BmpImage.Height then SrcY := BmpImage.Height - 1;

        // Map two-dimensional space coordinates to flat byte array offsets
        DestIdx := (Y * WinWidth + X) * BytesPerPixel;
        SrcIdx  := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;

        // Blit the transformed pixel data directly into the frame window buffer
        PixelBuffer[DestIdx]     := BmpImage.Pixels[SrcIdx];     // Blue
        PixelBuffer[DestIdx + 1] := BmpImage.Pixels[SrcIdx + 1]; // Green
        PixelBuffer[DestIdx + 2] := BmpImage.Pixels[SrcIdx + 2]; // Red
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + 3] := 255; // Alpha channel
      end;
    end;

    // Present the completed frame buffer onto the screen window
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
