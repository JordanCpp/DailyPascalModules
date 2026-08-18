unit PixelPainter;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  Support,
  SysUtils, Math;

type
  
  PBytesArray = ^TBytes;
  TMaxByteArray = array[0..$7FFFFF00] of Byte;
  PMaxByteArray = ^TMaxByteArray;

const
  AlphaByte: Byte = 255;

{$IFDEF WIN32}
  idxR = 2;
  idxG = 1;
  idxB = 0;
{$ELSE}
  {$IFDEF MSWINDOWS}
    idxR = 2;
    idxG = 1;
    idxB = 0;
  {$ELSE}
    idxR = 0;
    idxG = 1;
    idxB = 2;
  {$ENDIF}
{$ENDIF}
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
  TPixelPainter = object
  private
    FColor: TColor;
    FWidth: Integer;
    FHeight: Integer;
    FBytesPerPixel: Byte;
    FPixelsRef: Pointer;
    
    function GetPixelsSize: Integer;
    function IsBufferValid: Boolean;
  public
    procedure Init(W, H: Integer; ABytesPerPixel: Byte; var APixels: TBytes);

    function GetColor: TColor;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetBytesPerPixel: Byte;

    procedure SetColor(const AColor: TColor);
    procedure Clear;
    procedure Pixel(X, Y: Integer);
    procedure Line(X0, Y0, X1, Y1: Integer);
    procedure Fill(X, Y, AWidth, AHeight: Integer);
  end;

implementation

function MakeColor(ARed, AGreen, ABlue: Byte; AAlpha: Byte): TColor;
begin
  Result.R := ARed;
  Result.G := AGreen;
  Result.B := ABlue;
  Result.A := AAlpha;
end;

{ TPixelPainter }

function TPixelPainter.GetPixelsSize: Integer;
begin
  if FPixelsRef = nil then 
    Result := 0
  else
    Result := Length(PBytesArray(FPixelsRef)^);
end;

function TPixelPainter.IsBufferValid: Boolean;
begin
  Result := (FPixelsRef <> nil) and (Length(PBytesArray(FPixelsRef)^) > 0);
end;

procedure TPixelPainter.Init(W, H: Integer; ABytesPerPixel: Byte; var APixels: TBytes);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FPixelsRef := @APixels;
  FColor := MakeColor(0, 0, 0, AlphaByte);
end;

function TPixelPainter.GetColor: TColor;
begin
  Result := FColor;
end;

function TPixelPainter.GetWidth: Integer;
begin
  Result := FWidth;
end;

function TPixelPainter.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TPixelPainter.GetBytesPerPixel: Byte;
begin
  Result := FBytesPerPixel;
end;

procedure TPixelPainter.SetColor(const AColor: TColor);
begin
  FColor := AColor;
end;

procedure TPixelPainter.Clear;
var
  I: Integer;
  PackedColor: Cardinal;
  Dest32: PCardinal;
  PBytesPtr: PMaxByteArray;
  PixelsSize: Integer;
  PBuffer: PMaxByteArray;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;
  
  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);

  if (FColor.R = FColor.G) and (FColor.G = FColor.B) and
     ((FBytesPerPixel = 3) or (FColor.B = FColor.A)) then
  begin
    FillChar(PBuffer^, PixelsSize, FColor.R);
    Exit;
  end;

  if FBytesPerPixel = 4 then
  begin
    PackedColor := 0;
    PBytesPtr := PMaxByteArray(@PackedColor);
    PBytesPtr^[idxR] := FColor.R;
    PBytesPtr^[idxG] := FColor.G;
    PBytesPtr^[idxB] := FColor.B;
    PBytesPtr^[idxA] := FColor.A;

    Dest32 := PCardinal(PBuffer);
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
      PBuffer^[I + idxR] := FColor.R;
      PBuffer^[I + idxG] := FColor.G;
      PBuffer^[I + idxB] := FColor.B;
      Inc(I, 3);
    end;
  end;
end;

