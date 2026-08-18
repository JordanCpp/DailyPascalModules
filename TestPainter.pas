{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program Test;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  PixelPainter,
  PixelCopier,
  WinLiteEnums,
  WinLiteEvents,
  WinLiteSoftwareWindow,
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
  Copier      : TPixelCopier;
  FrameCounter: Integer;
  BmpLoad     : TBmpLoader;
  BmpImage    : TImage;
  BmpError    : TBmpError;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  Copier.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  BmpLoad.Load('LDL_24_256.bmp', BmpImage, BmpError);

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

    Render.SetColor(MakeColor(10, 20, 40 + (FrameCounter mod 30)));
    Render.Clear;

    Render.SetColor(MakeColor(0, 255, 128));
    Render.Line(0, 0, WinWidth - 1, (FrameCounter * 4) mod WinHeight);
    Render.Line(WinWidth - 1, WinHeight - 1, 0, WinHeight - 1 - ((FrameCounter * 4) mod WinHeight));

    Render.SetColor(MakeColor(255, 64, 64));
    Render.Fill(WinWidth div 2 - 50, WinHeight div 2 - 50, 100, 100);

    Copier.Copy(0, 0, BmpImage.Width, BmpImage.Height, BmpImage.Bpp, BmpImage.Pixels);

    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  Window.Done;
end.
