{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteStarfieldDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Min, Max
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
  MaxStars      = 150; // Total number of active stars in space

type
  TStar = record
    X: Double;
    Y: Double;
    Z: Double;
  end;

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  
  Stars       : array[0..MaxStars - 1] of TStar;
  I           : Integer;

{==============================================================================
  Renders the 3D Starfield Warp perspective effect via TPixelPainter
==============================================================================}
procedure RenderStarfield(var Painter: TPixelPainter);
var
  Idx, CX, CY, Size: Integer;
  ScreenX, ScreenY: Integer;
  W, H: Integer;
  Brightness: Integer;
begin
  // Clear the canvas with a deep dark space background
  Painter.SetColor(MakeColor(5, 5, 12));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;
  CX := W div 2;
  CY := H div 2;

  for Idx := 0 to MaxStars - 1 do
  begin
    Stars[Idx].Z := Stars[Idx].Z - 6.0;

    if Stars[Idx].Z <= 10.0 then
    begin
      Stars[Idx].X := Random(W) - CX;
      Stars[Idx].Y := Random(H) - CY;
      Stars[Idx].Z := 1000.0;
    end;

    // Perspective projection 3D -> 2D
    ScreenX := Round(CX + (Stars[Idx].X * 450.0) / Stars[Idx].Z);
    ScreenY := Round(CY + (Stars[Idx].Y * 450.0) / Stars[Idx].Z);

    if (ScreenX < 0) or (ScreenX >= W) or (ScreenY < 0) or (ScreenY >= H) then
      Continue;

    // Scaling star projection sizes. Closer vectors scale up.
    Size := Round((1000.0 - Stars[Idx].Z) / 220.0);
    if Size < 1 then Size := 1;
    if Size > 5 then Size := 5;

    // Calculate depth atmospheric fading
    Brightness := Round((1000.0 - Stars[Idx].Z) * 0.255);
    Brightness := Min(255, Max(30, Brightness));

    // Tint distant objects slightly blue-ish, tint close objects bright white
    if Size <= 2 then
      Painter.SetColor(MakeColor(Brightness div 2, Brightness div 2, Brightness))
    else
      Painter.SetColor(MakeColor(Brightness, Brightness, Brightness));

    Painter.Fill(ScreenX, ScreenY, Size, Size);
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

  Window.SetTitle('WinLite Software Render - 3D Starfield Warp');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  
  Randomize;
  
  for I := 0 to MaxStars - 1 do
  begin
    Stars[I].X := Random(WinWidth) - (WinWidth div 2);
    Stars[I].Y := Random(WinHeight) - (WinHeight div 4);
    Stars[I].Z := Random(1000);
  end;

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

    RenderStarfield(Render);

    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
