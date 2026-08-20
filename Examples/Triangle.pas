{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program Triangle;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  Support, SysUtils, WinLiteEnums, WinLiteEvents, WinLiteWindow, OpenGLTypes, OpenGLConsts, OpenGLFuncs, OpenGLLoader;

const
  WinWidth = 800; 
  WinHeight = 600; 
  BytesPerPixel = 4;

var
  Window: TOpenGL1Window; 
  Event : TEvent; 
  Error : string;
  Loader: TOpenGLLoader;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite - Fullscreen Texture Burning', Error) then Halt(1);

  Loader.Init(1, 2);

  glClearColor(0.1, 0.1, 0.1, 1.0);
  glViewport(0, 0, WinWidth, WinHeight);

  while Window.IsRunning do
  begin
    while Window.GetEvent(Event) do 
    begin
      if (Event.FType = Quit) or ((Event.FType = Keyboard) 
      and (Event.Keyboard.Key = keyEscape) 
      and (Event.Keyboard.State = Pressed)) 
      then Window.StopEvent;
    end;

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

    glBegin(GL_TRIANGLES);
      glColor3f(1.0, 0.0, 0.0);
      glVertex2f(-0.5, -0.5);

      glColor3f(0.0, 1.0, 0.0);
      glVertex2f(0.5, -0.5);

      glColor3f(0.0, 0.0, 1.0);
      glVertex2f(0.0, 0.5);
    glEnd;

    Window.Present;
  end;
  
  Window.Done;
  Loader.Done;
end.
