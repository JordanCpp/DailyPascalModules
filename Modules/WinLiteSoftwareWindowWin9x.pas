{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteSoftwareWindowWin9x;

{$mode objfpc}{$H+}

interface

uses
  Support,
  Windows, SysUtils, WinLiteEvents, WinLiteMainWindowWin9x;

type
  TSoftwareWindowWin9x = object
  private
    FBitmapInfo: TBitmapInfo;
    FImpl: TMainWindow;
    procedure SetupBitmapInfo(W, H: Integer; BytesPerPixel: Byte);
  public
    procedure Init(W, H: Integer; BytesPerPixel: Byte);
    procedure Done;
    
    function CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
    function IsRunning: Boolean;
    procedure StopEvent;
    function GetEvent(out AnEvent: TEvent): Boolean;
    procedure SetTitle(const ATitle: string);
    procedure Present(const Pixels: TBytes; W, H: Integer);
    
    function GetImpl: PMainWindow;
  end;

implementation

{ TSoftwareWindowWin9x }

procedure TSoftwareWindowWin9x.SetupBitmapInfo(W, H: Integer; BytesPerPixel: Byte);
begin
  FillChar(FBitmapInfo, SizeOf(FBitmapInfo), 0);
  FBitmapInfo.bmiHeader.biSize := SizeOf(TBitmapInfoHeader);
  FBitmapInfo.bmiHeader.biPlanes := 1;
  FBitmapInfo.bmiHeader.biCompression := BI_RGB;
  FBitmapInfo.bmiHeader.biWidth := W;
  FBitmapInfo.bmiHeader.biHeight := -H;
  FBitmapInfo.bmiHeader.biBitCount := BytesPerPixel * 8;
end;

procedure TSoftwareWindowWin9x.Init(W, H: Integer; BytesPerPixel: Byte);
begin
  SetupBitmapInfo(W, H, BytesPerPixel);
end;

procedure TSoftwareWindowWin9x.Done;
begin
  FImpl.Done;
end;

function TSoftwareWindowWin9x.CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
begin
  Result := False;
  if not FImpl.Create(W, H, ATitle, AError) then
    Exit;

  Self.SetupBitmapInfo(W, H, 4);
  Result := True;
end;

function TSoftwareWindowWin9x.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TSoftwareWindowWin9x.StopEvent;
begin
  FImpl.StopEvent;
end;

function TSoftwareWindowWin9x.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TSoftwareWindowWin9x.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TSoftwareWindowWin9x.Present(const Pixels: TBytes; W, H: Integer);
var
  BytesPerPixel: Integer;
  RequiredSize: Integer;
begin
  BytesPerPixel := FBitmapInfo.bmiHeader.biBitCount div 8;
  if BytesPerPixel = 0 then 
    BytesPerPixel := 4;

  RequiredSize := W * H * BytesPerPixel;

  if (Length(Pixels) < RequiredSize) or (RequiredSize <= 0) then
    Exit;

  FBitmapInfo.bmiHeader.biWidth := W;
  FBitmapInfo.bmiHeader.biHeight := -H;
  FBitmapInfo.bmiHeader.biBitCount := BytesPerPixel * 8;

  SetDIBitsToDevice(
    FImpl.GetHdc, 
    0, 0, 
    DWORD(W), DWORD(H), 
    0, 0, 
    0, UINT(H), 
    @Pixels[0],
    FBitmapInfo, 
    DIB_RGB_COLORS
  );
end;

function TSoftwareWindowWin9x.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
