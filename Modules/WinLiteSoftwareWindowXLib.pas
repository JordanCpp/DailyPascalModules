{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteSoftwareWindowXLib;

{$mode objfpc}{$H+}

interface

uses
  x, xlib, xutil,
  Support, SysUtils, WinLiteEvents, WinLiteMainWindowXLib;

type
  TSoftwareWindowXLib = object
  private
    FImpl: TMainWindow;
    FGC  : TGC;
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

{ TSoftwareWindowXLib }

procedure TSoftwareWindowXLib.Init(W, H: Integer; BytesPerPixel: Byte);
begin
  FGC := nil;
end;

procedure TSoftwareWindowXLib.Done;
begin
  if FGC <> nil then
  begin
    XFreeGC(FImpl.FDisplay, FGC);
    FGC := nil;
  end;
  FImpl.Done;
end;

function TSoftwareWindowXLib.CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
begin
  Result := FImpl.Create(W, H, ATitle, AError);
  if Result then
  begin
    FGC := XCreateGC(FImpl.FDisplay, FImpl.FWindow, 0, nil);
  end;
end;

function TSoftwareWindowXLib.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TSoftwareWindowXLib.StopEvent;
begin
  FImpl.StopEvent;
end;

function TSoftwareWindowXLib.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TSoftwareWindowXLib.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TSoftwareWindowXLib.Present(const Pixels: TBytes; W, H: Integer);
var
  Img: PXImage;
  BitsPerPixel: Integer;
begin
  if (FImpl.FDisplay = nil) or (FImpl.FWindow = 0) or (FGC = nil) or (Length(Pixels) = 0) then 
    Exit;

  BitsPerPixel := (Length(Pixels) div (W * H)) * 8;
  if BitsPerPixel = 0 then BitsPerPixel := 32;

  Img := XCreateImage(
    FImpl.FDisplay,
    XDefaultVisual(FImpl.FDisplay, XDefaultScreen(FImpl.FDisplay)),
    XDefaultDepth(FImpl.FDisplay, XDefaultScreen(FImpl.FDisplay)),
    ZPixmap,
    0,
    PChar(@Pixels[0]),
    W, H,
    32,
    0
  );

  if Img <> nil then
  begin
    XPutImage(FImpl.FDisplay, FImpl.FWindow, FGC, Img, 0, 0, 0, 0, W, H);
    XFlush(FImpl.FDisplay);

    Img^.data := nil;
    XDestroyImage(Img);
  end;
end;

function TSoftwareWindowXLib.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
