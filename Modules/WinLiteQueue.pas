{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteQueue;

{$mode objfpc}{$H+}

interface

uses
  WinLiteEvents;

type
  TEventArray = array of TEvent;

const
  DefaultCapacity = 256;

type
  TQueue = object
  private
    FRunning: Boolean;
    FBuffer: TEventArray;
    FHead: Integer;           
    FTail: Integer;           
    FCount: Integer;      
    function GetCapacity: Integer;
  public
    procedure Init(ACapacity: Integer = DefaultCapacity);
    procedure Done;
    function Empty: Boolean;
    function Full: Boolean;
    procedure Push(const AnEvent: TEvent);
    function Pop(var AnEvent: TEvent): Boolean;
    function IsRunning: Boolean;
    procedure Stop;
    property Capacity: Integer read GetCapacity;
    property Count: Integer read FCount;
  end;

implementation

{ TQueue }

procedure TQueue.Init(ACapacity: Integer);
begin
  FRunning := True;
  FHead := 0;
  FTail := 0;
  FCount := 0;
  if ACapacity < 1 then ACapacity := DefaultCapacity;
  SetLength(FBuffer, ACapacity);
end;

procedure TQueue.Done;
begin
  SetLength(FBuffer, 0);
  FCount := 0;
  FHead := 0;
  FTail := 0;
end;

function TQueue.GetCapacity: Integer;
begin
  Result := Length(FBuffer);
end;

function TQueue.Empty: Boolean;
begin
  Result := (FCount = 0);
end;

function TQueue.Full: Boolean;
begin
  Result := (FCount = Length(FBuffer));
end;

procedure TQueue.Push(const AnEvent: TEvent);
var
  Cap: Integer;
  NewBuffer: TEventArray;
  I: Integer;
begin
  Cap := Length(FBuffer);
  if Cap = 0 then
  begin
    Init(DefaultCapacity);
    Cap := Length(FBuffer);
  end;

  if Full then
  begin
    SetLength(NewBuffer, Cap * 2);
    for I := 0 to FCount - 1 do
      NewBuffer[I] := FBuffer[(FHead + I) mod Cap];
      
    FHead := 0;
    FTail := FCount;
    FBuffer := NewBuffer;
    Cap := Length(FBuffer);
  end;

  FBuffer[FTail] := AnEvent;
  FTail := (FTail + 1) mod Cap;
  Inc(FCount);
end;

function TQueue.Pop(var AnEvent: TEvent): Boolean;
var
  Cap: Integer;
begin
  Cap := Length(FBuffer);
  if (FCount = 0) or (Cap = 0) then
  begin
    Result := False;
    Exit;
  end;

  AnEvent := FBuffer[FHead];
  FHead := (FHead + 1) mod Cap;
  Dec(FCount);
  Result := True;
end;

function TQueue.IsRunning: Boolean;
begin
  Result := FRunning;
end;

procedure TQueue.Stop;
begin
  FRunning := False;
end;

end.
