{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteMandelbrotDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  Math, // Required for math functions: Sin, Cos, LogN, Min, Max
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
begin
  W := Painter.GetWidth;
  H := Painter.GetHeight;

  // Smooth cyclic zoom factor based on the cosine of the current frame
  Zoom := 1.2 + (Cos(Frame * 0.015) + 1.0) * 1.5;

  // Complex plane coordinate coordinates to focus on during magnification
  TargetX := -0.743643887037158;
  TargetY := 0.131825904205312;

  // Pixel-by-pixel rendering loop of the fractal viewport
  for Y := 0 to H - 1 do
  begin
    for X := 0 to W - 1 do
    begin
      // Map screen coordinates (X, Y) to the complex plane number C (Cr + i*Ci)
      // factoring in the active zoom magnification level and target offsets
      Cr := (X - W * 0.5) * (3.5 / (W * Zoom)) + TargetX;
      Ci := (Y - H * 0.5) * (2.5 / (H * Zoom)) + TargetY;

      Zr := 0.0;
      Zi := 0.0;
      ZrSq := 0.0;
      ZiSq := 0.0;
      Iter := 0;

      // Core iteration loop of the Mandelbrot quadratic recurrence formula: Z = Z^2 + C
      while (Iter < MaxIter) and (ZrSq + ZiSq < 4.0) do
      begin
        Zi := 2.0 * Zr * Zi + Ci;
        Zr := ZrSq - ZiSq + Cr;
        ZrSq := Zr * Zr;
        ZiSq := Zi * Zi;
        Inc(Iter);
      end;

      // Color assignment based on escape velocity criteria
      if Iter = MaxIter then
      begin
        // Points belonging inside the Mandelbrot set are rendered solid black
        R := 0; G := 0; B := 0;
      end
      else
      begin
        // Continuous smooth coloring algorithm using potential mathematical normalization
        Mu := Iter + 1.0 - LogN(2.0, LogN(2.0, ZrSq + ZiSq));

        // Generate neon wave cycles shifting gracefully through time
        R := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.3 + Frame * 0.05 + 0.0) + 1.0) * 127.5)));
        G := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.2 + Frame * 0.03 + 2.0) + 1.0) * 127.5)));
        B := Round(Min(255.0, Max(0.0, (Sin(Mu * 0.1 + Frame * 0.02 + 4.0) + 1.0) * 127.5)));
      end;

      Painter.SetColor(MakeColor(R, G, B));
      Painter.Pixel(X, Y);
    end;
  end;
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  // 1. Initialize the graphical system window
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Mandelbrot Fractal Zoom');

  // 2. Allocate memory for the pixel buffer array
  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // 3. Initialize the painter engine linked to the allocated window pixel space
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  // 4. Main loop handling graphics processing and operating system events
  while Window.IsRunning do
  begin
    // Process input and window action messages from the system queue
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            // Terminate application when the Escape key is pressed down
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;
      end;
    end;

    // Advance fractal animation frame index
    Inc(FrameCounter);

    // Call procedural fractal math renderer
    RenderMandelbrot(Render, FrameCounter);

    // Present the completed pixel memory architecture to the physical frame
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Safe release of components and termination of display systems
  Window.Done;
end.
