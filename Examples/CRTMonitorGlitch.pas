{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteRetroGlitchDemo;

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

  // Processing loop variables
  X, Y        : Integer;
  GlitchOffset: Integer;
  ScanlineDark: Single;
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  DestIdx     : Integer;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - CRT Glitch Art', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite CRT Monitor Glitch - Pure CPU Simulation - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Initialize Random seed for organic digital noise generation
  Randomize;

  // Load the source neon asset.
  // Recommended search query: "80s synthwave wallpaper bmp" or "cyberpunk neon city bmp"
  // Save it in the executable directory as 'synthwave_neon.bmp'
  BmpLoad.Load('synthwave_neon.bmp', BmpImage, BmpError);

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

    // Apply per-pixel transformations row by row to simulate analog CRT display
    for Y := 0 to WinHeight - 1 do
    begin
      // CRT Effect 1: Darken alternating rows to produce vintage scanlines
      if (Y mod 2 = 0) then
        ScanlineDark := 0.55
      else
        ScanlineDark := 1.0;

      // CRT Effect 2: Calculate random horizontal line shifting (glitch jitter)
      GlitchOffset := 0;

      // Periodic rolling displacement wave combined with sudden full-frame sync spikes
      if (Y mod 50 = (FrameCounter mod 50)) or (Random(1000) > 995) then
      begin
        GlitchOffset := Round(Sin(Y * 0.3 + FrameCounter * 0.8) * 12.0);
      end;

      for X := 0 to WinWidth - 1 do
      begin
        // Apply calculated horizontal displacement offset
        SrcX := X + GlitchOffset;
        SrcY := Y;

        // Secure edge boundaries using simple clamping architecture
        if SrcX < 0 then SrcX := 0;
        if SrcX >= BmpImage.Width then SrcX := BmpImage.Width - 1;
        if SrcY >= BmpImage.Height then SrcY := BmpImage.Height - 1;

        // Resolve hardware byte indices for pixel extraction
        SrcIdx  := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;
        DestIdx := (Y * WinWidth + X) * BytesPerPixel;

        // Commit color channels scaled by the current scanline intensity factor
        PixelBuffer[DestIdx]     := Round(BmpImage.Pixels[SrcIdx]     * ScanlineDark); // Blue
        PixelBuffer[DestIdx + 1] := Round(BmpImage.Pixels[SrcIdx + 1] * ScanlineDark); // Green
        PixelBuffer[DestIdx + 2] := Round(BmpImage.Pixels[SrcIdx + 2] * ScanlineDark); // Red
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + 3] := 255; // Alpha
      end;
    end;

    // Direct blit presentation loop update
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
