{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit OpenGLLoader;

{$mode objfpc}{$H+}

interface

uses
  OpenGLTypes,
  OpenGLConsts,
  OpenGLFuncs;

type
  TVersionLoader = procedure;

  PVersionEntry = ^TVersionEntry;
  TVersionEntry = record
    major: Integer;
    minor: Integer;
    loader: TVersionLoader;
  end;

  POpenGLLoader = ^TOpenGLLoader;
  TOpenGLLoader = object
  private
    FLoaded: Boolean;
    FMajor: Integer;
    FMinor: Integer;

    procedure LoadFunctions(aMajor: Integer; aMinor: Integer);

  public
    procedure Init(aMajor: Integer; aMinor: Integer);
    procedure Done;
    function IsLoaded: Boolean;
    function GetMajor: Integer;
    function GetMinor: Integer;
    function GetVersion: string;
  end;

function GetProcAddress(const aName: PAnsiChar): Pointer;

procedure LoadVersion1_0;
procedure LoadVersion1_1;
procedure LoadVersion1_2;
procedure LoadVersion1_3;
procedure LoadVersion1_4;
procedure LoadVersion1_5;
procedure LoadVersion2_0;
procedure LoadVersion2_1;
procedure LoadVersion3_0;
procedure LoadVersion3_1;
procedure LoadVersion3_2;
procedure LoadVersion3_3;
procedure LoadVersion4_0;
procedure LoadVersion4_1;
procedure LoadVersion4_2;
procedure LoadVersion4_3;
procedure LoadVersion4_4;
procedure LoadVersion4_5;
procedure LoadVersion4_6;

implementation

{$IFDEF MSWINDOWS}
uses
  SysUtils,
  Windows;
{$ELSE}
uses
  SysUtils;
{$ENDIF}

{=============================================================================
                              GetProcAddress
=============================================================================}

function GetProcAddress(const aName: PAnsiChar): Pointer;
{$IFDEF MSWINDOWS}
var
  opengl32: HMODULE;
  wglGetProcAddress: function(name: PAnsiChar): Pointer; stdcall;
  ext_proc: Pointer;
begin
  Result := nil;
  opengl32 := LoadLibrary('opengl32.dll');
  if opengl32 = 0 then
    Exit;

  Result := Windows.GetProcAddress(opengl32, aName);

  if Result = nil then
  begin

{$IFDEF FPC}
  Pointer(wglGetProcAddress) := Windows.GetProcAddress(opengl32, 'wglGetProcAddress');
{$ELSE}
  @wglGetProcAddress := Windows.GetProcAddress(opengl32, 'wglGetProcAddress');
{$ENDIF}

    if Assigned(wglGetProcAddress) then
    begin
      ext_proc := wglGetProcAddress(aName);

      if (ext_proc <> nil) and
         (ext_proc <> Pointer($1)) and
         (ext_proc <> Pointer($2)) and
         (ext_proc <> Pointer($3)) and
         (ext_proc <> Pointer(-1)) then
      begin
        Result := ext_proc;
      end;
    end;
  end;
end;
{$ELSE}
begin
  Result := nil;
  {$IFDEF LINUX}
  {$ENDIF}
  {$IFDEF DARWIN}
  {$ENDIF}
end;
{$ENDIF}

{=============================================================================
  TOpenGLLoader
=============================================================================}

procedure TOpenGLLoader.Init(aMajor: Integer; aMinor: Integer);
begin
  FMajor := aMajor;
  FMinor := aMinor;
  FLoaded := False;
  LoadFunctions(aMajor, aMinor);
end;

procedure TOpenGLLoader.Done;
begin
end;

function TOpenGLLoader.IsLoaded: Boolean;
begin
  Result := FLoaded;
end;

function TOpenGLLoader.GetMajor: Integer;
begin
  Result := FMajor;
end;

function TOpenGLLoader.GetMinor: Integer;
begin
  Result := FMinor;
end;

function TOpenGLLoader.GetVersion: string;
begin
  Result := Format('%d.%d', [FMajor, FMinor]);
end;

procedure TOpenGLLoader.LoadFunctions(aMajor: Integer; aMinor: Integer);
var
  Versions: array[0..18] of TVersionEntry;
  i: Integer;
begin
  Versions[0].major := 1;  Versions[0].minor := 0;  Versions[0].loader := @LoadVersion1_0;
  Versions[1].major := 1;  Versions[1].minor := 1;  Versions[1].loader := @LoadVersion1_1;
  Versions[2].major := 1;  Versions[2].minor := 2;  Versions[2].loader := @LoadVersion1_2;
  Versions[3].major := 1;  Versions[3].minor := 3;  Versions[3].loader := @LoadVersion1_3;
  Versions[4].major := 1;  Versions[4].minor := 4;  Versions[4].loader := @LoadVersion1_4;
  Versions[5].major := 1;  Versions[5].minor := 5;  Versions[5].loader := @LoadVersion1_5;
  Versions[6].major := 2;  Versions[6].minor := 0;  Versions[6].loader := @LoadVersion2_0;
  Versions[7].major := 2;  Versions[7].minor := 1;  Versions[7].loader := @LoadVersion2_1;
  Versions[8].major := 3;  Versions[8].minor := 0;  Versions[8].loader := @LoadVersion3_0;
  Versions[9].major := 3;  Versions[9].minor := 1;  Versions[9].loader := @LoadVersion3_1;
  Versions[10].major := 3; Versions[10].minor := 2; Versions[10].loader := @LoadVersion3_2;
  Versions[11].major := 3; Versions[11].minor := 3; Versions[11].loader := @LoadVersion3_3;
  Versions[12].major := 4; Versions[12].minor := 0; Versions[12].loader := @LoadVersion4_0;
  Versions[13].major := 4; Versions[13].minor := 1; Versions[13].loader := @LoadVersion4_1;
  Versions[14].major := 4; Versions[14].minor := 2; Versions[14].loader := @LoadVersion4_2;
  Versions[15].major := 4; Versions[15].minor := 3; Versions[15].loader := @LoadVersion4_3;
  Versions[16].major := 4; Versions[16].minor := 4; Versions[16].loader := @LoadVersion4_4;
  Versions[17].major := 4; Versions[17].minor := 5; Versions[17].loader := @LoadVersion4_5;
  Versions[18].major := 4; Versions[18].minor := 6; Versions[18].loader := @LoadVersion4_6;

  for i := 0 to High(Versions) do
  begin
    if not Assigned(Versions[i].loader) then
      Break;

    if (Versions[i].major < aMajor) or
       ((Versions[i].major = aMajor) and (Versions[i].minor <= aMinor)) then
    begin
      Versions[i].loader();
    end;
  end;

  FLoaded := True;
end;

{=============================================================================
  OpenGL 1.0
=============================================================================}

procedure LoadVersion1_0;
begin
  Pointer(glCullFace) := GetProcAddress('glCullFace');
  Pointer(glFrontFace) := GetProcAddress('glFrontFace');
  Pointer(glHint) := GetProcAddress('glHint');
  Pointer(glLineWidth) := GetProcAddress('glLineWidth');
  Pointer(glPointSize) := GetProcAddress('glPointSize');
  Pointer(glPolygonMode) := GetProcAddress('glPolygonMode');
  Pointer(glScissor) := GetProcAddress('glScissor');
  Pointer(glTexParameterf) := GetProcAddress('glTexParameterf');
  Pointer(glTexParameterfv) := GetProcAddress('glTexParameterfv');
  Pointer(glTexParameteri) := GetProcAddress('glTexParameteri');
  Pointer(glTexParameteriv) := GetProcAddress('glTexParameteriv');
  Pointer(glTexImage1D) := GetProcAddress('glTexImage1D');
  Pointer(glTexImage2D) := GetProcAddress('glTexImage2D');
  Pointer(glDrawBuffer) := GetProcAddress('glDrawBuffer');
  Pointer(glClear) := GetProcAddress('glClear');
  Pointer(glClearColor) := GetProcAddress('glClearColor');
  Pointer(glClearStencil) := GetProcAddress('glClearStencil');
  Pointer(glClearDepth) := GetProcAddress('glClearDepth');
  Pointer(glStencilMask) := GetProcAddress('glStencilMask');
  Pointer(glColorMask) := GetProcAddress('glColorMask');
  Pointer(glDepthMask) := GetProcAddress('glDepthMask');
  Pointer(glDisable) := GetProcAddress('glDisable');
  Pointer(glEnable) := GetProcAddress('glEnable');
  Pointer(glFinish) := GetProcAddress('glFinish');
  Pointer(glFlush) := GetProcAddress('glFlush');
  Pointer(glBlendFunc) := GetProcAddress('glBlendFunc');
  Pointer(glLogicOp) := GetProcAddress('glLogicOp');
  Pointer(glStencilFunc) := GetProcAddress('glStencilFunc');
  Pointer(glStencilOp) := GetProcAddress('glStencilOp');
  Pointer(glDepthFunc) := GetProcAddress('glDepthFunc');
  Pointer(glPixelStoref) := GetProcAddress('glPixelStoref');
  Pointer(glPixelStorei) := GetProcAddress('glPixelStorei');
  Pointer(glReadBuffer) := GetProcAddress('glReadBuffer');
  Pointer(glReadPixels) := GetProcAddress('glReadPixels');
  Pointer(glGetBooleanv) := GetProcAddress('glGetBooleanv');
  Pointer(glGetDoublev) := GetProcAddress('glGetDoublev');
  Pointer(glGetError) := GetProcAddress('glGetError');
  Pointer(glGetFloatv) := GetProcAddress('glGetFloatv');
  Pointer(glGetIntegerv) := GetProcAddress('glGetIntegerv');
  Pointer(glGetString) := GetProcAddress('glGetString');
  Pointer(glGetTexImage) := GetProcAddress('glGetTexImage');
  Pointer(glGetTexParameterfv) := GetProcAddress('glGetTexParameterfv');
  Pointer(glGetTexParameteriv) := GetProcAddress('glGetTexParameteriv');
  Pointer(glGetTexLevelParameterfv) := GetProcAddress('glGetTexLevelParameterfv');
  Pointer(glGetTexLevelParameteriv) := GetProcAddress('glGetTexLevelParameteriv');
  Pointer(glIsEnabled) := GetProcAddress('glIsEnabled');
  Pointer(glDepthRange) := GetProcAddress('glDepthRange');
  Pointer(glViewport) := GetProcAddress('glViewport');
  Pointer(glNewList) := GetProcAddress('glNewList');
  Pointer(glEndList) := GetProcAddress('glEndList');
  Pointer(glCallList) := GetProcAddress('glCallList');
  Pointer(glCallLists) := GetProcAddress('glCallLists');
  Pointer(glDeleteLists) := GetProcAddress('glDeleteLists');
  Pointer(glGenLists) := GetProcAddress('glGenLists');
  Pointer(glListBase) := GetProcAddress('glListBase');
  Pointer(glBegin) := GetProcAddress('glBegin');
  Pointer(glBitmap) := GetProcAddress('glBitmap');
  Pointer(glColor3b) := GetProcAddress('glColor3b');
  Pointer(glColor3bv) := GetProcAddress('glColor3bv');
  Pointer(glColor3d) := GetProcAddress('glColor3d');
  Pointer(glColor3dv) := GetProcAddress('glColor3dv');
  Pointer(glColor3f) := GetProcAddress('glColor3f');
  Pointer(glColor3fv) := GetProcAddress('glColor3fv');
  Pointer(glColor3i) := GetProcAddress('glColor3i');
  Pointer(glColor3iv) := GetProcAddress('glColor3iv');
  Pointer(glColor3s) := GetProcAddress('glColor3s');
  Pointer(glColor3sv) := GetProcAddress('glColor3sv');
  Pointer(glColor3ub) := GetProcAddress('glColor3ub');
  Pointer(glColor3ubv) := GetProcAddress('glColor3ubv');
  Pointer(glColor3ui) := GetProcAddress('glColor3ui');
  Pointer(glColor3uiv) := GetProcAddress('glColor3uiv');
  Pointer(glColor3us) := GetProcAddress('glColor3us');
  Pointer(glColor3usv) := GetProcAddress('glColor3usv');
  Pointer(glColor4b) := GetProcAddress('glColor4b');
  Pointer(glColor4bv) := GetProcAddress('glColor4bv');
  Pointer(glColor4d) := GetProcAddress('glColor4d');
  Pointer(glColor4dv) := GetProcAddress('glColor4dv');
  Pointer(glColor4f) := GetProcAddress('glColor4f');
  Pointer(glColor4fv) := GetProcAddress('glColor4fv');
  Pointer(glColor4i) := GetProcAddress('glColor4i');
  Pointer(glColor4iv) := GetProcAddress('glColor4iv');
  Pointer(glColor4s) := GetProcAddress('glColor4s');
  Pointer(glColor4sv) := GetProcAddress('glColor4sv');
  Pointer(glColor4ub) := GetProcAddress('glColor4ub');
  Pointer(glColor4ubv) := GetProcAddress('glColor4ubv');
  Pointer(glColor4ui) := GetProcAddress('glColor4ui');
  Pointer(glColor4uiv) := GetProcAddress('glColor4uiv');
  Pointer(glColor4us) := GetProcAddress('glColor4us');
  Pointer(glColor4usv) := GetProcAddress('glColor4usv');
  Pointer(glEdgeFlag) := GetProcAddress('glEdgeFlag');
  Pointer(glEdgeFlagv) := GetProcAddress('glEdgeFlagv');
  Pointer(glEnd) := GetProcAddress('glEnd');
  Pointer(glIndexd) := GetProcAddress('glIndexd');
  Pointer(glIndexdv) := GetProcAddress('glIndexdv');
  Pointer(glIndexf) := GetProcAddress('glIndexf');
  Pointer(glIndexfv) := GetProcAddress('glIndexfv');
  Pointer(glIndexi) := GetProcAddress('glIndexi');
  Pointer(glIndexiv) := GetProcAddress('glIndexiv');
  Pointer(glIndexs) := GetProcAddress('glIndexs');
  Pointer(glIndexsv) := GetProcAddress('glIndexsv');
  Pointer(glNormal3b) := GetProcAddress('glNormal3b');
  Pointer(glNormal3bv) := GetProcAddress('glNormal3bv');
  Pointer(glNormal3d) := GetProcAddress('glNormal3d');
  Pointer(glNormal3dv) := GetProcAddress('glNormal3dv');
  Pointer(glNormal3f) := GetProcAddress('glNormal3f');
  Pointer(glNormal3fv) := GetProcAddress('glNormal3fv');
  Pointer(glNormal3i) := GetProcAddress('glNormal3i');
  Pointer(glNormal3iv) := GetProcAddress('glNormal3iv');
  Pointer(glNormal3s) := GetProcAddress('glNormal3s');
  Pointer(glNormal3sv) := GetProcAddress('glNormal3sv');
  Pointer(glRasterPos2d) := GetProcAddress('glRasterPos2d');
  Pointer(glRasterPos2dv) := GetProcAddress('glRasterPos2dv');
  Pointer(glRasterPos2f) := GetProcAddress('glRasterPos2f');
  Pointer(glRasterPos2fv) := GetProcAddress('glRasterPos2fv');
  Pointer(glRasterPos2i) := GetProcAddress('glRasterPos2i');
  Pointer(glRasterPos2iv) := GetProcAddress('glRasterPos2iv');
  Pointer(glRasterPos2s) := GetProcAddress('glRasterPos2s');
  Pointer(glRasterPos2sv) := GetProcAddress('glRasterPos2sv');
  Pointer(glRasterPos3d) := GetProcAddress('glRasterPos3d');
  Pointer(glRasterPos3dv) := GetProcAddress('glRasterPos3dv');
  Pointer(glRasterPos3f) := GetProcAddress('glRasterPos3f');
  Pointer(glRasterPos3fv) := GetProcAddress('glRasterPos3fv');
  Pointer(glRasterPos3i) := GetProcAddress('glRasterPos3i');
  Pointer(glRasterPos3iv) := GetProcAddress('glRasterPos3iv');
  Pointer(glRasterPos3s) := GetProcAddress('glRasterPos3s');
  Pointer(glRasterPos3sv) := GetProcAddress('glRasterPos3sv');
  Pointer(glRasterPos4d) := GetProcAddress('glRasterPos4d');
  Pointer(glRasterPos4dv) := GetProcAddress('glRasterPos4dv');
  Pointer(glRasterPos4f) := GetProcAddress('glRasterPos4f');
  Pointer(glRasterPos4fv) := GetProcAddress('glRasterPos4fv');
  Pointer(glRasterPos4i) := GetProcAddress('glRasterPos4i');
  Pointer(glRasterPos4iv) := GetProcAddress('glRasterPos4iv');
  Pointer(glRasterPos4s) := GetProcAddress('glRasterPos4s');
  Pointer(glRasterPos4sv) := GetProcAddress('glRasterPos4sv');
  Pointer(glRectd) := GetProcAddress('glRectd');
  Pointer(glRectdv) := GetProcAddress('glRectdv');
  Pointer(glRectf) := GetProcAddress('glRectf');
  Pointer(glRectfv) := GetProcAddress('glRectfv');
  Pointer(glRecti) := GetProcAddress('glRecti');
  Pointer(glRectiv) := GetProcAddress('glRectiv');
  Pointer(glRects) := GetProcAddress('glRects');
  Pointer(glRectsv) := GetProcAddress('glRectsv');
  Pointer(glTexCoord1d) := GetProcAddress('glTexCoord1d');
  Pointer(glTexCoord1dv) := GetProcAddress('glTexCoord1dv');
  Pointer(glTexCoord1f) := GetProcAddress('glTexCoord1f');
  Pointer(glTexCoord1fv) := GetProcAddress('glTexCoord1fv');
  Pointer(glTexCoord1i) := GetProcAddress('glTexCoord1i');
  Pointer(glTexCoord1iv) := GetProcAddress('glTexCoord1iv');
  Pointer(glTexCoord1s) := GetProcAddress('glTexCoord1s');
  Pointer(glTexCoord1sv) := GetProcAddress('glTexCoord1sv');
  Pointer(glTexCoord2d) := GetProcAddress('glTexCoord2d');
  Pointer(glTexCoord2dv) := GetProcAddress('glTexCoord2dv');
  Pointer(glTexCoord2f) := GetProcAddress('glTexCoord2f');
  Pointer(glTexCoord2fv) := GetProcAddress('glTexCoord2fv');
  Pointer(glTexCoord2i) := GetProcAddress('glTexCoord2i');
  Pointer(glTexCoord2iv) := GetProcAddress('glTexCoord2iv');
  Pointer(glTexCoord2s) := GetProcAddress('glTexCoord2s');
  Pointer(glTexCoord2sv) := GetProcAddress('glTexCoord2sv');
  Pointer(glTexCoord3d) := GetProcAddress('glTexCoord3d');
  Pointer(glTexCoord3dv) := GetProcAddress('glTexCoord3dv');
  Pointer(glTexCoord3f) := GetProcAddress('glTexCoord3f');
  Pointer(glTexCoord3fv) := GetProcAddress('glTexCoord3fv');
  Pointer(glTexCoord3i) := GetProcAddress('glTexCoord3i');
  Pointer(glTexCoord3iv) := GetProcAddress('glTexCoord3iv');
  Pointer(glTexCoord3s) := GetProcAddress('glTexCoord3s');
  Pointer(glTexCoord3sv) := GetProcAddress('glTexCoord3sv');
  Pointer(glTexCoord4d) := GetProcAddress('glTexCoord4d');
  Pointer(glTexCoord4dv) := GetProcAddress('glTexCoord4dv');
  Pointer(glTexCoord4f) := GetProcAddress('glTexCoord4f');
  Pointer(glTexCoord4fv) := GetProcAddress('glTexCoord4fv');
  Pointer(glTexCoord4i) := GetProcAddress('glTexCoord4i');
  Pointer(glTexCoord4iv) := GetProcAddress('glTexCoord4iv');
  Pointer(glTexCoord4s) := GetProcAddress('glTexCoord4s');
  Pointer(glTexCoord4sv) := GetProcAddress('glTexCoord4sv');
  Pointer(glVertex2d) := GetProcAddress('glVertex2d');
  Pointer(glVertex2dv) := GetProcAddress('glVertex2dv');
  Pointer(glVertex2f) := GetProcAddress('glVertex2f');
  Pointer(glVertex2fv) := GetProcAddress('glVertex2fv');
  Pointer(glVertex2i) := GetProcAddress('glVertex2i');
  Pointer(glVertex2iv) := GetProcAddress('glVertex2iv');
  Pointer(glVertex2s) := GetProcAddress('glVertex2s');
  Pointer(glVertex2sv) := GetProcAddress('glVertex2sv');
  Pointer(glVertex3d) := GetProcAddress('glVertex3d');
  Pointer(glVertex3dv) := GetProcAddress('glVertex3dv');
  Pointer(glVertex3f) := GetProcAddress('glVertex3f');
  Pointer(glVertex3fv) := GetProcAddress('glVertex3fv');
  Pointer(glVertex3i) := GetProcAddress('glVertex3i');
  Pointer(glVertex3iv) := GetProcAddress('glVertex3iv');
  Pointer(glVertex3s) := GetProcAddress('glVertex3s');
  Pointer(glVertex3sv) := GetProcAddress('glVertex3sv');
  Pointer(glVertex4d) := GetProcAddress('glVertex4d');
  Pointer(glVertex4dv) := GetProcAddress('glVertex4dv');
  Pointer(glVertex4f) := GetProcAddress('glVertex4f');
  Pointer(glVertex4fv) := GetProcAddress('glVertex4fv');
  Pointer(glVertex4i) := GetProcAddress('glVertex4i');
  Pointer(glVertex4iv) := GetProcAddress('glVertex4iv');
  Pointer(glVertex4s) := GetProcAddress('glVertex4s');
  Pointer(glVertex4sv) := GetProcAddress('glVertex4sv');
  Pointer(glClipPlane) := GetProcAddress('glClipPlane');
  Pointer(glColorMaterial) := GetProcAddress('glColorMaterial');
  Pointer(glFogf) := GetProcAddress('glFogf');
  Pointer(glFogfv) := GetProcAddress('glFogfv');
  Pointer(glFogi) := GetProcAddress('glFogi');
  Pointer(glFogiv) := GetProcAddress('glFogiv');
  Pointer(glLightf) := GetProcAddress('glLightf');
  Pointer(glLightfv) := GetProcAddress('glLightfv');
  Pointer(glLighti) := GetProcAddress('glLighti');
  Pointer(glLightiv) := GetProcAddress('glLightiv');
  Pointer(glLightModelf) := GetProcAddress('glLightModelf');
  Pointer(glLightModelfv) := GetProcAddress('glLightModelfv');
  Pointer(glLightModeli) := GetProcAddress('glLightModeli');
  Pointer(glLightModeliv) := GetProcAddress('glLightModeliv');
  Pointer(glLineStipple) := GetProcAddress('glLineStipple');
  Pointer(glMaterialf) := GetProcAddress('glMaterialf');
  Pointer(glMaterialfv) := GetProcAddress('glMaterialfv');
  Pointer(glMateriali) := GetProcAddress('glMateriali');
  Pointer(glMaterialiv) := GetProcAddress('glMaterialiv');
  Pointer(glPolygonStipple) := GetProcAddress('glPolygonStipple');
  Pointer(glShadeModel) := GetProcAddress('glShadeModel');
  Pointer(glTexEnvf) := GetProcAddress('glTexEnvf');
  Pointer(glTexEnvfv) := GetProcAddress('glTexEnvfv');
  Pointer(glTexEnvi) := GetProcAddress('glTexEnvi');
  Pointer(glTexEnviv) := GetProcAddress('glTexEnviv');
  Pointer(glTexGend) := GetProcAddress('glTexGend');
  Pointer(glTexGendv) := GetProcAddress('glTexGendv');
  Pointer(glTexGenf) := GetProcAddress('glTexGenf');
  Pointer(glTexGenfv) := GetProcAddress('glTexGenfv');
  Pointer(glTexGeni) := GetProcAddress('glTexGeni');
  Pointer(glTexGeniv) := GetProcAddress('glTexGeniv');
  Pointer(glFeedbackBuffer) := GetProcAddress('glFeedbackBuffer');
  Pointer(glSelectBuffer) := GetProcAddress('glSelectBuffer');
  Pointer(glRenderMode) := GetProcAddress('glRenderMode');
  Pointer(glInitNames) := GetProcAddress('glInitNames');
  Pointer(glLoadName) := GetProcAddress('glLoadName');
  Pointer(glPassThrough) := GetProcAddress('glPassThrough');
  Pointer(glPopName) := GetProcAddress('glPopName');
  Pointer(glPushName) := GetProcAddress('glPushName');
  Pointer(glClearAccum) := GetProcAddress('glClearAccum');
  Pointer(glClearIndex) := GetProcAddress('glClearIndex');
  Pointer(glIndexMask) := GetProcAddress('glIndexMask');
  Pointer(glAccum) := GetProcAddress('glAccum');
  Pointer(glPopAttrib) := GetProcAddress('glPopAttrib');
  Pointer(glPushAttrib) := GetProcAddress('glPushAttrib');
  Pointer(glMap1d) := GetProcAddress('glMap1d');
  Pointer(glMap1f) := GetProcAddress('glMap1f');
  Pointer(glMap2d) := GetProcAddress('glMap2d');
  Pointer(glMap2f) := GetProcAddress('glMap2f');
  Pointer(glMapGrid1d) := GetProcAddress('glMapGrid1d');
  Pointer(glMapGrid1f) := GetProcAddress('glMapGrid1f');
  Pointer(glMapGrid2d) := GetProcAddress('glMapGrid2d');
  Pointer(glMapGrid2f) := GetProcAddress('glMapGrid2f');
  Pointer(glEvalCoord1d) := GetProcAddress('glEvalCoord1d');
  Pointer(glEvalCoord1dv) := GetProcAddress('glEvalCoord1dv');
  Pointer(glEvalCoord1f) := GetProcAddress('glEvalCoord1f');
  Pointer(glEvalCoord1fv) := GetProcAddress('glEvalCoord1fv');
  Pointer(glEvalCoord2d) := GetProcAddress('glEvalCoord2d');
  Pointer(glEvalCoord2dv) := GetProcAddress('glEvalCoord2dv');
  Pointer(glEvalCoord2f) := GetProcAddress('glEvalCoord2f');
  Pointer(glEvalCoord2fv) := GetProcAddress('glEvalCoord2fv');
  Pointer(glEvalMesh1) := GetProcAddress('glEvalMesh1');
  Pointer(glEvalPoint1) := GetProcAddress('glEvalPoint1');
  Pointer(glEvalMesh2) := GetProcAddress('glEvalMesh2');
  Pointer(glEvalPoint2) := GetProcAddress('glEvalPoint2');
  Pointer(glAlphaFunc) := GetProcAddress('glAlphaFunc');
  Pointer(glPixelZoom) := GetProcAddress('glPixelZoom');
  Pointer(glPixelTransferf) := GetProcAddress('glPixelTransferf');
  Pointer(glPixelTransferi) := GetProcAddress('glPixelTransferi');
  Pointer(glPixelMapfv) := GetProcAddress('glPixelMapfv');
  Pointer(glPixelMapuiv) := GetProcAddress('glPixelMapuiv');
  Pointer(glPixelMapusv) := GetProcAddress('glPixelMapusv');
  Pointer(glCopyPixels) := GetProcAddress('glCopyPixels');
  Pointer(glDrawPixels) := GetProcAddress('glDrawPixels');
  Pointer(glGetClipPlane) := GetProcAddress('glGetClipPlane');
  Pointer(glGetLightfv) := GetProcAddress('glGetLightfv');
  Pointer(glGetLightiv) := GetProcAddress('glGetLightiv');
  Pointer(glGetMapdv) := GetProcAddress('glGetMapdv');
  Pointer(glGetMapfv) := GetProcAddress('glGetMapfv');
  Pointer(glGetMapiv) := GetProcAddress('glGetMapiv');
  Pointer(glGetMaterialfv) := GetProcAddress('glGetMaterialfv');
  Pointer(glGetMaterialiv) := GetProcAddress('glGetMaterialiv');
  Pointer(glGetPixelMapfv) := GetProcAddress('glGetPixelMapfv');
  Pointer(glGetPixelMapuiv) := GetProcAddress('glGetPixelMapuiv');
  Pointer(glGetPixelMapusv) := GetProcAddress('glGetPixelMapusv');
  Pointer(glGetPolygonStipple) := GetProcAddress('glGetPolygonStipple');
  Pointer(glGetTexEnvfv) := GetProcAddress('glGetTexEnvfv');
  Pointer(glGetTexEnviv) := GetProcAddress('glGetTexEnviv');
  Pointer(glGetTexGendv) := GetProcAddress('glGetTexGendv');
  Pointer(glGetTexGenfv) := GetProcAddress('glGetTexGenfv');
  Pointer(glGetTexGeniv) := GetProcAddress('glGetTexGeniv');
  Pointer(glIsList) := GetProcAddress('glIsList');
  Pointer(glFrustum) := GetProcAddress('glFrustum');
  Pointer(glLoadIdentity) := GetProcAddress('glLoadIdentity');
  Pointer(glLoadMatrixf) := GetProcAddress('glLoadMatrixf');
  Pointer(glLoadMatrixd) := GetProcAddress('glLoadMatrixd');
  Pointer(glMatrixMode) := GetProcAddress('glMatrixMode');
  Pointer(glMultMatrixf) := GetProcAddress('glMultMatrixf');
  Pointer(glMultMatrixd) := GetProcAddress('glMultMatrixd');
  Pointer(glOrtho) := GetProcAddress('glOrtho');
  Pointer(glPopMatrix) := GetProcAddress('glPopMatrix');
  Pointer(glPushMatrix) := GetProcAddress('glPushMatrix');
  Pointer(glRotated) := GetProcAddress('glRotated');
  Pointer(glRotatef) := GetProcAddress('glRotatef');
  Pointer(glScaled) := GetProcAddress('glScaled');
  Pointer(glScalef) := GetProcAddress('glScalef');
  Pointer(glTranslated) := GetProcAddress('glTranslated');
  Pointer(glTranslatef) := GetProcAddress('glTranslatef');
end;

{=============================================================================
  OpenGL 1.1
=============================================================================}

procedure LoadVersion1_1;
begin
  Pointer(glDrawArrays) := GetProcAddress('glDrawArrays');
  Pointer(glDrawElements) := GetProcAddress('glDrawElements');
  Pointer(glGetPointerv) := GetProcAddress('glGetPointerv');
  Pointer(glPolygonOffset) := GetProcAddress('glPolygonOffset');
  Pointer(glCopyTexImage1D) := GetProcAddress('glCopyTexImage1D');
  Pointer(glCopyTexImage2D) := GetProcAddress('glCopyTexImage2D');
  Pointer(glCopyTexSubImage1D) := GetProcAddress('glCopyTexSubImage1D');
  Pointer(glCopyTexSubImage2D) := GetProcAddress('glCopyTexSubImage2D');
  Pointer(glTexSubImage1D) := GetProcAddress('glTexSubImage1D');
  Pointer(glTexSubImage2D) := GetProcAddress('glTexSubImage2D');
  Pointer(glBindTexture) := GetProcAddress('glBindTexture');
  Pointer(glDeleteTextures) := GetProcAddress('glDeleteTextures');
  Pointer(glGenTextures) := GetProcAddress('glGenTextures');
  Pointer(glIsTexture) := GetProcAddress('glIsTexture');
  Pointer(glArrayElement) := GetProcAddress('glArrayElement');
  Pointer(glColorPointer) := GetProcAddress('glColorPointer');
  Pointer(glDisableClientState) := GetProcAddress('glDisableClientState');
  Pointer(glEdgeFlagPointer) := GetProcAddress('glEdgeFlagPointer');
  Pointer(glEnableClientState) := GetProcAddress('glEnableClientState');
  Pointer(glIndexPointer) := GetProcAddress('glIndexPointer');
  Pointer(glInterleavedArrays) := GetProcAddress('glInterleavedArrays');
  Pointer(glNormalPointer) := GetProcAddress('glNormalPointer');
  Pointer(glTexCoordPointer) := GetProcAddress('glTexCoordPointer');
  Pointer(glVertexPointer) := GetProcAddress('glVertexPointer');
  Pointer(glAreTexturesResident) := GetProcAddress('glAreTexturesResident');
  Pointer(glPrioritizeTextures) := GetProcAddress('glPrioritizeTextures');
  Pointer(glIndexub) := GetProcAddress('glIndexub');
  Pointer(glIndexubv) := GetProcAddress('glIndexubv');
  Pointer(glPopClientAttrib) := GetProcAddress('glPopClientAttrib');
  Pointer(glPushClientAttrib) := GetProcAddress('glPushClientAttrib');
end;

{=============================================================================
  OpenGL 1.2
=============================================================================}

procedure LoadVersion1_2;
begin
  Pointer(glDrawRangeElements) := GetProcAddress('glDrawRangeElements');
  Pointer(glTexImage3D) := GetProcAddress('glTexImage3D');
  Pointer(glTexSubImage3D) := GetProcAddress('glTexSubImage3D');
  Pointer(glCopyTexSubImage3D) := GetProcAddress('glCopyTexSubImage3D');
end;

{=============================================================================
  OpenGL 1.3
=============================================================================}

procedure LoadVersion1_3;
begin
  Pointer(glActiveTexture) := GetProcAddress('glActiveTexture');
  Pointer(glSampleCoverage) := GetProcAddress('glSampleCoverage');
  Pointer(glCompressedTexImage3D) := GetProcAddress('glCompressedTexImage3D');
  Pointer(glCompressedTexImage2D) := GetProcAddress('glCompressedTexImage2D');
  Pointer(glCompressedTexImage1D) := GetProcAddress('glCompressedTexImage1D');
  Pointer(glCompressedTexSubImage3D) := GetProcAddress('glCompressedTexSubImage3D');
  Pointer(glCompressedTexSubImage2D) := GetProcAddress('glCompressedTexSubImage2D');
  Pointer(glCompressedTexSubImage1D) := GetProcAddress('glCompressedTexSubImage1D');
  Pointer(glGetCompressedTexImage) := GetProcAddress('glGetCompressedTexImage');
  Pointer(glClientActiveTexture) := GetProcAddress('glClientActiveTexture');
  Pointer(glMultiTexCoord1d) := GetProcAddress('glMultiTexCoord1d');
  Pointer(glMultiTexCoord1dv) := GetProcAddress('glMultiTexCoord1dv');
  Pointer(glMultiTexCoord1f) := GetProcAddress('glMultiTexCoord1f');
  Pointer(glMultiTexCoord1fv) := GetProcAddress('glMultiTexCoord1fv');
  Pointer(glMultiTexCoord1i) := GetProcAddress('glMultiTexCoord1i');
  Pointer(glMultiTexCoord1iv) := GetProcAddress('glMultiTexCoord1iv');
  Pointer(glMultiTexCoord1s) := GetProcAddress('glMultiTexCoord1s');
  Pointer(glMultiTexCoord1sv) := GetProcAddress('glMultiTexCoord1sv');
  Pointer(glMultiTexCoord2d) := GetProcAddress('glMultiTexCoord2d');
  Pointer(glMultiTexCoord2dv) := GetProcAddress('glMultiTexCoord2dv');
  Pointer(glMultiTexCoord2f) := GetProcAddress('glMultiTexCoord2f');
  Pointer(glMultiTexCoord2fv) := GetProcAddress('glMultiTexCoord2fv');
  Pointer(glMultiTexCoord2i) := GetProcAddress('glMultiTexCoord2i');
  Pointer(glMultiTexCoord2iv) := GetProcAddress('glMultiTexCoord2iv');
  Pointer(glMultiTexCoord2s) := GetProcAddress('glMultiTexCoord2s');
  Pointer(glMultiTexCoord2sv) := GetProcAddress('glMultiTexCoord2sv');
  Pointer(glMultiTexCoord3d) := GetProcAddress('glMultiTexCoord3d');
  Pointer(glMultiTexCoord3dv) := GetProcAddress('glMultiTexCoord3dv');
  Pointer(glMultiTexCoord3f) := GetProcAddress('glMultiTexCoord3f');
  Pointer(glMultiTexCoord3fv) := GetProcAddress('glMultiTexCoord3fv');
  Pointer(glMultiTexCoord3i) := GetProcAddress('glMultiTexCoord3i');
  Pointer(glMultiTexCoord3iv) := GetProcAddress('glMultiTexCoord3iv');
  Pointer(glMultiTexCoord3s) := GetProcAddress('glMultiTexCoord3s');
  Pointer(glMultiTexCoord3sv) := GetProcAddress('glMultiTexCoord3sv');
  Pointer(glMultiTexCoord4d) := GetProcAddress('glMultiTexCoord4d');
  Pointer(glMultiTexCoord4dv) := GetProcAddress('glMultiTexCoord4dv');
  Pointer(glMultiTexCoord4f) := GetProcAddress('glMultiTexCoord4f');
  Pointer(glMultiTexCoord4fv) := GetProcAddress('glMultiTexCoord4fv');
  Pointer(glMultiTexCoord4i) := GetProcAddress('glMultiTexCoord4i');
  Pointer(glMultiTexCoord4iv) := GetProcAddress('glMultiTexCoord4iv');
  Pointer(glMultiTexCoord4s) := GetProcAddress('glMultiTexCoord4s');
  Pointer(glMultiTexCoord4sv) := GetProcAddress('glMultiTexCoord4sv');
  Pointer(glLoadTransposeMatrixf) := GetProcAddress('glLoadTransposeMatrixf');
  Pointer(glLoadTransposeMatrixd) := GetProcAddress('glLoadTransposeMatrixd');
  Pointer(glMultTransposeMatrixf) := GetProcAddress('glMultTransposeMatrixf');
  Pointer(glMultTransposeMatrixd) := GetProcAddress('glMultTransposeMatrixd');
end;

{=============================================================================
  OpenGL 1.4
=============================================================================}

procedure LoadVersion1_4;
begin
  Pointer(glBlendFuncSeparate) := GetProcAddress('glBlendFuncSeparate');
  Pointer(glMultiDrawArrays) := GetProcAddress('glMultiDrawArrays');
  Pointer(glMultiDrawElements) := GetProcAddress('glMultiDrawElements');
  Pointer(glPointParameterf) := GetProcAddress('glPointParameterf');
  Pointer(glPointParameterfv) := GetProcAddress('glPointParameterfv');
  Pointer(glPointParameteri) := GetProcAddress('glPointParameteri');
  Pointer(glPointParameteriv) := GetProcAddress('glPointParameteriv');
  Pointer(glFogCoordf) := GetProcAddress('glFogCoordf');
  Pointer(glFogCoordfv) := GetProcAddress('glFogCoordfv');
  Pointer(glFogCoordd) := GetProcAddress('glFogCoordd');
  Pointer(glFogCoorddv) := GetProcAddress('glFogCoorddv');
  Pointer(glFogCoordPointer) := GetProcAddress('glFogCoordPointer');
  Pointer(glSecondaryColor3b) := GetProcAddress('glSecondaryColor3b');
  Pointer(glSecondaryColor3bv) := GetProcAddress('glSecondaryColor3bv');
  Pointer(glSecondaryColor3d) := GetProcAddress('glSecondaryColor3d');
  Pointer(glSecondaryColor3dv) := GetProcAddress('glSecondaryColor3dv');
  Pointer(glSecondaryColor3f) := GetProcAddress('glSecondaryColor3f');
  Pointer(glSecondaryColor3fv) := GetProcAddress('glSecondaryColor3fv');
  Pointer(glSecondaryColor3i) := GetProcAddress('glSecondaryColor3i');
  Pointer(glSecondaryColor3iv) := GetProcAddress('glSecondaryColor3iv');
  Pointer(glSecondaryColor3s) := GetProcAddress('glSecondaryColor3s');
  Pointer(glSecondaryColor3sv) := GetProcAddress('glSecondaryColor3sv');
  Pointer(glSecondaryColor3ub) := GetProcAddress('glSecondaryColor3ub');
  Pointer(glSecondaryColor3ubv) := GetProcAddress('glSecondaryColor3ubv');
  Pointer(glSecondaryColor3ui) := GetProcAddress('glSecondaryColor3ui');
  Pointer(glSecondaryColor3uiv) := GetProcAddress('glSecondaryColor3uiv');
  Pointer(glSecondaryColor3us) := GetProcAddress('glSecondaryColor3us');
  Pointer(glSecondaryColor3usv) := GetProcAddress('glSecondaryColor3usv');
  Pointer(glSecondaryColorPointer) := GetProcAddress('glSecondaryColorPointer');
  Pointer(glWindowPos2d) := GetProcAddress('glWindowPos2d');
  Pointer(glWindowPos2dv) := GetProcAddress('glWindowPos2dv');
  Pointer(glWindowPos2f) := GetProcAddress('glWindowPos2f');
  Pointer(glWindowPos2fv) := GetProcAddress('glWindowPos2fv');
  Pointer(glWindowPos2i) := GetProcAddress('glWindowPos2i');
  Pointer(glWindowPos2iv) := GetProcAddress('glWindowPos2iv');
  Pointer(glWindowPos2s) := GetProcAddress('glWindowPos2s');
  Pointer(glWindowPos2sv) := GetProcAddress('glWindowPos2sv');
  Pointer(glWindowPos3d) := GetProcAddress('glWindowPos3d');
  Pointer(glWindowPos3dv) := GetProcAddress('glWindowPos3dv');
  Pointer(glWindowPos3f) := GetProcAddress('glWindowPos3f');
  Pointer(glWindowPos3fv) := GetProcAddress('glWindowPos3fv');
  Pointer(glWindowPos3i) := GetProcAddress('glWindowPos3i');
  Pointer(glWindowPos3iv) := GetProcAddress('glWindowPos3iv');
  Pointer(glWindowPos3s) := GetProcAddress('glWindowPos3s');
  Pointer(glWindowPos3sv) := GetProcAddress('glWindowPos3sv');
  Pointer(glBlendColor) := GetProcAddress('glBlendColor');
  Pointer(glBlendEquation) := GetProcAddress('glBlendEquation');
end;

{=============================================================================
  OpenGL 1.5
=============================================================================}

procedure LoadVersion1_5;
begin
  Pointer(glGenQueries) := GetProcAddress('glGenQueries');
  Pointer(glDeleteQueries) := GetProcAddress('glDeleteQueries');
  Pointer(glIsQuery) := GetProcAddress('glIsQuery');
  Pointer(glBeginQuery) := GetProcAddress('glBeginQuery');
  Pointer(glEndQuery) := GetProcAddress('glEndQuery');
  Pointer(glGetQueryiv) := GetProcAddress('glGetQueryiv');
  Pointer(glGetQueryObjectiv) := GetProcAddress('glGetQueryObjectiv');
  Pointer(glGetQueryObjectuiv) := GetProcAddress('glGetQueryObjectuiv');
  Pointer(glBindBuffer) := GetProcAddress('glBindBuffer');
  Pointer(glDeleteBuffers) := GetProcAddress('glDeleteBuffers');
  Pointer(glGenBuffers) := GetProcAddress('glGenBuffers');
  Pointer(glIsBuffer) := GetProcAddress('glIsBuffer');
  Pointer(glBufferData) := GetProcAddress('glBufferData');
  Pointer(glBufferSubData) := GetProcAddress('glBufferSubData');
  Pointer(glGetBufferSubData) := GetProcAddress('glGetBufferSubData');
  Pointer(glMapBuffer) := GetProcAddress('glMapBuffer');
  Pointer(glUnmapBuffer) := GetProcAddress('glUnmapBuffer');
  Pointer(glGetBufferParameteriv) := GetProcAddress('glGetBufferParameteriv');
  Pointer(glGetBufferPointerv) := GetProcAddress('glGetBufferPointerv');
end;

{=============================================================================
  OpenGL 2.0
=============================================================================}

procedure LoadVersion2_0;
begin
  Pointer(glBlendEquationSeparate) := GetProcAddress('glBlendEquationSeparate');
  Pointer(glDrawBuffers) := GetProcAddress('glDrawBuffers');
  Pointer(glStencilOpSeparate) := GetProcAddress('glStencilOpSeparate');
  Pointer(glStencilFuncSeparate) := GetProcAddress('glStencilFuncSeparate');
  Pointer(glStencilMaskSeparate) := GetProcAddress('glStencilMaskSeparate');
  Pointer(glAttachShader) := GetProcAddress('glAttachShader');
  Pointer(glBindAttribLocation) := GetProcAddress('glBindAttribLocation');
  Pointer(glCompileShader) := GetProcAddress('glCompileShader');
  Pointer(glCreateProgram) := GetProcAddress('glCreateProgram');
  Pointer(glCreateShader) := GetProcAddress('glCreateShader');
  Pointer(glDeleteProgram) := GetProcAddress('glDeleteProgram');
  Pointer(glDeleteShader) := GetProcAddress('glDeleteShader');
  Pointer(glDetachShader) := GetProcAddress('glDetachShader');
  Pointer(glDisableVertexAttribArray) := GetProcAddress('glDisableVertexAttribArray');
  Pointer(glEnableVertexAttribArray) := GetProcAddress('glEnableVertexAttribArray');
  Pointer(glGetActiveAttrib) := GetProcAddress('glGetActiveAttrib');
  Pointer(glGetActiveUniform) := GetProcAddress('glGetActiveUniform');
  Pointer(glGetAttachedShaders) := GetProcAddress('glGetAttachedShaders');
  Pointer(glGetAttribLocation) := GetProcAddress('glGetAttribLocation');
  Pointer(glGetProgramiv) := GetProcAddress('glGetProgramiv');
  Pointer(glGetProgramInfoLog) := GetProcAddress('glGetProgramInfoLog');
  Pointer(glGetShaderiv) := GetProcAddress('glGetShaderiv');
  Pointer(glGetShaderInfoLog) := GetProcAddress('glGetShaderInfoLog');
  Pointer(glGetShaderSource) := GetProcAddress('glGetShaderSource');
  Pointer(glGetUniformLocation) := GetProcAddress('glGetUniformLocation');
  Pointer(glGetUniformfv) := GetProcAddress('glGetUniformfv');
  Pointer(glGetUniformiv) := GetProcAddress('glGetUniformiv');
  Pointer(glGetVertexAttribdv) := GetProcAddress('glGetVertexAttribdv');
  Pointer(glGetVertexAttribfv) := GetProcAddress('glGetVertexAttribfv');
  Pointer(glGetVertexAttribiv) := GetProcAddress('glGetVertexAttribiv');
  Pointer(glGetVertexAttribPointerv) := GetProcAddress('glGetVertexAttribPointerv');
  Pointer(glIsProgram) := GetProcAddress('glIsProgram');
  Pointer(glIsShader) := GetProcAddress('glIsShader');
  Pointer(glLinkProgram) := GetProcAddress('glLinkProgram');
  Pointer(glShaderSource) := GetProcAddress('glShaderSource');
  Pointer(glUseProgram) := GetProcAddress('glUseProgram');
  Pointer(glUniform1f) := GetProcAddress('glUniform1f');
  Pointer(glUniform2f) := GetProcAddress('glUniform2f');
  Pointer(glUniform3f) := GetProcAddress('glUniform3f');
  Pointer(glUniform4f) := GetProcAddress('glUniform4f');
  Pointer(glUniform1i) := GetProcAddress('glUniform1i');
  Pointer(glUniform2i) := GetProcAddress('glUniform2i');
  Pointer(glUniform3i) := GetProcAddress('glUniform3i');
  Pointer(glUniform4i) := GetProcAddress('glUniform4i');
  Pointer(glUniform1fv) := GetProcAddress('glUniform1fv');
  Pointer(glUniform2fv) := GetProcAddress('glUniform2fv');
  Pointer(glUniform3fv) := GetProcAddress('glUniform3fv');
  Pointer(glUniform4fv) := GetProcAddress('glUniform4fv');
  Pointer(glUniform1iv) := GetProcAddress('glUniform1iv');
  Pointer(glUniform2iv) := GetProcAddress('glUniform2iv');
  Pointer(glUniform3iv) := GetProcAddress('glUniform3iv');
  Pointer(glUniform4iv) := GetProcAddress('glUniform4iv');
  Pointer(glUniformMatrix2fv) := GetProcAddress('glUniformMatrix2fv');
  Pointer(glUniformMatrix3fv) := GetProcAddress('glUniformMatrix3fv');
  Pointer(glUniformMatrix4fv) := GetProcAddress('glUniformMatrix4fv');
  Pointer(glValidateProgram) := GetProcAddress('glValidateProgram');
  Pointer(glVertexAttrib1d) := GetProcAddress('glVertexAttrib1d');
  Pointer(glVertexAttrib1dv) := GetProcAddress('glVertexAttrib1dv');
  Pointer(glVertexAttrib1f) := GetProcAddress('glVertexAttrib1f');
  Pointer(glVertexAttrib1fv) := GetProcAddress('glVertexAttrib1fv');
  Pointer(glVertexAttrib1s) := GetProcAddress('glVertexAttrib1s');
  Pointer(glVertexAttrib1sv) := GetProcAddress('glVertexAttrib1sv');
  Pointer(glVertexAttrib2d) := GetProcAddress('glVertexAttrib2d');
  Pointer(glVertexAttrib2dv) := GetProcAddress('glVertexAttrib2dv');
  Pointer(glVertexAttrib2f) := GetProcAddress('glVertexAttrib2f');
  Pointer(glVertexAttrib2fv) := GetProcAddress('glVertexAttrib2fv');
  Pointer(glVertexAttrib2s) := GetProcAddress('glVertexAttrib2s');
  Pointer(glVertexAttrib2sv) := GetProcAddress('glVertexAttrib2sv');
  Pointer(glVertexAttrib3d) := GetProcAddress('glVertexAttrib3d');
  Pointer(glVertexAttrib3dv) := GetProcAddress('glVertexAttrib3dv');
  Pointer(glVertexAttrib3f) := GetProcAddress('glVertexAttrib3f');
  Pointer(glVertexAttrib3fv) := GetProcAddress('glVertexAttrib3fv');
  Pointer(glVertexAttrib3s) := GetProcAddress('glVertexAttrib3s');
  Pointer(glVertexAttrib3sv) := GetProcAddress('glVertexAttrib3sv');
  Pointer(glVertexAttrib4Nbv) := GetProcAddress('glVertexAttrib4Nbv');
  Pointer(glVertexAttrib4Niv) := GetProcAddress('glVertexAttrib4Niv');
  Pointer(glVertexAttrib4Nsv) := GetProcAddress('glVertexAttrib4Nsv');
  Pointer(glVertexAttrib4Nub) := GetProcAddress('glVertexAttrib4Nub');
  Pointer(glVertexAttrib4Nubv) := GetProcAddress('glVertexAttrib4Nubv');
  Pointer(glVertexAttrib4Nuiv) := GetProcAddress('glVertexAttrib4Nuiv');
  Pointer(glVertexAttrib4Nusv) := GetProcAddress('glVertexAttrib4Nusv');
  Pointer(glVertexAttrib4bv) := GetProcAddress('glVertexAttrib4bv');
  Pointer(glVertexAttrib4d) := GetProcAddress('glVertexAttrib4d');
  Pointer(glVertexAttrib4dv) := GetProcAddress('glVertexAttrib4dv');
  Pointer(glVertexAttrib4f) := GetProcAddress('glVertexAttrib4f');
  Pointer(glVertexAttrib4fv) := GetProcAddress('glVertexAttrib4fv');
  Pointer(glVertexAttrib4iv) := GetProcAddress('glVertexAttrib4iv');
  Pointer(glVertexAttrib4s) := GetProcAddress('glVertexAttrib4s');
  Pointer(glVertexAttrib4sv) := GetProcAddress('glVertexAttrib4sv');
  Pointer(glVertexAttrib4ubv) := GetProcAddress('glVertexAttrib4ubv');
  Pointer(glVertexAttrib4uiv) := GetProcAddress('glVertexAttrib4uiv');
  Pointer(glVertexAttrib4usv) := GetProcAddress('glVertexAttrib4usv');
  Pointer(glVertexAttribPointer) := GetProcAddress('glVertexAttribPointer');
end;

{=============================================================================
  OpenGL 2.1
=============================================================================}

procedure LoadVersion2_1;
begin
  Pointer(glUniformMatrix2x3fv) := GetProcAddress('glUniformMatrix2x3fv');
  Pointer(glUniformMatrix3x2fv) := GetProcAddress('glUniformMatrix3x2fv');
  Pointer(glUniformMatrix2x4fv) := GetProcAddress('glUniformMatrix2x4fv');
  Pointer(glUniformMatrix4x2fv) := GetProcAddress('glUniformMatrix4x2fv');
  Pointer(glUniformMatrix3x4fv) := GetProcAddress('glUniformMatrix3x4fv');
  Pointer(glUniformMatrix4x3fv) := GetProcAddress('glUniformMatrix4x3fv');
end;

{=============================================================================
  OpenGL 3.0
=============================================================================}

procedure LoadVersion3_0;
begin
  Pointer(glColorMaski) := GetProcAddress('glColorMaski');
  Pointer(glGetBooleani_v) := GetProcAddress('glGetBooleani_v');
  Pointer(glGetIntegeri_v) := GetProcAddress('glGetIntegeri_v');
  Pointer(glEnablei) := GetProcAddress('glEnablei');
  Pointer(glDisablei) := GetProcAddress('glDisablei');
  Pointer(glIsEnabledi) := GetProcAddress('glIsEnabledi');
  Pointer(glBeginTransformFeedback) := GetProcAddress('glBeginTransformFeedback');
  Pointer(glEndTransformFeedback) := GetProcAddress('glEndTransformFeedback');
  Pointer(glBindBufferRange) := GetProcAddress('glBindBufferRange');
  Pointer(glBindBufferBase) := GetProcAddress('glBindBufferBase');
  Pointer(glTransformFeedbackVaryings) := GetProcAddress('glTransformFeedbackVaryings');
  Pointer(glGetTransformFeedbackVarying) := GetProcAddress('glGetTransformFeedbackVarying');
  Pointer(glClampColor) := GetProcAddress('glClampColor');
  Pointer(glBeginConditionalRender) := GetProcAddress('glBeginConditionalRender');
  Pointer(glEndConditionalRender) := GetProcAddress('glEndConditionalRender');
  Pointer(glVertexAttribIPointer) := GetProcAddress('glVertexAttribIPointer');
  Pointer(glGetVertexAttribIiv) := GetProcAddress('glGetVertexAttribIiv');
  Pointer(glGetVertexAttribIuiv) := GetProcAddress('glGetVertexAttribIuiv');
  Pointer(glVertexAttribI1i) := GetProcAddress('glVertexAttribI1i');
  Pointer(glVertexAttribI2i) := GetProcAddress('glVertexAttribI2i');
  Pointer(glVertexAttribI3i) := GetProcAddress('glVertexAttribI3i');
  Pointer(glVertexAttribI4i) := GetProcAddress('glVertexAttribI4i');
  Pointer(glVertexAttribI1ui) := GetProcAddress('glVertexAttribI1ui');
  Pointer(glVertexAttribI2ui) := GetProcAddress('glVertexAttribI2ui');
  Pointer(glVertexAttribI3ui) := GetProcAddress('glVertexAttribI3ui');
  Pointer(glVertexAttribI4ui) := GetProcAddress('glVertexAttribI4ui');
  Pointer(glVertexAttribI1iv) := GetProcAddress('glVertexAttribI1iv');
  Pointer(glVertexAttribI2iv) := GetProcAddress('glVertexAttribI2iv');
  Pointer(glVertexAttribI3iv) := GetProcAddress('glVertexAttribI3iv');
  Pointer(glVertexAttribI4iv) := GetProcAddress('glVertexAttribI4iv');
  Pointer(glVertexAttribI1uiv) := GetProcAddress('glVertexAttribI1uiv');
  Pointer(glVertexAttribI2uiv) := GetProcAddress('glVertexAttribI2uiv');
  Pointer(glVertexAttribI3uiv) := GetProcAddress('glVertexAttribI3uiv');
  Pointer(glVertexAttribI4uiv) := GetProcAddress('glVertexAttribI4uiv');
  Pointer(glVertexAttribI4bv) := GetProcAddress('glVertexAttribI4bv');
  Pointer(glVertexAttribI4sv) := GetProcAddress('glVertexAttribI4sv');
  Pointer(glVertexAttribI4ubv) := GetProcAddress('glVertexAttribI4ubv');
  Pointer(glVertexAttribI4usv) := GetProcAddress('glVertexAttribI4usv');
  Pointer(glGetUniformuiv) := GetProcAddress('glGetUniformuiv');
  Pointer(glBindFragDataLocation) := GetProcAddress('glBindFragDataLocation');
  Pointer(glGetFragDataLocation) := GetProcAddress('glGetFragDataLocation');
  Pointer(glUniform1ui) := GetProcAddress('glUniform1ui');
  Pointer(glUniform2ui) := GetProcAddress('glUniform2ui');
  Pointer(glUniform3ui) := GetProcAddress('glUniform3ui');
  Pointer(glUniform4ui) := GetProcAddress('glUniform4ui');
  Pointer(glUniform1uiv) := GetProcAddress('glUniform1uiv');
  Pointer(glUniform2uiv) := GetProcAddress('glUniform2uiv');
  Pointer(glUniform3uiv) := GetProcAddress('glUniform3uiv');
  Pointer(glUniform4uiv) := GetProcAddress('glUniform4uiv');
  Pointer(glTexParameterIiv) := GetProcAddress('glTexParameterIiv');
  Pointer(glTexParameterIuiv) := GetProcAddress('glTexParameterIuiv');
  Pointer(glGetTexParameterIiv) := GetProcAddress('glGetTexParameterIiv');
  Pointer(glGetTexParameterIuiv) := GetProcAddress('glGetTexParameterIuiv');
  Pointer(glClearBufferiv) := GetProcAddress('glClearBufferiv');
  Pointer(glClearBufferuiv) := GetProcAddress('glClearBufferuiv');
  Pointer(glClearBufferfv) := GetProcAddress('glClearBufferfv');
  Pointer(glClearBufferfi) := GetProcAddress('glClearBufferfi');
  Pointer(glGetStringi) := GetProcAddress('glGetStringi');
  Pointer(glIsRenderbuffer) := GetProcAddress('glIsRenderbuffer');
  Pointer(glBindRenderbuffer) := GetProcAddress('glBindRenderbuffer');
  Pointer(glDeleteRenderbuffers) := GetProcAddress('glDeleteRenderbuffers');
  Pointer(glGenRenderbuffers) := GetProcAddress('glGenRenderbuffers');
  Pointer(glRenderbufferStorage) := GetProcAddress('glRenderbufferStorage');
  Pointer(glGetRenderbufferParameteriv) := GetProcAddress('glGetRenderbufferParameteriv');
  Pointer(glIsFramebuffer) := GetProcAddress('glIsFramebuffer');
  Pointer(glBindFramebuffer) := GetProcAddress('glBindFramebuffer');
  Pointer(glDeleteFramebuffers) := GetProcAddress('glDeleteFramebuffers');
  Pointer(glGenFramebuffers) := GetProcAddress('glGenFramebuffers');
  Pointer(glCheckFramebufferStatus) := GetProcAddress('glCheckFramebufferStatus');
  Pointer(glFramebufferTexture1D) := GetProcAddress('glFramebufferTexture1D');
  Pointer(glFramebufferTexture2D) := GetProcAddress('glFramebufferTexture2D');
  Pointer(glFramebufferTexture3D) := GetProcAddress('glFramebufferTexture3D');
  Pointer(glFramebufferRenderbuffer) := GetProcAddress('glFramebufferRenderbuffer');
  Pointer(glGetFramebufferAttachmentParameteriv) := GetProcAddress('glGetFramebufferAttachmentParameteriv');
  Pointer(glGenerateMipmap) := GetProcAddress('glGenerateMipmap');
  Pointer(glBlitFramebuffer) := GetProcAddress('glBlitFramebuffer');
  Pointer(glRenderbufferStorageMultisample) := GetProcAddress('glRenderbufferStorageMultisample');
  Pointer(glFramebufferTextureLayer) := GetProcAddress('glFramebufferTextureLayer');
  Pointer(glMapBufferRange) := GetProcAddress('glMapBufferRange');
  Pointer(glFlushMappedBufferRange) := GetProcAddress('glFlushMappedBufferRange');
  Pointer(glBindVertexArray) := GetProcAddress('glBindVertexArray');
  Pointer(glDeleteVertexArrays) := GetProcAddress('glDeleteVertexArrays');
  Pointer(glGenVertexArrays) := GetProcAddress('glGenVertexArrays');
  Pointer(glIsVertexArray) := GetProcAddress('glIsVertexArray');
end;

{=============================================================================
  OpenGL 3.1
=============================================================================}

procedure LoadVersion3_1;
begin
  Pointer(glDrawArraysInstanced) := GetProcAddress('glDrawArraysInstanced');
  Pointer(glDrawElementsInstanced) := GetProcAddress('glDrawElementsInstanced');
  Pointer(glTexBuffer) := GetProcAddress('glTexBuffer');
  Pointer(glPrimitiveRestartIndex) := GetProcAddress('glPrimitiveRestartIndex');
  Pointer(glCopyBufferSubData) := GetProcAddress('glCopyBufferSubData');
  Pointer(glGetUniformIndices) := GetProcAddress('glGetUniformIndices');
  Pointer(glGetActiveUniformsiv) := GetProcAddress('glGetActiveUniformsiv');
  Pointer(glGetActiveUniformName) := GetProcAddress('glGetActiveUniformName');
  Pointer(glGetUniformBlockIndex) := GetProcAddress('glGetUniformBlockIndex');
  Pointer(glGetActiveUniformBlockiv) := GetProcAddress('glGetActiveUniformBlockiv');
  Pointer(glGetActiveUniformBlockName) := GetProcAddress('glGetActiveUniformBlockName');
  Pointer(glUniformBlockBinding) := GetProcAddress('glUniformBlockBinding');
end;

{=============================================================================
  OpenGL 3.2
=============================================================================}

procedure LoadVersion3_2;
begin
  Pointer(glDrawElementsBaseVertex) := GetProcAddress('glDrawElementsBaseVertex');
  Pointer(glDrawRangeElementsBaseVertex) := GetProcAddress('glDrawRangeElementsBaseVertex');
  Pointer(glDrawElementsInstancedBaseVertex) := GetProcAddress('glDrawElementsInstancedBaseVertex');
  Pointer(glMultiDrawElementsBaseVertex) := GetProcAddress('glMultiDrawElementsBaseVertex');
  Pointer(glProvokingVertex) := GetProcAddress('glProvokingVertex');
  Pointer(glFenceSync) := GetProcAddress('glFenceSync');
  Pointer(glIsSync) := GetProcAddress('glIsSync');
  Pointer(glDeleteSync) := GetProcAddress('glDeleteSync');
  Pointer(glClientWaitSync) := GetProcAddress('glClientWaitSync');
  Pointer(glWaitSync) := GetProcAddress('glWaitSync');
  Pointer(glGetInteger64v) := GetProcAddress('glGetInteger64v');
  Pointer(glGetSynciv) := GetProcAddress('glGetSynciv');
  Pointer(glGetInteger64i_v) := GetProcAddress('glGetInteger64i_v');
  Pointer(glGetBufferParameteri64v) := GetProcAddress('glGetBufferParameteri64v');
  Pointer(glFramebufferTexture) := GetProcAddress('glFramebufferTexture');
  Pointer(glTexImage2DMultisample) := GetProcAddress('glTexImage2DMultisample');
  Pointer(glTexImage3DMultisample) := GetProcAddress('glTexImage3DMultisample');
  Pointer(glGetMultisamplefv) := GetProcAddress('glGetMultisamplefv');
  Pointer(glSampleMaski) := GetProcAddress('glSampleMaski');
end;

{=============================================================================
  OpenGL 3.3
=============================================================================}

procedure LoadVersion3_3;
begin
  Pointer(glBindFragDataLocationIndexed) := GetProcAddress('glBindFragDataLocationIndexed');
  Pointer(glGetFragDataIndex) := GetProcAddress('glGetFragDataIndex');
  Pointer(glGenSamplers) := GetProcAddress('glGenSamplers');
  Pointer(glDeleteSamplers) := GetProcAddress('glDeleteSamplers');
  Pointer(glIsSampler) := GetProcAddress('glIsSampler');
  Pointer(glBindSampler) := GetProcAddress('glBindSampler');
  Pointer(glSamplerParameteri) := GetProcAddress('glSamplerParameteri');
  Pointer(glSamplerParameteriv) := GetProcAddress('glSamplerParameteriv');
  Pointer(glSamplerParameterf) := GetProcAddress('glSamplerParameterf');
  Pointer(glSamplerParameterfv) := GetProcAddress('glSamplerParameterfv');
  Pointer(glSamplerParameterIiv) := GetProcAddress('glSamplerParameterIiv');
  Pointer(glSamplerParameterIuiv) := GetProcAddress('glSamplerParameterIuiv');
  Pointer(glGetSamplerParameteriv) := GetProcAddress('glGetSamplerParameteriv');
  Pointer(glGetSamplerParameterIiv) := GetProcAddress('glGetSamplerParameterIiv');
  Pointer(glGetSamplerParameterfv) := GetProcAddress('glGetSamplerParameterfv');
  Pointer(glGetSamplerParameterIuiv) := GetProcAddress('glGetSamplerParameterIuiv');
  Pointer(glQueryCounter) := GetProcAddress('glQueryCounter');
  Pointer(glGetQueryObjecti64v) := GetProcAddress('glGetQueryObjecti64v');
  Pointer(glGetQueryObjectui64v) := GetProcAddress('glGetQueryObjectui64v');
  Pointer(glVertexAttribDivisor) := GetProcAddress('glVertexAttribDivisor');
  Pointer(glVertexAttribP1ui) := GetProcAddress('glVertexAttribP1ui');
  Pointer(glVertexAttribP1uiv) := GetProcAddress('glVertexAttribP1uiv');
  Pointer(glVertexAttribP2ui) := GetProcAddress('glVertexAttribP2ui');
  Pointer(glVertexAttribP2uiv) := GetProcAddress('glVertexAttribP2uiv');
  Pointer(glVertexAttribP3ui) := GetProcAddress('glVertexAttribP3ui');
  Pointer(glVertexAttribP3uiv) := GetProcAddress('glVertexAttribP3uiv');
  Pointer(glVertexAttribP4ui) := GetProcAddress('glVertexAttribP4ui');
  Pointer(glVertexAttribP4uiv) := GetProcAddress('glVertexAttribP4uiv');
  Pointer(glVertexP2ui) := GetProcAddress('glVertexP2ui');
  Pointer(glVertexP2uiv) := GetProcAddress('glVertexP2uiv');
  Pointer(glVertexP3ui) := GetProcAddress('glVertexP3ui');
  Pointer(glVertexP3uiv) := GetProcAddress('glVertexP3uiv');
  Pointer(glVertexP4ui) := GetProcAddress('glVertexP4ui');
  Pointer(glVertexP4uiv) := GetProcAddress('glVertexP4uiv');
  Pointer(glTexCoordP1ui) := GetProcAddress('glTexCoordP1ui');
  Pointer(glTexCoordP1uiv) := GetProcAddress('glTexCoordP1uiv');
  Pointer(glTexCoordP2ui) := GetProcAddress('glTexCoordP2ui');
  Pointer(glTexCoordP2uiv) := GetProcAddress('glTexCoordP2uiv');
  Pointer(glTexCoordP3ui) := GetProcAddress('glTexCoordP3ui');
  Pointer(glTexCoordP3uiv) := GetProcAddress('glTexCoordP3uiv');
  Pointer(glTexCoordP4ui) := GetProcAddress('glTexCoordP4ui');
  Pointer(glTexCoordP4uiv) := GetProcAddress('glTexCoordP4uiv');
  Pointer(glMultiTexCoordP1ui) := GetProcAddress('glMultiTexCoordP1ui');
  Pointer(glMultiTexCoordP1uiv) := GetProcAddress('glMultiTexCoordP1uiv');
  Pointer(glMultiTexCoordP2ui) := GetProcAddress('glMultiTexCoordP2ui');
  Pointer(glMultiTexCoordP2uiv) := GetProcAddress('glMultiTexCoordP2uiv');
  Pointer(glMultiTexCoordP3ui) := GetProcAddress('glMultiTexCoordP3ui');
  Pointer(glMultiTexCoordP3uiv) := GetProcAddress('glMultiTexCoordP3uiv');
  Pointer(glMultiTexCoordP4ui) := GetProcAddress('glMultiTexCoordP4ui');
  Pointer(glMultiTexCoordP4uiv) := GetProcAddress('glMultiTexCoordP4uiv');
  Pointer(glNormalP3ui) := GetProcAddress('glNormalP3ui');
  Pointer(glNormalP3uiv) := GetProcAddress('glNormalP3uiv');
  Pointer(glColorP3ui) := GetProcAddress('glColorP3ui');
  Pointer(glColorP3uiv) := GetProcAddress('glColorP3uiv');
  Pointer(glColorP4ui) := GetProcAddress('glColorP4ui');
  Pointer(glColorP4uiv) := GetProcAddress('glColorP4uiv');
  Pointer(glSecondaryColorP3ui) := GetProcAddress('glSecondaryColorP3ui');
  Pointer(glSecondaryColorP3uiv) := GetProcAddress('glSecondaryColorP3uiv');
end;

{=============================================================================
  OpenGL 4.0
=============================================================================}

procedure LoadVersion4_0;
begin
  Pointer(glMinSampleShading) := GetProcAddress('glMinSampleShading');
  Pointer(glBlendEquationi) := GetProcAddress('glBlendEquationi');
  Pointer(glBlendEquationSeparatei) := GetProcAddress('glBlendEquationSeparatei');
  Pointer(glBlendFunci) := GetProcAddress('glBlendFunci');
  Pointer(glBlendFuncSeparatei) := GetProcAddress('glBlendFuncSeparatei');
  Pointer(glDrawArraysIndirect) := GetProcAddress('glDrawArraysIndirect');
  Pointer(glDrawElementsIndirect) := GetProcAddress('glDrawElementsIndirect');
  Pointer(glUniform1d) := GetProcAddress('glUniform1d');
  Pointer(glUniform2d) := GetProcAddress('glUniform2d');
  Pointer(glUniform3d) := GetProcAddress('glUniform3d');
  Pointer(glUniform4d) := GetProcAddress('glUniform4d');
  Pointer(glUniform1dv) := GetProcAddress('glUniform1dv');
  Pointer(glUniform2dv) := GetProcAddress('glUniform2dv');
  Pointer(glUniform3dv) := GetProcAddress('glUniform3dv');
  Pointer(glUniform4dv) := GetProcAddress('glUniform4dv');
  Pointer(glUniformMatrix2dv) := GetProcAddress('glUniformMatrix2dv');
  Pointer(glUniformMatrix3dv) := GetProcAddress('glUniformMatrix3dv');
  Pointer(glUniformMatrix4dv) := GetProcAddress('glUniformMatrix4dv');
  Pointer(glUniformMatrix2x3dv) := GetProcAddress('glUniformMatrix2x3dv');
  Pointer(glUniformMatrix2x4dv) := GetProcAddress('glUniformMatrix2x4dv');
  Pointer(glUniformMatrix3x2dv) := GetProcAddress('glUniformMatrix3x2dv');
  Pointer(glUniformMatrix3x4dv) := GetProcAddress('glUniformMatrix3x4dv');
  Pointer(glUniformMatrix4x2dv) := GetProcAddress('glUniformMatrix4x2dv');
  Pointer(glUniformMatrix4x3dv) := GetProcAddress('glUniformMatrix4x3dv');
  Pointer(glGetUniformdv) := GetProcAddress('glGetUniformdv');
  Pointer(glGetSubroutineUniformLocation) := GetProcAddress('glGetSubroutineUniformLocation');
  Pointer(glGetSubroutineIndex) := GetProcAddress('glGetSubroutineIndex');
  Pointer(glGetActiveSubroutineUniformiv) := GetProcAddress('glGetActiveSubroutineUniformiv');
  Pointer(glGetActiveSubroutineUniformName) := GetProcAddress('glGetActiveSubroutineUniformName');
  Pointer(glGetActiveSubroutineName) := GetProcAddress('glGetActiveSubroutineName');
  Pointer(glUniformSubroutinesuiv) := GetProcAddress('glUniformSubroutinesuiv');
  Pointer(glGetUniformSubroutineuiv) := GetProcAddress('glGetUniformSubroutineuiv');
  Pointer(glGetProgramStageiv) := GetProcAddress('glGetProgramStageiv');
  Pointer(glPatchParameteri) := GetProcAddress('glPatchParameteri');
  Pointer(glPatchParameterfv) := GetProcAddress('glPatchParameterfv');
  Pointer(glBindTransformFeedback) := GetProcAddress('glBindTransformFeedback');
  Pointer(glDeleteTransformFeedbacks) := GetProcAddress('glDeleteTransformFeedbacks');
  Pointer(glGenTransformFeedbacks) := GetProcAddress('glGenTransformFeedbacks');
  Pointer(glIsTransformFeedback) := GetProcAddress('glIsTransformFeedback');
  Pointer(glPauseTransformFeedback) := GetProcAddress('glPauseTransformFeedback');
  Pointer(glResumeTransformFeedback) := GetProcAddress('glResumeTransformFeedback');
  Pointer(glDrawTransformFeedback) := GetProcAddress('glDrawTransformFeedback');
  Pointer(glDrawTransformFeedbackStream) := GetProcAddress('glDrawTransformFeedbackStream');
  Pointer(glBeginQueryIndexed) := GetProcAddress('glBeginQueryIndexed');
  Pointer(glEndQueryIndexed) := GetProcAddress('glEndQueryIndexed');
  Pointer(glGetQueryIndexediv) := GetProcAddress('glGetQueryIndexediv');
end;

{=============================================================================
  OpenGL 4.1
=============================================================================}

procedure LoadVersion4_1;
begin
  Pointer(glReleaseShaderCompiler) := GetProcAddress('glReleaseShaderCompiler');
  Pointer(glShaderBinary) := GetProcAddress('glShaderBinary');
  Pointer(glGetShaderPrecisionFormat) := GetProcAddress('glGetShaderPrecisionFormat');
  Pointer(glDepthRangef) := GetProcAddress('glDepthRangef');
  Pointer(glClearDepthf) := GetProcAddress('glClearDepthf');
  Pointer(glGetProgramBinary) := GetProcAddress('glGetProgramBinary');
  Pointer(glProgramBinary) := GetProcAddress('glProgramBinary');
  Pointer(glProgramParameteri) := GetProcAddress('glProgramParameteri');
  Pointer(glUseProgramStages) := GetProcAddress('glUseProgramStages');
  Pointer(glActiveShaderProgram) := GetProcAddress('glActiveShaderProgram');
  Pointer(glCreateShaderProgramv) := GetProcAddress('glCreateShaderProgramv');
  Pointer(glBindProgramPipeline) := GetProcAddress('glBindProgramPipeline');
  Pointer(glDeleteProgramPipelines) := GetProcAddress('glDeleteProgramPipelines');
  Pointer(glGenProgramPipelines) := GetProcAddress('glGenProgramPipelines');
  Pointer(glIsProgramPipeline) := GetProcAddress('glIsProgramPipeline');
  Pointer(glGetProgramPipelineiv) := GetProcAddress('glGetProgramPipelineiv');
  Pointer(glProgramUniform1i) := GetProcAddress('glProgramUniform1i');
  Pointer(glProgramUniform1iv) := GetProcAddress('glProgramUniform1iv');
  Pointer(glProgramUniform1f) := GetProcAddress('glProgramUniform1f');
  Pointer(glProgramUniform1fv) := GetProcAddress('glProgramUniform1fv');
  Pointer(glProgramUniform1d) := GetProcAddress('glProgramUniform1d');
  Pointer(glProgramUniform1dv) := GetProcAddress('glProgramUniform1dv');
  Pointer(glProgramUniform1ui) := GetProcAddress('glProgramUniform1ui');
  Pointer(glProgramUniform1uiv) := GetProcAddress('glProgramUniform1uiv');
  Pointer(glProgramUniform2i) := GetProcAddress('glProgramUniform2i');
  Pointer(glProgramUniform2iv) := GetProcAddress('glProgramUniform2iv');
  Pointer(glProgramUniform2f) := GetProcAddress('glProgramUniform2f');
  Pointer(glProgramUniform2fv) := GetProcAddress('glProgramUniform2fv');
  Pointer(glProgramUniform2d) := GetProcAddress('glProgramUniform2d');
  Pointer(glProgramUniform2dv) := GetProcAddress('glProgramUniform2dv');
  Pointer(glProgramUniform2ui) := GetProcAddress('glProgramUniform2ui');
  Pointer(glProgramUniform2uiv) := GetProcAddress('glProgramUniform2uiv');
  Pointer(glProgramUniform3i) := GetProcAddress('glProgramUniform3i');
  Pointer(glProgramUniform3iv) := GetProcAddress('glProgramUniform3iv');
  Pointer(glProgramUniform3f) := GetProcAddress('glProgramUniform3f');
  Pointer(glProgramUniform3fv) := GetProcAddress('glProgramUniform3fv');
  Pointer(glProgramUniform3d) := GetProcAddress('glProgramUniform3d');
  Pointer(glProgramUniform3dv) := GetProcAddress('glProgramUniform3dv');
  Pointer(glProgramUniform3ui) := GetProcAddress('glProgramUniform3ui');
  Pointer(glProgramUniform3uiv) := GetProcAddress('glProgramUniform3uiv');
  Pointer(glProgramUniform4i) := GetProcAddress('glProgramUniform4i');
  Pointer(glProgramUniform4iv) := GetProcAddress('glProgramUniform4iv');
  Pointer(glProgramUniform4f) := GetProcAddress('glProgramUniform4f');
  Pointer(glProgramUniform4fv) := GetProcAddress('glProgramUniform4fv');
  Pointer(glProgramUniform4d) := GetProcAddress('glProgramUniform4d');
  Pointer(glProgramUniform4dv) := GetProcAddress('glProgramUniform4dv');
  Pointer(glProgramUniform4ui) := GetProcAddress('glProgramUniform4ui');
  Pointer(glProgramUniform4uiv) := GetProcAddress('glProgramUniform4uiv');
  Pointer(glProgramUniformMatrix2fv) := GetProcAddress('glProgramUniformMatrix2fv');
  Pointer(glProgramUniformMatrix3fv) := GetProcAddress('glProgramUniformMatrix3fv');
  Pointer(glProgramUniformMatrix4fv) := GetProcAddress('glProgramUniformMatrix4fv');
  Pointer(glProgramUniformMatrix2dv) := GetProcAddress('glProgramUniformMatrix2dv');
  Pointer(glProgramUniformMatrix3dv) := GetProcAddress('glProgramUniformMatrix3dv');
  Pointer(glProgramUniformMatrix4dv) := GetProcAddress('glProgramUniformMatrix4dv');
  Pointer(glProgramUniformMatrix2x3fv) := GetProcAddress('glProgramUniformMatrix2x3fv');
  Pointer(glProgramUniformMatrix3x2fv) := GetProcAddress('glProgramUniformMatrix3x2fv');
  Pointer(glProgramUniformMatrix2x4fv) := GetProcAddress('glProgramUniformMatrix2x4fv');
  Pointer(glProgramUniformMatrix4x2fv) := GetProcAddress('glProgramUniformMatrix4x2fv');
  Pointer(glProgramUniformMatrix3x4fv) := GetProcAddress('glProgramUniformMatrix3x4fv');
  Pointer(glProgramUniformMatrix4x3fv) := GetProcAddress('glProgramUniformMatrix4x3fv');
  Pointer(glProgramUniformMatrix2x3dv) := GetProcAddress('glProgramUniformMatrix2x3dv');
  Pointer(glProgramUniformMatrix3x2dv) := GetProcAddress('glProgramUniformMatrix3x2dv');
  Pointer(glProgramUniformMatrix2x4dv) := GetProcAddress('glProgramUniformMatrix2x4dv');
  Pointer(glProgramUniformMatrix4x2dv) := GetProcAddress('glProgramUniformMatrix4x2dv');
  Pointer(glProgramUniformMatrix3x4dv) := GetProcAddress('glProgramUniformMatrix3x4dv');
  Pointer(glProgramUniformMatrix4x3dv) := GetProcAddress('glProgramUniformMatrix4x3dv');
  Pointer(glValidateProgramPipeline) := GetProcAddress('glValidateProgramPipeline');
  Pointer(glGetProgramPipelineInfoLog) := GetProcAddress('glGetProgramPipelineInfoLog');
  Pointer(glVertexAttribL1d) := GetProcAddress('glVertexAttribL1d');
  Pointer(glVertexAttribL2d) := GetProcAddress('glVertexAttribL2d');
  Pointer(glVertexAttribL3d) := GetProcAddress('glVertexAttribL3d');
  Pointer(glVertexAttribL4d) := GetProcAddress('glVertexAttribL4d');
  Pointer(glVertexAttribL1dv) := GetProcAddress('glVertexAttribL1dv');
  Pointer(glVertexAttribL2dv) := GetProcAddress('glVertexAttribL2dv');
  Pointer(glVertexAttribL3dv) := GetProcAddress('glVertexAttribL3dv');
  Pointer(glVertexAttribL4dv) := GetProcAddress('glVertexAttribL4dv');
  Pointer(glVertexAttribLPointer) := GetProcAddress('glVertexAttribLPointer');
  Pointer(glGetVertexAttribLdv) := GetProcAddress('glGetVertexAttribLdv');
  Pointer(glViewportArrayv) := GetProcAddress('glViewportArrayv');
  Pointer(glViewportIndexedf) := GetProcAddress('glViewportIndexedf');
  Pointer(glViewportIndexedfv) := GetProcAddress('glViewportIndexedfv');
  Pointer(glScissorArrayv) := GetProcAddress('glScissorArrayv');
  Pointer(glScissorIndexed) := GetProcAddress('glScissorIndexed');
  Pointer(glScissorIndexedv) := GetProcAddress('glScissorIndexedv');
  Pointer(glDepthRangeArrayv) := GetProcAddress('glDepthRangeArrayv');
  Pointer(glDepthRangeIndexed) := GetProcAddress('glDepthRangeIndexed');
  Pointer(glGetFloati_v) := GetProcAddress('glGetFloati_v');
  Pointer(glGetDoublei_v) := GetProcAddress('glGetDoublei_v');
end;

{=============================================================================
  OpenGL 4.2
=============================================================================}

procedure LoadVersion4_2;
begin
  Pointer(glDrawArraysInstancedBaseInstance) := GetProcAddress('glDrawArraysInstancedBaseInstance');
  Pointer(glDrawElementsInstancedBaseInstance) := GetProcAddress('glDrawElementsInstancedBaseInstance');
  Pointer(glDrawElementsInstancedBaseVertexBaseInstance) := GetProcAddress('glDrawElementsInstancedBaseVertexBaseInstance');
  Pointer(glGetInternalformativ) := GetProcAddress('glGetInternalformativ');
  Pointer(glGetActiveAtomicCounterBufferiv) := GetProcAddress('glGetActiveAtomicCounterBufferiv');
  Pointer(glBindImageTexture) := GetProcAddress('glBindImageTexture');
  Pointer(glMemoryBarrier) := GetProcAddress('glMemoryBarrier');
  Pointer(glTexStorage1D) := GetProcAddress('glTexStorage1D');
  Pointer(glTexStorage2D) := GetProcAddress('glTexStorage2D');
  Pointer(glTexStorage3D) := GetProcAddress('glTexStorage3D');
  Pointer(glDrawTransformFeedbackInstanced) := GetProcAddress('glDrawTransformFeedbackInstanced');
  Pointer(glDrawTransformFeedbackStreamInstanced) := GetProcAddress('glDrawTransformFeedbackStreamInstanced');
end;

{=============================================================================
  OpenGL 4.3
=============================================================================}

procedure LoadVersion4_3;
begin
  Pointer(glClearBufferData) := GetProcAddress('glClearBufferData');
  Pointer(glClearBufferSubData) := GetProcAddress('glClearBufferSubData');
  Pointer(glDispatchCompute) := GetProcAddress('glDispatchCompute');
  Pointer(glDispatchComputeIndirect) := GetProcAddress('glDispatchComputeIndirect');
  Pointer(glCopyImageSubData) := GetProcAddress('glCopyImageSubData');
  Pointer(glFramebufferParameteri) := GetProcAddress('glFramebufferParameteri');
  Pointer(glGetFramebufferParameteriv) := GetProcAddress('glGetFramebufferParameteriv');
  Pointer(glGetInternalformati64v) := GetProcAddress('glGetInternalformati64v');
  Pointer(glInvalidateTexSubImage) := GetProcAddress('glInvalidateTexSubImage');
  Pointer(glInvalidateTexImage) := GetProcAddress('glInvalidateTexImage');
  Pointer(glInvalidateBufferSubData) := GetProcAddress('glInvalidateBufferSubData');
  Pointer(glInvalidateBufferData) := GetProcAddress('glInvalidateBufferData');
  Pointer(glInvalidateFramebuffer) := GetProcAddress('glInvalidateFramebuffer');
  Pointer(glInvalidateSubFramebuffer) := GetProcAddress('glInvalidateSubFramebuffer');
  Pointer(glMultiDrawArraysIndirect) := GetProcAddress('glMultiDrawArraysIndirect');
  Pointer(glMultiDrawElementsIndirect) := GetProcAddress('glMultiDrawElementsIndirect');
  Pointer(glGetProgramInterfaceiv) := GetProcAddress('glGetProgramInterfaceiv');
  Pointer(glGetProgramResourceIndex) := GetProcAddress('glGetProgramResourceIndex');
  Pointer(glGetProgramResourceName) := GetProcAddress('glGetProgramResourceName');
  Pointer(glGetProgramResourceiv) := GetProcAddress('glGetProgramResourceiv');
  Pointer(glGetProgramResourceLocation) := GetProcAddress('glGetProgramResourceLocation');
  Pointer(glGetProgramResourceLocationIndex) := GetProcAddress('glGetProgramResourceLocationIndex');
  Pointer(glShaderStorageBlockBinding) := GetProcAddress('glShaderStorageBlockBinding');
  Pointer(glTexBufferRange) := GetProcAddress('glTexBufferRange');
  Pointer(glTexStorage2DMultisample) := GetProcAddress('glTexStorage2DMultisample');
  Pointer(glTexStorage3DMultisample) := GetProcAddress('glTexStorage3DMultisample');
  Pointer(glTextureView) := GetProcAddress('glTextureView');
  Pointer(glBindVertexBuffer) := GetProcAddress('glBindVertexBuffer');
  Pointer(glVertexAttribFormat) := GetProcAddress('glVertexAttribFormat');
  Pointer(glVertexAttribIFormat) := GetProcAddress('glVertexAttribIFormat');
  Pointer(glVertexAttribLFormat) := GetProcAddress('glVertexAttribLFormat');
  Pointer(glVertexAttribBinding) := GetProcAddress('glVertexAttribBinding');
  Pointer(glVertexBindingDivisor) := GetProcAddress('glVertexBindingDivisor');
  Pointer(glDebugMessageControl) := GetProcAddress('glDebugMessageControl');
  Pointer(glDebugMessageInsert) := GetProcAddress('glDebugMessageInsert');
  Pointer(glDebugMessageCallback) := GetProcAddress('glDebugMessageCallback');
  Pointer(glGetDebugMessageLog) := GetProcAddress('glGetDebugMessageLog');
  Pointer(glPushDebugGroup) := GetProcAddress('glPushDebugGroup');
  Pointer(glPopDebugGroup) := GetProcAddress('glPopDebugGroup');
  Pointer(glObjectLabel) := GetProcAddress('glObjectLabel');
  Pointer(glGetObjectLabel) := GetProcAddress('glGetObjectLabel');
  Pointer(glObjectPtrLabel) := GetProcAddress('glObjectPtrLabel');
  Pointer(glGetObjectPtrLabel) := GetProcAddress('glGetObjectPtrLabel');
end;

{=============================================================================
  OpenGL 4.4
=============================================================================}

procedure LoadVersion4_4;
begin
  Pointer(glBufferStorage) := GetProcAddress('glBufferStorage');
  Pointer(glClearTexImage) := GetProcAddress('glClearTexImage');
  Pointer(glClearTexSubImage) := GetProcAddress('glClearTexSubImage');
  Pointer(glBindBuffersBase) := GetProcAddress('glBindBuffersBase');
  Pointer(glBindBuffersRange) := GetProcAddress('glBindBuffersRange');
  Pointer(glBindTextures) := GetProcAddress('glBindTextures');
  Pointer(glBindSamplers) := GetProcAddress('glBindSamplers');
  Pointer(glBindImageTextures) := GetProcAddress('glBindImageTextures');
  Pointer(glBindVertexBuffers) := GetProcAddress('glBindVertexBuffers');
end;

{=============================================================================
  OpenGL 4.5
=============================================================================}

procedure LoadVersion4_5;
begin
  Pointer(glClipControl) := GetProcAddress('glClipControl');
  Pointer(glCreateTransformFeedbacks) := GetProcAddress('glCreateTransformFeedbacks');
  Pointer(glTransformFeedbackBufferBase) := GetProcAddress('glTransformFeedbackBufferBase');
  Pointer(glTransformFeedbackBufferRange) := GetProcAddress('glTransformFeedbackBufferRange');
  Pointer(glGetTransformFeedbackiv) := GetProcAddress('glGetTransformFeedbackiv');
  Pointer(glGetTransformFeedbacki_v) := GetProcAddress('glGetTransformFeedbacki_v');
  Pointer(glGetTransformFeedbacki64_v) := GetProcAddress('glGetTransformFeedbacki64_v');
  Pointer(glCreateBuffers) := GetProcAddress('glCreateBuffers');
  Pointer(glNamedBufferStorage) := GetProcAddress('glNamedBufferStorage');
  Pointer(glNamedBufferData) := GetProcAddress('glNamedBufferData');
  Pointer(glNamedBufferSubData) := GetProcAddress('glNamedBufferSubData');
  Pointer(glCopyNamedBufferSubData) := GetProcAddress('glCopyNamedBufferSubData');
  Pointer(glClearNamedBufferData) := GetProcAddress('glClearNamedBufferData');
  Pointer(glClearNamedBufferSubData) := GetProcAddress('glClearNamedBufferSubData');
  Pointer(glMapNamedBuffer) := GetProcAddress('glMapNamedBuffer');
  Pointer(glMapNamedBufferRange) := GetProcAddress('glMapNamedBufferRange');
  Pointer(glUnmapNamedBuffer) := GetProcAddress('glUnmapNamedBuffer');
  Pointer(glFlushMappedNamedBufferRange) := GetProcAddress('glFlushMappedNamedBufferRange');
  Pointer(glGetNamedBufferParameteriv) := GetProcAddress('glGetNamedBufferParameteriv');
  Pointer(glGetNamedBufferParameteri64v) := GetProcAddress('glGetNamedBufferParameteri64v');
  Pointer(glGetNamedBufferPointerv) := GetProcAddress('glGetNamedBufferPointerv');
  Pointer(glGetNamedBufferSubData) := GetProcAddress('glGetNamedBufferSubData');
  Pointer(glCreateFramebuffers) := GetProcAddress('glCreateFramebuffers');
  Pointer(glNamedFramebufferRenderbuffer) := GetProcAddress('glNamedFramebufferRenderbuffer');
  Pointer(glNamedFramebufferParameteri) := GetProcAddress('glNamedFramebufferParameteri');
  Pointer(glNamedFramebufferTexture) := GetProcAddress('glNamedFramebufferTexture');
  Pointer(glNamedFramebufferTextureLayer) := GetProcAddress('glNamedFramebufferTextureLayer');
  Pointer(glNamedFramebufferDrawBuffer) := GetProcAddress('glNamedFramebufferDrawBuffer');
  Pointer(glNamedFramebufferDrawBuffers) := GetProcAddress('glNamedFramebufferDrawBuffers');
  Pointer(glNamedFramebufferReadBuffer) := GetProcAddress('glNamedFramebufferReadBuffer');
  Pointer(glInvalidateNamedFramebufferData) := GetProcAddress('glInvalidateNamedFramebufferData');
  Pointer(glInvalidateNamedFramebufferSubData) := GetProcAddress('glInvalidateNamedFramebufferSubData');
  Pointer(glClearNamedFramebufferiv) := GetProcAddress('glClearNamedFramebufferiv');
  Pointer(glClearNamedFramebufferuiv) := GetProcAddress('glClearNamedFramebufferuiv');
  Pointer(glClearNamedFramebufferfv) := GetProcAddress('glClearNamedFramebufferfv');
  Pointer(glClearNamedFramebufferfi) := GetProcAddress('glClearNamedFramebufferfi');
  Pointer(glBlitNamedFramebuffer) := GetProcAddress('glBlitNamedFramebuffer');
  Pointer(glCheckNamedFramebufferStatus) := GetProcAddress('glCheckNamedFramebufferStatus');
  Pointer(glGetNamedFramebufferParameteriv) := GetProcAddress('glGetNamedFramebufferParameteriv');
  Pointer(glGetNamedFramebufferAttachmentParameteriv) := GetProcAddress('glGetNamedFramebufferAttachmentParameteriv');
  Pointer(glCreateRenderbuffers) := GetProcAddress('glCreateRenderbuffers');
  Pointer(glNamedRenderbufferStorage) := GetProcAddress('glNamedRenderbufferStorage');
  Pointer(glNamedRenderbufferStorageMultisample) := GetProcAddress('glNamedRenderbufferStorageMultisample');
  Pointer(glGetNamedRenderbufferParameteriv) := GetProcAddress('glGetNamedRenderbufferParameteriv');
  Pointer(glCreateTextures) := GetProcAddress('glCreateTextures');
  Pointer(glTextureBuffer) := GetProcAddress('glTextureBuffer');
  Pointer(glTextureBufferRange) := GetProcAddress('glTextureBufferRange');
  Pointer(glTextureStorage1D) := GetProcAddress('glTextureStorage1D');
  Pointer(glTextureStorage2D) := GetProcAddress('glTextureStorage2D');
  Pointer(glTextureStorage3D) := GetProcAddress('glTextureStorage3D');
  Pointer(glTextureStorage2DMultisample) := GetProcAddress('glTextureStorage2DMultisample');
  Pointer(glTextureStorage3DMultisample) := GetProcAddress('glTextureStorage3DMultisample');
  Pointer(glTextureSubImage1D) := GetProcAddress('glTextureSubImage1D');
  Pointer(glTextureSubImage2D) := GetProcAddress('glTextureSubImage2D');
  Pointer(glTextureSubImage3D) := GetProcAddress('glTextureSubImage3D');
  Pointer(glCompressedTextureSubImage1D) := GetProcAddress('glCompressedTextureSubImage1D');
  Pointer(glCompressedTextureSubImage2D) := GetProcAddress('glCompressedTextureSubImage2D');
  Pointer(glCompressedTextureSubImage3D) := GetProcAddress('glCompressedTextureSubImage3D');
  Pointer(glCopyTextureSubImage1D) := GetProcAddress('glCopyTextureSubImage1D');
  Pointer(glCopyTextureSubImage2D) := GetProcAddress('glCopyTextureSubImage2D');
  Pointer(glCopyTextureSubImage3D) := GetProcAddress('glCopyTextureSubImage3D');
  Pointer(glTextureParameterf) := GetProcAddress('glTextureParameterf');
  Pointer(glTextureParameterfv) := GetProcAddress('glTextureParameterfv');
  Pointer(glTextureParameteri) := GetProcAddress('glTextureParameteri');
  Pointer(glTextureParameterIiv) := GetProcAddress('glTextureParameterIiv');
  Pointer(glTextureParameterIuiv) := GetProcAddress('glTextureParameterIuiv');
  Pointer(glTextureParameteriv) := GetProcAddress('glTextureParameteriv');
  Pointer(glGenerateTextureMipmap) := GetProcAddress('glGenerateTextureMipmap');
  Pointer(glBindTextureUnit) := GetProcAddress('glBindTextureUnit');
  Pointer(glGetTextureImage) := GetProcAddress('glGetTextureImage');
  Pointer(glGetCompressedTextureImage) := GetProcAddress('glGetCompressedTextureImage');
  Pointer(glGetTextureLevelParameterfv) := GetProcAddress('glGetTextureLevelParameterfv');
  Pointer(glGetTextureLevelParameteriv) := GetProcAddress('glGetTextureLevelParameteriv');
  Pointer(glGetTextureParameterfv) := GetProcAddress('glGetTextureParameterfv');
  Pointer(glGetTextureParameterIiv) := GetProcAddress('glGetTextureParameterIiv');
  Pointer(glGetTextureParameterIuiv) := GetProcAddress('glGetTextureParameterIuiv');
  Pointer(glGetTextureParameteriv) := GetProcAddress('glGetTextureParameteriv');
  Pointer(glCreateVertexArrays) := GetProcAddress('glCreateVertexArrays');
  Pointer(glDisableVertexArrayAttrib) := GetProcAddress('glDisableVertexArrayAttrib');
  Pointer(glEnableVertexArrayAttrib) := GetProcAddress('glEnableVertexArrayAttrib');
  Pointer(glVertexArrayElementBuffer) := GetProcAddress('glVertexArrayElementBuffer');
  Pointer(glVertexArrayVertexBuffer) := GetProcAddress('glVertexArrayVertexBuffer');
  Pointer(glVertexArrayVertexBuffers) := GetProcAddress('glVertexArrayVertexBuffers');
  Pointer(glVertexArrayAttribBinding) := GetProcAddress('glVertexArrayAttribBinding');
  Pointer(glVertexArrayAttribFormat) := GetProcAddress('glVertexArrayAttribFormat');
  Pointer(glVertexArrayAttribIFormat) := GetProcAddress('glVertexArrayAttribIFormat');
  Pointer(glVertexArrayAttribLFormat) := GetProcAddress('glVertexArrayAttribLFormat');
  Pointer(glVertexArrayBindingDivisor) := GetProcAddress('glVertexArrayBindingDivisor');
  Pointer(glGetVertexArrayiv) := GetProcAddress('glGetVertexArrayiv');
  Pointer(glGetVertexArrayIndexediv) := GetProcAddress('glGetVertexArrayIndexediv');
  Pointer(glGetVertexArrayIndexed64iv) := GetProcAddress('glGetVertexArrayIndexed64iv');
  Pointer(glCreateSamplers) := GetProcAddress('glCreateSamplers');
  Pointer(glCreateProgramPipelines) := GetProcAddress('glCreateProgramPipelines');
  Pointer(glCreateQueries) := GetProcAddress('glCreateQueries');
  Pointer(glGetQueryBufferObjecti64v) := GetProcAddress('glGetQueryBufferObjecti64v');
  Pointer(glGetQueryBufferObjectiv) := GetProcAddress('glGetQueryBufferObjectiv');
  Pointer(glGetQueryBufferObjectui64v) := GetProcAddress('glGetQueryBufferObjectui64v');
  Pointer(glGetQueryBufferObjectuiv) := GetProcAddress('glGetQueryBufferObjectuiv');
  Pointer(glMemoryBarrierByRegion) := GetProcAddress('glMemoryBarrierByRegion');
  Pointer(glGetTextureSubImage) := GetProcAddress('glGetTextureSubImage');
  Pointer(glGetCompressedTextureSubImage) := GetProcAddress('glGetCompressedTextureSubImage');
  Pointer(glGetGraphicsResetStatus) := GetProcAddress('glGetGraphicsResetStatus');
  Pointer(glGetnCompressedTexImage) := GetProcAddress('glGetnCompressedTexImage');
  Pointer(glGetnTexImage) := GetProcAddress('glGetnTexImage');
  Pointer(glGetnUniformdv) := GetProcAddress('glGetnUniformdv');
  Pointer(glGetnUniformfv) := GetProcAddress('glGetnUniformfv');
  Pointer(glGetnUniformiv) := GetProcAddress('glGetnUniformiv');
  Pointer(glGetnUniformuiv) := GetProcAddress('glGetnUniformuiv');
  Pointer(glReadnPixels) := GetProcAddress('glReadnPixels');
  Pointer(glGetnMapdv) := GetProcAddress('glGetnMapdv');
  Pointer(glGetnMapfv) := GetProcAddress('glGetnMapfv');
  Pointer(glGetnMapiv) := GetProcAddress('glGetnMapiv');
  Pointer(glGetnPixelMapfv) := GetProcAddress('glGetnPixelMapfv');
  Pointer(glGetnPixelMapuiv) := GetProcAddress('glGetnPixelMapuiv');
  Pointer(glGetnPixelMapusv) := GetProcAddress('glGetnPixelMapusv');
  Pointer(glGetnPolygonStipple) := GetProcAddress('glGetnPolygonStipple');
  Pointer(glGetnColorTable) := GetProcAddress('glGetnColorTable');
  Pointer(glGetnConvolutionFilter) := GetProcAddress('glGetnConvolutionFilter');
  Pointer(glGetnSeparableFilter) := GetProcAddress('glGetnSeparableFilter');
  Pointer(glGetnHistogram) := GetProcAddress('glGetnHistogram');
  Pointer(glGetnMinmax) := GetProcAddress('glGetnMinmax');
  Pointer(glTextureBarrier) := GetProcAddress('glTextureBarrier');
end;

{=============================================================================
  OpenGL 4.6
=============================================================================}

procedure LoadVersion4_6;
begin
  Pointer(glSpecializeShader) := GetProcAddress('glSpecializeShader');
  Pointer(glMultiDrawArraysIndirectCount) := GetProcAddress('glMultiDrawArraysIndirectCount');
  Pointer(glMultiDrawElementsIndirectCount) := GetProcAddress('glMultiDrawElementsIndirectCount');
  Pointer(glPolygonOffsetClamp) := GetProcAddress('glPolygonOffsetClamp');
end;

end.