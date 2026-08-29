{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program PredatorVision;

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
  BmpLoad     : TBmpLoader;
  BmpImage    : TImage;
  BmpError    : TBmpError;

  // Processing loop variables
  X, Y        : Integer;
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  DestIdx     : Integer;
  SrcR, SrcG, SrcB : Byte;
  Luminance   : Integer;
  HeatR       : Byte;
  HeatG       : Byte;
  HeatB       : Byte;

  XRatio, YRatio : Single;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Predator Thermal Vision', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Predator Vision - Pure CPU Thermal Filter - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  // Load the source image.
  BmpLoad.Load('city_daylight.bmp', BmpImage, BmpError);

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

    Render.SetColor(MakeColor(0, 0, 30));
    Render.Clear;

    for Y := 0 to WinHeight - 1 do
    begin
      DestIdx := Y * WinWidth * BytesPerPixel;

      if (BmpImage.Height > 0) then
      begin
        SrcY := Floor(Y * YRatio);
        if SrcY >= Integer(BmpImage.Height) then SrcY := BmpImage.Height - 1;
      end;

      for X := 0 to WinWidth - 1 do
      begin
        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          SrcX := Floor(X * XRatio);
          if SrcX >= Integer(BmpImage.Width) then SrcX := BmpImage.Width - 1;

          SrcIdx := (SrcY * Integer(BmpImage.Width) + SrcX) * BmpImage.Bpp;

          SrcR := BmpImage.Pixels[SrcIdx];
          SrcG := BmpImage.Pixels[SrcIdx + 1];
          SrcB := BmpImage.Pixels[SrcIdx + 2];
          
          // Standard perceived luminance conversion formula
          Luminance := Round(0.299 * SrcR + 0.587 * SrcG + 0.114 * SrcB);
        end
        else
        begin
          Luminance := Round((1.0 + Sin(X * 0.01) * Cos(Y * 0.01)) * 127.5);
        end;

        // Procedural thermal lookup ramp color mapping (Blue -> Green -> Red -> Yellow)
        if Luminance < 64 then
        begin
          HeatB := Min(255, Luminance * 4);
          HeatG := 0;
          HeatR := 0;
        end
        else if Luminance < 128 then
        begin
          HeatB := Max(0, 255 - (Luminance - 64) * 4);
          HeatG := Min(255, (Luminance - 64) * 4);
          HeatR := 0;
        end
        else if Luminance < 192 then
        begin
          HeatB := 0;
          HeatG := 255;
          HeatR := Min(255, (Luminance - 128) * 4);
        end
        else
        begin
          HeatB := 0;
          HeatG := Max(0, 255 - (Luminance - 192) * 4);
          HeatR := 255;
        end;

        PixelBuffer[DestIdx + idxR] := HeatR;
        PixelBuffer[DestIdx + idxG] := HeatG;
        PixelBuffer[DestIdx + idxB] := HeatB;
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + idxA] := 255;

        Inc(DestIdx, BytesPerPixel);
      end;
    end;

    // Update screen surface with newly generated thermal data block
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
