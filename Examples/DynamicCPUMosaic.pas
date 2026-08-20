{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLitePixelArtConverterDemo;

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

  // Pixelation parameters
  BlockSize   : Integer;
  X, Y        : Integer;
  BX, BY      : Integer;

  // Color accumulation variables
  SumR, SumG, SumB : LongWord;
  PixelCount  : Integer;
  AvgR, AvgG, AvgB : Byte;

  // Image projection and scaling variables
  XRatio, YRatio : Single;
  TargetX, TargetY : Integer;
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  DestIdx     : Integer;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Pixel Art Converter', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Pixel Art Converter - Fullscreen CPU Mosaic - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Load the source asset for downsampling.
  // Recommended search query: "Mona Lisa high contrast bmp" or "pop art portrait bmp"
  // Save it in the executable directory as 'mosaic_source.bmp'
  BmpLoad.Load('mosaic_source.bmp', BmpImage, BmpError);

  // Pre-calculate scale factors to stretch map any small texture onto window bounds
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

    // Animate pixelation block size over time (oscillating between 4x4 and 24x24 blocks)
    BlockSize := 4 + Round((1 + Sin(FrameCounter * 0.04)) * 10);

    // Clear buffer with a flat background before drawing
    Render.SetColor(MakeColor(20, 20, 20));
    Render.Clear;

    // Grid-based processing loop spans across full window boundaries now
    Y := 0;
    while Y < WinHeight do
    begin
      X := 0;
      while X < WinWidth do
      begin
        SumR := 0;
        SumG := 0;
        SumB := 0;
        PixelCount := 0;

        // Sub-loop: Accumulate colors within the boundaries of the current screen block
        for BY := 0 to BlockSize - 1 do
        begin
          for BX := 0 to BlockSize - 1 do
          begin
            TargetX := X + BX;
            TargetY := Y + BY;

            // Clamp screen block boundaries to window dimensions
            if (TargetX < WinWidth) and (TargetY < WinHeight) then
            begin
              // Back-project current screen block sub-pixels onto raw source texture space
              SrcX := Floor(TargetX * XRatio);
              SrcY := Floor(TargetY * YRatio);

              // Safe clamping guard for source asset index resolution
              if SrcX >= BmpImage.Width then SrcX := BmpImage.Width - 1;
              if SrcY >= BmpImage.Height then SrcY := BmpImage.Height - 1;
              if SrcX < 0 then SrcX := 0;
              if SrcY < 0 then SrcY := 0;

              if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
              begin
                SrcIdx := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;

                SumB := SumB + BmpImage.Pixels[SrcIdx];
                SumG := SumG + BmpImage.Pixels[SrcIdx + 1];
                SumR := SumR + BmpImage.Pixels[SrcIdx + 2];
                Inc(PixelCount);
              end;
            end;
          end;
        end;

        // Calculate average block color and apply posterization step
        if PixelCount > 0 then
        begin
          AvgB := SumB div PixelCount;
          AvgG := SumG div PixelCount;
          AvgR := SumR div PixelCount;

          // Retro-color quantization (snapping to nearest 32-value interval)
          AvgB := (AvgB div 32) * 32;
          AvgG := (AvgG div 32) * 32;
          AvgR := (AvgR div 32) * 32;
        end
        else
        begin
          AvgB := 0;
          AvgG := 0;
          AvgR := 0;
        end;

        // Sub-loop: Write the calculated unified color block into the screen buffer
        for BY := 0 to BlockSize - 1 do
        begin
          for BX := 0 to BlockSize - 1 do
          begin
            TargetX := X + BX;
            TargetY := Y + BY;

            if (TargetX < WinWidth) and (TargetY < WinHeight) then
            begin
              DestIdx := (TargetY * WinWidth + TargetX) * BytesPerPixel;

              PixelBuffer[DestIdx]     := AvgB; // Blue
              PixelBuffer[DestIdx + 1] := AvgG; // Green
              PixelBuffer[DestIdx + 2] := AvgR; // Red
              if BytesPerPixel = 4 then
                PixelBuffer[DestIdx + 3] := 255; // Alpha
            end;
          end;
        end;

        X := X + BlockSize;
      end;
      Y := Y + BlockSize;
    end;

    // Present downsampled block structure to the window context
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
