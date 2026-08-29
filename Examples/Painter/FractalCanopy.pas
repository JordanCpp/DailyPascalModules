{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteFractalTreeDemo;

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
  Recursive helper procedure to calculate and draw individual branches
==============================================================================}
procedure DrawBranch(var Painter: TPixelPainter; X, Y: Double; Angle, Length: Double; Depth: Integer);
var
  XEnd, YEnd: Double;
  R, G, B: Byte;
  CalcR, CalcG: Integer;
begin
  // Base case: stop recursion when maximum depth is reached
  if Depth = 0 then Exit;

  if Length < 1.5 then Exit;

  // Calculate the end coordinates of the current branch
  XEnd := X + Cos(Angle) * Length;
  YEnd := Y - Sin(Angle) * Length;

  // Procedural coloring with strict protection against Byte Underflow/Overflow
  if Depth > 4 then
  begin
    CalcR := 139 - (Depth * 5);
    CalcG := 69 + (Depth * 2);
    
    if CalcR < 0 then CalcR := 0;
    if CalcG > 255 then CalcG := 255;
    
    R := Byte(CalcR);
    G := Byte(CalcG);
    B := 19;
  end
  else
  begin
    CalcR := 34 + (Depth * 10);
    CalcG := 139 + (Depth * 20);
    
    if CalcR > 255 then CalcR := 255;
    if CalcG > 255 then CalcG := 255;
    
    R := Byte(CalcR);
    G := Byte(CalcG);
    B := 34;
  end;

  Painter.SetColor(MakeColor(R, G, B));

  // Draw the actual branch line
  Painter.Line(Round(X), Round(Y), Round(XEnd), Round(YEnd));

  // Recursively spawn left and right branches with reduced length and specific angles
  DrawBranch(Painter, XEnd, YEnd, Angle + 0.38, Length * 0.76, Depth - 1);
  DrawBranch(Painter, XEnd, YEnd, Angle - 0.32, Length * 0.72, Depth - 1);
end;

{==============================================================================
  Renders the Animated Fractal Tree canopy effect via TPixelPainter
==============================================================================}
procedure RenderFractalTree(var Painter: TPixelPainter; Frame: Integer);
var
  WindAngle: Double;
begin
  // Clear the screen with a smooth dark slate background
  Painter.SetColor(MakeColor(15, 18, 24));
  Painter.Clear;

  // Simulate wind forces slightly swaying the base angle using a sine wave over time
  WindAngle := DegToRad(90.0) + Sin(Frame * 0.04) * 0.06;

  // Start drawing from the bottom-center of the screen
  // Initial branch length = 135.0 pixels, recursion depth = 11 levels
  DrawBranch(Painter, Painter.GetWidth div 2, Painter.GetHeight - 15, WindAngle, 135.0, 11);
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

  Window.SetTitle('WinLite Software Render - Generative Fractal Canopy');

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
    RenderFractalTree(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
