{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteOpenGL1WindowXLib;

{$mode objfpc}{$H+}

interface

uses
  x, xlib, xutil, gl, glx,
  SysUtils, WinLiteEvents, WinLiteMainWindowXLib;

type
  TOpenGL1WindowXLib = object
  private
    FImpl    : TMainWindow;
    FGLXCtx  : GLXContext;

    procedure ReleaseContexts;
  public
    procedure Init;
    procedure Done;

    function CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
    
    function IsRunning: Boolean;
    procedure StopEvent;
    function GetEvent(out AnEvent: TEvent): Boolean;
    procedure SetTitle(const ATitle: string);
    procedure Present;

    function GetImpl: PMainWindow;
  end;

implementation

{ TOpenGL1WindowXLib private methods }

procedure TOpenGL1WindowXLib.ReleaseContexts;
begin
  if (FImpl.FDisplay <> nil) then
  begin
    if FGLXCtx <> nil then
    begin
      if glXGetCurrentContext() = FGLXCtx then
      begin
        glXMakeCurrent(FImpl.FDisplay, 0, nil);
      end;
      glXDestroyContext(FImpl.FDisplay, FGLXCtx);
      FGLXCtx := nil;
    end;
  end;
end;

{ TOpenGL1WindowXLib public methods }

procedure TOpenGL1WindowXLib.Init;
begin
  FGLXCtx := nil;
  FillChar(FImpl, SizeOf(FImpl), 0);
end;

procedure TOpenGL1WindowXLib.Done;
begin
  ReleaseContexts;
  FImpl.Done;
end;

function TOpenGL1WindowXLib.CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
var
  TempDisplay: PDisplay;
  Root: TWindow;
  Visual: PXVisualInfo;
  Screen: Integer;
  GLAttributes: array[0..9] of Integer;
begin
  Result := False;
  FGLXCtx := nil;

  GLAttributes[0] := GLX_RGBA;
  GLAttributes[1] := GLX_DOUBLEBUFFER;
  GLAttributes[2] := GLX_DEPTH_SIZE;   
  GLAttributes[3] := 16;
  GLAttributes[4] := GLX_RED_SIZE;     
  GLAttributes[5] := 8;
  GLAttributes[6] := GLX_GREEN_SIZE;   
  GLAttributes[7] := 8;
  GLAttributes[8] := GLX_BLUE_SIZE;
  GLAttributes[9] := 0;

  TempDisplay := XOpenDisplay(nil);
  if TempDisplay = nil then
  begin
    AError := 'XOpenDisplay fail';
    Exit;
  end;

  Screen := XDefaultScreen(TempDisplay);
  Visual := glXChooseVisual(TempDisplay, Screen, @GLAttributes[0]);
  if Visual = nil then
  begin
    AError := 'glXChooseVisual fail';
    XCloseDisplay(TempDisplay);
    Exit;
  end;

  XCloseDisplay(TempDisplay);

  if not FImpl.CreateWithVisual(W, H, ATitle, Visual, AError) then
  begin
    XFree(Visual);
    Exit;
  end;

  FGLXCtx := glXCreateContext(FImpl.FDisplay, Visual, nil, True);
  XFree(Visual);

  if FGLXCtx = nil then
  begin
    AError := 'glXCreateContext fail';
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  if not glXMakeCurrent(FImpl.FDisplay, FImpl.FWindow, FGLXCtx) then
  begin
    AError := 'glXMakeCurrent fail';
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  Result := True;
end;


function TOpenGL1WindowXLib.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TOpenGL1WindowXLib.StopEvent;
begin
  FImpl.StopEvent;
end;

function TOpenGL1WindowXLib.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TOpenGL1WindowXLib.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TOpenGL1WindowXLib.Present;
begin
  if (FImpl.FDisplay <> nil) and (FImpl.FWindow <> 0) then
  begin
    glXSwapBuffers(FImpl.FDisplay, FImpl.FWindow);
  end;
end;

function TOpenGL1WindowXLib.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
