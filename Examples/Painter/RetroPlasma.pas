{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program RetroPlasma;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, Sqrt, Min, Max
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

{==============================================================================
  Renders the retro plasma wave interference effect via TPixelPainter
==============================================================================}
procedure RenderRetroPlasma(var Painter: TPixelPainter; Frame: Integer);
var
  X, Y: Integer;
  W, H: Integer;
  CX, CY: Double;
  Time1, Time2, Time3, Time4: Double;
  Value: Double;
  R, G, B: Byte;
  DistX, DistY: Double;
  DestIdx: Integer;
  WaveY: Double;
begin
  W := Painter.GetWidth;
  H := Painter.GetHeight;
  CX := W / 2.0;
  CY := H / 2.0;

  // Pre-calculate time scale offsets to optimize cycle iterations
  Time1 := Frame * 0.04;
  Time2 := Frame * 0.02;
  Time3 := Frame * 0.03;
  Time4 := Frame * 0.05;

  // Pixel-by-pixel mathematical rendering loop
  for Y := 0 to H - 1 do
  begin
    DistY := Y - CY;
    
    WaveY := Sin(Y * 0.020 + Time2);
    DestIdx := Y * W * BytesPerPixel;

    for X := 0 to W - 1 do
    begin
      DistX := X - CX;

      // Mathematical formula combining vertical, horizontal, diagonal, and radial waves
      Value :=
        Sin(X * 0.015 + Time1) +
        WaveY +
        Sin((X + Y) * 0.010 + Time3) +
        Sqrt(DistX * DistX + DistY * DistY) * 0.025 - Time4;

      Value := Sin(Value);

      // Generate a shifting psychedelic palette using phase-shifted sine modulations.
      R := Byte(Round(Min(255.0, Max(0.0, (Sin(Value * Pi + 0.0) + 1.0) * 127.5))));
      G := Byte(Round(Min(255.0, Max(0.0, (Sin(Value * Pi + 2.0) * 0.5 + 0.5) * 255.0))));
      B := Byte(Round(Min(255.0, Max(0.0, (Cos(Value * Pi + Time1) + 1.0) * 127.5))));

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

  Window.SetTitle('WinLite Software Render - Retro Plasma');

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
    RenderRetroPlasma(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
