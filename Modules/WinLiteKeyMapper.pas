unit WinLiteKeyMapper;

{$mode objfpc}{$H+}

interface

uses
  WinLiteEnums;

const
  MaxKeyTableSize = 256;

type
  TKeyMap = object
    Key: TKey;
    Code: Cardinal;
  end;

  TKeyMapArray = array[0..MaxKeyTableSize - 1] of TKeyMap;

  TKeyMapper = object
    Current: NativeUInt;
    Table: TKeyMapArray;

    procedure Init;
    procedure Add(ACode: Cardinal; AKey: TKey);
    function FindKey(AScanCode: Cardinal): TKey;
    procedure Clear;
  end;

implementation

{ TKeyMapper }

procedure TKeyMapper.Init;
begin
  Self.Clear;
  FillChar(Self.Table, SizeOf(Self.Table), 0);
end;

procedure TKeyMapper.Add(ACode: Cardinal; AKey: TKey);
begin
  if Current < MaxKeyTableSize then
  begin
    Table[Current].Key := AKey;
    Table[Current].Code := ACode;
    Inc(Current);
  end;
end;

function TKeyMapper.FindKey(AScanCode: Cardinal): TKey;
var
  I: NativeUInt;
begin
  for I := 0 to Current - 1 do
  begin
    if Table[I].Code = AScanCode then
    begin
      Exit(Table[I].Key);
    end;
  end;
  Result := TKey.keyUnknown;
end;

procedure TKeyMapper.Clear;
begin
  Current := 0;
end;

end.

