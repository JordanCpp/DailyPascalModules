{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteTextureFireDemo;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, PixelPainter, PixelCopier, WinLiteEnums, WinLiteEvents, WinLiteWindow, BmpLoader;

const
  WinWidth = 800; WinHeight = 600; BytesPerPixel = 4;

var
  Window: TSoftwareWindow; Event: TEvent; Error: string; PixelBuffer: TBytes; Render: TPixelPainter;
  BmpLoad: TBmpLoader; BmpImage: TImage; BmpError: TBmpError; FireBuffer: array of Byte;
  X, Y, SrcIdx, Heat: Integer;
  TextR, TextG, TextB, FireR, FireG, FireB, FinalR, FinalG, FinalB: Byte;

  // Scale ratio coefficients for fullscreen texture projection
  XRatio, YRatio: Single;
  SrcX, SrcY: Integer;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite - Fullscreen Texture Burning', Error) then Halt(1);
  SetLength(PixelBuffer, WinWidth * WinHeight * BytesPerPixel);
  SetLength(FireBuffer, WinWidth * WinHeight);
  FillChar(FireBuffer[0], Length(FireBuffer), 0);
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  Randomize;

  BmpLoad.Load('burning_source.bmp', BmpImage, BmpError);

  // Pre-calculate scale factors (handles division protection if image failed to load)
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
      if (Event.FType = Quit) or ((Event.FType = Keyboard) and (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed)) then Window.StopEvent;

    // Step 1: Intense heat generation at the bottom (feeding 3 rows for a massive fire source)
    for Y := WinHeight - 3 to WinHeight - 1 do
    begin
      for X := 0 to WinWidth - 1 do
      begin
        if Random(100) > 25 then
          FireBuffer[Y * WinWidth + X] := 255
        else
          FireBuffer[Y * WinWidth + X] := 0;
      end;
    end;

    for Y := WinHeight - 4 downto 1 do
    begin
      for X := 1 to WinWidth - 2 do
      begin
        // Smooth pixel blur by averaging the heat matrix from lines below
        Heat := (FireBuffer[(Y + 1) * WinWidth + (X - 1)] +
                 FireBuffer[(Y + 1) * WinWidth + X]       +
                 FireBuffer[(Y + 1) * WinWidth + (X + 1)] +
                 FireBuffer[(Y + 2) * WinWidth + X]) div 4;

        // Slower cooling rate: decimate heat only based on custom probability matrix
        if (Heat > 1) and (Random(100) > 22) then
          Dec(Heat);

        FireBuffer[Y * WinWidth + X] := Heat;
      end;
    end;

    // Step 3: Composite and stretch map small image with alpha fire overlay
    for Y := 0 to WinHeight - 1 do
    begin
      // Back-project the current screen Y coordinate to the texture space
      SrcY := Floor(Y * YRatio);
      if SrcY >= BmpImage.Height then SrcY := BmpImage.Height - 1;
      if SrcY < 0 then SrcY := 0;

      for X := 0 to WinWidth - 1 do
      begin
        Heat := FireBuffer[Y * WinWidth + X];

        // Back-project the current screen X coordinate to the texture space
        SrcX := Floor(X * XRatio);
        if SrcX >= BmpImage.Width then SrcX := BmpImage.Width - 1;
        if SrcX < 0 then SrcX := 0;

        // Fetch pixels from the newly scaled mapping coordinates
        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          SrcIdx := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;

          TextR := BmpImage.Pixels[SrcIdx];
          TextG := BmpImage.Pixels[SrcIdx + 1];
          TextB := BmpImage.Pixels[SrcIdx + 2];
        end 
        else 
        begin 
          TextB := 0; TextG := 0; TextR := 0; 
        end;

        // Enhanced procedural combustion palette mapping
        if Heat < 70 then
        begin
          FireR := Round(Heat * 3.5); FireG := 0; FireB := 0;
        end
        else if Heat < 150 then
        begin
          FireR := 255; FireG := Round((Heat - 70) * 3.2); FireB := 0;
        end
        else
        begin
          FireR := 255; FireG := 255; FireB := Round((Heat - 150) * 2.4);
        end;

        // Blending and saturation logic for deep screen integration
        FinalB := Min(255, TextB + (FireB div 2));
        FinalG := Min(255, TextG + (FireG div 2));
        FinalR := Min(255, TextR + FireR);

        Render.SetColor(MakeColor(FinalR, FinalG, FinalB, 255));
        Render.Pixel(X, Y);
      end;
    end;
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;
  Window.Done;
end.
