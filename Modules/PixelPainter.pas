{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit PixelPainter;

{$mode objfpc}{$H+}

interface

uses
  Support,
  SysUtils, Math;

const
  AlphaByte: Byte = 255;

{$IFDEF WIN32}
  idxR = 2;
  idxG = 1;
  idxB = 0;
{$ELSE}
  idxR = 0;
  idxG = 1;
  idxB = 2;
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
    FScreenPixels: TBytes;
    
    function GetPixelsSize: Integer;
    function IsBufferValid: Boolean;
  public
    procedure Init(W, H: Integer; ABytesPerPixel: Byte; const APixels: TBytes);

    function GetColor: TColor;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetBytesPerPixel: Byte;

    procedure SetColor(const AColor: TColor);
    procedure Clear;
    procedure Pixel(X, Y: Integer); inline;
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
  Result := Length(FScreenPixels);
end;

function TPixelPainter.IsBufferValid: Boolean;
begin
  Result := Length(FScreenPixels) > 0;
end;

procedure TPixelPainter.Init(W, H: Integer; ABytesPerPixel: Byte; const APixels: TBytes);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FScreenPixels := APixels;
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
  PixelsSize: Integer;
  BlockSize: Integer;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;

  if (FColor.R = FColor.G) and (FColor.G = FColor.B) and
     ((FBytesPerPixel = 3) or (FColor.B = FColor.A)) then
  begin
    FillChar(FScreenPixels[0], PixelsSize, FColor.R);
    Exit;
  end;

  I := 0;
  while I < FBytesPerPixel do
  begin
    if I = idxR then FScreenPixels[I] := FColor.R
    else if I = idxG then FScreenPixels[I] := FColor.G
    else if I = idxB then FScreenPixels[I] := FColor.B
    else if I = idxA then FScreenPixels[I] := FColor.A;
    Inc(I);
  end;

  BlockSize := FBytesPerPixel;
  while BlockSize < PixelsSize do
  begin
    I := Min(BlockSize, PixelsSize - BlockSize);
    Move(FScreenPixels[0], FScreenPixels[BlockSize], I);
    Inc(BlockSize, I);
  end;
end;

procedure TPixelPainter.Pixel(X, Y: Integer); inline;
var
  Idx: Integer;
  PixelsSize: Integer;
begin
  if (X < 0) or (X >= FWidth) or (Y < 0) or (Y >= FHeight) or (not IsBufferValid) then Exit;

  Idx := (Y * FWidth + X) * FBytesPerPixel;
  PixelsSize := GetPixelsSize;
  
  if Idx + idxB >= PixelsSize then Exit;

  FScreenPixels[Idx + idxR] := FColor.R;
  FScreenPixels[Idx + idxG] := FColor.G;
  FScreenPixels[Idx + idxB] := FColor.B;

  if FBytesPerPixel = 4 then
    FScreenPixels[Idx + idxA] := FColor.A;
end;

procedure TPixelPainter.Line(X0, Y0, X1, Y1: Integer);
var
  Dx, Dy, Sx, Sy, Err, E2: Integer;
  Idx: Integer;
  PixelsSize: Integer;
begin
  if not IsBufferValid then Exit;
  PixelsSize := GetPixelsSize;

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
        FScreenPixels[Idx + idxR] := FColor.R;
        FScreenPixels[Idx + idxG] := FColor.G;
        FScreenPixels[Idx + idxB] := FColor.B;

        if FBytesPerPixel = 4 then
          FScreenPixels[Idx + idxA] := FColor.A;
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
  RowStart, Idx: Integer;
  PixelsSize: Integer;
  LineBlockSize: Integer;
begin
  if (AWidth <= 0) or (AHeight <= 0) or (not IsBufferValid) then Exit;

  X0 := Max(0, X);
  Y0 := Max(0, Y);
  X1 := Min(FWidth, X + AWidth);
  Y1 := Min(FHeight, Y + AHeight);

  if (X0 >= X1) or (Y0 >= Y1) then Exit;

  PixelsSize := GetPixelsSize;

  RowStart := (Y0 * FWidth + X0) * FBytesPerPixel;
  for CurrX := X0 to X1 - 1 do
  begin
    Idx := RowStart + (CurrX - X0) * FBytesPerPixel;
    if Idx + idxB < PixelsSize then
    begin
      FScreenPixels[Idx + idxR] := FColor.R;
      FScreenPixels[Idx + idxG] := FColor.G;
      FScreenPixels[Idx + idxB] := FColor.B;
      if FBytesPerPixel = 4 then
        FScreenPixels[Idx + idxA] := FColor.A;
    end;
  end;

  LineBlockSize := (X1 - X0) * FBytesPerPixel;
  for CurrY := Y0 + 1 to Y1 - 1 do
  begin
    Idx := (CurrY * FWidth + X0) * FBytesPerPixel;
    if Idx + LineBlockSize <= PixelsSize then
    begin
      Move(FScreenPixels[RowStart], FScreenPixels[Idx], LineBlockSize);
    end;
  end;
end;

end.
