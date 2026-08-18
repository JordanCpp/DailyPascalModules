unit WinLiteSoftwareWindow;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

{$IFDEF WIN32}
  {$DEFINE IS_WINDOWS}
{$ELSE}
  {$IFDEF MSWINDOWS}
    {$DEFINE IS_WINDOWS}
  {$ENDIF}
{$ENDIF}

uses
  WinLiteEvents
  {$IFDEF IS_WINDOWS}
  , WinLiteSoftwareWindowWin9x
  {$ENDIF}
  {$IFDEF LINUX}
  , WinLiteSoftwareWindowLinux
  {$ENDIF}
  ;

type
  {$IFDEF IS_WINDOWS}
  TSoftwareWindow = TSoftwareWindowWin9x;
  {$ENDIF}
  {$IFDEF LINUX}
  TSoftwareWindow = TSoftwareWindowLinux;
  {$ENDIF}

implementation

end.
