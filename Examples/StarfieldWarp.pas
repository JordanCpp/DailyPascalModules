{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteStarfieldDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

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

var
  Window      : TSoftwareWindow;
  Event       : TEvent;
  Error       : string;
  PixelBuffer : TBytes;
  BufferSize  : Integer;
  Render      : TPixelPainter;
  FrameCounter: Integer;

{==============================================================================
  Renders the 3D Starfield Warp perspective effect via TPixelPainter
==============================================================================}
procedure RenderStarfield(var Painter: TPixelPainter; Frame: Integer);
var
  I, CX, CY, Size: Integer;
  StarX, StarY, StarZ: Double;
  ScreenX, ScreenY: Integer;
  W, H: Integer;
  Brightness: Integer;
begin
  // Clear the canvas with a deep dark space background (almost black with subtle blue)
  Painter.SetColor(MakeColor(5, 5, 12));
  Painter.Clear;

  W := Painter.GetWidth;
  H := Painter.GetHeight;
  CX := W div 2;
  CY := H div 2;

  // Initialize pseudo-random generator with a fixed seed every frame.
  // This guarantees that stars retain their spatial base trajectory vectors.
  RandSeed := 42;

  for I := 0 to MaxStars - 1 do
  begin
    // Generate pseudo-random 3D coordinates for the current star vector space
    StarX := Random(W) - CX;
    StarY := Random(H) - CY;

    // Calculate current star depth distance (Z) using integer arithmetic.
    // Progressively advances forward, resetting cleanly via modulo operations.
    StarZ := 1000 - (I * (1000 div MaxStars) + Frame * 6) mod 1000;
    if StarZ <= 0 then
      StarZ := StarZ + 1000.0;

    // Perspective projection 3D -> 2D: divide coordinates by relative depth Z.
    // Factor 450.0 represents focal length properties (camera FOV).
    ScreenX := Round(CX + (StarX * 450.0) / StarZ);
    ScreenY := Round(CY + (StarY * 450.0) / StarZ);

    // Scaling star projection sizes. Closer vectors (low Z values) scale up.
    Size := Round((1000.0 - StarZ) / 220.0);
    if Size < 1 then Size := 1;
    if Size > 5 then Size := 5; // Constrain maximum diameter for close-range points

    // Calculate depth atmospheric fading: distant sparks are dim, close ones are bright white.
    Brightness := Round((1000.0 - StarZ) * 0.255);
    Brightness := Min(255, Max(30, Brightness));

    // Evaluate clip boundary constraints against window screen dimensions
    if (ScreenX >= 0) and (ScreenX + Size < W) and
       (ScreenY >= 0) and (ScreenY + Size < H) then
    begin
      // Tint distant objects slightly blue-ish, tint close objects bright white
      if Size <= 2 then
        Painter.SetColor(MakeColor(Brightness div 2, Brightness div 2, Brightness))
      else
        Painter.SetColor(MakeColor(Brightness, Brightness, Brightness));

      // Draw the single star component architecture
      Painter.Fill(ScreenX, ScreenY, Size, Size);
    end;
  end;
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  // 1. Initialize the graphical viewport windows
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - 3D Starfield Warp');

  // 2. Allocate memory array bounds for screen raw pixel alignment
  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // 3. Initialize the painter entity linked to the allocated window pixel storage
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  // 4. Main loop resolving application logic, rendering frames, and filtering OS events
  while Window.IsRunning do
  begin
    // Poll hardware and operational input data tokens from message queue
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            // Break loop and exit application when the Escape key is identified
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;
      end;
    end;

    // Advance mathematical frame modifier sequence
    Inc(FrameCounter);

    // Invoke procedural graphics starfield engine
    RenderStarfield(Render, FrameCounter);

    // Swap buffers: Present the complete memory payload directly to display panel via API
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Dismantle active instances, free handles, and close down context structures
  Window.Done;
end.
