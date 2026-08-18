{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit Support;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses 
  SysUtils;

type
  {$IFDEF FPC}
  TBytes = SysUtils.TBytes;
  {$ELSE}
  TBytes = array of Byte;
  PByte = ^Byte;
  PCardinal = ^Cardinal;
  {$ENDIF}

implementation

end.

