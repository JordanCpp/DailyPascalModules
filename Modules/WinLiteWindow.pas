{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteWindow;

{$mode objfpc}{$H+}

interface

uses
  WinLiteEvents
  {$IFDEF MSWINDOWS}
  ,WinLiteSoftwareWindowWin9x
  ,WinLiteOpenGL1WindowWin9x
  ,WinLiteOpenGL3WindowWin9x
  {$ENDIF}

  {$IFDEF LINUX}
  ,WinLiteSoftwareWindowXLib
  ,WinLiteOpenGL1WindowXLib
  ,WinLiteOpenGL3WindowXLib
  {$ENDIF}
  ;

type
  {$IFDEF MSWINDOWS}
  TSoftwareWindow = TSoftwareWindowWin9x;
  TOpenGL1Window  = TOpenGL1Window9x;
  TOpenGL3Window  = TOpenGL3Window9x;
  {$ENDIF}

  {$IFDEF LINUX}
  TSoftwareWindow = TSoftwareWindowXLib;
  TOpenGL1Window  = TOpenGL1WindowXLib;
  TOpenGL3Window  = TOpenGL3WindowXLib;
  {$ENDIF}

implementation

end.
