{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteOpenGL1WindowWin9x;

{$mode objfpc}{$H+}

interface

uses
  Windows, SysUtils, WinLiteEvents, WinLiteMainWindowWin9x;

type
  TOpenGL1Window9x = object
  private
    FImpl  : TMainWindow;
    FHdc   : HDC;
    FHglrc : HGLRC;

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

function wglCreateContext(DC: HDC): HGLRC; stdcall; external 'opengl32.dll';
function wglDeleteContext(GLRC: HGLRC): BOOL; stdcall; external 'opengl32.dll';
function wglMakeCurrent(DC: HDC; GLRC: HGLRC): BOOL; stdcall; external 'opengl32.dll';
function wglGetCurrentContext: HGLRC; stdcall; external 'opengl32.dll';

implementation

{ TOpenGL1Window9x private methods }

procedure TOpenGL1Window9x.ReleaseContexts;
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

{ TOpenGL1Window9x public methods }

procedure TOpenGL1Window9x.Init;
begin
  FHdc := 0;
  FHglrc := 0;
  FillChar(FImpl, SizeOf(FImpl), 0);
end;

procedure TOpenGL1Window9x.Done;
begin
  ReleaseContexts;
  FImpl.Done;
end;

function TOpenGL1Window9x.CreateWindow(W, H: Integer; const ATitle: string; out AError: string): Boolean;
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
  Pfd.cDepthBits := 16;
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

  FHglrc := wglCreateContext(FHdc);
  if FHglrc = 0 then
  begin
    AError := 'Failed to create OpenGL context';
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

function TOpenGL1Window9x.IsRunning: Boolean;
begin
  Result := FImpl.IsRunning;
end;

procedure TOpenGL1Window9x.StopEvent;
begin
  FImpl.StopEvent;
end;

function TOpenGL1Window9x.GetEvent(out AnEvent: TEvent): Boolean;
begin
  Result := FImpl.GetEvent(AnEvent);
end;

procedure TOpenGL1Window9x.SetTitle(const ATitle: string);
begin
  FImpl.SetTitle(ATitle);
end;

procedure TOpenGL1Window9x.Present;
begin
  if FHdc <> 0 then
  begin
    SwapBuffers(FHdc);
  end;
end;

function TOpenGL1Window9x.GetImpl: PMainWindow;
begin
  Result := @FImpl;
end;

end.
