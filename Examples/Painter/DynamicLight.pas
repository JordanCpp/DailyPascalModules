{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteDynamicLightDemo;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, PixelPainter, PixelCopier, WinLiteEnums, WinLiteEvents, WinLiteWindow, BmpLoader;

const
  WinWidth      = 800;
  WinHeight     = 600;
  BytesPerPixel = 4;
  LightRadius   = 200.0; // Radius of the flashlight beam in pixels

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

  // Flashlight center coordinates
  MouseX      : Single;
  MouseY      : Single;

  // Processing loop variables
  X, Y        : Integer;
  Dx, Dy      : Single;
  Distance    : Single;
  Intensity   : Single; // Light attenuation factor (0.0 to 1.0)
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  R, G, B     : Byte;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Dynamic Flashlight', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Dynamic Light - Move Mouse to aim Flashlight - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Load the background dark brick/dungeon asset
  BmpLoad.Load('dungeon_texture.bmp', BmpImage, BmpError);

  // Set initial light position to the center of the window
  MouseX := WinWidth div 2;
  MouseY := WinHeight div 2;

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
            // MouseX := Event.MouseMove.X;
            // MouseY := Event.MouseMove.Y;
          end;
      end;
    end;

    Inc(FrameCounter);

    MouseX := (WinWidth div 2)  + Cos(FrameCounter * 0.02) * 250.0;
    MouseY := (WinHeight div 2) + Sin(FrameCounter * 0.034) * 150.0;

    // Per-pixel raycasting light attenuation loop calculated on CPU
    for Y := 0 to WinHeight - 1 do
    begin
      for X := 0 to WinWidth - 1 do
      begin
        // Calculate euclidean distance from the current pixel to the light center
        Dx := X - MouseX;
        Dy := Y - MouseY;
        Distance := Sqrt(Dx * Dx + Dy * Dy);

        // Calculate smooth light fade factor based on distance constraints
        if Distance >= LightRadius then
        begin
          Intensity := 0.05; // Ambient darkness floor factor
        end
        else
        begin
          Intensity := 1.0 - (Distance / LightRadius);
          Intensity := Intensity * Intensity; // Gamma falloff
          if Intensity < 0.05 then
            Intensity := 0.05;
        end;

        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          SrcX := X mod Integer(BmpImage.Width);
          SrcY := Y mod Integer(BmpImage.Height);
          SrcIdx := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;

          R := BmpImage.Pixels[SrcIdx];
          G := BmpImage.Pixels[SrcIdx + 1];
          B := BmpImage.Pixels[SrcIdx + 2];
        end
        else
        begin
          if (X mod 100 = 0) or (Y mod 50 = 0) then
          begin R := 80; G := 80; B := 85; end
          else
          begin R := 45; G := 35; B := 30; end;
        end;

        Render.SetColor(MakeColor(
          Round(R * Intensity),
          Round(G * Intensity),
          Round(B * Intensity),
          255
        ));
        Render.Pixel(X, Y);
      end;
    end;

    // Swap graphics device frames
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
