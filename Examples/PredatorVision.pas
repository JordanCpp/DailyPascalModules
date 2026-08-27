{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLitePredatorVisionDemo;

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
  SrcIdx      : Integer;
  DestIdx     : Integer;
  R, G, B     : Byte;
  Luminance   : Integer;
  HeatR       : Byte;
  HeatG       : Byte;
  HeatB       : Byte;
  MaxRows     : Integer;
  MaxCols     : Integer;

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
  // Recommended search query: "city street daylight bmp" or "landscape photography bmp"
  // Save it in the executable directory as 'city_daylight.bmp'
  BmpLoad.Load('city_daylight.bmp', BmpImage, BmpError);

  // Safety boundaries to prevent out-of-bounds cross-reading
  MaxRows := Min(WinHeight, BmpImage.Height);
  MaxCols := Min(WinWidth, BmpImage.Width);

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

    // Process every pixel and map grayscale intensity to infrared spectrum values
    for Y := 0 to MaxRows - 1 do
    begin
      for X := 0 to MaxCols - 1 do
      begin
        // Calculate raw flat byte indices for source and destination buffers
        SrcIdx  := (Y * BmpImage.Width + X) * BmpImage.Bpp;
        DestIdx := (Y * WinWidth + X) * BytesPerPixel;

        // Extract individual color channels from the asset
        B := BmpImage.Pixels[SrcIdx];
        G := BmpImage.Pixels[SrcIdx + 1];
        R := BmpImage.Pixels[SrcIdx + 2];

        // Standard perceived luminance conversion formula (Grayscale weights)
        Luminance := Round(0.299 * R + 0.587 * G + 0.114 * B);

        // Procedural thermal lookup ramp color mapping (Blue -> Green -> Red -> Yellow)
        if Luminance < 64 then
        begin
          HeatB := Luminance * 4;
          HeatG := 0;
          HeatR := 0;
        end
        else if Luminance < 128 then
        begin
          HeatB := 255 - (Luminance - 64) * 4;
          HeatG := (Luminance - 64) * 4;
          HeatR := 0;
        end
        else if Luminance < 192 then
        begin
          HeatB := 0;
          HeatG := 255;
          HeatR := (Luminance - 128) * 4;
        end
        else
        begin
          HeatB := 0;
          HeatG := 255 - (Luminance - 192) * 4;
          HeatR := 255;
        end;

        // Commit mapped bytes directly into the rendering hardware frame container
        PixelBuffer[DestIdx]     := HeatB; // Blue
        PixelBuffer[DestIdx + 1] := HeatG; // Green
        PixelBuffer[DestIdx + 2] := HeatR; // Red
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + 3] := 255; // Alpha
      end;
    end;

    // Update screen surface with newly generated thermal data block
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
