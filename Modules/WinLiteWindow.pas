{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteWindow;

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
  , WinLiteOpenGL1WindowWin9x
  {$ENDIF}
  {$IFDEF LINUX}
  , WinLiteSoftwareWindowLinux
  {$ENDIF}
  ;

type
  {$IFDEF IS_WINDOWS}
  TSoftwareWindow = TSoftwareWindowWin9x;
  TOpenGL1Window  = TOpenGL1Window9x;
  {$ENDIF}
  {$IFDEF LINUX}
  TSoftwareWindow = TSoftwareWindowLinux;
  {$ENDIF}

implementation

end.
