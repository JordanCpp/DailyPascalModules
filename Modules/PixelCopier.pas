unit PixelCopier;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Math;

const
  AlphaByte: Byte = 255;

{$if defined(windows) or defined(win32) or defined(win64)}
  idxR = 2;
  idxG = 1;
  idxB = 0;
{$else}
  idxR = 0;
  idxG = 1;
  idxB = 2;
{$ifend}
  idxA = 3;

type
  TPixelCopier = object
  private
    FWidth: NativeUInt;
    FHeight: NativeUInt;
    FBytesPerPixel: Byte;
    FPixelsRef: ^TBytes; 
    
    function GetPixelsSize: NativeInt; inline;
    function IsBufferValid: Boolean; inline;
  public
    procedure Init(W, H: NativeUInt; ABytesPerPixel: Byte; var APixels: TBytes);
    function GetWidth: NativeUInt;
    function GetHeight: NativeUInt;
    function GetBytesPerPixel: Byte;
    function Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
  end;

implementation

{ TPixelCopier }

function TPixelCopier.GetPixelsSize: NativeInt;
begin
  if FPixelsRef = nil then Exit(0);
  Result := Length(FPixelsRef^);
end;

function TPixelCopier.IsBufferValid: Boolean;
begin
  Result := (FPixelsRef <> nil) and (Length(FPixelsRef^) > 0);
end;

procedure TPixelCopier.Init(W, H: NativeUInt; ABytesPerPixel: Byte; var APixels: TBytes);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FPixelsRef := @APixels;
end;

function TPixelCopier.GetWidth: NativeUInt;
begin
  Result := FWidth;
end;

function TPixelCopier.GetHeight: NativeUInt;
begin
  Result := FHeight;
end;

function TPixelCopier.GetBytesPerPixel: Byte;
begin
  Result := FBytesPerPixel;
end;

function TPixelCopier.Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
var
  SrcX0, SrcY0: NativeUInt;
  DstX0, DstY0: NativeUInt;
  CopyW, CopyH: NativeUInt;
  RowIdx, ColIdx: NativeUInt;
  SrcRowStart, DstRowStart: NativeInt;
  SrcPixelIdx, DstPixelIdx: NativeInt;
  SrcPixelsSize: NativeInt;
  PixelsSize: NativeInt;
  
  R, G, B, A: Byte;
begin
  Result := False;

  SrcPixelsSize := Length(SrcPixels);
  if (not IsBufferValid) or (SrcPixelsSize = 0) or (W = 0) or (H = 0) or (ABytesPerPixel <> FBytesPerPixel) then 
    Exit;

  PixelsSize := GetPixelsSize;

  if X < 0 then
  begin
    if NativeUInt(-X) >= W then Exit;
    SrcX0 := NativeUInt(-X);
    DstX0 := 0;
  end
  else
  begin
    if NativeUInt(X) >= FWidth then Exit;
    SrcX0 := 0;
    DstX0 := NativeUInt(X);
  end;

  if Y < 0 then
  begin
    if NativeUInt(-Y) >= H then Exit;
    SrcY0 := NativeUInt(-Y);
    DstY0 := 0;
  end
  else
  begin
    if NativeUInt(Y) >= FHeight then Exit;
    SrcY0 := 0;
    DstY0 := NativeUInt(Y);
  end;

  CopyW := Min(W - SrcX0, FWidth - DstX0);
  CopyH := Min(H - SrcY0, FHeight - DstY0);

  if (CopyW = 0) or (CopyH = 0) then Exit;

  for RowIdx := 0 to CopyH - 1 do
  begin
    SrcRowStart := (NativeInt(SrcY0 + RowIdx) * NativeInt(W) + NativeInt(SrcX0)) * NativeInt(FBytesPerPixel);
    DstRowStart := (NativeInt(DstY0 + RowIdx) * NativeInt(FWidth) + NativeInt(DstX0)) * NativeInt(FBytesPerPixel);

    for ColIdx := 0 to CopyW - 1 do
    begin
      SrcPixelIdx := SrcRowStart + NativeInt(ColIdx) * NativeInt(FBytesPerPixel);
      DstPixelIdx := DstRowStart + NativeInt(ColIdx) * NativeInt(FBytesPerPixel);

      if (SrcPixelIdx + NativeInt(FBytesPerPixel) <= SrcPixelsSize) and 
         (DstPixelIdx + NativeInt(FBytesPerPixel) <= PixelsSize) then
      begin
        R := SrcPixels[SrcPixelIdx + 0];
        G := SrcPixels[SrcPixelIdx + 1];
        B := SrcPixels[SrcPixelIdx + 2];
        
        if FBytesPerPixel = 4 then
          A := SrcPixels[SrcPixelIdx + 3];

        FPixelsRef^[DstPixelIdx + idxR] := R;
        FPixelsRef^[DstPixelIdx + idxG] := G;
        FPixelsRef^[DstPixelIdx + idxB] := B;

        if FBytesPerPixel = 4 then
          FPixelsRef^[DstPixelIdx + idxA] := A;
      end;
    end;
  end;

  Result := True;
end;

end.
