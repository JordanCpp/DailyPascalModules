{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit FpsCounter;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  TFpsCounter = object
  private
    FLastTime   : QWord;
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
  FLastTime   := GetTickCount64;
  FFrameCount := 0;
  FFps        := 0;
end;

function TFpsCounter.Update: Boolean;
var
  NowTime : QWord;
  Elapsed : QWord;
begin
  Result := False;
  Inc(FFrameCount);

  NowTime := GetTickCount64;

  if NowTime >= FLastTime then
    Elapsed := NowTime - FLastTime
  else
    Elapsed := 0;

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
