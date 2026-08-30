{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program PureCPUPolarMath;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, PixelPainter, PixelCopier, WinLiteEnums, WinLiteEvents, WinLiteWindow, BmpLoader;

const
  WinWidth      = 800;
  WinHeight     = 600;
  BytesPerPixel = 4;
  Segments      = 8;

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

  // Center points for polar coordinate transformations
  CenterX     : Single;
  CenterY     : Single;

  // Processing math variables
  X, Y        : Integer;
  Dx, Dy      : Single;
  Radius      : Single;
  Angle       : Single;
  Sector      : Single;

  // Projected texture space coordinates
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  R, G, B     : Byte;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Screen Twister', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Kaleidoscope & Twister - Pure CPU Polar Math - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Load the vibrant source asset
  BmpLoad.Load('abstract_pattern.bmp', BmpImage, BmpError);

  CenterX := WinWidth / 2.0;
  CenterY := WinHeight / 2.0;

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

    // Render every viewport pixel using polar texture mapping logic
    for Y := 0 to WinHeight - 1 do
    begin
      for X := 0 to WinWidth - 1 do
      begin
        // Convert Cartesian screen coordinates (X, Y) to displacement vectors relative to center
        Dx := X - CenterX;
        Dy := Y - CenterY;

        Radius := Sqrt(Dx * Dx + Dy * Dy);

        if Radius > 0.001 then
        begin
          Angle := ArcTan2(Dy, Dx);
          if Angle < 0 then Angle := Angle + 2.0 * Pi;

          Sector := (2.0 * Pi) / Segments;
          
          if Sector <> 0 then 
            Angle := Angle - Trunc(Angle / Sector) * Sector;
          
          if Angle > Sector * 0.5 then 
            Angle := Sector - Angle;

          Angle := Angle + (Radius * 0.003) + (FrameCounter * 0.015);

          // Re-project polar vectors back to distorted Cartesian coordinate lookup indices
          SrcX := Round(CenterX + Cos(Angle) * Radius);
          SrcY := Round(CenterY + Sin(Angle) * Radius);
        end
        else
        begin
          SrcX := X;
          SrcY := Y;
        end;

        // Texture boundaries clamping and safety validation wrap
        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          SrcX := Abs(SrcX) mod Integer(BmpImage.Width);
          SrcY := Abs(SrcY) mod Integer(BmpImage.Height);

          SrcIdx := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;

          R := BmpImage.Pixels[SrcIdx];
          G := BmpImage.Pixels[SrcIdx + 1];
          B := BmpImage.Pixels[SrcIdx + 2];
        end
        else
        begin
          R := Round((1.0 + Sin(SrcX * 0.05 + FrameCounter * 0.02)) * 127.5);
          G := Round((1.0 + Cos(SrcY * 0.05 - FrameCounter * 0.03)) * 127.5);
          B := Round((1.0 + Sin((SrcX + SrcY) * 0.02)) * 127.5);
        end;

        Render.SetColor(MakeColor(R, G, B, 255));
        Render.Pixel(X, Y);
      end;
    end;

    // Swap viewports
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
