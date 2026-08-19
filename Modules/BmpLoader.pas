{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit BmpLoader;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  Support,
  SysUtils, Classes;

type
  TBmpFileHeader = packed record
    FileType: Word;
    FileSize: Cardinal;
    Reserved1: Word;
    Reserved2: Word;
    DataOffset: Cardinal;
  end;

  TBmpInfoHeader = packed record
    Size: Cardinal;
    Width: LongInt;
    Height: LongInt;
    Planes: Word;
    BitCount: Word;
    Compression: Cardinal;
    ImageSize: Cardinal;
    XPelsPerMeter: LongInt;
    YPelsPerMeter: LongInt;
    ClrUsed: Cardinal;
    ClrImportant: Cardinal;
  end;

  TBmpError = (
    errOk,
    errFileNotFound,
    errInvalidFormat,
    errUnsupportedBpp,
    errCorruptedHeader,
    errReadError
  );

  TImage = object
    Bpp: Byte;
    Width: Cardinal;
    Height: Cardinal;
    Pixels: TBytes;

    procedure Free;
  end;

  TBmpLoader = object
    function Load(const APath: string; out AImage: TImage; out AError: TBmpError): Boolean;
  end;

implementation

{ TImage }

procedure TImage.Free;
begin
  Pixels := nil;
  Width := 0;
  Height := 0;
  Bpp := 0;
end;

{ TBmpLoader }

function TBmpLoader.Load(const APath: string; out AImage: TImage; out AError: TBmpError): Boolean;
var
  FileStream: TFileStream;
  FileHeader: TBmpFileHeader;
  InfoHeader: TBmpInfoHeader;
  IsTopDown: Boolean;
  BytesPerPixel: Cardinal;
  RowStride: Cardinal;
  RowBuffer: TBytes;
  X, Y, TargetY: Cardinal;
  SrcIdx, DstIdx: Cardinal;
  TargetRowOffset: Cardinal;
  AbsWidth, AbsHeight: Cardinal;
begin
  Result := False;
  AError := errOk;
  AImage.Width := 0;
  AImage.Height := 0;
  AImage.Bpp := 0;
  AImage.Pixels := nil;

  if not FileExists(APath) then
  begin
    AError := errFileNotFound;
    Exit;
  end;

  FileStream := TFileStream.Create(APath, fmOpenRead or fmShareDenyWrite);
  try
    if FileStream.Size < SizeOf(TBmpFileHeader) + SizeOf(TBmpInfoHeader) then
    begin
      AError := errCorruptedHeader;
      Exit;
    end;

    FileStream.ReadBuffer(FileHeader, SizeOf(FileHeader));
    FileStream.ReadBuffer(InfoHeader, SizeOf(InfoHeader));

    if FileHeader.FileType <> $4D42 then
    begin
      AError := errInvalidFormat;
      Exit;
    end;

    if (InfoHeader.Compression <> 0) or ((InfoHeader.BitCount <> 24) and (InfoHeader.BitCount <> 32)) then
    begin
      AError := errUnsupportedBpp;
      Exit;
    end;

    if InfoHeader.Width < 0 then AbsWidth := Cardinal(-InfoHeader.Width) else AbsWidth := Cardinal(InfoHeader.Width);
    if InfoHeader.Height < 0 then AbsHeight := Cardinal(-InfoHeader.Height) else AbsHeight := Cardinal(InfoHeader.Height);

    if (AbsWidth = 0) or (AbsHeight = 0) then
    begin
      AError := errCorruptedHeader;
      Exit;
    end;

    IsTopDown := InfoHeader.Height < 0;

    AImage.Bpp := 4;
    AImage.Width := AbsWidth;
    AImage.Height := AbsHeight;
    SetLength(AImage.Pixels, AbsWidth * AbsHeight * 4);

    if FileHeader.DataOffset >= Cardinal(FileStream.Size) then
    begin
      AError := errCorruptedHeader;
      AImage.Free;
      Exit;
    end;
    FileStream.Position := FileHeader.DataOffset;

    BytesPerPixel := InfoHeader.BitCount div 8;
    RowStride := (AbsWidth * BytesPerPixel + 3) and not 3;
    SetLength(RowBuffer, RowStride);

    for Y := 0 to AbsHeight - 1 do
    begin
      if FileStream.Read(RowBuffer[0], RowStride) < Integer(RowStride) then
      begin
        AError := errReadError;
        AImage.Free;
        Exit;
      end;

      if IsTopDown then TargetY := Y else TargetY := AbsHeight - 1 - Y;
      TargetRowOffset := TargetY * AbsWidth * 4;

      for X := 0 to AbsWidth - 1 do
      begin
        SrcIdx := X * BytesPerPixel;
        DstIdx := TargetRowOffset + (X * 4);

        AImage.Pixels[DstIdx + 0] := RowBuffer[SrcIdx + 2];
        AImage.Pixels[DstIdx + 1] := RowBuffer[SrcIdx + 1];
        AImage.Pixels[DstIdx + 2] := RowBuffer[SrcIdx + 0];

        if BytesPerPixel = 4 then
          AImage.Pixels[DstIdx + 3] := RowBuffer[SrcIdx + 3]
        else
          AImage.Pixels[DstIdx + 3] := 255;
      end;
    end;

    Result := True;
  finally
    FileStream.Free;
  end;
end;

end.