procedure TPixelPainter.Pixel(X, Y: Integer);
var
  Idx: Integer;
  PBuffer: PMaxByteArray;
begin
  if (X < 0) or (X >= FWidth) or (Y < 0) or (Y >= FHeight) or (not IsBufferValid) then Exit;

  Idx := (Y * FWidth + X) * FBytesPerPixel;
  
  if Idx + idxB >= GetPixelsSize then Exit;

  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);

  PBuffer^[Idx + idxR] := FColor.R;
  PBuffer^[Idx + idxG] := FColor.G;
  PBuffer^[Idx + idxB] := FColor.B;

  if FBytesPerPixel = 4 then
    PBuffer^[Idx + idxA] := FColor.A;
end;

procedure TPixelPainter.Line(X0, Y0, X1, Y1: Integer);
var
  Dx, Dy, Sx, Sy, Err, E2: Integer;
  Idx: Integer;
  PixelsSize: Integer;
  PBuffer: PMaxByteArray;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;
  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);

  Dx := Abs(X1 - X0);
  Dy := Abs(Y1 - Y0);
  
  if X0 < X1 then Sx := 1 else Sx := -1;
  if Y0 < Y1 then Sy := 1 else Sy := -1;
  
  Err := Dx - Dy;

  while True do
  begin
    if (X0 >= 0) and (X0 < FWidth) and (Y0 >= 0) and (Y0 < FHeight) then
    begin
      Idx := (Y0 * FWidth + X0) * FBytesPerPixel;
      
      if Idx + idxB < PixelsSize then
      begin
        PBuffer^[Idx + idxR] := FColor.R;
        PBuffer^[Idx + idxG] := FColor.G;
        PBuffer^[Idx + idxB] := FColor.B;

        if FBytesPerPixel = 4 then
          PBuffer^[Idx + idxA] := FColor.A;
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

procedure TPixelPainter.Fill(X, Y, AWidth, AHeight: Integer);
var
  X0, Y0, X1, Y1, CurrY, CurrX: Integer;
  PackedColor: Cardinal;
  RowPtr32: PCardinal;
  RowStart: Integer;
  PBytesPtr: PMaxByteArray;
  Idx: Integer;
  PBuffer: PMaxByteArray;
  PixelsSize: Integer;
  Count32: Integer;
  I: Integer;
begin
  if (AWidth <= 0) or (AHeight <= 0) or (not IsBufferValid) then Exit;

  X0 := Max(0, X);
  Y0 := Max(0, Y);
  X1 := Min(FWidth, X + AWidth);
  Y1 := Min(FHeight, Y + AHeight);

  if (X0 >= X1) or (Y0 >= Y1) then Exit;

  PixelsSize := GetPixelsSize;
  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);

  if FBytesPerPixel = 4 then
  begin
    PackedColor := 0;
    PBytesPtr := PMaxByteArray(@PackedColor);
    PBytesPtr^[idxR] := FColor.R;
    PBytesPtr^[idxG] := FColor.G;
    PBytesPtr^[idxB] := FColor.B;
    PBytesPtr^[idxA] := FColor.A;

    for CurrY := Y0 to Y1 - 1 do
    begin
      RowStart := (CurrY * FWidth + X0) * 4;
      if RowStart < PixelsSize then
      begin
        RowPtr32 := PCardinal(@PBuffer^[RowStart]);
        Count32 := X1 - X0;
        
        for I := 0 to Count32 - 1 do
        begin
          RowPtr32^ := PackedColor;
          Inc(RowPtr32);
        end;
      end;
    end;
  end
  else
  begin
    for CurrY := Y0 to Y1 - 1 do
      for CurrX := X0 to X1 - 1 do
      begin
        Idx := (CurrY * FWidth + CurrX) * 3;
        if Idx + 2 < GetPixelsSize then
        begin
          PBuffer^[Idx + idxR] := FColor.R;
          PBuffer^[Idx + idxG] := FColor.G;
          PBuffer^[Idx + idxB] := FColor.B;
        end;
      end;
  end;
end;

end.
