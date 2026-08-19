{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit FpsCounter;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  SysUtils,
  {$IFDEF WIN32}
    Windows;
  {$ELSE}
    {$IFDEF MSWINDOWS}
      Windows;
    {$ELSE}
      Windows;
    {$ENDIF}
  {$ENDIF}

type
  TFpsCounter = object
  private
    FLastTime   : Cardinal;
    FFrameCount : Cardinal;
    FFps        : Cardinal;
  public
    procedure Init;
    function Update: Boolean;
    function GetFps: Cardinal;
  end;

implementation

{ TFpsCounter }

procedure TFpsCounter.Init;
begin
  FLastTime   := GetTickCount;
  FFrameCount := 0;
  FFps        := 0;
end;

function TFpsCounter.Update: Boolean;
var
  NowTime : Cardinal;
  Elapsed : Cardinal;
begin
  Result := False;
  Inc(FFrameCount);

  NowTime := GetTickCount;
  
  if NowTime >= FLastTime then
    Elapsed := NowTime - FLastTime
  else
    Elapsed := (High(Cardinal) - FLastTime) + NowTime + 1;

  if Elapsed >= 1000 then
  begin
    FFps        := FFrameCount;
    FFrameCount := 0;
    FLastTime   := NowTime;
    Result      := True;
  end;
end;

function TFpsCounter.GetFps: Cardinal;
begin
  Result := FFps;
end;

end.
