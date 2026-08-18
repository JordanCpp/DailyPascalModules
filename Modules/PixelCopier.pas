{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit PixelCopier;

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
  TPixelCopier = object
  private
    FWidth: Integer;
    FHeight: Integer;
    FBytesPerPixel: Byte;
    FPixelsRef: Pointer; 
    
    function GetPixelsSize: Integer;
    function IsBufferValid: Boolean;
  public
    procedure Init(W, H: Integer; ABytesPerPixel: Byte; var APixels: TBytes);
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetBytesPerPixel: Byte;
    function Copy(X, Y: Integer; W, H: Integer; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
  end;

implementation

{ TPixelCopier }

function TPixelCopier.GetPixelsSize: Integer;
begin
  if FPixelsRef = nil then 
    Result := 0
  else
    Result := Length(PBytesArray(FPixelsRef)^);
end;

function TPixelCopier.IsBufferValid: Boolean;
begin
  Result := (FPixelsRef <> nil) and (Length(PBytesArray(FPixelsRef)^) > 0);
end;

procedure TPixelCopier.Init(W, H: Integer; ABytesPerPixel: Byte; var APixels: TBytes);
begin
  if (ABytesPerPixel <> 3) and (ABytesPerPixel <> 4) then
    raise Exception.Create('Only 3 or 4 bytes per pixel are supported.');

  FWidth := W;
  FHeight := H;
  FBytesPerPixel := ABytesPerPixel;
  FPixelsRef := @APixels;
end;

function TPixelCopier.GetWidth: Integer;
begin
  Result := FWidth;
end;

function TPixelCopier.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TPixelCopier.GetBytesPerPixel: Byte;
begin
  Result := FBytesPerPixel;
end;

function TPixelCopier.Copy(X, Y: Integer; W, H: Integer; ABytesPerPixel: Byte; const SrcPixels: TBytes): Boolean;
var
  SrcX0, SrcY0: Integer;
  DstX0, DstY0: Integer;
  CopyW, CopyH: Integer;
  RowIdx, ColIdx: Integer;
  SrcRowStart, DstRowStart: Integer;
  SrcPixelIdx, DstPixelIdx: Integer;
  SrcPixelsSize: Integer;
  PixelsSize: Integer;
  
  R, G, B, A: Byte;
  PBuffer: PMaxByteArray;
  PSrcBuffer: PMaxByteArray;
begin
  Result := False;

  SrcPixelsSize := Length(SrcPixels);
  if (not IsBufferValid) or (SrcPixelsSize = 0) or (W = 0) or (H = 0) or (ABytesPerPixel <> FBytesPerPixel) then 
    Exit;

  PixelsSize := GetPixelsSize;
  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);
  PSrcBuffer := PMaxByteArray(@SrcPixels[0]);

  if X < 0 then
  begin
    if -X >= W then Exit;
    SrcX0 := -X;
    DstX0 := 0;
  end
  else
  begin
    if X >= FWidth then Exit;
    SrcX0 := 0;
    DstX0 := X;
  end;

  if Y < 0 then
  begin
    if -Y >= H then Exit;
    SrcY0 := -Y;
    DstY0 := 0;
  end
  else
  begin
    if Y >= FHeight then Exit;
    SrcY0 := 0;
    DstY0 := Y;
  end;

  CopyW := Min(W - SrcX0, FWidth - DstX0);
  CopyH := Min(H - SrcY0, FHeight - DstY0);

  if (CopyW = 0) or (CopyH = 0) then Exit;

  for RowIdx := 0 to CopyH - 1 do
  begin
    SrcRowStart := ((SrcY0 + RowIdx) * W + SrcX0) * FBytesPerPixel;
    DstRowStart := ((DstY0 + RowIdx) * FWidth + DstX0) * FBytesPerPixel;

    for ColIdx := 0 to CopyW - 1 do
    begin
      SrcPixelIdx := SrcRowStart + ColIdx * FBytesPerPixel;
      DstPixelIdx := DstRowStart + ColIdx * FBytesPerPixel;

      if (SrcPixelIdx + FBytesPerPixel <= SrcPixelsSize) and 
         (DstPixelIdx + FBytesPerPixel <= PixelsSize) then
      begin
        R := PSrcBuffer^[SrcPixelIdx + 0];
        G := PSrcBuffer^[SrcPixelIdx + 1];
        B := PSrcBuffer^[SrcPixelIdx + 2];
        
        if FBytesPerPixel = 4 then
          A := PSrcBuffer^[SrcPixelIdx + 3];

        PBuffer^[DstPixelIdx + idxR] := R;
        PBuffer^[DstPixelIdx + idxG] := G;
        PBuffer^[DstPixelIdx + idxB] := B;

        if FBytesPerPixel = 4 then
          PBuffer^[DstPixelIdx + idxA] := A;
      end;
    end;
  end;

  Result := True;
end;

end.
