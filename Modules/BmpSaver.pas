{==============================================================================
Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
Distributed under the Boost Software License, Version 1.0.
(See accompanying file LICENSE_1_0.txt or copy at
https://boost.org)
==============================================================================}

unit BmpSaver;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  Support,
  SysUtils,
  Classes;

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

  TSaverError = (
    savOk,
    savInvalidSource,
    savCannotCreateFile,
    savWriteError
  );

  TSaverImage = record
    Bpp: Byte;
    Width: Cardinal;
    Height: Cardinal;
    Pixels: TBytes;
  end;

  TBmpSaver = object
    function Save(const APath: string; const AImage: TSaverImage; ASaveAs32Bit: Boolean; out AError: TSaverError): Boolean;
  end;

implementation

{ TBmpSaver }

function TBmpSaver.Save(const APath: string; const AImage: TSaverImage; ASaveAs32Bit: Boolean; out AError: TSaverError): Boolean;
var
  FileStream: TFileStream;
  FileHeader: TBmpFileHeader;
  InfoHeader: TBmpInfoHeader;
  BytesPerPixel: Cardinal;
  RowStride: Cardinal;
  RowBuffer: TBytes;
  X, Y: Cardinal;
  SrcIdx, DstIdx: Cardinal;
  RowOffset: Cardinal;
begin
  Result := False;
  AError := savOk;

  if (AImage.Width = 0) or (AImage.Height = 0) or (Length(AImage.Pixels) = 0) then
  begin
    AError := savInvalidSource;
    Exit;
  end;

  if ASaveAs32Bit then
    BytesPerPixel := 4
  else
    BytesPerPixel := 3;

  RowStride := (AImage.Width * BytesPerPixel + 3) and not 3;

  FillChar(FileHeader, SizeOf(FileHeader), 0);
  FileHeader.FileType := $4D42; { 'BM' }
  FileHeader.DataOffset := SizeOf(TBmpFileHeader) + SizeOf(TBmpInfoHeader);
  FileHeader.FileSize := FileHeader.DataOffset + (RowStride * AImage.Height);

  FillChar(InfoHeader, SizeOf(InfoHeader), 0);
  InfoHeader.Size := SizeOf(TBmpInfoHeader);
  InfoHeader.Width := LongInt(AImage.Width);
  InfoHeader.Height := LongInt(AImage.Height);
  InfoHeader.Planes := 1;
  InfoHeader.BitCount := Word(BytesPerPixel * 8);
  InfoHeader.Compression := 0; { BI_RGB }
  InfoHeader.ImageSize := RowStride * AImage.Height;

  try
    FileStream := TFileStream.Create(APath, fmCreate);
  except
    AError := savCannotCreateFile;
    Exit;
  end;

  try
    SetLength(RowBuffer, RowStride);

    FileStream.WriteBuffer(FileHeader, SizeOf(FileHeader));
    FileStream.WriteBuffer(InfoHeader, SizeOf(InfoHeader));

    for Y := 0 to AImage.Height - 1 do
    begin
      RowOffset := (AImage.Height - 1 - Y) * AImage.Width * 4;

      if RowStride > 0 then
        FillChar(RowBuffer, RowStride, 0);

      for X := 0 to AImage.Width - 1 do
      begin
        SrcIdx := RowOffset + (X * 4);
        DstIdx := X * BytesPerPixel;

        RowBuffer[DstIdx + 0] := AImage.Pixels[SrcIdx + 0]; { B }
        RowBuffer[DstIdx + 1] := AImage.Pixels[SrcIdx + 1]; { G }
        RowBuffer[DstIdx + 2] := AImage.Pixels[SrcIdx + 2]; { R }

        if BytesPerPixel = 4 then
          RowBuffer[DstIdx + 3] := AImage.Pixels[SrcIdx + 3]; { A }
      end;

      FileStream.WriteBuffer(RowBuffer[0], Integer(RowStride));
    end;

    Result := True;

  except
    AError := savWriteError;
  end;

  RowBuffer := nil;
  FileStream.Free;
end;

end.
