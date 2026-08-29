{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMotionBlurDemo;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, PixelPainter, PixelCopier, WinLiteEnums, WinLiteEvents, WinLiteWindow, BmpLoader;

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
  Copier      : TPixelCopier;
  FrameCounter: Integer;
  BmpLoad     : TBmpLoader;
  BmpImage    : TImage;
  BmpError    : TBmpError;

  // Sprite motion paths variables
  SpriteX     : Integer;
  SpriteY     : Integer;
  SprW, SprH  : Integer;

  // Processing loops variables
  I           : Integer;
  X, Y        : Integer;
  DestIdx     : Integer;

  // Vignette edge blur variables
  CenterX     : Single;
  CenterY     : Single;
  Dx, Dy      : Single;
  DistFromCtr : Single;
  MaxDist     : Single;
  VignetteFactor: Single;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Motion Blur', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Motion Blur - Long Soft Trails - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  Copier.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  BmpLoad.Load('motion_sprite.bmp', BmpImage, BmpError);

  // Initialize screen buffer memory once
  Render.SetColor(MakeColor(0, 0, 0));
  Render.Clear;

  CenterX := WinWidth / 2.0;
  CenterY := WinHeight / 2.0;
  MaxDist := Sqrt(CenterX * CenterX + CenterY * CenterY);

  while Window.IsRunning do
  begin
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit: Window.StopEvent;
        Keyboard:
          if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
            Window.StopEvent;
      end;
    end;

    Inc(FrameCounter);

    I := 0;
    while I < BufferSize do
    begin
      PixelBuffer[I]     := (PixelBuffer[I]     * 94) div 100; // Blue
      PixelBuffer[I + 1] := (PixelBuffer[I + 1] * 94) div 100; // Green
      PixelBuffer[I + 2] := (PixelBuffer[I + 2] * 94) div 100; // Red
      Inc(I, BytesPerPixel);
    end;

    if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
    begin
      SprW := BmpImage.Width;
      SprH := BmpImage.Height;
    end
    else
    begin
      SprW := 64;
      SprH := 64;
    end;

    // Step 2: Compute dynamic moving coordinate pathways using Lissajous mathematics
    SpriteX := Round((WinWidth div 2 - SprW div 2) + Cos(FrameCounter * 0.04) * (WinWidth div 3));
    SpriteY := Round((WinHeight div 2 - SprH div 2) + Sin(FrameCounter * 0.02) * (WinHeight div 4));

    // Step 3: Draw additional neon vector accents via standard rendering primitives
    Render.SetColor(MakeColor(0, Round(128 + 127 * Sin(FrameCounter * 0.08)), 255));
    Render.Line(0, 0, SpriteX + SprW div 2, SpriteY + SprH div 2);
    Render.Line(WinWidth - 1, WinHeight - 1, SpriteX + SprW div 2, SpriteY + SprH div 2);

    // Step 4: Blit the sprite asset onto the accumulation buffer layout
    if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
    begin
      Copier.Copy(SpriteX, SpriteY, BmpImage.Width, BmpImage.Height, BmpImage.Bpp, BmpImage.Pixels);
    end;

    for Y := 0 to WinHeight - 1 do
    begin
      DestIdx := Y * WinWidth * BytesPerPixel;
      Dy := Y - CenterY;
      for X := 0 to WinWidth - 1 do
      begin
        Dx := X - CenterX;
        DistFromCtr := Sqrt(Dx * Dx + Dy * Dy);
        VignetteFactor := 1.0 - (DistFromCtr / MaxDist);
        VignetteFactor := VignetteFactor * VignetteFactor;

        PixelBuffer[DestIdx]     := Round(PixelBuffer[DestIdx]     * VignetteFactor);
        PixelBuffer[DestIdx + 1] := Round(PixelBuffer[DestIdx + 1] * VignetteFactor);
        PixelBuffer[DestIdx + 2] := Round(PixelBuffer[DestIdx + 2] * VignetteFactor);

        Inc(DestIdx, BytesPerPixel);
      end;
    end;

    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
