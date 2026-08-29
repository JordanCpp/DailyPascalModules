{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program ExampleTemplate;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, WinLiteEnums, WinLiteEvents, WinLiteWindow, OpenGL;

const
  WinWidth  = 800; 
  WinHeight = 600; 

var
  Window: TOpenGL3Window; 
  Event : TEvent; 
  Error : string;
  Loader: TOpenGLLoader;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'OpenGL 3 - ExampleTemplate', Error) then 
  Halt(1);
  Loader.Init(3, 0);

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

    Window.Present;
  end;
  
  Window.Done;
  Loader.Done;
end.
