{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMoireDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, DegToRad
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
  Renders the Colorful Moire interference pattern effect via TPixelPainter
==============================================================================}
procedure RenderMoire(var Painter: TPixelPainter; Frame: Integer);
var
  I: Integer;
  CX1, CY1, CX2, CY2: Integer;
  W, H: Integer;
  X1, Y1, X2, Y2: Integer;
  Angle1, Angle2: Double;
  R, G, B: Byte;
begin
  // Clear the screen with solid black to make neon colors pop out
  Painter.SetColor(MakeColor(10, 10, 15));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;

  // 1. The first light center is static, positioned at the left third of the screen
  CX1 := W div 3;
  CY1 := H div 2;

  // 2. The second center rotates dynamically in an orbit around the screen center
  CX2 := (W div 2) + Round(Cos(Frame * 0.020) * 140.0);
  CY2 := (H div 2) + Round(Sin(Frame * 0.020) * 140.0);

  // Draw a fan of thin rays from both centers to full length.
  for I := 0 to 179 do
  begin
    Angle1 := DegToRad(I * 2.0);
    X1 := Round(Cos(Angle1) * 1200.0);
    Y1 := Round(Sin(Angle1) * 1200.0);

    // --- Dynamic Color Generation ---
    R := Byte(Round(Min(255.0, Max(0.0, (Sin(Angle1 + Frame * 0.03) + 1.0) * 127.5))));
    G := Byte(Round(Min(255.0, Max(0.0, (Sin(Angle1 + Frame * 0.02 + 2.0) + 1.0) * 127.5))));
    B := Byte(Round(Min(255.0, Max(0.0, (Cos(Angle1 - Frame * 0.01 + 4.0) + 1.0) * 127.5))));

    // Draw ray from the first (stationary) center
    Painter.SetColor(MakeColor(R, G, B));
    Painter.Line(CX1, CY1, CX1 + X1, CY1 + Y1);

    Angle2 := Angle1 + (Frame * 0.01);
    X2 := Round(Cos(Angle2) * 1200.0);
    Y2 := Round(Sin(Angle2) * 1200.0);

    // Draw ray from the second (moving) center with slightly inverted colors for extra depth
    Painter.SetColor(MakeColor(B, R, G));
    Painter.Line(CX2, CY2, CX2 + X2, CY2 + Y2);
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

  Window.SetTitle('WinLite Software Render - Colorful Moire Pattern');

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
    RenderMoire(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
