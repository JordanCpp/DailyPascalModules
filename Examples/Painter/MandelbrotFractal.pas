{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMandelbrotDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, Ln, Min, Max
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
  MaxIter       = 40; // Maximum number of iterations (balance between quality and performance)

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Renders the Mandelbrot fractal set with dynamic zoom and smooth coloring
==============================================================================}
procedure RenderMandelbrot(var Painter: TPixelPainter; Frame: Integer);
var
  X, Y, Iter: Integer;
  W, H: Integer;
  Cr, Ci, Zr, Zi, ZrSq, ZiSq: Double;
  Zoom, TargetX, TargetY: Double;
  R, G, B: Byte;
  Mu: Double;
  DestIdx: Integer;
  Ln2: Double;
begin
  W := Painter.GetWidth;
  H := Painter.GetHeight;
  Ln2 := Ln(2.0); // Precalculate constant to avoid overhead in loop

  // Smooth cyclic zoom factor based on the cosine of the current frame
  Zoom := 1.2 + (Cos(Frame * 0.015) + 1.0) * 1.5;

  // Complex plane coordinate coordinates to focus on during magnification
  TargetX := -0.743643887037158;
  TargetY := 0.131825904205312;

  // Pixel-by-pixel rendering loop of the fractal viewport
  for Y := 0 to H - 1 do
  begin
    DestIdx := Y * W * BytesPerPixel;
    
    for X := 0 to W - 1 do
    begin
      // Map screen coordinates (X, Y) to the complex plane number C (Cr + i*Ci)
      Cr := (X - W * 0.5) * (3.5 / (W * Zoom)) + TargetX;
      Ci := (Y - H * 0.5) * (2.5 / (H * Zoom)) + TargetY;

      Zr := 0.0;
      Zi := 0.0;
      ZrSq := 0.0;
      ZiSq := 0.0;
      Iter := 0;

      while (Iter < MaxIter) and (ZrSq + ZiSq < 16.0) do
      begin
        Zi := 2.0 * Zr * Zi + Ci;
        Zr := ZrSq - ZiSq + Cr;
        ZrSq := Zr * Zr;
        ZiSq := Zi * Zi;
        Inc(Iter);
      end;

      if Iter = MaxIter then
      begin
        R := 0; G := 0; B := 0;
      end
      else
      begin
        Mu := Iter + 1.0 - (Ln(Ln(Max(0.0001, ZrSq + ZiSq)) / Ln2) / Ln2);

        // Generate neon wave cycles shifting gracefully through time
        R := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.3 + Frame * 0.05 + 0.0) + 1.0) * 127.5)));
        G := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.2 + Frame * 0.03 + 2.0) + 1.0) * 127.5)));
        B := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.1 + Frame * 0.02 + 4.0) + 1.0) * 127.5)));
      end;

      PixelBuffer[DestIdx + idxR] := R;
      PixelBuffer[DestIdx + idxG] := G;
      PixelBuffer[DestIdx + idxB] := B;
      if BytesPerPixel = 4 then
        PixelBuffer[DestIdx + idxA] := 255;

      Inc(DestIdx, BytesPerPixel);
    end;
  end;
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Mandelbrot Fractal Zoom');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  FrameCounter := 0;

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
    RenderMandelbrot(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
