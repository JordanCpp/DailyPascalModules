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
    
    function Copy(DstX, DstY: Integer; SrcW, SrcH: Integer; SrcBpp: Byte; const SrcPixels: TBytes): Boolean; overload;
    function Copy(DstX, DstY, DstW, DstH: Integer; SrcX, SrcY, SrcW, SrcH: Integer; SrcW_Full: Integer; SrcBpp: Byte; const SrcPixels: TBytes): Boolean; overload;
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

function TPixelCopier.Copy(DstX, DstY: Integer; SrcW, SrcH: Integer; SrcBpp: Byte; const SrcPixels: TBytes): Boolean;
begin
  Result := Copy(DstX, DstY, SrcW, SrcH, 0, 0, SrcW, SrcH, SrcW, SrcBpp, SrcPixels);
end;

function TPixelCopier.Copy(DstX, DstY, DstW, DstH: Integer; SrcX, SrcY, SrcW, SrcH: Integer; SrcW_Full: Integer; SrcBpp: Byte; const SrcPixels: TBytes): Boolean;
var
  CurrDstX, CurrDstY : Integer;
  MappedSrcX, MappedSrcY : Integer;
  ClipDstX0, ClipDstY0 : Integer;
  ClipDstX1, ClipDstY1 : Integer;
  SrcPixelIdx, DstPixelIdx : Integer;
  SrcPixelsSize, PixelsSize : Integer;
  PBuffer, PSrcBuffer : PMaxByteArray;
  XRatio, YRatio : Single;
begin
  Result := False;

  SrcPixelsSize := Length(SrcPixels);
  if (not IsBufferValid) or (SrcPixelsSize = 0) then Exit;
  if (DstW <= 0) or (DstH <= 0) or (SrcW <= 0) or (SrcH <= 0) or (SrcW_Full <= 0) then Exit;

  PixelsSize := GetPixelsSize;
  PBuffer := PMaxByteArray(PBytesArray(FPixelsRef)^);
  PSrcBuffer := PMaxByteArray(@SrcPixels[0]);

  XRatio := SrcW / DstW;
  YRatio := SrcH / DstH;

  ClipDstX0 := Max(0, DstX);
  ClipDstY0 := Max(0, DstY);
  ClipDstX1 := Min(FWidth - 1, DstX + DstW - 1);
  ClipDstY1 := Min(FHeight - 1, DstY + DstH - 1);

  if (ClipDstX0 > ClipDstX1) or (ClipDstY0 > ClipDstY1) then Exit;

  for CurrDstY := ClipDstY0 to ClipDstY1 do
  begin
    MappedSrcY := SrcY + Floor((CurrDstY - DstY) * YRatio);
    if MappedSrcY < SrcY then MappedSrcY := SrcY;
    if MappedSrcY >= SrcY + SrcH then MappedSrcY := SrcY + SrcH - 1;

    DstPixelIdx := (CurrDstY * FWidth + ClipDstX0) * FBytesPerPixel;

    for CurrDstX := ClipDstX0 to ClipDstX1 do
    begin
      MappedSrcX := SrcX + Floor((CurrDstX - DstX) * XRatio);
      if MappedSrcX < SrcX then MappedSrcX := SrcX;
      if MappedSrcX >= SrcX + SrcW then MappedSrcX := SrcX + SrcW - 1;

      SrcPixelIdx := (MappedSrcY * SrcW_Full + MappedSrcX) * SrcBpp;

      if (SrcPixelIdx + 3 <= SrcPixelsSize) and (DstPixelIdx + FBytesPerPixel <= PixelsSize) then
      begin
        PBuffer^[DstPixelIdx + idxR] := PSrcBuffer^[SrcPixelIdx + 2];
        PBuffer^[DstPixelIdx + idxG] := PSrcBuffer^[SrcPixelIdx + 1];
        PBuffer^[DstPixelIdx + idxB] := PSrcBuffer^[SrcPixelIdx + 0];
        
        if (FBytesPerPixel = 4) then
        begin
          if (SrcBpp = 4) then
            PBuffer^[DstPixelIdx + idxA] := PSrcBuffer^[SrcPixelIdx + 3]
          else
            PBuffer^[DstPixelIdx + idxA] := AlphaByte;
        end;
      end;

      Inc(DstPixelIdx, FBytesPerPixel);
    end;
  end;

  Result := True;
end;

end.
