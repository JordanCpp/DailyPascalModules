{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteKaleidoscopeDemo;

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
  TwistAngle  : Single;

  // Projected texture space coordinates
  SrcX, SrcY  : Integer;
  SrcIdx      : Integer;
  DestIdx     : Integer;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Software Render - Screen Twister', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Twister Effect - Pure CPU Polar Math - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

  // Load the vibrant source asset.
  // Recommended search query: "psychedelic abstract pattern colorful bmp" or "graffiti wall bmp"
  // Save it in the executable directory as 'abstract_pattern.bmp'
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

    // Render every viewport pixel using polar texture mapping mapping logic
    for Y := 0 to WinHeight - 1 do
    begin
      for X := 0 to WinWidth - 1 do
      begin
        // Convert Cartesian screen coordinates (X, Y) to displacement vectors relative to center
        Dx := X - CenterX;
        Dy := Y - CenterY;

        // Calculate raw distance (Radius) from the screen center axis
        Radius := Sqrt(Dx * Dx + Dy * Dy);

        if Radius > 0.001 then
        begin
          // Determine base vector angle using standard ArcTan2 trigonometric wrapper
          Angle := ArcTan2(Dy, Dx);

          // Apply twist: shift angle based on distance from center and time (FrameCounter)
          // 0.005 controls the speed of the spiral twist, 0.03 controls time animation phase speed
          TwistAngle := Angle + (Radius * 0.005) + (FrameCounter * 0.03);

          // Re-project polar vectors back to distorted Cartesian coordinate lookup indices
          SrcX := Round(CenterX + Cos(TwistAngle) * Radius);
          SrcY := Round(CenterY + Sin(TwistAngle) * Radius);
        end
        else
        begin
          SrcX := X;
          SrcY := Y;
        end;

        // Texture boundaries clamping and safety validation wrap
        if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
        begin
          // Handle screen wrap/tiling if source coordinates scale outside asset dimensions
          SrcX := Abs(SrcX) mod BmpImage.Width;
          SrcY := Abs(SrcY) mod BmpImage.Height;

          SrcIdx := (SrcY * BmpImage.Width + SrcX) * BmpImage.Bpp;
        end
        else
        begin
          SrcIdx := 0;
        end;

        DestIdx := (Y * WinWidth + X) * BytesPerPixel;

        // Blit final calculated pixel maps directly into presentation window memory blocks
        if (SrcIdx >= 0) and (SrcIdx + 2 < Length(BmpImage.Pixels)) then
        begin
          PixelBuffer[DestIdx]     := BmpImage.Pixels[SrcIdx];     // Blue
          PixelBuffer[DestIdx + 1] := BmpImage.Pixels[SrcIdx + 1]; // Green
          PixelBuffer[DestIdx + 2] := BmpImage.Pixels[SrcIdx + 2]; // Red
          if BytesPerPixel = 4 then
            PixelBuffer[DestIdx + 3] := 255;                       // Alpha
        end
        else
        begin
          // Fallback to solid background color grid space if index checks fail
          PixelBuffer[DestIdx]     := 0;
          PixelBuffer[DestIdx + 1] := 0;
          PixelBuffer[DestIdx + 2] := 0;
          if BytesPerPixel = 4 then PixelBuffer[DestIdx + 3] := 255;
        end;
      end;
    end;

    // Swap viewports
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
