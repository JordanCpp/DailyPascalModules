{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit HighResTimer;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  SysUtils;

type
  THighResTimer = object
  private
    FInitialized : Boolean;
    {$IFDEF MSWINDOWS}
    FFrequency   : Int64;
    {$ENDIF}
  public
    procedure Init;
    function GetTime: Double;
    function GetElapsed(const AStart: Double): Double;
  end;

implementation

{$IFDEF MSWINDOWS}
  function QueryPerformanceFrequency(out lpFrequency: Int64): LongBool; stdcall; external 'kernel32.dll' name 'QueryPerformanceFrequency';
  function QueryPerformanceCounter(out lpPerformanceCount: Int64): LongBool; stdcall; external 'kernel32.dll' name 'QueryPerformanceCounter';
  function GetTickCount: Cardinal; stdcall; external 'kernel32.dll' name 'GetTickCount';
{$ENDIF}

{$IFDEF UNIX}
  {$IFDEF FPC}
    uses UnixCli;
  {$ENDIF}
{$ENDIF}

{ THighResTimer }

procedure THighResTimer.Init;
begin
  FInitialized := True;
  {$IFDEF MSWINDOWS}
  if not QueryPerformanceFrequency(FFrequency) then
    FFrequency := 0;
  {$ENDIF}
end;

function THighResTimer.GetTime: Double;
{$IFDEF MSWINDOWS}
var
  Counter: Int64;
begin
  if not FInitialized then Init;

  if FFrequency > 0 then
  begin
    QueryPerformanceCounter(Counter);
    Result := Counter / FFrequency;
  end
  else
  begin
    Result := GetTickCount / 1000.0;
  end;
end;
{$ELSE}
  {$IFDEF UNIX}
  var
    TimeVal: TTimeVal;
  begin
    if not FInitialized then Init;
    fpGetTimeOfDay(@TimeVal, nil);
    Result := TimeVal.Tv_Sec + (TimeVal.Tv_Usec / 1000000.0);
  end;
  {$ELSE}
  begin
    if not FInitialized then Init;
    Result := SysUtils.Now * 86400.0;
  end;
  {$ENDIF}
{$ENDIF}

function THighResTimer.GetElapsed(const AStart: Double): Double;
var
  Current: Double;
begin
  Current := GetTime;
  if Current >= AStart then
    Result := Current - AStart
  else
    Result := 0.0;
end;

end.

