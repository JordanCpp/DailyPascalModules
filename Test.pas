program Test;

{$mode objfpc}{$H+}

uses
  Painter,
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

      if Event.FType = TEventType.Quit then
      begin
            Window.StopEvent;
      end;

      end;

    end;

  Window.Done;
end.
