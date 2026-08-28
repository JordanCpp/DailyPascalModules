{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteOpenGL3WindowWin9x;

{$mode objfpc}{$H+}

interface

uses
  Windows, SysUtils, WinLiteEvents, WinLiteMainWindowWin9x;

const
  WGL_CONTEXT_MAJOR_VERSION_ARB           = $2091;
  WGL_CONTEXT_MINOR_VERSION_ARB           = $2092;
  WGL_CONTEXT_FLAGS_ARB                   = $2094;
  WGL_CONTEXT_PROFILE_MASK_ARB            = $9126;
  
  WGL_CONTEXT_CORE_PROFILE_BIT_ARB        = $00000001;
  WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = $00000002;
  
  WGL_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB  = $00000001;
  WGL_CONTEXT_DEBUG_BIT_ARB               = $00000002;

type
  TwglCreateContextAttribsARB = function(DC: HDC; ShareContext: HGLRC; const AttribList: PInteger): HGLRC; stdcall;

  TOpenGL3Window9x = object
  private
    FImpl  : TMainWindow;
    FHdc   : HDC;
    FHglrc : HGLRC;

    procedure ReleaseContexts;
    function CreateModernContext(AnHdc: HDC; Major, Minor: Integer; CoreProfile: Boolean; out AError: string): HGLRC;
  public
    procedure Init;
    procedure Done;

    function CreateWindow(W, H: Integer; const ATitle: string; out AError: string; Major: Integer = 3; Minor: Integer = 3; CoreProfile: Boolean = True): Boolean;
    
    function IsRunning: Boolean;
    procedure StopEvent;
    function GetEvent(out AnEvent: TEvent): Boolean;
    procedure SetTitle(const ATitle: string);
    procedure Present;

    function GetImpl: PMainWindow;
  end;

function wglCreateContext(DC: HDC): HGLRC; stdcall; external 'opengl32.dll';
function wglDeleteContext(GLRC: HGLRC): BOOL; stdcall; external 'opengl32.dll';
function wglMakeCurrent(DC: HDC; GLRC: HGLRC): BOOL; stdcall; external 'opengl32.dll';
function wglGetCurrentContext: HGLRC; stdcall; external 'opengl32.dll';
function wglGetProcAddress(ProcName: LPCSTR): Pointer; stdcall; external 'opengl32.dll';

implementation

{ TOpenGL3Window9x private methods }

procedure TOpenGL3Window9x.ReleaseContexts;
begin
  if FHglrc <> 0 then
  begin
    if wglGetCurrentContext = FHglrc then
    begin
      wglMakeCurrent(0, 0);
    end;
    wglDeleteContext(FHglrc);
    FHglrc := 0;
  end;

  if FHdc <> 0 then
  begin
    if FImpl.GetHwnd <> 0 then
    begin
      ReleaseDC(FImpl.GetHwnd(), FHdc);
    end;
    FHdc := 0;
  end;
end;

function TOpenGL3Window9x.CreateModernContext(AnHdc: HDC; Major, Minor: Integer; CoreProfile: Boolean; out AError: string): HGLRC;
var
  DummyContext: HGLRC;
  wglCreateContextAttribsARB: TwglCreateContextAttribsARB;
  Attribs: array[0..9] of Integer;
  ProfileBit: Integer;
begin
  Result := 0;

  DummyContext := wglCreateContext(AnHdc);
  if DummyContext = 0 then
  begin
    AError := 'GL3: Failed to create dummy context';
    Exit;
  end;

  if not wglMakeCurrent(AnHdc, DummyContext) then
  begin
    AError := 'GL3: Failed to make dummy context current';
    wglDeleteContext(DummyContext);
    Exit;
  end;

  wglCreateContextAttribsARB := TwglCreateContextAttribsARB(wglGetProcAddress('wglCreateContextAttribsARB'));
  
  if @wglCreateContextAttribsARB = nil then
  begin
    AError := 'GL3: wglCreateContextAttribsARB not supported by driver';
    wglMakeCurrent(0, 0);
    wglDeleteContext(DummyContext);
    Exit;
  end;

  if CoreProfile then
    ProfileBit := WGL_CONTEXT_CORE_PROFILE_BIT_ARB
  else
    ProfileBit := WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB;

  Attribs[0] := WGL_CONTEXT_MAJOR_VERSION_ARB;
  Attribs[1] := Major;
  Attribs[2] := WGL_CONTEXT_MINOR_VERSION_ARB;
  Attribs[3] := Minor;
  Attribs[4] := WGL_CONTEXT_PROFILE_MASK_ARB;
  Attribs[5] := ProfileBit;
  Attribs[6] := WGL_CONTEXT_FLAGS_ARB;
  Attribs[7] := 0;
  Attribs[8] := 0;

  Result := wglCreateContextAttribsARB(AnHdc, 0, @Attribs[0]);

  wglMakeCurrent(0, 0);
  wglDeleteContext(DummyContext);

  if Result = 0 then
    AError := Format('GL3: Failed to create OpenGL %d.%d context', [Major, Minor]);
end;

{ TOpenGL3Window9x public methods }

procedure TOpenGL3Window9x.Init;
begin
  FHdc := 0;
  FHglrc := 0;
  FillChar(FImpl, SizeOf(FImpl), 0);
end;

procedure TOpenGL3Window9x.Done;
begin
  ReleaseContexts;
  FImpl.Done;
end;

function TOpenGL3Window9x.CreateWindow(W, H: Integer; const ATitle: string; out AError: string; Major: Integer = 3; Minor: Integer = 3; CoreProfile: Boolean = True): Boolean;
var
  Pfd: TPixelFormatDescriptor;
  Format: Integer;
begin
  Result := False;

  if not FImpl.Create(W, H, ATitle, AError) then
    Exit;

  FHdc := FImpl.GetHdc;
  if FHdc = 0 then
  begin
    AError := 'Failed to get device context (HDC) from MainWindow';
    FImpl.Done;
    Exit;
  end;

  FillChar(Pfd, SizeOf(Pfd), 0);
  Pfd.nSize := SizeOf(Pfd);
  Pfd.nVersion := 1;
  Pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  Pfd.iPixelType := PFD_TYPE_RGBA;
  Pfd.cColorBits := 24;
  Pfd.cDepthBits := 24;
  Pfd.cStencilBits := 8;
  Pfd.iLayerType := PFD_MAIN_PLANE;

  Format := ChoosePixelFormat(FHdc, @Pfd);
  if Format = 0 then
  begin
    AError := 'Failed to choose pixel format';
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  if not SetPixelFormat(FHdc, Format, @Pfd) then
  begin
    AError := 'Failed to set pixel format';
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  FHglrc := CreateModernContext(FHdc, Major, Minor, CoreProfile, AError);
  if FHglrc = 0 then
  begin
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  if not wglMakeCurrent(FHdc, FHglrc) then
  begin
    AError := 'Failed to make OpenGL context current';
    ReleaseContexts;
    FImpl.Done;
    Exit;
  end;

  Result := True;
end;

function TOpenGL3Window9x.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TOpenGL3Window9x.StopEvent;
begin
  FImpl.StopEvent;
end;

function TOpenGL3Window9x.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TOpenGL3Window9x.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TOpenGL3Window9x.Present;
begin
  if FHdc <> 0 then
  begin
    SwapBuffers(FHdc);
  end;
end;

function TOpenGL3Window9x.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
