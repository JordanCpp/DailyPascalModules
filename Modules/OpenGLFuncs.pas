{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit OpenGLFuncs;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

interface

uses
  Windows,
  OpenGLTypes;

type
  // ==================== OpenGL 1.0 Functions ====================
  TglCullFace = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFrontFace = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglHint = procedure(target: GLenum; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLineWidth = procedure(width: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPointSize = procedure(size: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPolygonMode = procedure(face: GLenum; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScissor = procedure(x: GLint; y: GLint; width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameterf = procedure(target: GLenum; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameterfv = procedure(target: GLenum; pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameteri = procedure(target: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameteriv = procedure(target: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexImage1D = procedure(target: GLenum; level: GLint; internalformat: GLint; width: GLsizei;
                            border: GLint; format: GLenum; type_: GLenum; const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexImage2D = procedure(target: GLenum; level: GLint; internalformat: GLint; width: GLsizei;
                            height: GLsizei; border: GLint; format: GLenum; type_: GLenum;
                            const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawBuffer = procedure(buf: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClear = procedure(mask: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearColor = procedure(red: GLfloat; green: GLfloat; blue: GLfloat; alpha: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearStencil = procedure(s: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearDepth = procedure(depth: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilMask = procedure(mask: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorMask = procedure(red: GLboolean; green: GLboolean; blue: GLboolean; alpha: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthMask = procedure(flag: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDisable = procedure(cap: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnable = procedure(cap: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFinish = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFlush = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendFunc = procedure(sfactor: GLenum; dfactor: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLogicOp = procedure(opcode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilFunc = procedure(func: GLenum; ref: GLint; mask: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilOp = procedure(fail: GLenum; zfail: GLenum; zpass: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthFunc = procedure(func: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelStoref = procedure(pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelStorei = procedure(pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglReadBuffer = procedure(src: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglReadPixels = procedure(x: GLint; y: GLint; width: GLsizei; height: GLsizei;
                            format: GLenum; type_: GLenum; pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBooleanv = procedure(pname: GLenum; data: PGLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetDoublev = procedure(pname: GLenum; data: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetError = function: GLenum; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFloatv = procedure(pname: GLenum; data: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetIntegerv = procedure(pname: GLenum; data: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetString = function(name: GLenum): PGLubyte; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexImage = procedure(target: GLenum; level: GLint; format: GLenum; type_: GLenum;
                             pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexParameterfv = procedure(target: GLenum; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexParameteriv = procedure(target: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexLevelParameterfv = procedure(target: GLenum; level: GLint; pname: GLenum;
                                        params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexLevelParameteriv = procedure(target: GLenum; level: GLint; pname: GLenum;
                                        params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsEnabled = function(cap: GLenum): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthRange = procedure(n: GLdouble; f: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglViewport = procedure(x: GLint; y: GLint; width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNewList = procedure(list: GLuint; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEndList = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCallList = procedure(list: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCallLists = procedure(n: GLsizei; type_: GLenum; const lists: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteLists = procedure(list: GLuint; range: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenLists = function(range: GLsizei): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglListBase = procedure(base: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBegin = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBitmap = procedure(width: GLsizei; height: GLsizei; xorig: GLfloat; yorig: GLfloat;
                        xmove: GLfloat; ymove: GLfloat; const bitmap: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3b = procedure(red: GLbyte; green: GLbyte; blue: GLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3bv = procedure(const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3d = procedure(red: GLdouble; green: GLdouble; blue: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3f = procedure(red: GLfloat; green: GLfloat; blue: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3i = procedure(red: GLint; green: GLint; blue: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3s = procedure(red: GLshort; green: GLshort; blue: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3ub = procedure(red: GLubyte; green: GLubyte; blue: GLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3ubv = procedure(const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3ui = procedure(red: GLuint; green: GLuint; blue: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3uiv = procedure(const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3us = procedure(red: GLushort; green: GLushort; blue: GLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor3usv = procedure(const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4b = procedure(red: GLbyte; green: GLbyte; blue: GLbyte; alpha: GLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4bv = procedure(const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4d = procedure(red: GLdouble; green: GLdouble; blue: GLdouble; alpha: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4f = procedure(red: GLfloat; green: GLfloat; blue: GLfloat; alpha: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4i = procedure(red: GLint; green: GLint; blue: GLint; alpha: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4s = procedure(red: GLshort; green: GLshort; blue: GLshort; alpha: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4ub = procedure(red: GLubyte; green: GLubyte; blue: GLubyte; alpha: GLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4ubv = procedure(const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4ui = procedure(red: GLuint; green: GLuint; blue: GLuint; alpha: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4uiv = procedure(const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4us = procedure(red: GLushort; green: GLushort; blue: GLushort; alpha: GLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColor4usv = procedure(const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEdgeFlag = procedure(flag: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEdgeFlagv = procedure(const flag: PGLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnd = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexd = procedure(c: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexdv = procedure(const c: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexf = procedure(c: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexfv = procedure(const c: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexi = procedure(c: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexiv = procedure(const c: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexs = procedure(c: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexsv = procedure(const c: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3b = procedure(nx: GLbyte; ny: GLbyte; nz: GLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3bv = procedure(const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3d = procedure(nx: GLdouble; ny: GLdouble; nz: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3f = procedure(nx: GLfloat; ny: GLfloat; nz: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3i = procedure(nx: GLint; ny: GLint; nz: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3s = procedure(nx: GLshort; ny: GLshort; nz: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormal3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2d = procedure(x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2f = procedure(x: GLfloat; y: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2i = procedure(x: GLint; y: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2s = procedure(x: GLshort; y: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos2sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3d = procedure(x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3f = procedure(x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3i = procedure(x: GLint; y: GLint; z: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3s = procedure(x: GLshort; y: GLshort; z: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4d = procedure(x: GLdouble; y: GLdouble; z: GLdouble; w: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4f = procedure(x: GLfloat; y: GLfloat; z: GLfloat; w: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4i = procedure(x: GLint; y: GLint; z: GLint; w: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4s = procedure(x: GLshort; y: GLshort; z: GLshort; w: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRasterPos4sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectd = procedure(x1: GLdouble; y1: GLdouble; x2: GLdouble; y2: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectdv = procedure(const v1: PGLdouble; const v2: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectf = procedure(x1: GLfloat; y1: GLfloat; x2: GLfloat; y2: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectfv = procedure(const v1: PGLfloat; const v2: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRecti = procedure(x1: GLint; y1: GLint; x2: GLint; y2: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectiv = procedure(const v1: PGLint; const v2: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRects = procedure(x1: GLshort; y1: GLshort; x2: GLshort; y2: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRectsv = procedure(const v1: PGLshort; const v2: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1d = procedure(s: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1f = procedure(s: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1i = procedure(s: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1s = procedure(s: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord1sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2d = procedure(s: GLdouble; t: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2f = procedure(s: GLfloat; t: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2i = procedure(s: GLint; t: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2s = procedure(s: GLshort; t: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord2sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3d = procedure(s: GLdouble; t: GLdouble; r: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3f = procedure(s: GLfloat; t: GLfloat; r: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3i = procedure(s: GLint; t: GLint; r: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3s = procedure(s: GLshort; t: GLshort; r: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4d = procedure(s: GLdouble; t: GLdouble; r: GLdouble; q: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4f = procedure(s: GLfloat; t: GLfloat; r: GLfloat; q: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4i = procedure(s: GLint; t: GLint; r: GLint; q: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4s = procedure(s: GLshort; t: GLshort; r: GLshort; q: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoord4sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2d = procedure(x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2f = procedure(x: GLfloat; y: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2i = procedure(x: GLint; y: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2s = procedure(x: GLshort; y: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex2sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3d = procedure(x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3f = procedure(x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3i = procedure(x: GLint; y: GLint; z: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3s = procedure(x: GLshort; y: GLshort; z: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4d = procedure(x: GLdouble; y: GLdouble; z: GLdouble; w: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4f = procedure(x: GLfloat; y: GLfloat; z: GLfloat; w: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4i = procedure(x: GLint; y: GLint; z: GLint; w: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4s = procedure(x: GLshort; y: GLshort; z: GLshort; w: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertex4sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClipPlane = procedure(plane: GLenum; const equation: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorMaterial = procedure(face: GLenum; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogf = procedure(pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogfv = procedure(pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogi = procedure(pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogiv = procedure(pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightf = procedure(light: GLenum; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightfv = procedure(light: GLenum; pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLighti = procedure(light: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightiv = procedure(light: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightModelf = procedure(pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightModelfv = procedure(pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightModeli = procedure(pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLightModeliv = procedure(pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLineStipple = procedure(factor: GLint; pattern: GLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMaterialf = procedure(face: GLenum; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMaterialfv = procedure(face: GLenum; pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMateriali = procedure(face: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMaterialiv = procedure(face: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPolygonStipple = procedure(const mask: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglShadeModel = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexEnvf = procedure(target: GLenum; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexEnvfv = procedure(target: GLenum; pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexEnvi = procedure(target: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexEnviv = procedure(target: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGend = procedure(coord: GLenum; pname: GLenum; param: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGendv = procedure(coord: GLenum; pname: GLenum; const params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGenf = procedure(coord: GLenum; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGenfv = procedure(coord: GLenum; pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGeni = procedure(coord: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexGeniv = procedure(coord: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFeedbackBuffer = procedure(size: GLsizei; type_: GLenum; buffer: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSelectBuffer = procedure(size: GLsizei; buffer: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRenderMode = function(mode: GLenum): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInitNames = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadName = procedure(name: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPassThrough = procedure(token: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPopName = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPushName = procedure(name: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearAccum = procedure(red: GLfloat; green: GLfloat; blue: GLfloat; alpha: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearIndex = procedure(c: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexMask = procedure(mask: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglAccum = procedure(op: GLenum; value: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPopAttrib = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPushAttrib = procedure(mask: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMap1d = procedure(target: GLenum; u1: GLdouble; u2: GLdouble; stride: GLint; order: GLint;
                       const points: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMap1f = procedure(target: GLenum; u1: GLfloat; u2: GLfloat; stride: GLint; order: GLint;
                       const points: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMap2d = procedure(target: GLenum; u1: GLdouble; u2: GLdouble; ustride: GLint; uorder: GLint;
                       v1: GLdouble; v2: GLdouble; vstride: GLint; vorder: GLint;
                       const points: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMap2f = procedure(target: GLenum; u1: GLfloat; u2: GLfloat; ustride: GLint; uorder: GLint;
                       v1: GLfloat; v2: GLfloat; vstride: GLint; vorder: GLint;
                       const points: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapGrid1d = procedure(un: GLint; u1: GLdouble; u2: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapGrid1f = procedure(un: GLint; u1: GLfloat; u2: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapGrid2d = procedure(un: GLint; u1: GLdouble; u2: GLdouble; vn: GLint; v1: GLdouble;
                           v2: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapGrid2f = procedure(un: GLint; u1: GLfloat; u2: GLfloat; vn: GLint; v1: GLfloat;
                           v2: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord1d = procedure(u: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord1dv = procedure(const u: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord1f = procedure(u: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord1fv = procedure(const u: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord2d = procedure(u: GLdouble; v: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord2dv = procedure(const u: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord2f = procedure(u: GLfloat; v: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalCoord2fv = procedure(const u: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalMesh1 = procedure(mode: GLenum; i1: GLint; i2: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalPoint1 = procedure(i: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalMesh2 = procedure(mode: GLenum; i1: GLint; i2: GLint; j1: GLint; j2: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEvalPoint2 = procedure(i: GLint; j: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglAlphaFunc = procedure(func: GLenum; ref: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelZoom = procedure(xfactor: GLfloat; yfactor: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelTransferf = procedure(pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelTransferi = procedure(pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelMapfv = procedure(map_: GLenum; mapsize: GLsizei; const values: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelMapuiv = procedure(map_: GLenum; mapsize: GLsizei; const values: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPixelMapusv = procedure(map_: GLenum; mapsize: GLsizei; const values: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyPixels = procedure(x: GLint; y: GLint; width: GLsizei; height: GLsizei;
                            type_: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawPixels = procedure(width: GLsizei; height: GLsizei; format: GLenum; type_: GLenum;
                            const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetClipPlane = procedure(plane: GLenum; equation: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetLightfv = procedure(light: GLenum; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetLightiv = procedure(light: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMapdv = procedure(target: GLenum; query: GLenum; v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMapfv = procedure(target: GLenum; query: GLenum; v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMapiv = procedure(target: GLenum; query: GLenum; v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMaterialfv = procedure(face: GLenum; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMaterialiv = procedure(face: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetPixelMapfv = procedure(map_: GLenum; values: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetPixelMapuiv = procedure(map_: GLenum; values: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetPixelMapusv = procedure(map_: GLenum; values: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetPolygonStipple = procedure(mask: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexEnvfv = procedure(target: GLenum; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexEnviv = procedure(target: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexGendv = procedure(coord: GLenum; pname: GLenum; params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexGenfv = procedure(coord: GLenum; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexGeniv = procedure(coord: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsList = function(list: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFrustum = procedure(left: GLdouble; right: GLdouble; bottom: GLdouble; top: GLdouble;
                         zNear: GLdouble; zFar: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadIdentity = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadMatrixf = procedure(const m: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadMatrixd = procedure(const m: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMatrixMode = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultMatrixf = procedure(const m: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultMatrixd = procedure(const m: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglOrtho = procedure(left: GLdouble; right: GLdouble; bottom: GLdouble; top: GLdouble;
                       zNear: GLdouble; zFar: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPopMatrix = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPushMatrix = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRotated = procedure(angle: GLdouble; x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRotatef = procedure(angle: GLfloat; x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScaled = procedure(x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScalef = procedure(x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTranslated = procedure(x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTranslatef = procedure(x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 1.1 Array Functions ====================
  TglDrawArrays = procedure(mode: GLenum; first: GLint; count: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElements = procedure(mode: GLenum; count: GLsizei; type_: GLenum;
                              const indices: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetPointerv = procedure(pname: GLenum; params: PGLvoid); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPolygonOffset = procedure(factor: GLfloat; units: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTexImage1D = procedure(target: GLenum; level: GLint; internalformat: GLenum;
                                x: GLint; y: GLint; width: GLsizei; border: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTexImage2D = procedure(target: GLenum; level: GLint; internalformat: GLenum;
                                x: GLint; y: GLint; width: GLsizei; height: GLsizei;
                                border: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTexSubImage1D = procedure(target: GLenum; level: GLint; xoffset: GLint; x: GLint;
                                   y: GLint; width: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTexSubImage2D = procedure(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint;
                                   x: GLint; y: GLint; width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexSubImage1D = procedure(target: GLenum; level: GLint; xoffset: GLint; width: GLsizei;
                               format: GLenum; type_: GLenum; const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexSubImage2D = procedure(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint;
                               width: GLsizei; height: GLsizei; format: GLenum; type_: GLenum;
                               const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindTexture = procedure(target: GLenum; texture: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteTextures = procedure(n: GLsizei; const textures: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenTextures = procedure(n: GLsizei; textures: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsTexture = function(texture: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglArrayElement = procedure(i: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorPointer = procedure(size: GLint; type_: GLenum; stride: GLsizei;
                              const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDisableClientState = procedure(array_: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEdgeFlagPointer = procedure(stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnableClientState = procedure(array_: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexPointer = procedure(type_: GLenum; stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInterleavedArrays = procedure(format: GLenum; stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormalPointer = procedure(type_: GLenum; stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordPointer = procedure(size: GLint; type_: GLenum; stride: GLsizei;
                                 const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexPointer = procedure(size: GLint; type_: GLenum; stride: GLsizei;
                               const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglAreTexturesResident = function(n: GLsizei; const textures: PGLuint;
                                    residences: PGLboolean): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPrioritizeTextures = procedure(n: GLsizei; const textures: PGLuint;
                                    const priorities: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexub = procedure(c: GLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIndexubv = procedure(const c: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPopClientAttrib = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPushClientAttrib = procedure(mask: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 1.2 Functions ====================
  TglDrawRangeElements = procedure(mode: GLenum; start: GLuint; end_: GLuint; count: GLsizei;
                                   type_: GLenum; const indices: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexImage3D = procedure(target: GLenum; level: GLint; internalformat: GLint; width: GLsizei;
                            height: GLsizei; depth: GLsizei; border: GLint; format: GLenum;
                            type_: GLenum; const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexSubImage3D = procedure(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint;
                               zoffset: GLint; width: GLsizei; height: GLsizei; depth: GLsizei;
                               format: GLenum; type_: GLenum; const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTexSubImage3D = procedure(target: GLenum; level: GLint; xoffset: GLint; yoffset: GLint;
                                   zoffset: GLint; x: GLint; y: GLint; width: GLsizei;
                                   height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 1.3 Functions ====================
  TglActiveTexture = procedure(texture: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSampleCoverage = procedure(value: GLfloat; invert: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexImage3D = procedure(target: GLenum; level: GLint; internalformat: GLenum;
                                      width: GLsizei; height: GLsizei; depth: GLsizei;
                                      border: GLint; imageSize: GLsizei; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexImage2D = procedure(target: GLenum; level: GLint; internalformat: GLenum;
                                      width: GLsizei; height: GLsizei; border: GLint;
                                      imageSize: GLsizei; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexImage1D = procedure(target: GLenum; level: GLint; internalformat: GLenum;
                                      width: GLsizei; border: GLint; imageSize: GLsizei;
                                      const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexSubImage3D = procedure(target: GLenum; level: GLint; xoffset: GLint;
                                         yoffset: GLint; zoffset: GLint; width: GLsizei;
                                         height: GLsizei; depth: GLsizei; format: GLenum;
                                         imageSize: GLsizei; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexSubImage2D = procedure(target: GLenum; level: GLint; xoffset: GLint;
                                         yoffset: GLint; width: GLsizei; height: GLsizei;
                                         format: GLenum; imageSize: GLsizei;
                                         const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTexSubImage1D = procedure(target: GLenum; level: GLint; xoffset: GLint;
                                         width: GLsizei; format: GLenum; imageSize: GLsizei;
                                         const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetCompressedTexImage = procedure(target: GLenum; level: GLint; img: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClientActiveTexture = procedure(texture: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1d = procedure(target: GLenum; s: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1dv = procedure(target: GLenum; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1f = procedure(target: GLenum; s: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1fv = procedure(target: GLenum; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1i = procedure(target: GLenum; s: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1iv = procedure(target: GLenum; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1s = procedure(target: GLenum; s: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord1sv = procedure(target: GLenum; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2d = procedure(target: GLenum; s: GLdouble; t: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2dv = procedure(target: GLenum; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2f = procedure(target: GLenum; s: GLfloat; t: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2fv = procedure(target: GLenum; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2i = procedure(target: GLenum; s: GLint; t: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2iv = procedure(target: GLenum; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2s = procedure(target: GLenum; s: GLshort; t: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord2sv = procedure(target: GLenum; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3d = procedure(target: GLenum; s: GLdouble; t: GLdouble; r: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3dv = procedure(target: GLenum; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3f = procedure(target: GLenum; s: GLfloat; t: GLfloat; r: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3fv = procedure(target: GLenum; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3i = procedure(target: GLenum; s: GLint; t: GLint; r: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3iv = procedure(target: GLenum; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3s = procedure(target: GLenum; s: GLshort; t: GLshort; r: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord3sv = procedure(target: GLenum; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4d = procedure(target: GLenum; s: GLdouble; t: GLdouble; r: GLdouble;
                                 q: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4dv = procedure(target: GLenum; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4f = procedure(target: GLenum; s: GLfloat; t: GLfloat; r: GLfloat;
                                 q: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4fv = procedure(target: GLenum; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4i = procedure(target: GLenum; s: GLint; t: GLint; r: GLint; q: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4iv = procedure(target: GLenum; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4s = procedure(target: GLenum; s: GLshort; t: GLshort; r: GLshort;
                                 q: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoord4sv = procedure(target: GLenum; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadTransposeMatrixf = procedure(const m: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLoadTransposeMatrixd = procedure(const m: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultTransposeMatrixf = procedure(const m: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultTransposeMatrixd = procedure(const m: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 1.4 Functions ====================
  TglBlendFuncSeparate = procedure(sfactorRGB: GLenum; dfactorRGB: GLenum;
                                   sfactorAlpha: GLenum; dfactorAlpha: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawArrays = procedure(mode: GLenum; const first: PGLint; const count: PGLsizei;
                                 drawcount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawElements = procedure(mode: GLenum; const count: PGLsizei; type_: GLenum;
                                   const indices: PGLvoid; drawcount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPointParameterf = procedure(pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPointParameterfv = procedure(pname: GLenum; const params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPointParameteri = procedure(pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPointParameteriv = procedure(pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogCoordf = procedure(coord: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogCoordfv = procedure(const coord: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogCoordd = procedure(coord: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogCoorddv = procedure(const coord: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFogCoordPointer = procedure(type_: GLenum; stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3b = procedure(red: GLbyte; green: GLbyte; blue: GLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3bv = procedure(const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3d = procedure(red: GLdouble; green: GLdouble; blue: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3f = procedure(red: GLfloat; green: GLfloat; blue: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3i = procedure(red: GLint; green: GLint; blue: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3s = procedure(red: GLshort; green: GLshort; blue: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3ub = procedure(red: GLubyte; green: GLubyte; blue: GLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3ubv = procedure(const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3ui = procedure(red: GLuint; green: GLuint; blue: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3uiv = procedure(const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3us = procedure(red: GLushort; green: GLushort; blue: GLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColor3usv = procedure(const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColorPointer = procedure(size: GLint; type_: GLenum; stride: GLsizei;
                                       const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2d = procedure(x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2f = procedure(x: GLfloat; y: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2i = procedure(x: GLint; y: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2s = procedure(x: GLshort; y: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos2sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3d = procedure(x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3dv = procedure(const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3f = procedure(x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3fv = procedure(const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3i = procedure(x: GLint; y: GLint; z: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3iv = procedure(const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3s = procedure(x: GLshort; y: GLshort; z: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWindowPos3sv = procedure(const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendColor = procedure(red: GLfloat; green: GLfloat; blue: GLfloat; alpha: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendEquation = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 1.5 Functions ====================
  TglGenQueries = procedure(n: GLsizei; ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteQueries = procedure(n: GLsizei; const ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsQuery = function(id: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBeginQuery = procedure(target: GLenum; id: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEndQuery = procedure(target: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryiv = procedure(target: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryObjectiv = procedure(id: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryObjectuiv = procedure(id: GLuint; pname: GLenum; params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindBuffer = procedure(target: GLenum; buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteBuffers = procedure(n: GLsizei; const buffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenBuffers = procedure(n: GLsizei; buffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsBuffer = function(buffer: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBufferData = procedure(target: GLenum; size: GLsizeiptr; const data: Pointer;
                            usage: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBufferSubData = procedure(target: GLenum; offset: GLintptr; size: GLsizeiptr;
                               const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBufferSubData = procedure(target: GLenum; offset: GLintptr; size: GLsizeiptr;
                                  data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapBuffer = function(target: GLenum; access: GLenum): Pointer; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUnmapBuffer = function(target: GLenum): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBufferParameteriv = procedure(target: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBufferPointerv = procedure(target: GLenum; pname: GLenum; params: PGLvoid); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 2.0 Functions ====================
  TglBlendEquationSeparate = procedure(modeRGB: GLenum; modeAlpha: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawBuffers = procedure(n: GLsizei; const bufs: PGLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilOpSeparate = procedure(face: GLenum; sfail: GLenum; dpfail: GLenum;
                                   dppass: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilFuncSeparate = procedure(face: GLenum; func: GLenum; ref: GLint;
                                     mask: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglStencilMaskSeparate = procedure(face: GLenum; mask: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglAttachShader = procedure(program_: GLuint; shader: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindAttribLocation = procedure(program_: GLuint; index: GLuint; const name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompileShader = procedure(shader: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateProgram = function: GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateShader = function(type_: GLenum): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteProgram = procedure(program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteShader = procedure(shader: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDetachShader = procedure(program_: GLuint; shader: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDisableVertexAttribArray = procedure(index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnableVertexAttribArray = procedure(index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveAttrib = procedure(program_: GLuint; index: GLuint; bufSize: GLsizei;
                                 length: PGLsizei; size: PGLint; type_: PGLenum;
                                 name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveUniform = procedure(program_: GLuint; index: GLuint; bufSize: GLsizei;
                                  length: PGLsizei; size: PGLint; type_: PGLenum;
                                  name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetAttachedShaders = procedure(program_: GLuint; maxCount: GLsizei; count: PGLsizei;
                                    shaders: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetAttribLocation = function(program_: GLuint; const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramiv = procedure(program_: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramInfoLog = procedure(program_: GLuint; bufSize: GLsizei; length: PGLsizei;
                                   infoLog: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetShaderiv = procedure(shader: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetShaderInfoLog = procedure(shader: GLuint; bufSize: GLsizei; length: PGLsizei;
                                  infoLog: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetShaderSource = procedure(shader: GLuint; bufSize: GLsizei; length: PGLsizei;
                                 source: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformLocation = function(program_: GLuint; const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformfv = procedure(program_: GLuint; location: GLint; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformiv = procedure(program_: GLuint; location: GLint; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribdv = procedure(index: GLuint; pname: GLenum; params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribfv = procedure(index: GLuint; pname: GLenum; params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribiv = procedure(index: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribPointerv = procedure(index: GLuint; pname: GLenum; pointer: PGLvoid); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsProgram = function(program_: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsShader = function(shader: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglLinkProgram = procedure(program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglShaderSource = procedure(shader: GLuint; count: GLsizei; const string_: PPGLchar;
                              const length: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUseProgram = procedure(program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1f = procedure(location: GLint; v0: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2f = procedure(location: GLint; v0: GLfloat; v1: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3f = procedure(location: GLint; v0: GLfloat; v1: GLfloat; v2: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4f = procedure(location: GLint; v0: GLfloat; v1: GLfloat; v2: GLfloat;
                           v3: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1i = procedure(location: GLint; v0: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2i = procedure(location: GLint; v0: GLint; v1: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3i = procedure(location: GLint; v0: GLint; v1: GLint; v2: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4i = procedure(location: GLint; v0: GLint; v1: GLint; v2: GLint; v3: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1fv = procedure(location: GLint; count: GLsizei; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2fv = procedure(location: GLint; count: GLsizei; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3fv = procedure(location: GLint; count: GLsizei; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4fv = procedure(location: GLint; count: GLsizei; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1iv = procedure(location: GLint; count: GLsizei; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2iv = procedure(location: GLint; count: GLsizei; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3iv = procedure(location: GLint; count: GLsizei; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4iv = procedure(location: GLint; count: GLsizei; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix2fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglValidateProgram = procedure(program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1d = procedure(index: GLuint; x: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1f = procedure(index: GLuint; x: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1fv = procedure(index: GLuint; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1s = procedure(index: GLuint; x: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib1sv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2d = procedure(index: GLuint; x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2f = procedure(index: GLuint; x: GLfloat; y: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2fv = procedure(index: GLuint; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2s = procedure(index: GLuint; x: GLshort; y: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib2sv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3d = procedure(index: GLuint; x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3f = procedure(index: GLuint; x: GLfloat; y: GLfloat; z: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3fv = procedure(index: GLuint; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3s = procedure(index: GLuint; x: GLshort; y: GLshort; z: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib3sv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nbv = procedure(index: GLuint; const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Niv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nsv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nub = procedure(index: GLuint; x: GLubyte; y: GLubyte; z: GLubyte;
                                  w: GLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nubv = procedure(index: GLuint; const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nuiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4Nusv = procedure(index: GLuint; const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4bv = procedure(index: GLuint; const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4d = procedure(index: GLuint; x: GLdouble; y: GLdouble; z: GLdouble;
                                w: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4f = procedure(index: GLuint; x: GLfloat; y: GLfloat; z: GLfloat;
                                w: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4fv = procedure(index: GLuint; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4iv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4s = procedure(index: GLuint; x: GLshort; y: GLshort; z: GLshort;
                                w: GLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4sv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4ubv = procedure(index: GLuint; const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4uiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttrib4usv = procedure(index: GLuint; const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribPointer = procedure(index: GLuint; size: GLint; type_: GLenum;
                                     normalized: GLboolean; stride: GLsizei;
                                     const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 2.1 Functions ====================
  TglUniformMatrix2x3fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3x2fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix2x4fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4x2fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3x4fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4x3fv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 3.0 Functions ====================
  TglColorMaski = procedure(index: GLuint; r: GLboolean; g: GLboolean; b: GLboolean;
                            a: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBooleani_v = procedure(target: GLenum; index: GLuint; data: PGLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetIntegeri_v = procedure(target: GLenum; index: GLuint; data: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnablei = procedure(target: GLenum; index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDisablei = procedure(target: GLenum; index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsEnabledi = function(target: GLenum; index: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBeginTransformFeedback = procedure(primitiveMode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEndTransformFeedback = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindBufferRange = procedure(target: GLenum; index: GLuint; buffer: GLuint;
                                 offset: GLintptr; size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindBufferBase = procedure(target: GLenum; index: GLuint; buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTransformFeedbackVaryings = procedure(program_: GLuint; count: GLsizei;
                                           const varyings: PPGLchar;
                                           bufferMode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTransformFeedbackVarying = procedure(program_: GLuint; index: GLuint; bufSize: GLsizei;
                                             length: PGLsizei; size: PGLsizei; type_: PGLenum;
                                             name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClampColor = procedure(target: GLenum; clamp: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBeginConditionalRender = procedure(id: GLuint; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEndConditionalRender = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribIPointer = procedure(index: GLuint; size: GLint; type_: GLenum;
                                      stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribIiv = procedure(index: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribIuiv = procedure(index: GLuint; pname: GLenum; params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI1i = procedure(index: GLuint; x: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI2i = procedure(index: GLuint; x: GLint; y: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI3i = procedure(index: GLuint; x: GLint; y: GLint; z: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4i = procedure(index: GLuint; x: GLint; y: GLint; z: GLint; w: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI1ui = procedure(index: GLuint; x: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI2ui = procedure(index: GLuint; x: GLuint; y: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI3ui = procedure(index: GLuint; x: GLuint; y: GLuint; z: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4ui = procedure(index: GLuint; x: GLuint; y: GLuint; z: GLuint;
                                  w: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI1iv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI2iv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI3iv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4iv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI1uiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI2uiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI3uiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4uiv = procedure(index: GLuint; const v: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4bv = procedure(index: GLuint; const v: PGLbyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4sv = procedure(index: GLuint; const v: PGLshort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4ubv = procedure(index: GLuint; const v: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribI4usv = procedure(index: GLuint; const v: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformuiv = procedure(program_: GLuint; location: GLint; params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindFragDataLocation = procedure(program_: GLuint; color: GLuint;
                                      const name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFragDataLocation = function(program_: GLuint; const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1ui = procedure(location: GLint; v0: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2ui = procedure(location: GLint; v0: GLuint; v1: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3ui = procedure(location: GLint; v0: GLuint; v1: GLuint; v2: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4ui = procedure(location: GLint; v0: GLuint; v1: GLuint; v2: GLuint;
                            v3: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1uiv = procedure(location: GLint; count: GLsizei; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2uiv = procedure(location: GLint; count: GLsizei; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3uiv = procedure(location: GLint; count: GLsizei; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4uiv = procedure(location: GLint; count: GLsizei; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameterIiv = procedure(target: GLenum; pname: GLenum; const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexParameterIuiv = procedure(target: GLenum; pname: GLenum; const params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexParameterIiv = procedure(target: GLenum; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTexParameterIuiv = procedure(target: GLenum; pname: GLenum; params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearBufferiv = procedure(buffer: GLenum; drawbuffer: GLint; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearBufferuiv = procedure(buffer: GLenum; drawbuffer: GLint; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearBufferfv = procedure(buffer: GLenum; drawbuffer: GLint; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearBufferfi = procedure(buffer: GLenum; drawbuffer: GLint; depth: GLfloat;
                               stencil: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetStringi = function(name: GLenum; index: GLuint): PGLubyte; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsRenderbuffer = function(renderbuffer: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindRenderbuffer = procedure(target: GLenum; renderbuffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteRenderbuffers = procedure(n: GLsizei; const renderbuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenRenderbuffers = procedure(n: GLsizei; renderbuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRenderbufferStorage = procedure(target: GLenum; internalformat: GLenum; width: GLsizei;
                                     height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetRenderbufferParameteriv = procedure(target: GLenum; pname: GLenum;
                                            params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsFramebuffer = function(framebuffer: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindFramebuffer = procedure(target: GLenum; framebuffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteFramebuffers = procedure(n: GLsizei; const framebuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenFramebuffers = procedure(n: GLsizei; framebuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCheckFramebufferStatus = function(target: GLenum): GLenum; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferTexture1D = procedure(target: GLenum; attachment: GLenum; textarget: GLenum;
                                      texture: GLuint; level: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferTexture2D = procedure(target: GLenum; attachment: GLenum; textarget: GLenum;
                                      texture: GLuint; level: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferTexture3D = procedure(target: GLenum; attachment: GLenum; textarget: GLenum;
                                      texture: GLuint; level: GLint; zoffset: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferRenderbuffer = procedure(target: GLenum; attachment: GLenum;
                                         renderbuffertarget: GLenum;
                                         renderbuffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFramebufferAttachmentParameteriv = procedure(target: GLenum; attachment: GLenum;
                                                     pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenerateMipmap = procedure(target: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlitFramebuffer = procedure(srcX0: GLint; srcY0: GLint; srcX1: GLint; srcY1: GLint;
                                 dstX0: GLint; dstY0: GLint; dstX1: GLint; dstY1: GLint;
                                 mask: GLbitfield; filter: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglRenderbufferStorageMultisample = procedure(target: GLenum; samples: GLsizei;
                                                internalformat: GLenum; width: GLsizei;
                                                height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferTextureLayer = procedure(target: GLenum; attachment: GLenum; texture: GLuint;
                                         level: GLint; layer: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapBufferRange = function(target: GLenum; offset: GLintptr; length: GLsizeiptr;
                               access: GLbitfield): Pointer; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFlushMappedBufferRange = procedure(target: GLenum; offset: GLintptr;
                                        length: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindVertexArray = procedure(array_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteVertexArrays = procedure(n: GLsizei; const arrays: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenVertexArrays = procedure(n: GLsizei; arrays: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsVertexArray = function(array_: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 3.1 Functions ====================
  TglDrawArraysInstanced = procedure(mode: GLenum; first: GLint; count: GLsizei;
                                     instancecount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElementsInstanced = procedure(mode: GLenum; count: GLsizei; type_: GLenum;
                                       const indices: Pointer; instancecount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexBuffer = procedure(target: GLenum; internalformat: GLenum; buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPrimitiveRestartIndex = procedure(index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyBufferSubData = procedure(readTarget: GLenum; writeTarget: GLenum;
                                   readOffset: GLintptr; writeOffset: GLintptr;
                                   size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformIndices = procedure(program_: GLuint; uniformCount: GLsizei;
                                   const uniformNames: PPGLchar;
                                   uniformIndices: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveUniformsiv = procedure(program_: GLuint; uniformCount: GLsizei;
                                     const uniformIndices: PGLuint; pname: GLenum;
                                     params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveUniformName = procedure(program_: GLuint; uniformIndex: GLuint; bufSize: GLsizei;
                                      length: PGLsizei; uniformName: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformBlockIndex = function(program_: GLuint; const uniformBlockName: PGLchar): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveUniformBlockiv = procedure(program_: GLuint; uniformBlockIndex: GLuint;
                                         pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveUniformBlockName = procedure(program_: GLuint; uniformBlockIndex: GLuint;
                                           bufSize: GLsizei; length: PGLsizei;
                                           uniformBlockName: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformBlockBinding = procedure(program_: GLuint; uniformBlockIndex: GLuint;
                                     uniformBlockBinding: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 3.2 Functions ====================
  TglDrawElementsBaseVertex = procedure(mode: GLenum; count: GLsizei; type_: GLenum;
                                        const indices: Pointer; basevertex: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawRangeElementsBaseVertex = procedure(mode: GLenum; start: GLuint; end_: GLuint;
                                             count: GLsizei; type_: GLenum;
                                             const indices: Pointer; basevertex: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElementsInstancedBaseVertex = procedure(mode: GLenum; count: GLsizei; type_: GLenum;
                                                 const indices: Pointer; instancecount: GLsizei;
                                                 basevertex: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawElementsBaseVertex = procedure(mode: GLenum; const count: PGLsizei; type_: GLenum;
                                             const indices: PGLvoid; drawcount: GLsizei;
                                             const basevertex: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProvokingVertex = procedure(mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFenceSync = function(condition: GLenum; flags: GLbitfield): GLsync; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsSync = function(sync: GLsync): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteSync = procedure(sync: GLsync); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClientWaitSync = function(sync: GLsync; flags: GLbitfield; timeout: GLuint64): GLenum; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglWaitSync = procedure(sync: GLsync; flags: GLbitfield; timeout: GLuint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetInteger64v = procedure(pname: GLenum; data: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSynciv = procedure(sync: GLsync; pname: GLenum; count: GLsizei; length: PGLsizei;
                           values: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetInteger64i_v = procedure(target: GLenum; index: GLuint; data: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetBufferParameteri64v = procedure(target: GLenum; pname: GLenum; params: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferTexture = procedure(target: GLenum; attachment: GLenum; texture: GLuint;
                                    level: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexImage2DMultisample = procedure(target: GLenum; samples: GLsizei; internalformat: GLenum;
                                       width: GLsizei; height: GLsizei;
                                       fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexImage3DMultisample = procedure(target: GLenum; samples: GLsizei; internalformat: GLenum;
                                       width: GLsizei; height: GLsizei; depth: GLsizei;
                                       fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetMultisamplefv = procedure(pname: GLenum; index: GLuint; val: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSampleMaski = procedure(maskNumber: GLuint; mask: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 3.3 Functions ====================
  TglBindFragDataLocationIndexed = procedure(program_: GLuint; colorNumber: GLuint;
                                             index: GLuint; const name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFragDataIndex = function(program_: GLuint; const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenSamplers = procedure(count: GLsizei; samplers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteSamplers = procedure(count: GLsizei; const samplers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsSampler = function(sampler: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindSampler = procedure(unit_: GLuint; sampler: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameteri = procedure(sampler: GLuint; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameteriv = procedure(sampler: GLuint; pname: GLenum;
                                    const param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameterf = procedure(sampler: GLuint; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameterfv = procedure(sampler: GLuint; pname: GLenum;
                                    const param: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameterIiv = procedure(sampler: GLuint; pname: GLenum;
                                     const param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSamplerParameterIuiv = procedure(sampler: GLuint; pname: GLenum;
                                      const param: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSamplerParameteriv = procedure(sampler: GLuint; pname: GLenum;
                                       params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSamplerParameterIiv = procedure(sampler: GLuint; pname: GLenum;
                                        params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSamplerParameterfv = procedure(sampler: GLuint; pname: GLenum;
                                       params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSamplerParameterIuiv = procedure(sampler: GLuint; pname: GLenum;
                                         params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglQueryCounter = procedure(id: GLuint; target: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryObjecti64v = procedure(id: GLuint; pname: GLenum; params: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryObjectui64v = procedure(id: GLuint; pname: GLenum; params: PGLuint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribDivisor = procedure(index: GLuint; divisor: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP1ui = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                  value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP1uiv = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                   const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP2ui = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                  value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP2uiv = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                   const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP3ui = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                  value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP3uiv = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                   const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP4ui = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                  value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribP4uiv = procedure(index: GLuint; type_: GLenum; normalized: GLboolean;
                                   const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP2ui = procedure(type_: GLenum; value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP2uiv = procedure(type_: GLenum; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP3ui = procedure(type_: GLenum; value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP3uiv = procedure(type_: GLenum; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP4ui = procedure(type_: GLenum; value: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexP4uiv = procedure(type_: GLenum; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP1ui = procedure(type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP1uiv = procedure(type_: GLenum; const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP2ui = procedure(type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP2uiv = procedure(type_: GLenum; const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP3ui = procedure(type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP3uiv = procedure(type_: GLenum; const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP4ui = procedure(type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexCoordP4uiv = procedure(type_: GLenum; const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP1ui = procedure(texture: GLenum; type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP1uiv = procedure(texture: GLenum; type_: GLenum;
                                    const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP2ui = procedure(texture: GLenum; type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP2uiv = procedure(texture: GLenum; type_: GLenum;
                                    const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP3ui = procedure(texture: GLenum; type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP3uiv = procedure(texture: GLenum; type_: GLenum;
                                    const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP4ui = procedure(texture: GLenum; type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiTexCoordP4uiv = procedure(texture: GLenum; type_: GLenum;
                                    const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormalP3ui = procedure(type_: GLenum; coords: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNormalP3uiv = procedure(type_: GLenum; const coords: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorP3ui = procedure(type_: GLenum; color: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorP3uiv = procedure(type_: GLenum; const color: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorP4ui = procedure(type_: GLenum; color: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglColorP4uiv = procedure(type_: GLenum; const color: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColorP3ui = procedure(type_: GLenum; color: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglSecondaryColorP3uiv = procedure(type_: GLenum; const color: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.0 Functions ====================
  TglMinSampleShading = procedure(value: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendEquationi = procedure(buf: GLuint; mode: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendEquationSeparatei = procedure(buf: GLuint; modeRGB: GLenum;
                                        modeAlpha: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendFunci = procedure(buf: GLuint; src: GLenum; dst: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlendFuncSeparatei = procedure(buf: GLuint; srcRGB: GLenum; dstRGB: GLenum;
                                    srcAlpha: GLenum; dstAlpha: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawArraysIndirect = procedure(mode: GLenum; const indirect: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElementsIndirect = procedure(mode: GLenum; type_: GLenum;
                                      const indirect: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1d = procedure(location: GLint; x: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2d = procedure(location: GLint; x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3d = procedure(location: GLint; x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4d = procedure(location: GLint; x: GLdouble; y: GLdouble; z: GLdouble;
                           w: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform1dv = procedure(location: GLint; count: GLsizei; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform2dv = procedure(location: GLint; count: GLsizei; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform3dv = procedure(location: GLint; count: GLsizei; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniform4dv = procedure(location: GLint; count: GLsizei; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix2dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                  const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix2x3dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix2x4dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3x2dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix3x4dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4x2dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformMatrix4x3dv = procedure(location: GLint; count: GLsizei; transpose: GLboolean;
                                    const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformdv = procedure(program_: GLuint; location: GLint; params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSubroutineUniformLocation = function(program_: GLuint; shadertype: GLenum;
                                             const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetSubroutineIndex = function(program_: GLuint; shadertype: GLenum;
                                   const name: PGLchar): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveSubroutineUniformiv = procedure(program_: GLuint; shadertype: GLenum;
                                              index: GLuint; pname: GLenum;
                                              values: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveSubroutineUniformName = procedure(program_: GLuint; shadertype: GLenum;
                                                index: GLuint; bufSize: GLsizei;
                                                length: PGLsizei; name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveSubroutineName = procedure(program_: GLuint; shadertype: GLenum; index: GLuint;
                                         bufSize: GLsizei; length: PGLsizei;
                                         name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUniformSubroutinesuiv = procedure(shadertype: GLenum; count: GLsizei;
                                       const indices: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetUniformSubroutineuiv = procedure(shadertype: GLenum; location: GLint;
                                         params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramStageiv = procedure(program_: GLuint; shadertype: GLenum; pname: GLenum;
                                   values: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPatchParameteri = procedure(pname: GLenum; value: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPatchParameterfv = procedure(pname: GLenum; const values: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindTransformFeedback = procedure(target: GLenum; id: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteTransformFeedbacks = procedure(n: GLsizei; const ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenTransformFeedbacks = procedure(n: GLsizei; ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsTransformFeedback = function(id: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPauseTransformFeedback = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglResumeTransformFeedback = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawTransformFeedback = procedure(mode: GLenum; id: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawTransformFeedbackStream = procedure(mode: GLenum; id: GLuint; stream: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBeginQueryIndexed = procedure(target: GLenum; index: GLuint; id: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEndQueryIndexed = procedure(target: GLenum; index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryIndexediv = procedure(target: GLenum; index: GLuint; pname: GLenum;
                                   params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.1 Functions ====================
  TglReleaseShaderCompiler = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglShaderBinary = procedure(count: GLsizei; const shaders: PGLuint; binaryFormat: GLenum;
                              const binary: Pointer; length: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetShaderPrecisionFormat = procedure(shadertype: GLenum; precisiontype: GLenum;
                                          range: PGLint; precision: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthRangef = procedure(n: GLfloat; f: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearDepthf = procedure(d: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramBinary = procedure(program_: GLuint; bufSize: GLsizei; length: PGLsizei;
                                  binaryFormat: PGLenum; binary: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramBinary = procedure(program_: GLuint; binaryFormat: GLenum; const binary: Pointer;
                               length: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramParameteri = procedure(program_: GLuint; pname: GLenum; value: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUseProgramStages = procedure(pipeline: GLuint; stages: GLbitfield; program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglActiveShaderProgram = procedure(pipeline: GLuint; program_: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateShaderProgramv = function(type_: GLenum; count: GLsizei;
                                     const strings: PPGLchar): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindProgramPipeline = procedure(pipeline: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDeleteProgramPipelines = procedure(n: GLsizei; const pipelines: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenProgramPipelines = procedure(n: GLsizei; pipelines: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglIsProgramPipeline = function(pipeline: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramPipelineiv = procedure(pipeline: GLuint; pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1i = procedure(program_: GLuint; location: GLint; v0: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1iv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1f = procedure(program_: GLuint; location: GLint; v0: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1d = procedure(program_: GLuint; location: GLint; v0: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1ui = procedure(program_: GLuint; location: GLint; v0: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform1uiv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                    const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2i = procedure(program_: GLuint; location: GLint; v0: GLint;
                                  v1: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2iv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2f = procedure(program_: GLuint; location: GLint; v0: GLfloat;
                                  v1: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2d = procedure(program_: GLuint; location: GLint; v0: GLdouble;
                                  v1: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2ui = procedure(program_: GLuint; location: GLint; v0: GLuint;
                                   v1: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform2uiv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                    const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3i = procedure(program_: GLuint; location: GLint; v0: GLint; v1: GLint;
                                  v2: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3iv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3f = procedure(program_: GLuint; location: GLint; v0: GLfloat;
                                  v1: GLfloat; v2: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3d = procedure(program_: GLuint; location: GLint; v0: GLdouble;
                                  v1: GLdouble; v2: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3ui = procedure(program_: GLuint; location: GLint; v0: GLuint;
                                   v1: GLuint; v2: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform3uiv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                    const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4i = procedure(program_: GLuint; location: GLint; v0: GLint; v1: GLint;
                                  v2: GLint; v3: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4iv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4f = procedure(program_: GLuint; location: GLint; v0: GLfloat;
                                  v1: GLfloat; v2: GLfloat; v3: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4d = procedure(program_: GLuint; location: GLint; v0: GLdouble;
                                  v1: GLdouble; v2: GLdouble; v3: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                   const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4ui = procedure(program_: GLuint; location: GLint; v0: GLuint;
                                   v1: GLuint; v2: GLuint; v3: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniform4uiv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                    const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                         transpose: GLboolean; const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2x3fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3x2fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2x4fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4x2fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3x4fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4x3fv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2x3dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3x2dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix2x4dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4x2dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix3x4dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglProgramUniformMatrix4x3dv = procedure(program_: GLuint; location: GLint; count: GLsizei;
                                           transpose: GLboolean;
                                           const value: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglValidateProgramPipeline = procedure(pipeline: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramPipelineInfoLog = procedure(pipeline: GLuint; bufSize: GLsizei;
                                           length: PGLsizei; infoLog: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL1d = procedure(index: GLuint; x: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL2d = procedure(index: GLuint; x: GLdouble; y: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL3d = procedure(index: GLuint; x: GLdouble; y: GLdouble; z: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL4d = procedure(index: GLuint; x: GLdouble; y: GLdouble; z: GLdouble;
                                 w: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL1dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL2dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL3dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribL4dv = procedure(index: GLuint; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribLPointer = procedure(index: GLuint; size: GLint; type_: GLenum;
                                      stride: GLsizei; const pointer: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexAttribLdv = procedure(index: GLuint; pname: GLenum; params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglViewportArrayv = procedure(first: GLuint; count: GLsizei; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglViewportIndexedf = procedure(index: GLuint; x: GLfloat; y: GLfloat; w: GLfloat;
                                  h: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglViewportIndexedfv = procedure(index: GLuint; const v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScissorArrayv = procedure(first: GLuint; count: GLsizei; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScissorIndexed = procedure(index: GLuint; left: GLint; bottom: GLint; width: GLsizei;
                                height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglScissorIndexedv = procedure(index: GLuint; const v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthRangeArrayv = procedure(first: GLuint; count: GLsizei; const v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDepthRangeIndexed = procedure(index: GLuint; n: GLdouble; f: GLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFloati_v = procedure(target: GLenum; index: GLuint; data: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetDoublei_v = procedure(target: GLenum; index: GLuint; data: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.2 Functions ====================
  TglDrawArraysInstancedBaseInstance = procedure(mode: GLenum; first: GLint; count: GLsizei;
                                                 instancecount: GLsizei;
                                                 baseinstance: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElementsInstancedBaseInstance = procedure(mode: GLenum; count: GLsizei; type_: GLenum;
                                                   const indices: Pointer;
                                                   instancecount: GLsizei;
                                                   baseinstance: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawElementsInstancedBaseVertexBaseInstance = procedure(mode: GLenum; count: GLsizei;
                                                             type_: GLenum;
                                                             const indices: Pointer;
                                                             instancecount: GLsizei;
                                                             basevertex: GLint;
                                                             baseinstance: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetInternalformativ = procedure(target: GLenum; internalformat: GLenum; pname: GLenum;
                                     count: GLsizei; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetActiveAtomicCounterBufferiv = procedure(program_: GLuint; bufferIndex: GLuint;
                                                pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindImageTexture = procedure(unit_: GLuint; texture: GLuint; level: GLint;
                                  layered: GLboolean; layer: GLint; access: GLenum;
                                  format: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMemoryBarrier = procedure(barriers: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexStorage1D = procedure(target: GLenum; levels: GLsizei; internalformat: GLenum;
                              width: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexStorage2D = procedure(target: GLenum; levels: GLsizei; internalformat: GLenum;
                              width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexStorage3D = procedure(target: GLenum; levels: GLsizei; internalformat: GLenum;
                              width: GLsizei; height: GLsizei; depth: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawTransformFeedbackInstanced = procedure(mode: GLenum; id: GLuint;
                                                instancecount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDrawTransformFeedbackStreamInstanced = procedure(mode: GLenum; id: GLuint; stream: GLuint;
                                                      instancecount: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.3 Functions ====================
  TglClearBufferData = procedure(target: GLenum; internalformat: GLenum; format: GLenum;
                                 type_: GLenum; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearBufferSubData = procedure(target: GLenum; internalformat: GLenum; offset: GLintptr;
                                    size: GLsizeiptr; format: GLenum; type_: GLenum;
                                    const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDispatchCompute = procedure(num_groups_x: GLuint; num_groups_y: GLuint;
                                 num_groups_z: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDispatchComputeIndirect = procedure(indirect: GLintptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyImageSubData = procedure(srcName: GLuint; srcTarget: GLenum; srcLevel: GLint;
                                  srcX: GLint; srcY: GLint; srcZ: GLint; dstName: GLuint;
                                  dstTarget: GLenum; dstLevel: GLint; dstX: GLint; dstY: GLint;
                                  dstZ: GLint; srcWidth: GLsizei; srcHeight: GLsizei;
                                  srcDepth: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFramebufferParameteri = procedure(target: GLenum; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetFramebufferParameteriv = procedure(target: GLenum; pname: GLenum;
                                           params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetInternalformati64v = procedure(target: GLenum; internalformat: GLenum; pname: GLenum;
                                       count: GLsizei; params: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateTexSubImage = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                       yoffset: GLint; zoffset: GLint; width: GLsizei;
                                       height: GLsizei; depth: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateTexImage = procedure(texture: GLuint; level: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateBufferSubData = procedure(buffer: GLuint; offset: GLintptr;
                                         length: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateBufferData = procedure(buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateFramebuffer = procedure(target: GLenum; numAttachments: GLsizei;
                                       const attachments: PGLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateSubFramebuffer = procedure(target: GLenum; numAttachments: GLsizei;
                                          const attachments: PGLenum; x: GLint; y: GLint;
                                          width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawArraysIndirect = procedure(mode: GLenum; const indirect: Pointer;
                                         drawcount: GLsizei; stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawElementsIndirect = procedure(mode: GLenum; type_: GLenum;
                                           const indirect: Pointer; drawcount: GLsizei;
                                           stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramInterfaceiv = procedure(program_: GLuint; programInterface: GLenum;
                                       pname: GLenum; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramResourceIndex = function(program_: GLuint; programInterface: GLenum;
                                        const name: PGLchar): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramResourceName = procedure(program_: GLuint; programInterface: GLenum;
                                        index: GLuint; bufSize: GLsizei; length: PGLsizei;
                                        name: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramResourceiv = procedure(program_: GLuint; programInterface: GLenum; index: GLuint;
                                      propCount: GLsizei; const props: PGLenum; count: GLsizei;
                                      length: PGLsizei; params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramResourceLocation = function(program_: GLuint; programInterface: GLenum;
                                           const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetProgramResourceLocationIndex = function(program_: GLuint; programInterface: GLenum;
                                                const name: PGLchar): GLint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglShaderStorageBlockBinding = procedure(program_: GLuint; storageBlockIndex: GLuint;
                                           storageBlockBinding: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexBufferRange = procedure(target: GLenum; internalformat: GLenum; buffer: GLuint;
                                offset: GLintptr; size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexStorage2DMultisample = procedure(target: GLenum; samples: GLsizei;
                                         internalformat: GLenum; width: GLsizei;
                                         height: GLsizei;
                                         fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTexStorage3DMultisample = procedure(target: GLenum; samples: GLsizei;
                                         internalformat: GLenum; width: GLsizei;
                                         height: GLsizei; depth: GLsizei;
                                         fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureView = procedure(texture: GLuint; target: GLenum; origtexture: GLuint;
                             internalformat: GLenum; minlevel: GLuint; numlevels: GLuint;
                             minlayer: GLuint; numlayers: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindVertexBuffer = procedure(bindingindex: GLuint; buffer: GLuint; offset: GLintptr;
                                  stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribFormat = procedure(attribindex: GLuint; size: GLint; type_: GLenum;
                                    normalized: GLboolean; relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribIFormat = procedure(attribindex: GLuint; size: GLint; type_: GLenum;
                                     relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribLFormat = procedure(attribindex: GLuint; size: GLint; type_: GLenum;
                                     relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexAttribBinding = procedure(attribindex: GLuint; bindingindex: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexBindingDivisor = procedure(bindingindex: GLuint; divisor: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDebugMessageControl = procedure(source: GLenum; type_: GLenum; severity: GLenum;
                                     count: GLsizei; const ids: PGLuint;
                                     enabled: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDebugMessageInsert = procedure(source: GLenum; type_: GLenum; id: GLuint;
                                    severity: GLenum; length: GLsizei;
                                    const buf: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDebugMessageCallback = procedure(callback: TGLDEBUGPROC;
                                      const userParam: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetDebugMessageLog = function(count: GLuint; bufSize: GLsizei; sources: PGLenum;
                                   types: PGLenum; ids: PGLuint; severities: PGLenum;
                                   lengths: PGLsizei; messageLog: PGLchar): GLuint; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPushDebugGroup = procedure(source: GLenum; id: GLuint; length: GLsizei;
                                const message: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPopDebugGroup = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglObjectLabel = procedure(identifier: GLenum; name: GLuint; length: GLsizei;
                             const alabel: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetObjectLabel = procedure(identifier: GLenum; name: GLuint; bufSize: GLsizei;
                                length: PGLsizei; alabel: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglObjectPtrLabel = procedure(const ptr: Pointer; length: GLsizei;
                                const alabel: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetObjectPtrLabel = procedure(const ptr: Pointer; bufSize: GLsizei; length: PGLsizei;
                                   alabel: PGLchar); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.4 Functions ====================
  TglBufferStorage = procedure(target: GLenum; size: GLsizeiptr; const data: Pointer;
                               flags: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearTexImage = procedure(texture: GLuint; level: GLint; format: GLenum; type_: GLenum;
                               const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearTexSubImage = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                  yoffset: GLint; zoffset: GLint; width: GLsizei;
                                  height: GLsizei; depth: GLsizei; format: GLenum;
                                  type_: GLenum; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindBuffersBase = procedure(target: GLenum; first: GLuint; count: GLsizei;
                                 const buffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindBuffersRange = procedure(target: GLenum; first: GLuint; count: GLsizei;
                                  const buffers: PGLuint; const offsets: PGLintptr;
                                  const sizes: PGLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindTextures = procedure(first: GLuint; count: GLsizei;
                              const textures: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindSamplers = procedure(first: GLuint; count: GLsizei;
                              const samplers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindImageTextures = procedure(first: GLuint; count: GLsizei;
                                   const textures: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindVertexBuffers = procedure(first: GLuint; count: GLsizei; const buffers: PGLuint;
                                   const offsets: PGLintptr; const strides: PGLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.5 Functions ====================
  TglClipControl = procedure(origin: GLenum; depth: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateTransformFeedbacks = procedure(n: GLsizei; ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTransformFeedbackBufferBase = procedure(xfb: GLuint; index: GLuint;
                                             buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTransformFeedbackBufferRange = procedure(xfb: GLuint; index: GLuint; buffer: GLuint;
                                              offset: GLintptr; size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTransformFeedbackiv = procedure(xfb: GLuint; pname: GLenum; param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTransformFeedbacki_v = procedure(xfb: GLuint; pname: GLenum; index: GLuint;
                                         param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTransformFeedbacki64_v = procedure(xfb: GLuint; pname: GLenum; index: GLuint;
                                           param: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateBuffers = procedure(n: GLsizei; buffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedBufferStorage = procedure(buffer: GLuint; size: GLsizeiptr; const data: Pointer;
                                    flags: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedBufferData = procedure(buffer: GLuint; size: GLsizeiptr; const data: Pointer;
                                 usage: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedBufferSubData = procedure(buffer: GLuint; offset: GLintptr; size: GLsizeiptr;
                                    const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyNamedBufferSubData = procedure(readBuffer: GLuint; writeBuffer: GLuint;
                                        readOffset: GLintptr; writeOffset: GLintptr;
                                        size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedBufferData = procedure(buffer: GLuint; internalformat: GLenum;
                                      format: GLenum; type_: GLenum;
                                      const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedBufferSubData = procedure(buffer: GLuint; internalformat: GLenum;
                                         offset: GLintptr; size: GLsizeiptr;
                                         format: GLenum; type_: GLenum;
                                         const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapNamedBuffer = function(buffer: GLuint; access: GLenum): Pointer; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMapNamedBufferRange = function(buffer: GLuint; offset: GLintptr; length: GLsizeiptr;
                                    access: GLbitfield): Pointer; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglUnmapNamedBuffer = function(buffer: GLuint): GLboolean; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglFlushMappedNamedBufferRange = procedure(buffer: GLuint; offset: GLintptr;
                                             length: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedBufferParameteriv = procedure(buffer: GLuint; pname: GLenum;
                                           params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedBufferParameteri64v = procedure(buffer: GLuint; pname: GLenum;
                                             params: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedBufferPointerv = procedure(buffer: GLuint; pname: GLenum;
                                        params: PGLvoid); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedBufferSubData = procedure(buffer: GLuint; offset: GLintptr; size: GLsizeiptr;
                                       data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateFramebuffers = procedure(n: GLsizei; framebuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferRenderbuffer = procedure(framebuffer: GLuint; attachment: GLenum;
                                              renderbuffertarget: GLenum;
                                              renderbuffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferParameteri = procedure(framebuffer: GLuint; pname: GLenum;
                                            param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferTexture = procedure(framebuffer: GLuint; attachment: GLenum;
                                         texture: GLuint; level: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferTextureLayer = procedure(framebuffer: GLuint; attachment: GLenum;
                                              texture: GLuint; level: GLint;
                                              layer: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferDrawBuffer = procedure(framebuffer: GLuint; buf: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferDrawBuffers = procedure(framebuffer: GLuint; n: GLsizei;
                                             const bufs: PGLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedFramebufferReadBuffer = procedure(framebuffer: GLuint; src: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateNamedFramebufferData = procedure(framebuffer: GLuint; numAttachments: GLsizei;
                                                const attachments: PGLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglInvalidateNamedFramebufferSubData = procedure(framebuffer: GLuint;
                                                   numAttachments: GLsizei;
                                                   const attachments: PGLenum;
                                                   x: GLint; y: GLint; width: GLsizei;
                                                   height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedFramebufferiv = procedure(framebuffer: GLuint; buffer: GLenum;
                                         drawbuffer: GLint; const value: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedFramebufferuiv = procedure(framebuffer: GLuint; buffer: GLenum;
                                          drawbuffer: GLint; const value: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedFramebufferfv = procedure(framebuffer: GLuint; buffer: GLenum;
                                         drawbuffer: GLint; const value: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglClearNamedFramebufferfi = procedure(framebuffer: GLuint; buffer: GLenum;
                                         drawbuffer: GLint; depth: GLfloat;
                                         stencil: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBlitNamedFramebuffer = procedure(readFramebuffer: GLuint; drawFramebuffer: GLuint;
                                      srcX0: GLint; srcY0: GLint; srcX1: GLint; srcY1: GLint;
                                      dstX0: GLint; dstY0: GLint; dstX1: GLint; dstY1: GLint;
                                      mask: GLbitfield; filter: GLenum); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCheckNamedFramebufferStatus = function(framebuffer: GLuint; target: GLenum): GLenum; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedFramebufferParameteriv = procedure(framebuffer: GLuint; pname: GLenum;
                                                param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedFramebufferAttachmentParameteriv = procedure(framebuffer: GLuint;
                                                          attachment: GLenum; pname: GLenum;
                                                          params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateRenderbuffers = procedure(n: GLsizei; renderbuffers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedRenderbufferStorage = procedure(renderbuffer: GLuint; internalformat: GLenum;
                                          width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglNamedRenderbufferStorageMultisample = procedure(renderbuffer: GLuint; samples: GLsizei;
                                                     internalformat: GLenum; width: GLsizei;
                                                     height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetNamedRenderbufferParameteriv = procedure(renderbuffer: GLuint; pname: GLenum;
                                                 params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateTextures = procedure(target: GLenum; n: GLsizei; textures: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureBuffer = procedure(texture: GLuint; internalformat: GLenum;
                               buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureBufferRange = procedure(texture: GLuint; internalformat: GLenum; buffer: GLuint;
                                    offset: GLintptr; size: GLsizeiptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureStorage1D = procedure(texture: GLuint; levels: GLsizei; internalformat: GLenum;
                                  width: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureStorage2D = procedure(texture: GLuint; levels: GLsizei; internalformat: GLenum;
                                  width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureStorage3D = procedure(texture: GLuint; levels: GLsizei; internalformat: GLenum;
                                  width: GLsizei; height: GLsizei; depth: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureStorage2DMultisample = procedure(texture: GLuint; samples: GLsizei;
                                             internalformat: GLenum; width: GLsizei;
                                             height: GLsizei;
                                             fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureStorage3DMultisample = procedure(texture: GLuint; samples: GLsizei;
                                             internalformat: GLenum; width: GLsizei;
                                             height: GLsizei; depth: GLsizei;
                                             fixedsamplelocations: GLboolean); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureSubImage1D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                   width: GLsizei; format: GLenum; type_: GLenum;
                                   const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureSubImage2D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                   yoffset: GLint; width: GLsizei; height: GLsizei;
                                   format: GLenum; type_: GLenum;
                                   const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureSubImage3D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                   yoffset: GLint; zoffset: GLint; width: GLsizei;
                                   height: GLsizei; depth: GLsizei; format: GLenum;
                                   type_: GLenum; const pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTextureSubImage1D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                             width: GLsizei; format: GLenum;
                                             imageSize: GLsizei; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTextureSubImage2D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                             yoffset: GLint; width: GLsizei; height: GLsizei;
                                             format: GLenum; imageSize: GLsizei;
                                             const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCompressedTextureSubImage3D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                             yoffset: GLint; zoffset: GLint; width: GLsizei;
                                             height: GLsizei; depth: GLsizei; format: GLenum;
                                             imageSize: GLsizei; const data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTextureSubImage1D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                       x: GLint; y: GLint; width: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTextureSubImage2D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                       yoffset: GLint; x: GLint; y: GLint; width: GLsizei;
                                       height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCopyTextureSubImage3D = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                       yoffset: GLint; zoffset: GLint; x: GLint; y: GLint;
                                       width: GLsizei; height: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameterf = procedure(texture: GLuint; pname: GLenum; param: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameterfv = procedure(texture: GLuint; pname: GLenum;
                                    const param: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameteri = procedure(texture: GLuint; pname: GLenum; param: GLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameterIiv = procedure(texture: GLuint; pname: GLenum;
                                     const params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameterIuiv = procedure(texture: GLuint; pname: GLenum;
                                      const params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureParameteriv = procedure(texture: GLuint; pname: GLenum;
                                    const param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGenerateTextureMipmap = procedure(texture: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglBindTextureUnit = procedure(unit_: GLuint; texture: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureImage = procedure(texture: GLuint; level: GLint; format: GLenum;
                                 type_: GLenum; bufSize: GLsizei; pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetCompressedTextureImage = procedure(texture: GLuint; level: GLint; bufSize: GLsizei;
                                           pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureLevelParameterfv = procedure(texture: GLuint; level: GLint; pname: GLenum;
                                            params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureLevelParameteriv = procedure(texture: GLuint; level: GLint; pname: GLenum;
                                            params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureParameterfv = procedure(texture: GLuint; pname: GLenum;
                                       params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureParameterIiv = procedure(texture: GLuint; pname: GLenum;
                                        params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureParameterIuiv = procedure(texture: GLuint; pname: GLenum;
                                         params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureParameteriv = procedure(texture: GLuint; pname: GLenum;
                                       params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateVertexArrays = procedure(n: GLsizei; arrays: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglDisableVertexArrayAttrib = procedure(vaobj: GLuint; index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglEnableVertexArrayAttrib = procedure(vaobj: GLuint; index: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayElementBuffer = procedure(vaobj: GLuint; buffer: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayVertexBuffer = procedure(vaobj: GLuint; bindingindex: GLuint; buffer: GLuint;
                                         offset: GLintptr; stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayVertexBuffers = procedure(vaobj: GLuint; first: GLuint; count: GLsizei;
                                          const buffers: PGLuint; const offsets: PGLintptr;
                                          const strides: PGLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayAttribBinding = procedure(vaobj: GLuint; attribindex: GLuint;
                                          bindingindex: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayAttribFormat = procedure(vaobj: GLuint; attribindex: GLuint; size: GLint;
                                         type_: GLenum; normalized: GLboolean;
                                         relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayAttribIFormat = procedure(vaobj: GLuint; attribindex: GLuint; size: GLint;
                                          type_: GLenum; relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayAttribLFormat = procedure(vaobj: GLuint; attribindex: GLuint; size: GLint;
                                          type_: GLenum; relativeoffset: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglVertexArrayBindingDivisor = procedure(vaobj: GLuint; bindingindex: GLuint;
                                           divisor: GLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexArrayiv = procedure(vaobj: GLuint; pname: GLenum; param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexArrayIndexediv = procedure(vaobj: GLuint; index: GLuint; pname: GLenum;
                                         param: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetVertexArrayIndexed64iv = procedure(vaobj: GLuint; index: GLuint; pname: GLenum;
                                           param: PGLint64); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateSamplers = procedure(n: GLsizei; samplers: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateProgramPipelines = procedure(n: GLsizei; pipelines: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglCreateQueries = procedure(target: GLenum; n: GLsizei; ids: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryBufferObjecti64v = procedure(id: GLuint; buffer: GLuint; pname: GLenum;
                                          offset: GLintptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryBufferObjectiv = procedure(id: GLuint; buffer: GLuint; pname: GLenum;
                                        offset: GLintptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryBufferObjectui64v = procedure(id: GLuint; buffer: GLuint; pname: GLenum;
                                           offset: GLintptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetQueryBufferObjectuiv = procedure(id: GLuint; buffer: GLuint; pname: GLenum;
                                         offset: GLintptr); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMemoryBarrierByRegion = procedure(barriers: GLbitfield); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetTextureSubImage = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                    yoffset: GLint; zoffset: GLint; width: GLsizei;
                                    height: GLsizei; depth: GLsizei; format: GLenum;
                                    type_: GLenum; bufSize: GLsizei; pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetCompressedTextureSubImage = procedure(texture: GLuint; level: GLint; xoffset: GLint;
                                              yoffset: GLint; zoffset: GLint; width: GLsizei;
                                              height: GLsizei; depth: GLsizei;
                                              bufSize: GLsizei; pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetGraphicsResetStatus = function: GLenum; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnCompressedTexImage = procedure(target: GLenum; lod: GLint; bufSize: GLsizei;
                                        pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnTexImage = procedure(target: GLenum; level: GLint; format: GLenum; type_: GLenum;
                              bufSize: GLsizei; pixels: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnUniformdv = procedure(program_: GLuint; location: GLint; bufSize: GLsizei;
                               params: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnUniformfv = procedure(program_: GLuint; location: GLint; bufSize: GLsizei;
                               params: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnUniformiv = procedure(program_: GLuint; location: GLint; bufSize: GLsizei;
                               params: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnUniformuiv = procedure(program_: GLuint; location: GLint; bufSize: GLsizei;
                                params: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglReadnPixels = procedure(x: GLint; y: GLint; width: GLsizei; height: GLsizei;
                             format: GLenum; type_: GLenum; bufSize: GLsizei;
                             data: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnMapdv = procedure(target: GLenum; query: GLenum; bufSize: GLsizei;
                           v: PGLdouble); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnMapfv = procedure(target: GLenum; query: GLenum; bufSize: GLsizei;
                           v: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnMapiv = procedure(target: GLenum; query: GLenum; bufSize: GLsizei;
                           v: PGLint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnPixelMapfv = procedure(map_: GLenum; bufSize: GLsizei; values: PGLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnPixelMapuiv = procedure(map_: GLenum; bufSize: GLsizei; values: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnPixelMapusv = procedure(map_: GLenum; bufSize: GLsizei; values: PGLushort); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnPolygonStipple = procedure(bufSize: GLsizei; pattern: PGLubyte); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnColorTable = procedure(target: GLenum; format: GLenum; type_: GLenum;
                                bufSize: GLsizei; table: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnConvolutionFilter = procedure(target: GLenum; format: GLenum; type_: GLenum;
                                       bufSize: GLsizei; image: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnSeparableFilter = procedure(target: GLenum; format: GLenum; type_: GLenum;
                                     rowBufSize: GLsizei; row: Pointer;
                                     columnBufSize: GLsizei; column: Pointer;
                                     span: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnHistogram = procedure(target: GLenum; reset: GLboolean; format: GLenum;
                               type_: GLenum; bufSize: GLsizei; values: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglGetnMinmax = procedure(target: GLenum; reset: GLboolean; format: GLenum; type_: GLenum;
                            bufSize: GLsizei; values: Pointer); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglTextureBarrier = procedure; {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== OpenGL 4.6 Functions ====================
  TglSpecializeShader = procedure(shader: GLuint; const pEntryPoint: PGLchar;
                                  numSpecializationConstants: GLuint;
                                  const pConstantIndex: PGLuint;
                                  const pConstantValue: PGLuint); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawArraysIndirectCount = procedure(mode: GLenum; const indirect: Pointer;
                                              drawcount: GLintptr; maxdrawcount: GLsizei;
                                              stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglMultiDrawElementsIndirectCount = procedure(mode: GLenum; type_: GLenum;
                                                const indirect: Pointer;
                                                drawcount: GLintptr;
                                                maxdrawcount: GLsizei;
                                                stride: GLsizei); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
  TglPolygonOffsetClamp = procedure(factor: GLfloat; units: GLfloat; clamp: GLfloat); {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}

  // ==================== Function Pointers ====================
var
  // OpenGL 1.0
  glCullFace: TglCullFace;
  glFrontFace: TglFrontFace;
  glHint: TglHint;
  glLineWidth: TglLineWidth;
  glPointSize: TglPointSize;
  glPolygonMode: TglPolygonMode;
  glScissor: TglScissor;
  glTexParameterf: TglTexParameterf;
  glTexParameterfv: TglTexParameterfv;
  glTexParameteri: TglTexParameteri;
  glTexParameteriv: TglTexParameteriv;
  glTexImage1D: TglTexImage1D;
  glTexImage2D: TglTexImage2D;
  glDrawBuffer: TglDrawBuffer;
  glClear: TglClear;
  glClearColor: TglClearColor;
  glClearStencil: TglClearStencil;
  glClearDepth: TglClearDepth;
  glStencilMask: TglStencilMask;
  glColorMask: TglColorMask;
  glDepthMask: TglDepthMask;
  glDisable: TglDisable;
  glEnable: TglEnable;
  glFinish: TglFinish;
  glFlush: TglFlush;
  glBlendFunc: TglBlendFunc;
  glLogicOp: TglLogicOp;
  glStencilFunc: TglStencilFunc;
  glStencilOp: TglStencilOp;
  glDepthFunc: TglDepthFunc;
  glPixelStoref: TglPixelStoref;
  glPixelStorei: TglPixelStorei;
  glReadBuffer: TglReadBuffer;
  glReadPixels: TglReadPixels;
  glGetBooleanv: TglGetBooleanv;
  glGetDoublev: TglGetDoublev;
  glGetError: TglGetError;
  glGetFloatv: TglGetFloatv;
  glGetIntegerv: TglGetIntegerv;
  glGetString: TglGetString;
  glGetTexImage: TglGetTexImage;
  glGetTexParameterfv: TglGetTexParameterfv;
  glGetTexParameteriv: TglGetTexParameteriv;
  glGetTexLevelParameterfv: TglGetTexLevelParameterfv;
  glGetTexLevelParameteriv: TglGetTexLevelParameteriv;
  glIsEnabled: TglIsEnabled;
  glDepthRange: TglDepthRange;
  glViewport: TglViewport;
  glNewList: TglNewList;
  glEndList: TglEndList;
  glCallList: TglCallList;
  glCallLists: TglCallLists;
  glDeleteLists: TglDeleteLists;
  glGenLists: TglGenLists;
  glListBase: TglListBase;
  glBegin: TglBegin;
  glBitmap: TglBitmap;
  glColor3b: TglColor3b;
  glColor3bv: TglColor3bv;
  glColor3d: TglColor3d;
  glColor3dv: TglColor3dv;
  glColor3f: TglColor3f;
  glColor3fv: TglColor3fv;
  glColor3i: TglColor3i;
  glColor3iv: TglColor3iv;
  glColor3s: TglColor3s;
  glColor3sv: TglColor3sv;
  glColor3ub: TglColor3ub;
  glColor3ubv: TglColor3ubv;
  glColor3ui: TglColor3ui;
  glColor3uiv: TglColor3uiv;
  glColor3us: TglColor3us;
  glColor3usv: TglColor3usv;
  glColor4b: TglColor4b;
  glColor4bv: TglColor4bv;
  glColor4d: TglColor4d;
  glColor4dv: TglColor4dv;
  glColor4f: TglColor4f;
  glColor4fv: TglColor4fv;
  glColor4i: TglColor4i;
  glColor4iv: TglColor4iv;
  glColor4s: TglColor4s;
  glColor4sv: TglColor4sv;
  glColor4ub: TglColor4ub;
  glColor4ubv: TglColor4ubv;
  glColor4ui: TglColor4ui;
  glColor4uiv: TglColor4uiv;
  glColor4us: TglColor4us;
  glColor4usv: TglColor4usv;
  glEdgeFlag: TglEdgeFlag;
  glEdgeFlagv: TglEdgeFlagv;
  glEnd: TglEnd;
  glIndexd: TglIndexd;
  glIndexdv: TglIndexdv;
  glIndexf: TglIndexf;
  glIndexfv: TglIndexfv;
  glIndexi: TglIndexi;
  glIndexiv: TglIndexiv;
  glIndexs: TglIndexs;
  glIndexsv: TglIndexsv;
  glNormal3b: TglNormal3b;
  glNormal3bv: TglNormal3bv;
  glNormal3d: TglNormal3d;
  glNormal3dv: TglNormal3dv;
  glNormal3f: TglNormal3f;
  glNormal3fv: TglNormal3fv;
  glNormal3i: TglNormal3i;
  glNormal3iv: TglNormal3iv;
  glNormal3s: TglNormal3s;
  glNormal3sv: TglNormal3sv;
  glRasterPos2d: TglRasterPos2d;
  glRasterPos2dv: TglRasterPos2dv;
  glRasterPos2f: TglRasterPos2f;
  glRasterPos2fv: TglRasterPos2fv;
  glRasterPos2i: TglRasterPos2i;
  glRasterPos2iv: TglRasterPos2iv;
  glRasterPos2s: TglRasterPos2s;
  glRasterPos2sv: TglRasterPos2sv;
  glRasterPos3d: TglRasterPos3d;
  glRasterPos3dv: TglRasterPos3dv;
  glRasterPos3f: TglRasterPos3f;
  glRasterPos3fv: TglRasterPos3fv;
  glRasterPos3i: TglRasterPos3i;
  glRasterPos3iv: TglRasterPos3iv;
  glRasterPos3s: TglRasterPos3s;
  glRasterPos3sv: TglRasterPos3sv;
  glRasterPos4d: TglRasterPos4d;
  glRasterPos4dv: TglRasterPos4dv;
  glRasterPos4f: TglRasterPos4f;
  glRasterPos4fv: TglRasterPos4fv;
  glRasterPos4i: TglRasterPos4i;
  glRasterPos4iv: TglRasterPos4iv;
  glRasterPos4s: TglRasterPos4s;
  glRasterPos4sv: TglRasterPos4sv;
  glRectd: TglRectd;
  glRectdv: TglRectdv;
  glRectf: TglRectf;
  glRectfv: TglRectfv;
  glRecti: TglRecti;
  glRectiv: TglRectiv;
  glRects: TglRects;
  glRectsv: TglRectsv;
  glTexCoord1d: TglTexCoord1d;
  glTexCoord1dv: TglTexCoord1dv;
  glTexCoord1f: TglTexCoord1f;
  glTexCoord1fv: TglTexCoord1fv;
  glTexCoord1i: TglTexCoord1i;
  glTexCoord1iv: TglTexCoord1iv;
  glTexCoord1s: TglTexCoord1s;
  glTexCoord1sv: TglTexCoord1sv;
  glTexCoord2d: TglTexCoord2d;
  glTexCoord2dv: TglTexCoord2dv;
  glTexCoord2f: TglTexCoord2f;
  glTexCoord2fv: TglTexCoord2fv;
  glTexCoord2i: TglTexCoord2i;
  glTexCoord2iv: TglTexCoord2iv;
  glTexCoord2s: TglTexCoord2s;
  glTexCoord2sv: TglTexCoord2sv;
  glTexCoord3d: TglTexCoord3d;
  glTexCoord3dv: TglTexCoord3dv;
  glTexCoord3f: TglTexCoord3f;
  glTexCoord3fv: TglTexCoord3fv;
  glTexCoord3i: TglTexCoord3i;
  glTexCoord3iv: TglTexCoord3iv;
  glTexCoord3s: TglTexCoord3s;
  glTexCoord3sv: TglTexCoord3sv;
  glTexCoord4d: TglTexCoord4d;
  glTexCoord4dv: TglTexCoord4dv;
  glTexCoord4f: TglTexCoord4f;
  glTexCoord4fv: TglTexCoord4fv;
  glTexCoord4i: TglTexCoord4i;
  glTexCoord4iv: TglTexCoord4iv;
  glTexCoord4s: TglTexCoord4s;
  glTexCoord4sv: TglTexCoord4sv;
  glVertex2d: TglVertex2d;
  glVertex2dv: TglVertex2dv;
  glVertex2f: TglVertex2f;
  glVertex2fv: TglVertex2fv;
  glVertex2i: TglVertex2i;
  glVertex2iv: TglVertex2iv;
  glVertex2s: TglVertex2s;
  glVertex2sv: TglVertex2sv;
  glVertex3d: TglVertex3d;
  glVertex3dv: TglVertex3dv;
  glVertex3f: TglVertex3f;
  glVertex3fv: TglVertex3fv;
  glVertex3i: TglVertex3i;
  glVertex3iv: TglVertex3iv;
  glVertex3s: TglVertex3s;
  glVertex3sv: TglVertex3sv;
  glVertex4d: TglVertex4d;
  glVertex4dv: TglVertex4dv;
  glVertex4f: TglVertex4f;
  glVertex4fv: TglVertex4fv;
  glVertex4i: TglVertex4i;
  glVertex4iv: TglVertex4iv;
  glVertex4s: TglVertex4s;
  glVertex4sv: TglVertex4sv;
  glClipPlane: TglClipPlane;
  glColorMaterial: TglColorMaterial;
  glFogf: TglFogf;
  glFogfv: TglFogfv;
  glFogi: TglFogi;
  glFogiv: TglFogiv;
  glLightf: TglLightf;
  glLightfv: TglLightfv;
  glLighti: TglLighti;
  glLightiv: TglLightiv;
  glLightModelf: TglLightModelf;
  glLightModelfv: TglLightModelfv;
  glLightModeli: TglLightModeli;
  glLightModeliv: TglLightModeliv;
  glLineStipple: TglLineStipple;
  glMaterialf: TglMaterialf;
  glMaterialfv: TglMaterialfv;
  glMateriali: TglMateriali;
  glMaterialiv: TglMaterialiv;
  glPolygonStipple: TglPolygonStipple;
  glShadeModel: TglShadeModel;
  glTexEnvf: TglTexEnvf;
  glTexEnvfv: TglTexEnvfv;
  glTexEnvi: TglTexEnvi;
  glTexEnviv: TglTexEnviv;
  glTexGend: TglTexGend;
  glTexGendv: TglTexGendv;
  glTexGenf: TglTexGenf;
  glTexGenfv: TglTexGenfv;
  glTexGeni: TglTexGeni;
  glTexGeniv: TglTexGeniv;
  glFeedbackBuffer: TglFeedbackBuffer;
  glSelectBuffer: TglSelectBuffer;
  glRenderMode: TglRenderMode;
  glInitNames: TglInitNames;
  glLoadName: TglLoadName;
  glPassThrough: TglPassThrough;
  glPopName: TglPopName;
  glPushName: TglPushName;
  glClearAccum: TglClearAccum;
  glClearIndex: TglClearIndex;
  glIndexMask: TglIndexMask;
  glAccum: TglAccum;
  glPopAttrib: TglPopAttrib;
  glPushAttrib: TglPushAttrib;
  glMap1d: TglMap1d;
  glMap1f: TglMap1f;
  glMap2d: TglMap2d;
  glMap2f: TglMap2f;
  glMapGrid1d: TglMapGrid1d;
  glMapGrid1f: TglMapGrid1f;
  glMapGrid2d: TglMapGrid2d;
  glMapGrid2f: TglMapGrid2f;
  glEvalCoord1d: TglEvalCoord1d;
  glEvalCoord1dv: TglEvalCoord1dv;
  glEvalCoord1f: TglEvalCoord1f;
  glEvalCoord1fv: TglEvalCoord1fv;
  glEvalCoord2d: TglEvalCoord2d;
  glEvalCoord2dv: TglEvalCoord2dv;
  glEvalCoord2f: TglEvalCoord2f;
  glEvalCoord2fv: TglEvalCoord2fv;
  glEvalMesh1: TglEvalMesh1;
  glEvalPoint1: TglEvalPoint1;
  glEvalMesh2: TglEvalMesh2;
  glEvalPoint2: TglEvalPoint2;
  glAlphaFunc: TglAlphaFunc;
  glPixelZoom: TglPixelZoom;
  glPixelTransferf: TglPixelTransferf;
  glPixelTransferi: TglPixelTransferi;
  glPixelMapfv: TglPixelMapfv;
  glPixelMapuiv: TglPixelMapuiv;
  glPixelMapusv: TglPixelMapusv;
  glCopyPixels: TglCopyPixels;
  glDrawPixels: TglDrawPixels;
  glGetClipPlane: TglGetClipPlane;
  glGetLightfv: TglGetLightfv;
  glGetLightiv: TglGetLightiv;
  glGetMapdv: TglGetMapdv;
  glGetMapfv: TglGetMapfv;
  glGetMapiv: TglGetMapiv;
  glGetMaterialfv: TglGetMaterialfv;
  glGetMaterialiv: TglGetMaterialiv;
  glGetPixelMapfv: TglGetPixelMapfv;
  glGetPixelMapuiv: TglGetPixelMapuiv;
  glGetPixelMapusv: TglGetPixelMapusv;
  glGetPolygonStipple: TglGetPolygonStipple;
  glGetTexEnvfv: TglGetTexEnvfv;
  glGetTexEnviv: TglGetTexEnviv;
  glGetTexGendv: TglGetTexGendv;
  glGetTexGenfv: TglGetTexGenfv;
  glGetTexGeniv: TglGetTexGeniv;
  glIsList: TglIsList;
  glFrustum: TglFrustum;
  glLoadIdentity: TglLoadIdentity;
  glLoadMatrixf: TglLoadMatrixf;
  glLoadMatrixd: TglLoadMatrixd;
  glMatrixMode: TglMatrixMode;
  glMultMatrixf: TglMultMatrixf;
  glMultMatrixd: TglMultMatrixd;
  glOrtho: TglOrtho;
  glPopMatrix: TglPopMatrix;
  glPushMatrix: TglPushMatrix;
  glRotated: TglRotated;
  glRotatef: TglRotatef;
  glScaled: TglScaled;
  glScalef: TglScalef;
  glTranslated: TglTranslated;
  glTranslatef: TglTranslatef;

  // OpenGL 1.1
  glDrawArrays: TglDrawArrays;
  glDrawElements: TglDrawElements;
  glGetPointerv: TglGetPointerv;
  glPolygonOffset: TglPolygonOffset;
  glCopyTexImage1D: TglCopyTexImage1D;
  glCopyTexImage2D: TglCopyTexImage2D;
  glCopyTexSubImage1D: TglCopyTexSubImage1D;
  glCopyTexSubImage2D: TglCopyTexSubImage2D;
  glTexSubImage1D: TglTexSubImage1D;
  glTexSubImage2D: TglTexSubImage2D;
  glBindTexture: TglBindTexture;
  glDeleteTextures: TglDeleteTextures;
  glGenTextures: TglGenTextures;
  glIsTexture: TglIsTexture;
  glArrayElement: TglArrayElement;
  glColorPointer: TglColorPointer;
  glDisableClientState: TglDisableClientState;
  glEdgeFlagPointer: TglEdgeFlagPointer;
  glEnableClientState: TglEnableClientState;
  glIndexPointer: TglIndexPointer;
  glInterleavedArrays: TglInterleavedArrays;
  glNormalPointer: TglNormalPointer;
  glTexCoordPointer: TglTexCoordPointer;
  glVertexPointer: TglVertexPointer;
  glAreTexturesResident: TglAreTexturesResident;
  glPrioritizeTextures: TglPrioritizeTextures;
  glIndexub: TglIndexub;
  glIndexubv: TglIndexubv;
  glPopClientAttrib: TglPopClientAttrib;
  glPushClientAttrib: TglPushClientAttrib;

  // OpenGL 1.2
  glDrawRangeElements: TglDrawRangeElements;
  glTexImage3D: TglTexImage3D;
  glTexSubImage3D: TglTexSubImage3D;
  glCopyTexSubImage3D: TglCopyTexSubImage3D;

  // OpenGL 1.3
  glActiveTexture: TglActiveTexture;
  glSampleCoverage: TglSampleCoverage;
  glCompressedTexImage3D: TglCompressedTexImage3D;
  glCompressedTexImage2D: TglCompressedTexImage2D;
  glCompressedTexImage1D: TglCompressedTexImage1D;
  glCompressedTexSubImage3D: TglCompressedTexSubImage3D;
  glCompressedTexSubImage2D: TglCompressedTexSubImage2D;
  glCompressedTexSubImage1D: TglCompressedTexSubImage1D;
  glGetCompressedTexImage: TglGetCompressedTexImage;
  glClientActiveTexture: TglClientActiveTexture;
  glMultiTexCoord1d: TglMultiTexCoord1d;
  glMultiTexCoord1dv: TglMultiTexCoord1dv;
  glMultiTexCoord1f: TglMultiTexCoord1f;
  glMultiTexCoord1fv: TglMultiTexCoord1fv;
  glMultiTexCoord1i: TglMultiTexCoord1i;
  glMultiTexCoord1iv: TglMultiTexCoord1iv;
  glMultiTexCoord1s: TglMultiTexCoord1s;
  glMultiTexCoord1sv: TglMultiTexCoord1sv;
  glMultiTexCoord2d: TglMultiTexCoord2d;
  glMultiTexCoord2dv: TglMultiTexCoord2dv;
  glMultiTexCoord2f: TglMultiTexCoord2f;
  glMultiTexCoord2fv: TglMultiTexCoord2fv;
  glMultiTexCoord2i: TglMultiTexCoord2i;
  glMultiTexCoord2iv: TglMultiTexCoord2iv;
  glMultiTexCoord2s: TglMultiTexCoord2s;
  glMultiTexCoord2sv: TglMultiTexCoord2sv;
  glMultiTexCoord3d: TglMultiTexCoord3d;
  glMultiTexCoord3dv: TglMultiTexCoord3dv;
  glMultiTexCoord3f: TglMultiTexCoord3f;
  glMultiTexCoord3fv: TglMultiTexCoord3fv;
  glMultiTexCoord3i: TglMultiTexCoord3i;
  glMultiTexCoord3iv: TglMultiTexCoord3iv;
  glMultiTexCoord3s: TglMultiTexCoord3s;
  glMultiTexCoord3sv: TglMultiTexCoord3sv;
  glMultiTexCoord4d: TglMultiTexCoord4d;
  glMultiTexCoord4dv: TglMultiTexCoord4dv;
  glMultiTexCoord4f: TglMultiTexCoord4f;
  glMultiTexCoord4fv: TglMultiTexCoord4fv;
  glMultiTexCoord4i: TglMultiTexCoord4i;
  glMultiTexCoord4iv: TglMultiTexCoord4iv;
  glMultiTexCoord4s: TglMultiTexCoord4s;
  glMultiTexCoord4sv: TglMultiTexCoord4sv;
  glLoadTransposeMatrixf: TglLoadTransposeMatrixf;
  glLoadTransposeMatrixd: TglLoadTransposeMatrixd;
  glMultTransposeMatrixf: TglMultTransposeMatrixf;
  glMultTransposeMatrixd: TglMultTransposeMatrixd;

  // OpenGL 1.4
  glBlendFuncSeparate: TglBlendFuncSeparate;
  glMultiDrawArrays: TglMultiDrawArrays;
  glMultiDrawElements: TglMultiDrawElements;
  glPointParameterf: TglPointParameterf;
  glPointParameterfv: TglPointParameterfv;
  glPointParameteri: TglPointParameteri;
  glPointParameteriv: TglPointParameteriv;
  glFogCoordf: TglFogCoordf;
  glFogCoordfv: TglFogCoordfv;
  glFogCoordd: TglFogCoordd;
  glFogCoorddv: TglFogCoorddv;
  glFogCoordPointer: TglFogCoordPointer;
  glSecondaryColor3b: TglSecondaryColor3b;
  glSecondaryColor3bv: TglSecondaryColor3bv;
  glSecondaryColor3d: TglSecondaryColor3d;
  glSecondaryColor3dv: TglSecondaryColor3dv;
  glSecondaryColor3f: TglSecondaryColor3f;
  glSecondaryColor3fv: TglSecondaryColor3fv;
  glSecondaryColor3i: TglSecondaryColor3i;
  glSecondaryColor3iv: TglSecondaryColor3iv;
  glSecondaryColor3s: TglSecondaryColor3s;
  glSecondaryColor3sv: TglSecondaryColor3sv;
  glSecondaryColor3ub: TglSecondaryColor3ub;
  glSecondaryColor3ubv: TglSecondaryColor3ubv;
  glSecondaryColor3ui: TglSecondaryColor3ui;
  glSecondaryColor3uiv: TglSecondaryColor3uiv;
  glSecondaryColor3us: TglSecondaryColor3us;
  glSecondaryColor3usv: TglSecondaryColor3usv;
  glSecondaryColorPointer: TglSecondaryColorPointer;
  glWindowPos2d: TglWindowPos2d;
  glWindowPos2dv: TglWindowPos2dv;
  glWindowPos2f: TglWindowPos2f;
  glWindowPos2fv: TglWindowPos2fv;
  glWindowPos2i: TglWindowPos2i;
  glWindowPos2iv: TglWindowPos2iv;
  glWindowPos2s: TglWindowPos2s;
  glWindowPos2sv: TglWindowPos2sv;
  glWindowPos3d: TglWindowPos3d;
  glWindowPos3dv: TglWindowPos3dv;
  glWindowPos3f: TglWindowPos3f;
  glWindowPos3fv: TglWindowPos3fv;
  glWindowPos3i: TglWindowPos3i;
  glWindowPos3iv: TglWindowPos3iv;
  glWindowPos3s: TglWindowPos3s;
  glWindowPos3sv: TglWindowPos3sv;
  glBlendColor: TglBlendColor;
  glBlendEquation: TglBlendEquation;

  // OpenGL 1.5
  glGenQueries: TglGenQueries;
  glDeleteQueries: TglDeleteQueries;
  glIsQuery: TglIsQuery;
  glBeginQuery: TglBeginQuery;
  glEndQuery: TglEndQuery;
  glGetQueryiv: TglGetQueryiv;
  glGetQueryObjectiv: TglGetQueryObjectiv;
  glGetQueryObjectuiv: TglGetQueryObjectuiv;
  glBindBuffer: TglBindBuffer;
  glDeleteBuffers: TglDeleteBuffers;
  glGenBuffers: TglGenBuffers;
  glIsBuffer: TglIsBuffer;
  glBufferData: TglBufferData;
  glBufferSubData: TglBufferSubData;
  glGetBufferSubData: TglGetBufferSubData;
  glMapBuffer: TglMapBuffer;
  glUnmapBuffer: TglUnmapBuffer;
  glGetBufferParameteriv: TglGetBufferParameteriv;
  glGetBufferPointerv: TglGetBufferPointerv;

  // OpenGL 2.0
  glBlendEquationSeparate: TglBlendEquationSeparate;
  glDrawBuffers: TglDrawBuffers;
  glStencilOpSeparate: TglStencilOpSeparate;
  glStencilFuncSeparate: TglStencilFuncSeparate;
  glStencilMaskSeparate: TglStencilMaskSeparate;
  glAttachShader: TglAttachShader;
  glBindAttribLocation: TglBindAttribLocation;
  glCompileShader: TglCompileShader;
  glCreateProgram: TglCreateProgram;
  glCreateShader: TglCreateShader;
  glDeleteProgram: TglDeleteProgram;
  glDeleteShader: TglDeleteShader;
  glDetachShader: TglDetachShader;
  glDisableVertexAttribArray: TglDisableVertexAttribArray;
  glEnableVertexAttribArray: TglEnableVertexAttribArray;
  glGetActiveAttrib: TglGetActiveAttrib;
  glGetActiveUniform: TglGetActiveUniform;
  glGetAttachedShaders: TglGetAttachedShaders;
  glGetAttribLocation: TglGetAttribLocation;
  glGetProgramiv: TglGetProgramiv;
  glGetProgramInfoLog: TglGetProgramInfoLog;
  glGetShaderiv: TglGetShaderiv;
  glGetShaderInfoLog: TglGetShaderInfoLog;
  glGetShaderSource: TglGetShaderSource;
  glGetUniformLocation: TglGetUniformLocation;
  glGetUniformfv: TglGetUniformfv;
  glGetUniformiv: TglGetUniformiv;
  glGetVertexAttribdv: TglGetVertexAttribdv;
  glGetVertexAttribfv: TglGetVertexAttribfv;
  glGetVertexAttribiv: TglGetVertexAttribiv;
  glGetVertexAttribPointerv: TglGetVertexAttribPointerv;
  glIsProgram: TglIsProgram;
  glIsShader: TglIsShader;
  glLinkProgram: TglLinkProgram;
  glShaderSource: TglShaderSource;
  glUseProgram: TglUseProgram;
  glUniform1f: TglUniform1f;
  glUniform2f: TglUniform2f;
  glUniform3f: TglUniform3f;
  glUniform4f: TglUniform4f;
  glUniform1i: TglUniform1i;
  glUniform2i: TglUniform2i;
  glUniform3i: TglUniform3i;
  glUniform4i: TglUniform4i;
  glUniform1fv: TglUniform1fv;
  glUniform2fv: TglUniform2fv;
  glUniform3fv: TglUniform3fv;
  glUniform4fv: TglUniform4fv;
  glUniform1iv: TglUniform1iv;
  glUniform2iv: TglUniform2iv;
  glUniform3iv: TglUniform3iv;
  glUniform4iv: TglUniform4iv;
  glUniformMatrix2fv: TglUniformMatrix2fv;
  glUniformMatrix3fv: TglUniformMatrix3fv;
  glUniformMatrix4fv: TglUniformMatrix4fv;
  glValidateProgram: TglValidateProgram;
  glVertexAttrib1d: TglVertexAttrib1d;
  glVertexAttrib1dv: TglVertexAttrib1dv;
  glVertexAttrib1f: TglVertexAttrib1f;
  glVertexAttrib1fv: TglVertexAttrib1fv;
  glVertexAttrib1s: TglVertexAttrib1s;
  glVertexAttrib1sv: TglVertexAttrib1sv;
  glVertexAttrib2d: TglVertexAttrib2d;
  glVertexAttrib2dv: TglVertexAttrib2dv;
  glVertexAttrib2f: TglVertexAttrib2f;
  glVertexAttrib2fv: TglVertexAttrib2fv;
  glVertexAttrib2s: TglVertexAttrib2s;
  glVertexAttrib2sv: TglVertexAttrib2sv;
  glVertexAttrib3d: TglVertexAttrib3d;
  glVertexAttrib3dv: TglVertexAttrib3dv;
  glVertexAttrib3f: TglVertexAttrib3f;
  glVertexAttrib3fv: TglVertexAttrib3fv;
  glVertexAttrib3s: TglVertexAttrib3s;
  glVertexAttrib3sv: TglVertexAttrib3sv;
  glVertexAttrib4Nbv: TglVertexAttrib4Nbv;
  glVertexAttrib4Niv: TglVertexAttrib4Niv;
  glVertexAttrib4Nsv: TglVertexAttrib4Nsv;
  glVertexAttrib4Nub: TglVertexAttrib4Nub;
  glVertexAttrib4Nubv: TglVertexAttrib4Nubv;
  glVertexAttrib4Nuiv: TglVertexAttrib4Nuiv;
  glVertexAttrib4Nusv: TglVertexAttrib4Nusv;
  glVertexAttrib4bv: TglVertexAttrib4bv;
  glVertexAttrib4d: TglVertexAttrib4d;
  glVertexAttrib4dv: TglVertexAttrib4dv;
  glVertexAttrib4f: TglVertexAttrib4f;
  glVertexAttrib4fv: TglVertexAttrib4fv;
  glVertexAttrib4iv: TglVertexAttrib4iv;
  glVertexAttrib4s: TglVertexAttrib4s;
  glVertexAttrib4sv: TglVertexAttrib4sv;
  glVertexAttrib4ubv: TglVertexAttrib4ubv;
  glVertexAttrib4uiv: TglVertexAttrib4uiv;
  glVertexAttrib4usv: TglVertexAttrib4usv;
  glVertexAttribPointer: TglVertexAttribPointer;

  // OpenGL 2.1
  glUniformMatrix2x3fv: TglUniformMatrix2x3fv;
  glUniformMatrix3x2fv: TglUniformMatrix3x2fv;
  glUniformMatrix2x4fv: TglUniformMatrix2x4fv;
  glUniformMatrix4x2fv: TglUniformMatrix4x2fv;
  glUniformMatrix3x4fv: TglUniformMatrix3x4fv;
  glUniformMatrix4x3fv: TglUniformMatrix4x3fv;

  // OpenGL 3.0
  glColorMaski: TglColorMaski;
  glGetBooleani_v: TglGetBooleani_v;
  glGetIntegeri_v: TglGetIntegeri_v;
  glEnablei: TglEnablei;
  glDisablei: TglDisablei;
  glIsEnabledi: TglIsEnabledi;
  glBeginTransformFeedback: TglBeginTransformFeedback;
  glEndTransformFeedback: TglEndTransformFeedback;
  glBindBufferRange: TglBindBufferRange;
  glBindBufferBase: TglBindBufferBase;
  glTransformFeedbackVaryings: TglTransformFeedbackVaryings;
  glGetTransformFeedbackVarying: TglGetTransformFeedbackVarying;
  glClampColor: TglClampColor;
  glBeginConditionalRender: TglBeginConditionalRender;
  glEndConditionalRender: TglEndConditionalRender;
  glVertexAttribIPointer: TglVertexAttribIPointer;
  glGetVertexAttribIiv: TglGetVertexAttribIiv;
  glGetVertexAttribIuiv: TglGetVertexAttribIuiv;
  glVertexAttribI1i: TglVertexAttribI1i;
  glVertexAttribI2i: TglVertexAttribI2i;
  glVertexAttribI3i: TglVertexAttribI3i;
  glVertexAttribI4i: TglVertexAttribI4i;
  glVertexAttribI1ui: TglVertexAttribI1ui;
  glVertexAttribI2ui: TglVertexAttribI2ui;
  glVertexAttribI3ui: TglVertexAttribI3ui;
  glVertexAttribI4ui: TglVertexAttribI4ui;
  glVertexAttribI1iv: TglVertexAttribI1iv;
  glVertexAttribI2iv: TglVertexAttribI2iv;
  glVertexAttribI3iv: TglVertexAttribI3iv;
  glVertexAttribI4iv: TglVertexAttribI4iv;
  glVertexAttribI1uiv: TglVertexAttribI1uiv;
  glVertexAttribI2uiv: TglVertexAttribI2uiv;
  glVertexAttribI3uiv: TglVertexAttribI3uiv;
  glVertexAttribI4uiv: TglVertexAttribI4uiv;
  glVertexAttribI4bv: TglVertexAttribI4bv;
  glVertexAttribI4sv: TglVertexAttribI4sv;
  glVertexAttribI4ubv: TglVertexAttribI4ubv;
  glVertexAttribI4usv: TglVertexAttribI4usv;
  glGetUniformuiv: TglGetUniformuiv;
  glBindFragDataLocation: TglBindFragDataLocation;
  glGetFragDataLocation: TglGetFragDataLocation;
  glUniform1ui: TglUniform1ui;
  glUniform2ui: TglUniform2ui;
  glUniform3ui: TglUniform3ui;
  glUniform4ui: TglUniform4ui;
  glUniform1uiv: TglUniform1uiv;
  glUniform2uiv: TglUniform2uiv;
  glUniform3uiv: TglUniform3uiv;
  glUniform4uiv: TglUniform4uiv;
  glTexParameterIiv: TglTexParameterIiv;
  glTexParameterIuiv: TglTexParameterIuiv;
  glGetTexParameterIiv: TglGetTexParameterIiv;
  glGetTexParameterIuiv: TglGetTexParameterIuiv;
  glClearBufferiv: TglClearBufferiv;
  glClearBufferuiv: TglClearBufferuiv;
  glClearBufferfv: TglClearBufferfv;
  glClearBufferfi: TglClearBufferfi;
  glGetStringi: TglGetStringi;
  glIsRenderbuffer: TglIsRenderbuffer;
  glBindRenderbuffer: TglBindRenderbuffer;
  glDeleteRenderbuffers: TglDeleteRenderbuffers;
  glGenRenderbuffers: TglGenRenderbuffers;
  glRenderbufferStorage: TglRenderbufferStorage;
  glGetRenderbufferParameteriv: TglGetRenderbufferParameteriv;
  glIsFramebuffer: TglIsFramebuffer;
  glBindFramebuffer: TglBindFramebuffer;
  glDeleteFramebuffers: TglDeleteFramebuffers;
  glGenFramebuffers: TglGenFramebuffers;
  glCheckFramebufferStatus: TglCheckFramebufferStatus;
  glFramebufferTexture1D: TglFramebufferTexture1D;
  glFramebufferTexture2D: TglFramebufferTexture2D;
  glFramebufferTexture3D: TglFramebufferTexture3D;
  glFramebufferRenderbuffer: TglFramebufferRenderbuffer;
  glGetFramebufferAttachmentParameteriv: TglGetFramebufferAttachmentParameteriv;
  glGenerateMipmap: TglGenerateMipmap;
  glBlitFramebuffer: TglBlitFramebuffer;
  glRenderbufferStorageMultisample: TglRenderbufferStorageMultisample;
  glFramebufferTextureLayer: TglFramebufferTextureLayer;
  glMapBufferRange: TglMapBufferRange;
  glFlushMappedBufferRange: TglFlushMappedBufferRange;
  glBindVertexArray: TglBindVertexArray;
  glDeleteVertexArrays: TglDeleteVertexArrays;
  glGenVertexArrays: TglGenVertexArrays;
  glIsVertexArray: TglIsVertexArray;

  // OpenGL 3.1
  glDrawArraysInstanced: TglDrawArraysInstanced;
  glDrawElementsInstanced: TglDrawElementsInstanced;
  glTexBuffer: TglTexBuffer;
  glPrimitiveRestartIndex: TglPrimitiveRestartIndex;
  glCopyBufferSubData: TglCopyBufferSubData;
  glGetUniformIndices: TglGetUniformIndices;
  glGetActiveUniformsiv: TglGetActiveUniformsiv;
  glGetActiveUniformName: TglGetActiveUniformName;
  glGetUniformBlockIndex: TglGetUniformBlockIndex;
  glGetActiveUniformBlockiv: TglGetActiveUniformBlockiv;
  glGetActiveUniformBlockName: TglGetActiveUniformBlockName;
  glUniformBlockBinding: TglUniformBlockBinding;

  // OpenGL 3.2
  glDrawElementsBaseVertex: TglDrawElementsBaseVertex;
  glDrawRangeElementsBaseVertex: TglDrawRangeElementsBaseVertex;
  glDrawElementsInstancedBaseVertex: TglDrawElementsInstancedBaseVertex;
  glMultiDrawElementsBaseVertex: TglMultiDrawElementsBaseVertex;
  glProvokingVertex: TglProvokingVertex;
  glFenceSync: TglFenceSync;
  glIsSync: TglIsSync;
  glDeleteSync: TglDeleteSync;
  glClientWaitSync: TglClientWaitSync;
  glWaitSync: TglWaitSync;
  glGetInteger64v: TglGetInteger64v;
  glGetSynciv: TglGetSynciv;
  glGetInteger64i_v: TglGetInteger64i_v;
  glGetBufferParameteri64v: TglGetBufferParameteri64v;
  glFramebufferTexture: TglFramebufferTexture;
  glTexImage2DMultisample: TglTexImage2DMultisample;
  glTexImage3DMultisample: TglTexImage3DMultisample;
  glGetMultisamplefv: TglGetMultisamplefv;
  glSampleMaski: TglSampleMaski;

  // OpenGL 3.3
  glBindFragDataLocationIndexed: TglBindFragDataLocationIndexed;
  glGetFragDataIndex: TglGetFragDataIndex;
  glGenSamplers: TglGenSamplers;
  glDeleteSamplers: TglDeleteSamplers;
  glIsSampler: TglIsSampler;
  glBindSampler: TglBindSampler;
  glSamplerParameteri: TglSamplerParameteri;
  glSamplerParameteriv: TglSamplerParameteriv;
  glSamplerParameterf: TglSamplerParameterf;
  glSamplerParameterfv: TglSamplerParameterfv;
  glSamplerParameterIiv: TglSamplerParameterIiv;
  glSamplerParameterIuiv: TglSamplerParameterIuiv;
  glGetSamplerParameteriv: TglGetSamplerParameteriv;
  glGetSamplerParameterIiv: TglGetSamplerParameterIiv;
  glGetSamplerParameterfv: TglGetSamplerParameterfv;
  glGetSamplerParameterIuiv: TglGetSamplerParameterIuiv;
  glQueryCounter: TglQueryCounter;
  glGetQueryObjecti64v: TglGetQueryObjecti64v;
  glGetQueryObjectui64v: TglGetQueryObjectui64v;
  glVertexAttribDivisor: TglVertexAttribDivisor;
  glVertexAttribP1ui: TglVertexAttribP1ui;
  glVertexAttribP1uiv: TglVertexAttribP1uiv;
  glVertexAttribP2ui: TglVertexAttribP2ui;
  glVertexAttribP2uiv: TglVertexAttribP2uiv;
  glVertexAttribP3ui: TglVertexAttribP3ui;
  glVertexAttribP3uiv: TglVertexAttribP3uiv;
  glVertexAttribP4ui: TglVertexAttribP4ui;
  glVertexAttribP4uiv: TglVertexAttribP4uiv;
  glVertexP2ui: TglVertexP2ui;
  glVertexP2uiv: TglVertexP2uiv;
  glVertexP3ui: TglVertexP3ui;
  glVertexP3uiv: TglVertexP3uiv;
  glVertexP4ui: TglVertexP4ui;
  glVertexP4uiv: TglVertexP4uiv;
  glTexCoordP1ui: TglTexCoordP1ui;
  glTexCoordP1uiv: TglTexCoordP1uiv;
  glTexCoordP2ui: TglTexCoordP2ui;
  glTexCoordP2uiv: TglTexCoordP2uiv;
  glTexCoordP3ui: TglTexCoordP3ui;
  glTexCoordP3uiv: TglTexCoordP3uiv;
  glTexCoordP4ui: TglTexCoordP4ui;
  glTexCoordP4uiv: TglTexCoordP4uiv;
  glMultiTexCoordP1ui: TglMultiTexCoordP1ui;
  glMultiTexCoordP1uiv: TglMultiTexCoordP1uiv;
  glMultiTexCoordP2ui: TglMultiTexCoordP2ui;
  glMultiTexCoordP2uiv: TglMultiTexCoordP2uiv;
  glMultiTexCoordP3ui: TglMultiTexCoordP3ui;
  glMultiTexCoordP3uiv: TglMultiTexCoordP3uiv;
  glMultiTexCoordP4ui: TglMultiTexCoordP4ui;
  glMultiTexCoordP4uiv: TglMultiTexCoordP4uiv;
  glNormalP3ui: TglNormalP3ui;
  glNormalP3uiv: TglNormalP3uiv;
  glColorP3ui: TglColorP3ui;
  glColorP3uiv: TglColorP3uiv;
  glColorP4ui: TglColorP4ui;
  glColorP4uiv: TglColorP4uiv;
  glSecondaryColorP3ui: TglSecondaryColorP3ui;
  glSecondaryColorP3uiv: TglSecondaryColorP3uiv;

  // OpenGL 4.0
  glMinSampleShading: TglMinSampleShading;
  glBlendEquationi: TglBlendEquationi;
  glBlendEquationSeparatei: TglBlendEquationSeparatei;
  glBlendFunci: TglBlendFunci;
  glBlendFuncSeparatei: TglBlendFuncSeparatei;
  glDrawArraysIndirect: TglDrawArraysIndirect;
  glDrawElementsIndirect: TglDrawElementsIndirect;
  glUniform1d: TglUniform1d;
  glUniform2d: TglUniform2d;
  glUniform3d: TglUniform3d;
  glUniform4d: TglUniform4d;
  glUniform1dv: TglUniform1dv;
  glUniform2dv: TglUniform2dv;
  glUniform3dv: TglUniform3dv;
  glUniform4dv: TglUniform4dv;
  glUniformMatrix2dv: TglUniformMatrix2dv;
  glUniformMatrix3dv: TglUniformMatrix3dv;
  glUniformMatrix4dv: TglUniformMatrix4dv;
  glUniformMatrix2x3dv: TglUniformMatrix2x3dv;
  glUniformMatrix2x4dv: TglUniformMatrix2x4dv;
  glUniformMatrix3x2dv: TglUniformMatrix3x2dv;
  glUniformMatrix3x4dv: TglUniformMatrix3x4dv;
  glUniformMatrix4x2dv: TglUniformMatrix4x2dv;
  glUniformMatrix4x3dv: TglUniformMatrix4x3dv;
  glGetUniformdv: TglGetUniformdv;
  glGetSubroutineUniformLocation: TglGetSubroutineUniformLocation;
  glGetSubroutineIndex: TglGetSubroutineIndex;
  glGetActiveSubroutineUniformiv: TglGetActiveSubroutineUniformiv;
  glGetActiveSubroutineUniformName: TglGetActiveSubroutineUniformName;
  glGetActiveSubroutineName: TglGetActiveSubroutineName;
  glUniformSubroutinesuiv: TglUniformSubroutinesuiv;
  glGetUniformSubroutineuiv: TglGetUniformSubroutineuiv;
  glGetProgramStageiv: TglGetProgramStageiv;
  glPatchParameteri: TglPatchParameteri;
  glPatchParameterfv: TglPatchParameterfv;
  glBindTransformFeedback: TglBindTransformFeedback;
  glDeleteTransformFeedbacks: TglDeleteTransformFeedbacks;
  glGenTransformFeedbacks: TglGenTransformFeedbacks;
  glIsTransformFeedback: TglIsTransformFeedback;
  glPauseTransformFeedback: TglPauseTransformFeedback;
  glResumeTransformFeedback: TglResumeTransformFeedback;
  glDrawTransformFeedback: TglDrawTransformFeedback;
  glDrawTransformFeedbackStream: TglDrawTransformFeedbackStream;
  glBeginQueryIndexed: TglBeginQueryIndexed;
  glEndQueryIndexed: TglEndQueryIndexed;
  glGetQueryIndexediv: TglGetQueryIndexediv;

  // OpenGL 4.1
  glReleaseShaderCompiler: TglReleaseShaderCompiler;
  glShaderBinary: TglShaderBinary;
  glGetShaderPrecisionFormat: TglGetShaderPrecisionFormat;
  glDepthRangef: TglDepthRangef;
  glClearDepthf: TglClearDepthf;
  glGetProgramBinary: TglGetProgramBinary;
  glProgramBinary: TglProgramBinary;
  glProgramParameteri: TglProgramParameteri;
  glUseProgramStages: TglUseProgramStages;
  glActiveShaderProgram: TglActiveShaderProgram;
  glCreateShaderProgramv: TglCreateShaderProgramv;
  glBindProgramPipeline: TglBindProgramPipeline;
  glDeleteProgramPipelines: TglDeleteProgramPipelines;
  glGenProgramPipelines: TglGenProgramPipelines;
  glIsProgramPipeline: TglIsProgramPipeline;
  glGetProgramPipelineiv: TglGetProgramPipelineiv;
  glProgramUniform1i: TglProgramUniform1i;
  glProgramUniform1iv: TglProgramUniform1iv;
  glProgramUniform1f: TglProgramUniform1f;
  glProgramUniform1fv: TglProgramUniform1fv;
  glProgramUniform1d: TglProgramUniform1d;
  glProgramUniform1dv: TglProgramUniform1dv;
  glProgramUniform1ui: TglProgramUniform1ui;
  glProgramUniform1uiv: TglProgramUniform1uiv;
  glProgramUniform2i: TglProgramUniform2i;
  glProgramUniform2iv: TglProgramUniform2iv;
  glProgramUniform2f: TglProgramUniform2f;
  glProgramUniform2fv: TglProgramUniform2fv;
  glProgramUniform2d: TglProgramUniform2d;
  glProgramUniform2dv: TglProgramUniform2dv;
  glProgramUniform2ui: TglProgramUniform2ui;
  glProgramUniform2uiv: TglProgramUniform2uiv;
  glProgramUniform3i: TglProgramUniform3i;
  glProgramUniform3iv: TglProgramUniform3iv;
  glProgramUniform3f: TglProgramUniform3f;
  glProgramUniform3fv: TglProgramUniform3fv;
  glProgramUniform3d: TglProgramUniform3d;
  glProgramUniform3dv: TglProgramUniform3dv;
  glProgramUniform3ui: TglProgramUniform3ui;
  glProgramUniform3uiv: TglProgramUniform3uiv;
  glProgramUniform4i: TglProgramUniform4i;
  glProgramUniform4iv: TglProgramUniform4iv;
  glProgramUniform4f: TglProgramUniform4f;
  glProgramUniform4fv: TglProgramUniform4fv;
  glProgramUniform4d: TglProgramUniform4d;
  glProgramUniform4dv: TglProgramUniform4dv;
  glProgramUniform4ui: TglProgramUniform4ui;
  glProgramUniform4uiv: TglProgramUniform4uiv;
  glProgramUniformMatrix2fv: TglProgramUniformMatrix2fv;
  glProgramUniformMatrix3fv: TglProgramUniformMatrix3fv;
  glProgramUniformMatrix4fv: TglProgramUniformMatrix4fv;
  glProgramUniformMatrix2dv: TglProgramUniformMatrix2dv;
  glProgramUniformMatrix3dv: TglProgramUniformMatrix3dv;
  glProgramUniformMatrix4dv: TglProgramUniformMatrix4dv;
  glProgramUniformMatrix2x3fv: TglProgramUniformMatrix2x3fv;
  glProgramUniformMatrix3x2fv: TglProgramUniformMatrix3x2fv;
  glProgramUniformMatrix2x4fv: TglProgramUniformMatrix2x4fv;
  glProgramUniformMatrix4x2fv: TglProgramUniformMatrix4x2fv;
  glProgramUniformMatrix3x4fv: TglProgramUniformMatrix3x4fv;
  glProgramUniformMatrix4x3fv: TglProgramUniformMatrix4x3fv;
  glProgramUniformMatrix2x3dv: TglProgramUniformMatrix2x3dv;
  glProgramUniformMatrix3x2dv: TglProgramUniformMatrix3x2dv;
  glProgramUniformMatrix2x4dv: TglProgramUniformMatrix2x4dv;
  glProgramUniformMatrix4x2dv: TglProgramUniformMatrix4x2dv;
  glProgramUniformMatrix3x4dv: TglProgramUniformMatrix3x4dv;
  glProgramUniformMatrix4x3dv: TglProgramUniformMatrix4x3dv;
  glValidateProgramPipeline: TglValidateProgramPipeline;
  glGetProgramPipelineInfoLog: TglGetProgramPipelineInfoLog;
  glVertexAttribL1d: TglVertexAttribL1d;
  glVertexAttribL2d: TglVertexAttribL2d;
  glVertexAttribL3d: TglVertexAttribL3d;
  glVertexAttribL4d: TglVertexAttribL4d;
  glVertexAttribL1dv: TglVertexAttribL1dv;
  glVertexAttribL2dv: TglVertexAttribL2dv;
  glVertexAttribL3dv: TglVertexAttribL3dv;
  glVertexAttribL4dv: TglVertexAttribL4dv;
  glVertexAttribLPointer: TglVertexAttribLPointer;
  glGetVertexAttribLdv: TglGetVertexAttribLdv;
  glViewportArrayv: TglViewportArrayv;
  glViewportIndexedf: TglViewportIndexedf;
  glViewportIndexedfv: TglViewportIndexedfv;
  glScissorArrayv: TglScissorArrayv;
  glScissorIndexed: TglScissorIndexed;
  glScissorIndexedv: TglScissorIndexedv;
  glDepthRangeArrayv: TglDepthRangeArrayv;
  glDepthRangeIndexed: TglDepthRangeIndexed;
  glGetFloati_v: TglGetFloati_v;
  glGetDoublei_v: TglGetDoublei_v;

  // OpenGL 4.2
  glDrawArraysInstancedBaseInstance: TglDrawArraysInstancedBaseInstance;
  glDrawElementsInstancedBaseInstance: TglDrawElementsInstancedBaseInstance;
  glDrawElementsInstancedBaseVertexBaseInstance: TglDrawElementsInstancedBaseVertexBaseInstance;
  glGetInternalformativ: TglGetInternalformativ;
  glGetActiveAtomicCounterBufferiv: TglGetActiveAtomicCounterBufferiv;
  glBindImageTexture: TglBindImageTexture;
  glMemoryBarrier: TglMemoryBarrier;
  glTexStorage1D: TglTexStorage1D;
  glTexStorage2D: TglTexStorage2D;
  glTexStorage3D: TglTexStorage3D;
  glDrawTransformFeedbackInstanced: TglDrawTransformFeedbackInstanced;
  glDrawTransformFeedbackStreamInstanced: TglDrawTransformFeedbackStreamInstanced;

  // OpenGL 4.3
  glClearBufferData: TglClearBufferData;
  glClearBufferSubData: TglClearBufferSubData;
  glDispatchCompute: TglDispatchCompute;
  glDispatchComputeIndirect: TglDispatchComputeIndirect;
  glCopyImageSubData: TglCopyImageSubData;
  glFramebufferParameteri: TglFramebufferParameteri;
  glGetFramebufferParameteriv: TglGetFramebufferParameteriv;
  glGetInternalformati64v: TglGetInternalformati64v;
  glInvalidateTexSubImage: TglInvalidateTexSubImage;
  glInvalidateTexImage: TglInvalidateTexImage;
  glInvalidateBufferSubData: TglInvalidateBufferSubData;
  glInvalidateBufferData: TglInvalidateBufferData;
  glInvalidateFramebuffer: TglInvalidateFramebuffer;
  glInvalidateSubFramebuffer: TglInvalidateSubFramebuffer;
  glMultiDrawArraysIndirect: TglMultiDrawArraysIndirect;
  glMultiDrawElementsIndirect: TglMultiDrawElementsIndirect;
  glGetProgramInterfaceiv: TglGetProgramInterfaceiv;
  glGetProgramResourceIndex: TglGetProgramResourceIndex;
  glGetProgramResourceName: TglGetProgramResourceName;
  glGetProgramResourceiv: TglGetProgramResourceiv;
  glGetProgramResourceLocation: TglGetProgramResourceLocation;
  glGetProgramResourceLocationIndex: TglGetProgramResourceLocationIndex;
  glShaderStorageBlockBinding: TglShaderStorageBlockBinding;
  glTexBufferRange: TglTexBufferRange;
  glTexStorage2DMultisample: TglTexStorage2DMultisample;
  glTexStorage3DMultisample: TglTexStorage3DMultisample;
  glTextureView: TglTextureView;
  glBindVertexBuffer: TglBindVertexBuffer;
  glVertexAttribFormat: TglVertexAttribFormat;
  glVertexAttribIFormat: TglVertexAttribIFormat;
  glVertexAttribLFormat: TglVertexAttribLFormat;
  glVertexAttribBinding: TglVertexAttribBinding;
  glVertexBindingDivisor: TglVertexBindingDivisor;
  glDebugMessageControl: TglDebugMessageControl;
  glDebugMessageInsert: TglDebugMessageInsert;
  glDebugMessageCallback: TglDebugMessageCallback;
  glGetDebugMessageLog: TglGetDebugMessageLog;
  glPushDebugGroup: TglPushDebugGroup;
  glPopDebugGroup: TglPopDebugGroup;
  glObjectLabel: TglObjectLabel;
  glGetObjectLabel: TglGetObjectLabel;
  glObjectPtrLabel: TglObjectPtrLabel;
  glGetObjectPtrLabel: TglGetObjectPtrLabel;

  // OpenGL 4.4
  glBufferStorage: TglBufferStorage;
  glClearTexImage: TglClearTexImage;
  glClearTexSubImage: TglClearTexSubImage;
  glBindBuffersBase: TglBindBuffersBase;
  glBindBuffersRange: TglBindBuffersRange;
  glBindTextures: TglBindTextures;
  glBindSamplers: TglBindSamplers;
  glBindImageTextures: TglBindImageTextures;
  glBindVertexBuffers: TglBindVertexBuffers;

  // OpenGL 4.5
  glClipControl: TglClipControl;
  glCreateTransformFeedbacks: TglCreateTransformFeedbacks;
  glTransformFeedbackBufferBase: TglTransformFeedbackBufferBase;
  glTransformFeedbackBufferRange: TglTransformFeedbackBufferRange;
  glGetTransformFeedbackiv: TglGetTransformFeedbackiv;
  glGetTransformFeedbacki_v: TglGetTransformFeedbacki_v;
  glGetTransformFeedbacki64_v: TglGetTransformFeedbacki64_v;
  glCreateBuffers: TglCreateBuffers;
  glNamedBufferStorage: TglNamedBufferStorage;
  glNamedBufferData: TglNamedBufferData;
  glNamedBufferSubData: TglNamedBufferSubData;
  glCopyNamedBufferSubData: TglCopyNamedBufferSubData;
  glClearNamedBufferData: TglClearNamedBufferData;
  glClearNamedBufferSubData: TglClearNamedBufferSubData;
  glMapNamedBuffer: TglMapNamedBuffer;
  glMapNamedBufferRange: TglMapNamedBufferRange;
  glUnmapNamedBuffer: TglUnmapNamedBuffer;
  glFlushMappedNamedBufferRange: TglFlushMappedNamedBufferRange;
  glGetNamedBufferParameteriv: TglGetNamedBufferParameteriv;
  glGetNamedBufferParameteri64v: TglGetNamedBufferParameteri64v;
  glGetNamedBufferPointerv: TglGetNamedBufferPointerv;
  glGetNamedBufferSubData: TglGetNamedBufferSubData;
  glCreateFramebuffers: TglCreateFramebuffers;
  glNamedFramebufferRenderbuffer: TglNamedFramebufferRenderbuffer;
  glNamedFramebufferParameteri: TglNamedFramebufferParameteri;
  glNamedFramebufferTexture: TglNamedFramebufferTexture;
  glNamedFramebufferTextureLayer: TglNamedFramebufferTextureLayer;
  glNamedFramebufferDrawBuffer: TglNamedFramebufferDrawBuffer;
  glNamedFramebufferDrawBuffers: TglNamedFramebufferDrawBuffers;
  glNamedFramebufferReadBuffer: TglNamedFramebufferReadBuffer;
  glInvalidateNamedFramebufferData: TglInvalidateNamedFramebufferData;
  glInvalidateNamedFramebufferSubData: TglInvalidateNamedFramebufferSubData;
  glClearNamedFramebufferiv: TglClearNamedFramebufferiv;
  glClearNamedFramebufferuiv: TglClearNamedFramebufferuiv;
  glClearNamedFramebufferfv: TglClearNamedFramebufferfv;
  glClearNamedFramebufferfi: TglClearNamedFramebufferfi;
  glBlitNamedFramebuffer: TglBlitNamedFramebuffer;
  glCheckNamedFramebufferStatus: TglCheckNamedFramebufferStatus;
  glGetNamedFramebufferParameteriv: TglGetNamedFramebufferParameteriv;
  glGetNamedFramebufferAttachmentParameteriv: TglGetNamedFramebufferAttachmentParameteriv;
  glCreateRenderbuffers: TglCreateRenderbuffers;
  glNamedRenderbufferStorage: TglNamedRenderbufferStorage;
  glNamedRenderbufferStorageMultisample: TglNamedRenderbufferStorageMultisample;
  glGetNamedRenderbufferParameteriv: TglGetNamedRenderbufferParameteriv;
  glCreateTextures: TglCreateTextures;
  glTextureBuffer: TglTextureBuffer;
  glTextureBufferRange: TglTextureBufferRange;
  glTextureStorage1D: TglTextureStorage1D;
  glTextureStorage2D: TglTextureStorage2D;
  glTextureStorage3D: TglTextureStorage3D;
  glTextureStorage2DMultisample: TglTextureStorage2DMultisample;
  glTextureStorage3DMultisample: TglTextureStorage3DMultisample;
  glTextureSubImage1D: TglTextureSubImage1D;
  glTextureSubImage2D: TglTextureSubImage2D;
  glTextureSubImage3D: TglTextureSubImage3D;
  glCompressedTextureSubImage1D: TglCompressedTextureSubImage1D;
  glCompressedTextureSubImage2D: TglCompressedTextureSubImage2D;
  glCompressedTextureSubImage3D: TglCompressedTextureSubImage3D;
  glCopyTextureSubImage1D: TglCopyTextureSubImage1D;
  glCopyTextureSubImage2D: TglCopyTextureSubImage2D;
  glCopyTextureSubImage3D: TglCopyTextureSubImage3D;
  glTextureParameterf: TglTextureParameterf;
  glTextureParameterfv: TglTextureParameterfv;
  glTextureParameteri: TglTextureParameteri;
  glTextureParameterIiv: TglTextureParameterIiv;
  glTextureParameterIuiv: TglTextureParameterIuiv;
  glTextureParameteriv: TglTextureParameteriv;
  glGenerateTextureMipmap: TglGenerateTextureMipmap;
  glBindTextureUnit: TglBindTextureUnit;
  glGetTextureImage: TglGetTextureImage;
  glGetCompressedTextureImage: TglGetCompressedTextureImage;
  glGetTextureLevelParameterfv: TglGetTextureLevelParameterfv;
  glGetTextureLevelParameteriv: TglGetTextureLevelParameteriv;
  glGetTextureParameterfv: TglGetTextureParameterfv;
  glGetTextureParameterIiv: TglGetTextureParameterIiv;
  glGetTextureParameterIuiv: TglGetTextureParameterIuiv;
  glGetTextureParameteriv: TglGetTextureParameteriv;
  glCreateVertexArrays: TglCreateVertexArrays;
  glDisableVertexArrayAttrib: TglDisableVertexArrayAttrib;
  glEnableVertexArrayAttrib: TglEnableVertexArrayAttrib;
  glVertexArrayElementBuffer: TglVertexArrayElementBuffer;
  glVertexArrayVertexBuffer: TglVertexArrayVertexBuffer;
  glVertexArrayVertexBuffers: TglVertexArrayVertexBuffers;
  glVertexArrayAttribBinding: TglVertexArrayAttribBinding;
  glVertexArrayAttribFormat: TglVertexArrayAttribFormat;
  glVertexArrayAttribIFormat: TglVertexArrayAttribIFormat;
  glVertexArrayAttribLFormat: TglVertexArrayAttribLFormat;
  glVertexArrayBindingDivisor: TglVertexArrayBindingDivisor;
  glGetVertexArrayiv: TglGetVertexArrayiv;
  glGetVertexArrayIndexediv: TglGetVertexArrayIndexediv;
  glGetVertexArrayIndexed64iv: TglGetVertexArrayIndexed64iv;
  glCreateSamplers: TglCreateSamplers;
  glCreateProgramPipelines: TglCreateProgramPipelines;
  glCreateQueries: TglCreateQueries;
  glGetQueryBufferObjecti64v: TglGetQueryBufferObjecti64v;
  glGetQueryBufferObjectiv: TglGetQueryBufferObjectiv;
  glGetQueryBufferObjectui64v: TglGetQueryBufferObjectui64v;
  glGetQueryBufferObjectuiv: TglGetQueryBufferObjectuiv;
  glMemoryBarrierByRegion: TglMemoryBarrierByRegion;
  glGetTextureSubImage: TglGetTextureSubImage;
  glGetCompressedTextureSubImage: TglGetCompressedTextureSubImage;
  glGetGraphicsResetStatus: TglGetGraphicsResetStatus;
  glGetnCompressedTexImage: TglGetnCompressedTexImage;
  glGetnTexImage: TglGetnTexImage;
  glGetnUniformdv: TglGetnUniformdv;
  glGetnUniformfv: TglGetnUniformfv;
  glGetnUniformiv: TglGetnUniformiv;
  glGetnUniformuiv: TglGetnUniformuiv;
  glReadnPixels: TglReadnPixels;
  glGetnMapdv: TglGetnMapdv;
  glGetnMapfv: TglGetnMapfv;
  glGetnMapiv: TglGetnMapiv;
  glGetnPixelMapfv: TglGetnPixelMapfv;
  glGetnPixelMapuiv: TglGetnPixelMapuiv;
  glGetnPixelMapusv: TglGetnPixelMapusv;
  glGetnPolygonStipple: TglGetnPolygonStipple;
  glGetnColorTable: TglGetnColorTable;
  glGetnConvolutionFilter: TglGetnConvolutionFilter;
  glGetnSeparableFilter: TglGetnSeparableFilter;
  glGetnHistogram: TglGetnHistogram;
  glGetnMinmax: TglGetnMinmax;
  glTextureBarrier: TglTextureBarrier;

  // OpenGL 4.6
  glSpecializeShader: TglSpecializeShader;
  glMultiDrawArraysIndirectCount: TglMultiDrawArraysIndirectCount;
  glMultiDrawElementsIndirectCount: TglMultiDrawElementsIndirectCount;
  glPolygonOffsetClamp: TglPolygonOffsetClamp;

implementation

end.
