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
    FPixelsRef: ^TBytes; 
    
    function GetPixelsSize: NativeInt; inline;
    function IsBufferValid: Boolean; inline;
  public
    procedure Init(W, H: NativeUInt; ABytesPerPixel: Byte; var APixels: TBytes);

    function GetColor: TColor;
    function GetWidth: NativeUInt;
    function GetHeight: NativeUInt;
    function GetBytesPerPixel: Byte;

    procedure SetColor(const AColor: TColor);
    procedure Clear;
    procedure Pixel(X, Y: NativeUInt);
    procedure Line(X0, Y0, X1, Y1: Integer);
    procedure Fill(X, Y, AWidth, AHeight: Integer);
    function Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
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

function TPainter.GetPixelsSize: NativeInt;
begin
  if FPixelsRef = nil then Exit(0);
  Result := Length(FPixelsRef^);
end;

function TPainter.IsBufferValid: Boolean;
begin
  Result := (FPixelsRef <> nil) and (Length(FPixelsRef^) > 0);
end;

procedure TPainter.Init(W, H: NativeUInt; ABytesPerPixel: Byte; var APixels: TBytes);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FPixelsRef := @APixels;
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
  PixelsSize: NativeInt;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;

  if (FColor.R = FColor.G) and (FColor.G = FColor.B) and
     ((FBytesPerPixel = 3) or (FColor.B = FColor.A)) then
  begin
    FillChar(FPixelsRef^[0], PixelsSize, FColor.R);
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

    Dest32 := PCardinal(@FPixelsRef^[0]);
    for I := 0 to (PixelsSize div 4) - 1 do
    begin
      Dest32^ := PackedColor;
      Inc(Dest32);
    end;
  end
  else
  begin
    I := 0;
    while I < PixelsSize - 2 do
    begin
      FPixelsRef^[I + idxR] := FColor.R;
      FPixelsRef^[I + idxG] := FColor.G;
      FPixelsRef^[I + idxB] := FColor.B;
      Inc(I, 3);
    end;
  end;
end;

procedure TPainter.Pixel(X, Y: NativeUInt);
var
  Idx: NativeInt;
begin
  if (X >= FWidth) or (Y >= FHeight) or (not IsBufferValid) then Exit;

  Idx := (NativeInt(Y) * NativeInt(FWidth) + NativeInt(X)) * NativeInt(FBytesPerPixel);
  
  if Idx + idxB >= GetPixelsSize then Exit;

  FPixelsRef^[Idx + idxR] := FColor.R;
  FPixelsRef^[Idx + idxG] := FColor.G;
  FPixelsRef^[Idx + idxB] := FColor.B;

  if FBytesPerPixel = 4 then
    FPixelsRef^[Idx + idxA] := FColor.A;
end;

procedure TPainter.Line(X0, Y0, X1, Y1: Integer);
var
  Dx, Dy, Sx, Sy, Err, E2: Integer;
  Idx: NativeInt;
  PixelsSize: NativeInt;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;

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
      
      if Idx + idxB < PixelsSize then
      begin
        FPixelsRef^[Idx + idxR] := FColor.R;
        FPixelsRef^[Idx + idxG] := FColor.G;
        FPixelsRef^[Idx + idxB] := FColor.B;

        if FBytesPerPixel = 4 then
          FPixelsRef^[Idx + idxA] := FColor.A;
      end;
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
  if (AWidth <= 0) or (AHeight <= 0) or (not IsBufferValid) then Exit;

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
      if RowStart < GetPixelsSize then
      begin
        RowPtr32 := PCardinal(@FPixelsRef^[RowStart]);
        FillDWord(RowPtr32^, X1 - X0, PackedColor);
      end;
    end;
  end
  else
  begin
    for CurrY := Y0 to Y1 - 1 do
      for CurrX := X0 to X1 - 1 do
      begin
        Idx := (NativeInt(CurrY) * NativeInt(FWidth) + NativeInt(CurrX)) * 3;
        if Idx + 2 < GetPixelsSize then
        begin
          FPixelsRef^[Idx + idxR] := FColor.R;
          FPixelsRef^[Idx + idxG] := FColor.G;
          FPixelsRef^[Idx + idxB] := FColor.B;
        end;
      end;
  end;
end;

function TPainter.Copy(X, Y: Integer; W, H: NativeUInt; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
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
