unit Painter;

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
  TColor = record
    R: Byte;
    G: Byte;
    B: Byte;
    A: Byte;
  end;

function MakeColor(ARed, AGreen, ABlue: Byte; AAlpha: Byte = 255): TColor;

type
  TPainter = object
  private
    FColor: TColor;
    FWidth: NativeUInt;
    FHeight: NativeUInt;
    FBytesPerPixel: Byte;
    FPixels: PByte;
    FPixelsSize: NativeInt;
  public
    procedure Init(W, H: NativeUInt; ABytesPerPixel: Byte; APixels: PByte; APixelsSize: NativeInt);

    function GetColor: TColor;
    function GetWidth: NativeUInt;
    function GetHeight: NativeUInt;
    function GetBytesPerPixel: Byte;

    procedure SetColor(const AColor: TColor);
    procedure Clear;
    procedure Pixel(X, Y: NativeUInt);
    procedure Line(X0, Y0, X1, Y1: Integer);
    procedure Fill(X, Y, AWidth, AHeight: Integer);
    function Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; APixels: PByte; APixelsSize: NativeInt): Boolean;
  end;

implementation

function MakeColor(ARed, AGreen, ABlue: Byte; AAlpha: Byte): TColor;
begin
  Result.R := ARed;
  Result.G := AGreen;
  Result.B := ABlue;
  Result.A := AAlpha;
end;

{ TPainter }

procedure TPainter.Init(W, H: NativeUInt; ABytesPerPixel: Byte; APixels: PByte; APixelsSize: NativeInt);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FPixels := APixels;
  FPixelsSize := APixelsSize;
  FColor := MakeColor(0, 0, 0, AlphaByte);
end;

function TPainter.GetColor: TColor;
begin
  Result := FColor;
end;

function TPainter.GetWidth: NativeUInt;
begin
  Result := FWidth;
end;

function TPainter.GetHeight: NativeUInt;
begin
  Result := FHeight;
end;

function TPainter.GetBytesPerPixel: Byte;
begin
  Result := FBytesPerPixel;
end;

procedure TPainter.SetColor(const AColor: TColor);
begin
  FColor := AColor;
end;

procedure TPainter.Clear;
var
  I: NativeInt;
  PackedColor: Cardinal;
  Dest32: PCardinal;
  PBytes: PByte;
begin
  if FPixels = nil then Exit;

  if (FColor.R = FColor.G) and (FColor.G = FColor.B) and
     ((FBytesPerPixel = 3) or (FColor.B = FColor.A)) then
  begin
    FillChar(FPixels^, FPixelsSize, FColor.R);
    Exit;
  end;

  if FBytesPerPixel = 4 then
  begin
    PackedColor := 0;
    PBytes := PByte(@PackedColor);
    PBytes[idxR] := FColor.R;
    PBytes[idxG] := FColor.G;
    PBytes[idxB] := FColor.B;
    PBytes[idxA] := FColor.A;

    Dest32 := PCardinal(FPixels);
    for I := 0 to (FPixelsSize div 4) - 1 do
    begin
      Dest32^ := PackedColor;
      Inc(Dest32);
    end;
  end
  else
  begin
    I := 0;
    while I < FPixelsSize - 2 do
    begin
      FPixels[I + idxR] := FColor.R;
      FPixels[I + idxG] := FColor.G;
      FPixels[I + idxB] := FColor.B;
      Inc(I, 3);
    end;
  end;
end;

procedure TPainter.Pixel(X, Y: NativeUInt);
var
  Idx: NativeInt;
begin
  if (X >= FWidth) or (Y >= FHeight) or (FPixels = nil) then Exit;

  Idx := (NativeInt(Y) * NativeInt(FWidth) + NativeInt(X)) * NativeInt(FBytesPerPixel);

  FPixels[Idx + idxR] := FColor.R;
  FPixels[Idx + idxG] := FColor.G;
  FPixels[Idx + idxB] := FColor.B;

  if FBytesPerPixel = 4 then
    FPixels[Idx + idxA] := FColor.A;
end;

procedure TPainter.Line(X0, Y0, X1, Y1: Integer);
var
  Dx, Dy, Sx, Sy, Err, E2: Integer;
  Idx: NativeInt;
