{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteWaterRippleDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math,
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
  XRatio, YRatio : Single;
  R, G, B     : Byte;

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
  BmpLoad.Load('water_texture.bmp', BmpImage, BmpError);

  if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
  begin
    XRatio := BmpImage.Width / WinWidth;
    YRatio := BmpImage.Height / WinHeight;
  end
  else
  begin
    XRatio := 1.0;
    YRatio := 1.0;
  end;

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
      end;
    end;

    Inc(FrameCounter);

    // Smooth procedural circle trajectory for searchlight/wave center
    WaveX := (WinWidth div 2)  + Cos(FrameCounter * 0.03) * 150.0;
    WaveY := (WinHeight div 2) + Sin(FrameCounter * 0.02) * 100.0;

    // Per-pixel CPU software rendering for the water ripple distortion
    for Y := 0 to WinHeight - 1 do
    begin
      DestIdx := Y * WinWidth * BytesPerPixel;

      for X := 0 to WinWidth - 1 do
      begin
        // Calculate the displacement vector from the wave center to the current pixel
        Dx := X - WaveX;
        Dy := Y - WaveY;
        Distance := Sqrt(Dx * Dx + Dy * Dy);

        // Ripple formula: decaying sine wave based on distance and elapsed time
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

        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          SrcX := Floor(SrcX * XRatio);
          SrcY := Floor(SrcY * YRatio);

          if SrcX < 0 then SrcX := 0;
          if SrcX >= Integer(BmpImage.Width) then SrcX := BmpImage.Width - 1;
          if SrcY < 0 then SrcY := 0;
          if SrcY >= Integer(BmpImage.Height) then SrcY := BmpImage.Height - 1;

          SrcIdx := (SrcY * Integer(BmpImage.Width) + SrcX) * BmpImage.Bpp;

          R := BmpImage.Pixels[SrcIdx];
          G := BmpImage.Pixels[SrcIdx + 1];
          B := BmpImage.Pixels[SrcIdx + 2];
        end
        else
        begin
          if ((SrcX div 32) mod 2 = (SrcY div 32) mod 2) then
          begin R := 0; G := 120; B := 180; end
          else
          begin R := 0; G := 90;  B := 150; end;
          R := Min(255, R + Round(Abs(Offset) * 4));
          G := Min(255, G + Round(Abs(Offset) * 4));
        end;

        PixelBuffer[DestIdx + idxR] := R;
        PixelBuffer[DestIdx + idxG] := G;
        PixelBuffer[DestIdx + idxB] := B;
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + idxA] := 255;

        Inc(DestIdx, BytesPerPixel);
      end;
    end;

    // Present the completed frame buffer onto the screen window
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
