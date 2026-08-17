unit TgaLoader;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes;

type
  TTgaHeader = packed record
    IdLength: Byte;
    ColorMapType: Byte;
    DataTypeCode: Byte;
    ColorMapOrigin: Word;
    ColorMapLength: Word;
    ColorMapDepth: Byte;
    XOrigin: Word;
    YOrigin: Word;
    Width: Word;
    Height: Word;
    BitsPerPixel: Byte;
    ImageDescriptor: Byte;
  end;

  TTgaError = (
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
    Pixels: array of Byte;

    procedure Free;
  end;

  TTgaLoader = object
    function LoadFromFile(const APath: string; out AImage: TImage; out AError: TTgaError): Boolean;
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

{ TTgaLoader }

function TTgaLoader.LoadFromFile(const APath: string; out AImage: TImage; out AError: TTgaError): Boolean;
var
  FileStream: TFileStream;
  Header: TTgaHeader;
  IsTopDown: Boolean;
  BytesPerPixel: Cardinal;
  DataSize: Cardinal;
  RawData: array of Byte;
  X, Y, TargetY: Cardinal;
  SrcRowOffset, DstRowOffset: Cardinal;
  SrcIdx, DstIdx: Cardinal;
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
    if FileStream.Size < SizeOf(TTgaHeader) then
    begin
      AError := errCorruptedHeader;
      Exit;
    end;

    FileStream.ReadBuffer(Header, SizeOf(Header));

    if Header.IdLength > 0 then
      FileStream.Position := FileStream.Position + Header.IdLength;

    if Header.DataTypeCode <> 2 then
    begin
      AError := errInvalidFormat;
      Exit;
    end;

    if (Header.BitsPerPixel <> 24) and (Header.BitsPerPixel <> 32) then
    begin
      AError := errUnsupportedBpp;
      Exit;
    end;

    if (Header.Width = 0) or (Header.Height = 0) then
    begin
      AError := errInvalidFormat;
      Exit;
    end;

    IsTopDown := (Header.ImageDescriptor and $20) <> 0;

    AImage.Bpp := 4;
    AImage.Width := Header.Width;
    AImage.Height := Header.Height;
    SetLength(AImage.Pixels, Cardinal(Header.Width) * Cardinal(Header.Height) * 4);

    BytesPerPixel := Header.BitsPerPixel div 8;
    DataSize := Cardinal(Header.Width) * Cardinal(Header.Height) * BytesPerPixel;

    SetLength(RawData, DataSize);
    if FileStream.Read(RawData, DataSize) <> DataSize then
    begin
      AError := errReadError;
      AImage.Free;
      Exit;
    end;

    for Y := 0 to Header.Height - 1 do
    begin
      if IsTopDown then
        TargetY := Y
      else
        TargetY := Header.Height - 1 - Y;

      SrcRowOffset := Y * Cardinal(Header.Width) * BytesPerPixel;
      DstRowOffset := TargetY * Cardinal(Header.Width) * 4;

      for X := 0 to Header.Width - 1 do
      begin
        SrcIdx := SrcRowOffset + (X * BytesPerPixel);
        DstIdx := DstRowOffset + (X * 4);

        AImage.Pixels[DstIdx + 0] := RawData[SrcIdx + 2];
        AImage.Pixels[DstIdx + 1] := RawData[SrcIdx + 1];
        AImage.Pixels[DstIdx + 2] := RawData[SrcIdx + 0];

        if BytesPerPixel = 4 then
          AImage.Pixels[DstIdx + 3] := RawData[SrcIdx + 3]
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

