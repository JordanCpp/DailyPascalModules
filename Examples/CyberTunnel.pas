{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program WinLiteTunnelDemo;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support,
  SysUtils,
  Math, // Required for EnsureRange / Min functions
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
  // This ensures closer rings properly overlap farther ones (Z-ordering).
  for I := MaxRings downto 1 do
  begin
    // Forward movement: ring size expands based on current frame,
    // wrapping around smoothly using the mod operator once it exceeds 'Step'
    Size := (I * Step) + (Frame mod Step);

    // Calculate top-left coordinates for the current square ring centered on screen
    X := CX - Size div 2;
    Y := CY - Size div 2;

    // Calculate smooth depth-based color fading.
    // Fixed: Prevent Byte overflow by clamping the value strictly to 0..255 inside Round()
    C := Round(Min(255.0, (Size / (MaxRings * Step)) * 255.0));

    // Define a cyber neon color shifting from indigo/blue to purple/pink
    Painter.SetColor(MakeColor(C, C div 4, 255 - C));

    // Check if the ring is at least partially visible within screen boundaries
    if (X + Size >= 0) and (X < W) and (Y + Size >= 0) and (Y < H) then
    begin
      // Draw 4 walls of the cyber corridor using rectangle fills
      Painter.Fill(X, Y, Size, Thickness);                       // Top edge
      Painter.Fill(X, Y + Size - Thickness, Size, Thickness);    // Bottom edge
      Painter.Fill(X, Y, Thickness, Size);                       // Left edge
      Painter.Fill(X + Size - Thickness, Y, Thickness, Size);    // Right edge
    end;
  end;
end;

{==============================================================================
  Main Program Block
==============================================================================}
begin
  // 1. Initialize the graphical window
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite Software Render - Infinite Cyber Tunnel');

  // 2. Allocate memory for the pixel buffer array
  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);

  // 3. Initialize the painter object linked to the allocated buffer
  Render.Init(WinWidth, WinHeight, BytesPerPixel, PixelBuffer);

  FrameCounter := 0;

  // 4. Main render loop and system event handling
  while Window.IsRunning do
  begin
    // Process the operating system message queue
    while Window.GetEvent(Event) do
    begin
      case Event.FType of
        Quit:
          begin
            Window.StopEvent;
          end;

        Keyboard:
          begin
            // Exit application when the Escape key is pressed
            if (Event.Keyboard.Key = keyEscape) and (Event.Keyboard.State = Pressed) then
              Window.StopEvent;
          end;
      end;
    end;

    // Increment animation frame step
    Inc(FrameCounter);

    // Call the procedural tunnel renderer
    RenderTunnel(Render, FrameCounter);

    // Swap buffers: Present the complete PixelBuffer to the physical screen
    Window.Present(PixelBuffer, WinWidth, WinHeight);
  end;

  // Clean up resources and close window subsystems
  Window.Done;
end.
