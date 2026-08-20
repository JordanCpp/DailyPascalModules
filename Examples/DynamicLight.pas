{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteDynamicLightDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

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
  DestIdx     : Integer;

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

  // Load the background dark brick/dungeon asset.
  // Recommended search query: "old brick texture seamless bmp" or "dungeon floor texture bmp"
  // Save it in the executable directory as 'dungeon_texture.bmp'
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
            // Update light tracking center directly from your WinLite system mouse coordinates
            // Assuming your structure exposes standard X and Y event values:
            // MouseX := Event.Mouse.X;
            // MouseY := Event.Mouse.Y;
          end;
      end;
    end;

    // If mouse events are not capturing coordinates yet, create a smooth idle searchlight animation
    // Comment out these two lines if you map the real mouse inputs above
    MouseX := (WinWidth div 2)  + Cos(Real(Frac(Now * 100000)) * 6.28) * 250.0;
    MouseY := (WinHeight div 2) + Sin(Real(Frac(Now * 100000)) * 4.00) * 150.0;

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
          Intensity := 0.05; // Ambient darkness floor factor (fog thickness)
        end
        else
        begin
          // Linear interpolation fallback fading out to the edge of the light cone
          Intensity := 1.0 - (Distance / LightRadius);
          // Apply basic gamma expansion for softer edge falloff
          Intensity := Intensity * Intensity;
          // Ensure ambient baseline minimum visibility remains intact
          if Intensity < 0.05 then
            Intensity := 0.05;
        end;

        // Tile/wrap coordinates if the source texture dimensions are smaller than window bounds
        SrcX := X mod BmpImage.Width;
        SrcY := Y mod BmpImage.Height;

        // Resolve hardware byte indices for buffers
        SrcIdx  := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;
        DestIdx := (Y * WinWidth + X) * BytesPerPixel;

        // Multiply texture color values by the light factor (Round safely for Delphi compatibility)
        PixelBuffer[DestIdx]     := Round(BmpImage.Pixels[SrcIdx]     * Intensity); // Blue
        PixelBuffer[DestIdx + 1] := Round(BmpImage.Pixels[SrcIdx + 1] * Intensity); // Green
        PixelBuffer[DestIdx + 2] := Round(BmpImage.Pixels[SrcIdx + 2] * Intensity); // Red
        if BytesPerPixel = 4 then
          PixelBuffer[DestIdx + 3] := 255; // Alpha
      end;
    end;

    // Swap graphics device frames
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
