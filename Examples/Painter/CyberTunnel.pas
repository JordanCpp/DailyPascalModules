{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteTunnelDemo;

{$mode objfpc}{$H+}

uses
  Support,
  SysUtils,
  Math,
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
  MaxRings      = 25; // Number of simultaneous visible square rings in the tunnel

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Renders the infinite square tunnel effect via TPixelPainter
==============================================================================}
procedure RenderTunnel(var Painter: TPixelPainter; Frame: Integer);
var
  I, Step, Size, X, Y: Integer;
  CX, CY: Integer;
  W, H: Integer;
  C: Byte;
  Thickness: Integer;
begin
  // Clear background with a deep dark blue color (the far end of the tunnel)
  Painter.SetColor(MakeColor(5, 5, 15));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;
  CX := W div 2;
  CY := H div 2;

  Step := 32;      // Distance in pixels between adjacent tunnel rings
  Thickness := 4;  // Border thickness of each ring wall

  // Render rings in reverse order: from back (small) to front (large).
  for I := MaxRings downto 1 do
  begin
    // Forward movement smoothly wrapped
    Size := (I * Step) + (Frame mod Step);

    if Size <= Thickness * 2 then Continue;

    // Calculate top-left coordinates for the current square ring centered on screen
    X := CX - Size div 2;
    Y := CY - Size div 2;

    // Calculate smooth depth-based color fading.
    C := Round(Min(255.0, (Size / (MaxRings * Step)) * 255.0));

    // Define a cyber neon color shifting from indigo/blue to purple/pink
    Painter.SetColor(MakeColor(C, C div 4, 255 - C));

    Painter.Fill(X, Y, Size, Thickness);                                            // Top edge
    Painter.Fill(X, Y + Size - Thickness, Size, Thickness);                         // Bottom edge
    Painter.Fill(X, Y + Thickness, Thickness, Size - (Thickness * 2));              // Left edge
    Painter.Fill(X + Size - Thickness, Y + Thickness, Thickness, Size - (Thickness * 2)); // Right edge
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

  Window.SetTitle('WinLite Software Render - Infinite Cyber Tunnel');

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
    RenderTunnel(Render, FrameCounter);
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
