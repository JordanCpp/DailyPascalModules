unit WinLiteSoftwareWindow;

{$mode objfpc}{$H+}

interface

uses
  WinLiteEvents
  {$IFDEF WINDOWS}
  ,WinLiteSoftwareWindowWin9x
  {$ENDIF}
  {$IFDEF LINUX}
  ,WinLiteSoftwareWindowLinux
  {$ENDIF}
  ;

type
  {$IFDEF WINDOWS}
  TSoftwareWindow = TSoftwareWindowWin9x;
  {$ENDIF}
  {$IFDEF LINUX}
  TSoftwareWindow = TSoftwareWindowLinux;
  {$ENDIF}

implementation

end.
