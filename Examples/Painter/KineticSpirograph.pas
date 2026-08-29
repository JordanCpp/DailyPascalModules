{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteSpirographDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, DegToRad, Min, Max
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
  Renders the kinetic spirograph (hypotrochoid) pattern via TPixelPainter
==============================================================================}
procedure RenderSpirograph(var Painter: TPixelPainter; Frame: Integer);
var
  I: Integer;
  R1, R2, D, T, NextT: Double;
  X0, Y0, X1, Y1: Double;
  CX, CY: Integer;
  R, G, B: Byte;
begin
  // Clear the screen with a deep dark background for neon contrast
  Painter.SetColor(MakeColor(10, 5, 20));
  Painter.Clear;

  // Calculate screen center coordinates
  CX := Painter.GetWidth div 2;
  CY := Painter.GetHeight div 2;

  // Spirograph mathematical parameters
  R1 := 175.0; // Radius of the fixed outer circle
  R2 := 75.0;  // Radius of the rolling inner circle
  D  := 100.0; // Pen offset distance from the center of the inner circle

  for I := 0 to 1079 do
  begin
    // Convert degrees to radians and inject Frame to rotate the whole system over time
    T := DegToRad(I + Frame * 0.5);
    NextT := DegToRad(I + 1 + Frame * 0.5);

    X0 := CX + (R1 - R2) * Cos(T) + D * Cos((R1 - R2) * T / R2);
    Y0 := CY + (R1 - R2) * Sin(T) + D * Sin((R1 - R2) * T / R2);

    X1 := CX + (R1 - R2) * Cos(NextT) + D * Cos((R1 - R2) * NextT / R2);
    Y1 := CY + (R1 - R2) * Sin(NextT) + D * Sin((R1 - R2) * NextT / R2);

    // Generate dynamic neon color gradient shifting gracefully across the angles
    R := Round(Min(255.0, Max(0.0, (Sin(T + Frame * 0.02) + 1.0) * 127.5)));
    G := Round(Min(255.0, Max(0.0, (Cos(T * 2.0) + 1.0) * 127.5)));
    B := Round(Min(255.0, Max(0.0, (Sin(T * 3.0) + 1.0) * 127.5)));

    Painter.SetColor(MakeColor(R, G, B));

    // Draw the individual lace line segment
    Painter.Line(Round(X0), Round(Y0), Round(X1), Round(Y1));
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

  Window.SetTitle('WinLite Software Render - Kinetic Spirograph');

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
    RenderSpirograph(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
