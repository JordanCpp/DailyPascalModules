{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program MatrixDigitalRain;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Min
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
  MaxDrops      = 45; // Maximum number of simultaneously falling rain drops

type
  TMatrixDrop = record
    X: Integer;
    Y: Single;
    Speed: Single;
    Len: Integer;
  end;

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  
  Drops       : array[0..MaxDrops - 1] of TMatrixDrop;
  I           : Integer;

{==============================================================================
  Renders the Matrix digital rain falling stream effect via TPixelPainter
==============================================================================}
procedure RenderMatrixRain(var Painter: TPixelPainter);
var
  I, Bright, SegmentY: Integer;
  FinalGreen: Integer;
  TailSegments: Integer;
begin
  // Clear the canvas with a very deep dark green tone to simulate monitor glow
  Painter.SetColor(MakeColor(0, 4, 1));
  Painter.Clear;

  for I := 0 to MaxDrops - 1 do
  begin
    Drops[I].Y := Drops[I].Y + Drops[I].Speed;
    
    if Drops[I].Y > Painter.GetHeight + Drops[I].Len then
    begin
      Drops[I].X := Random(Painter.GetWidth div 16) * 16 + 8;
      Drops[I].Y := -Drops[I].Len - Random(100);
      Drops[I].Speed := 3.0 + Random(4);
      Drops[I].Len := 60 + Random(140);
    end;

    TailSegments := Drops[I].Len div 5;

    for Bright := 0 to TailSegments do
    begin
      FinalGreen := Min(255, Bright * (255 div TailSegments));
      Painter.SetColor(MakeColor(0, FinalGreen, 0));
      
      SegmentY := Round(Drops[I].Y) - Drops[I].Len + (Bright * 5);
      Painter.Line(Drops[I].X, SegmentY, Drops[I].X, SegmentY + 4);
    end;

    // Draw a bright, almost pure white leading "head" at the very tip of the stream
    Painter.SetColor(MakeColor(190, 255, 200));
    Painter.Line(Drops[I].X, Round(Drops[I].Y), Drops[I].X, Round(Drops[I].Y) + 3);
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

  Window.SetTitle('WinLite Software Render - Matrix Digital Rain');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  Randomize;

  for I := 0 to MaxDrops - 1 do
  begin
    Drops[I].X := Random(WinWidth div 16) * 16 + 8;
    Drops[I].Len := 60 + Random(140);
    Drops[I].Y := Random(WinHeight + Drops[I].Len) - Drops[I].Len;
    Drops[I].Speed := 3.0 + Random(4);
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

    RenderMatrixRain(Render);

    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
