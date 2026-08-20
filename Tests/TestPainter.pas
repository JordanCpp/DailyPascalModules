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
  FpsCounter,
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
  Copier      : TPixelCopier;
  FrameCounter: Integer;
  BmpLoad     : TBmpLoader;
  BmpImage    : TImage;
  BmpError    : TBmpError;
  Performance : TFpsCounter;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // Initializing objects by reference passing via clean managed TBytes arrays
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  Copier.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);
  
  // Initialize the framerate performance metrics tracking
  Performance.Init;
  FrameCounter := 0;

  // Load the source asset (BmpLoader reads raw data into unified RGB memory format)
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

    // Update FPS Counter and refresh window title metrics once per second
    if Performance.Update then
    begin
      Window.SetTitle('WinLite Software Render - FPS: ' + IntToStr(Performance.GetFps) + ' - Press ESC to exit');
    end;

    // Background procedural flashing wash clearance
    Render.SetColor(MakeColor(10, 20, 40 + (FrameCounter mod 30)));
    Render.Clear;

    // Render moving vector accent lines using safe TPixelPainter primitives
    Render.SetColor(MakeColor(0, 255, 128));
    Render.Line(0, 0, WinWidth - 1, (FrameCounter * 4) mod WinHeight);
    Render.Line(WinWidth - 1, WinHeight - 1, 0, WinHeight - 1 - ((FrameCounter * 4) mod WinHeight));

    // Render central solid geometric fill block using high-speed block Move cloning
    Render.SetColor(MakeColor(255, 64, 64));
    Render.Fill(WinWidth div 2 - 50, WinHeight div 2 - 50, 100, 100);

    // Blit the image asset onto the native frame window viewport buffer
    // Copier.Copy maps clean RGB inputs to platform specific BGR(A) GDI layouts via constants
    if (BmpImage.Width > 0) and (BmpImage.Height > 0) then
    begin
      Copier.Copy(0, 0, BmpImage.Width, BmpImage.Height, BmpImage.Bpp, BmpImage.Pixels);
    end;

    // Display the finalized CPU frame buffer memory layout blocks to the screen device context
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Cleanup references and objects allocation handles
  BmpImage.Free;
  Window.Done;
end.