begin
  if FPixels = nil then Exit;

  Dx := Abs(X1 - X0);
  Dy := Abs(Y1 - Y0);
  Sx := IfThen(X0 < X1, 1, -1);
  Sy := IfThen(Y0 < Y1, 1, -1);
  Err := Dx - Dy;

  while True do
  begin
    if (X0 >= 0) and (NativeUInt(X0) < FWidth) and
       (Y0 >= 0) and (NativeUInt(Y0) < FHeight) then
    begin
      Idx := (NativeInt(Y0) * NativeInt(FWidth) + NativeInt(X0)) * NativeInt(FBytesPerPixel);
      FPixels[Idx + idxR] := FColor.R;
      FPixels[Idx + idxG] := FColor.G;
      FPixels[Idx + idxB] := FColor.B;

      if FBytesPerPixel = 4 then
        FPixels[Idx + idxA] := FColor.A;
    end;

    if (X0 = X1) and (Y0 = Y1) then Break;

    E2 := 2 * Err;
    if E2 > -Dy then
    begin
      Dec(Err, Dy);
      Inc(X0, Sx);
    end;
    if E2 < Dx then
    begin
      Inc(Err, Dx);
      Inc(Y0, Sy);
    end;
  end;
end;

procedure TPainter.Fill(X, Y, AWidth, AHeight: Integer);
var
  X0, Y0, X1, Y1, CurrY, CurrX: NativeUInt;
  PackedColor: Cardinal;
  RowPtr32: PCardinal;
  RowStart: NativeInt;
  PBytes: PByte;
  Idx: NativeInt;
begin
  if (AWidth <= 0) or (AHeight <= 0) or (FPixels = nil) then Exit;

  X0 := NativeUInt(Max(0, X));
  Y0 := NativeUInt(Max(0, Y));
  X1 := Min(FWidth, NativeUInt(X + AWidth));
  Y1 := Min(FHeight, NativeUInt(Y + AHeight));

  if (X0 >= X1) or (Y0 >= Y1) then Exit;

  if FBytesPerPixel = 4 then
  begin
    PackedColor := 0;
    PBytes := PByte(@PackedColor);
    PBytes[idxR] := FColor.R;
    PBytes[idxG] := FColor.G;
    PBytes[idxB] := FColor.B;
    PBytes[idxA] := FColor.A;

    for CurrY := Y0 to Y1 - 1 do
    begin
      RowStart := (NativeInt(CurrY) * NativeInt(FWidth) + NativeInt(X0)) * 4;
      RowPtr32 := PCardinal(FPixels + RowStart);
      FillDWord(RowPtr32^, X1 - X0, PackedColor);
    end;
  end
  else
  begin
    for CurrY := Y0 to Y1 - 1 do
      for CurrX := X0 to X1 - 1 do
      begin
        Idx := (NativeInt(CurrY) * NativeInt(FWidth) + NativeInt(CurrX)) * 3;
        FPixels[Idx + idxR] := FColor.R;
        FPixels[Idx + idxG] := FColor.G;
        FPixels[Idx + idxB] := FColor.B;
      end;
  end;
end;

function TPainter.Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; APixels: PByte; APixelsSize: NativeInt): Boolean;
var
  SrcX0, SrcY0: NativeUInt;
  DstX0, DstY0: NativeUInt;
  CopyW, CopyH: NativeUInt;
  RowIdx: NativeUInt;
  SrcRowStart, DstRowStart: NativeInt;
  BytesToCopyPerRow: NativeInt;
begin
  Result := False;

  if (FPixels = nil) or (APixels = nil) or (W = 0) or (H = 0) or (ABytesPerPixel <> FBytesPerPixel) then 
    Exit;

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

  BytesToCopyPerRow := NativeInt(CopyW) * NativeInt(FBytesPerPixel);

  for RowIdx := 0 to CopyH - 1 do
  begin
    SrcRowStart := (NativeInt(SrcY0 + RowIdx) * NativeInt(W) + NativeInt(SrcX0)) * NativeInt(FBytesPerPixel);
    DstRowStart := (NativeInt(DstY0 + RowIdx) * NativeInt(FWidth) + NativeInt(DstX0)) * NativeInt(FBytesPerPixel);

    if (SrcRowStart + BytesToCopyPerRow <= APixelsSize) and 
       (DstRowStart + BytesToCopyPerRow <= FPixelsSize) then
    begin
      Move((APixels + SrcRowStart)^, (FPixels + DstRowStart)^, BytesToCopyPerRow);
    end;
  end;

  Result := True;
end;


end.
