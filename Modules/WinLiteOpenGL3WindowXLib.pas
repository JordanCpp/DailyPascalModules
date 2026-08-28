{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteOpenGL3WindowXLib;

{$mode objfpc}{$H+}

interface

uses
  x, xlib, xutil, gl, glx,
  SysUtils, WinLiteEvents, WinLiteMainWindowXLib;

const
  GLX_CONTEXT_MAJOR_VERSION_ARB          = $2091;
  GLX_CONTEXT_MINOR_VERSION_ARB          = $2092;
  GLX_CONTEXT_FLAGS_ARB                  = $2094;
  GLX_CONTEXT_PROFILE_MASK_ARB            = $9126;
  GLX_CONTEXT_CORE_PROFILE_BIT_ARB        = $00000001;

  GLX_X_RENDERABLE                       = 20;
  GLX_DRAWABLE_TYPE                      = 8011;
  GLX_WINDOW_BIT                         = $00000001;

type
  X_GLXFBConfig = Pointer;
  PX_GLXFBConfig = ^X_GLXFBConfig;

  TglXCreateContextAttribsARB = function(
    dpy: PDisplay; 
    config: X_GLXFBConfig; 
    share_context: GLXContext; 
    direct: LongBool; 
    const attrib_list: PInteger
  ): GLXContext; cdecl;

  TOpenGL3WindowXLib = object
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

function local_glXChooseFBConfig(dpy: PDisplay; screen: Integer; const attrib_list: PInteger; nelements: PInteger): PX_GLXFBConfig; cdecl; external 'libGL.so.1' name 'glXChooseFBConfig';

implementation

procedure TOpenGL3WindowXLib.ReleaseContexts;
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

procedure TOpenGL3WindowXLib.Init;
begin
  FGLXCtx := nil;
  FillChar(FImpl, SizeOf(FImpl), 0);
end;

procedure TOpenGL3WindowXLib.Done;
begin
  ReleaseContexts;
  FImpl.Done;
end;

function TOpenGL3WindowXLib.CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
var
  TempDisplay: PDisplay;
  Visual: PXVisualInfo;
  Screen: Integer;
  
  FBConfigs: PX_GLXFBConfig;
  BestConfig: X_GLXFBConfig;
  ElementsCount: Integer;
  
  glXCreateContextAttribsARB: TglXCreateContextAttribsARB;

  FBAttributes: array[0..14] of Integer;
  CtxAttributes: array[0..10] of Integer;
begin
  Result := False;
  FGLXCtx := nil;

  FBAttributes[0]  := GLX_X_RENDERABLE;   
  FBAttributes[1]  := 1;
  FBAttributes[2]  := GLX_DRAWABLE_TYPE;  
  FBAttributes[3]  := GLX_WINDOW_BIT;
  FBAttributes[4]  := GLX_RENDER_TYPE;    
  FBAttributes[5]  := GLX_RGBA_BIT;
  FBAttributes[6]  := GLX_DOUBLEBUFFER;   
  FBAttributes[7]  := 1;
  FBAttributes[8]  := GLX_DEPTH_SIZE;     
  FBAttributes[9]  := 16;
  FBAttributes[10] := GLX_RED_SIZE;       
  FBAttributes[11] := 8;
  FBAttributes[12] := GLX_GREEN_SIZE;     
  FBAttributes[13] := 8;
  FBAttributes[14] := 0;

  TempDisplay := XOpenDisplay(nil);
  if TempDisplay = nil then
  begin
    AError := 'XOpenDisplay fail';
    Exit;
  end;

  Screen := XDefaultScreen(TempDisplay);

  FBConfigs := local_glXChooseFBConfig(TempDisplay, Screen, @FBAttributes[0], @ElementsCount);
  if (FBConfigs = nil) or (ElementsCount = 0) then
  begin
    AError := 'glXChooseFBConfig fail';
    XCloseDisplay(TempDisplay);
    Exit;
  end;

  BestConfig := FBConfigs^;
  XFree(FBConfigs);

  Visual := glXGetVisualFromFBConfig(TempDisplay, BestConfig);
  if Visual = nil then
  begin
    AError := 'glXGetVisualFromFBConfig fail';
    XCloseDisplay(TempDisplay);
    Exit;
  end;

  glXCreateContextAttribsARB := TglXCreateContextAttribsARB(glXGetProcAddress(PChar('glXCreateContextAttribsARB')));

  XCloseDisplay(TempDisplay);

  if @glXCreateContextAttribsARB = nil then
  begin
    AError := 'glXCreateContextAttribsARB fail';
    XFree(Visual);
    Exit;
  end;

  if not FImpl.CreateWithVisual(W, H, ATitle, Visual, AError) then
  begin
    XFree(Visual);
    Exit;
  end;
  XFree(Visual);

  CtxAttributes[0] := GLX_CONTEXT_MAJOR_VERSION_ARB;   
  CtxAttributes[1] := 3;
  CtxAttributes[2] := GLX_CONTEXT_MINOR_VERSION_ARB;   
  CtxAttributes[3] := 3;
  CtxAttributes[4] := GLX_CONTEXT_PROFILE_MASK_ARB;    
  CtxAttributes[5] := GLX_CONTEXT_CORE_PROFILE_BIT_ARB;
  CtxAttributes[6] := 0;

  FGLXCtx := glXCreateContextAttribsARB(FImpl.FDisplay, BestConfig, nil, True, @CtxAttributes[0]);

  if FGLXCtx = nil then
  begin
    AError := 'glXCreateContextAttribsARB fail';
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

function TOpenGL3WindowXLib.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TOpenGL3WindowXLib.StopEvent;
begin
  FImpl.StopEvent;
end;

function TOpenGL3WindowXLib.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TOpenGL3WindowXLib.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TOpenGL3WindowXLib.Present;
begin
  if (FImpl.FDisplay <> nil) and (FImpl.FWindow <> 0) then
  begin
    glXSwapBuffers(FImpl.FDisplay, FImpl.FWindow);
  end;
end;

function TOpenGL3WindowXLib.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
