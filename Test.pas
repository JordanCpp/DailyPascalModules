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
  PixelPainter,
  PixelCopier,
  WinLiteEnums,
  WinLiteEvents,
  WinLiteSoftwareWindow;

var
  Window: TSoftwareWindow;
  Event : TEvent;
  Error : string;

begin
  if not Window.CreateWindow(800, 600, 'WinLite Hello World (Object Pascal)', Error) then
  begin
    WriteLn('Error: ', Error);
    Halt(1);
  end;

  Window.SetTitle('WinLite - Move mouse or press ESC to exit');

  while Window.IsRunning do
  begin

    while Window.GetEvent(Event) do
    begin

      if Event.FType = Quit then
      begin
            Window.StopEvent;
      end;

      end;

    end;

  Window.Done;
end.
