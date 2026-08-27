{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit OpenGLTypes;

{$mode objfpc}{$H+}

interface

type
  GLenum    = LongWord;
  GLuint    = LongWord;
  GLint     = LongInt;
  GLsizei   = LongInt;
  GLfloat   = Single;
  GLdouble  = Double;
  GLbyte    = ShortInt;
  GLshort   = SmallInt;
  GLboolean = Byte;
  GLbitfield = LongWord;
  GLvoid    = Pointer;
  GLchar    = Char;
  GLubyte   = Byte;
  GLushort  = Word;
  GLuint64  = Int64;
  GLint64   = Int64;
  GLsizeiptr = LongInt;
  GLintptr  = LongInt;
  GLsync    = Pointer;

  GLhalf    = Word;
  GLclampf  = Single;
  GLclampd  = Double;

  PGLvoid     = ^Pointer;
  PGLenum    = ^GLenum;
  PGLuint    = ^GLuint;
  PGLint     = ^GLint;
  PGLsizei   = ^GLsizei;
  PGLfloat   = ^GLfloat;
  PGLdouble  = ^GLdouble;
  PGLbyte    = ^GLbyte;
  PGLshort   = ^GLshort;
  PGLboolean = ^GLboolean;
  PGLbitfield = ^GLbitfield;
  PGLchar    = ^GLchar;
  PPGLchar   = PAnsiChar;
  PGLubyte   = ^GLubyte;
  PGLushort  = ^GLushort;
  PGLuint64  = ^GLuint64;
  PGLint64   = ^GLint64;
  PGLsizeiptr = ^GLsizeiptr;
  PGLintptr  = ^GLintptr;
  PGLhalf    = ^GLhalf;
  PGLclampf  = ^GLclampf;
  PGLclampd  = ^GLclampd;

  // ==================== Debug Callback ====================
  TGLDEBUGPROC = procedure(source: GLenum; type_: GLenum; id: GLuint; severity: GLenum; length: GLsizei; const message: PGLchar; const userParam: Pointer); stdcall;
implementation

end.
