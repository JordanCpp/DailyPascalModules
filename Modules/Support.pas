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

