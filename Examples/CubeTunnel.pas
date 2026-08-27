{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program OpenGL12Tunnel;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, WinLiteEnums, WinLiteEvents, WinLiteWindow, 
  OpenGLTypes, OpenGLConsts, OpenGLFuncs, OpenGLLoader;

const
  WinWidth = 800; 
  WinHeight = 600; 
  BytesPerPixel = 4;

var
  Window: TOpenGL1Window; 
  Event : TEvent; 
  Error : string;
  Loader: TOpenGLLoader;
  Time  : Single;

procedure DrawCube(R, G, B: Single);
begin
  glBegin(GL_QUADS);
    glColor3f(R, G * 0.2, B * 0.2);
    glVertex3f(-0.5, -0.5,  0.5);
    glVertex3f( 0.5, -0.5,  0.5);
    glVertex3f( 0.5,  0.5,  0.5);
    glVertex3f(-0.5,  0.5,  0.5);

    glColor3f(R * 0.2, G, B * 0.2);
    glVertex3f(-0.5, -0.5, -0.5);
    glVertex3f(-0.5,  0.5, -0.5);
    glVertex3f( 0.5,  0.5, -0.5);
    glVertex3f( 0.5, -0.5, -0.5);

    glColor3f(R * 0.2, G * 0.2, B);
    glVertex3f(-0.5,  0.5, -0.5);
    glVertex3f(-0.5,  0.5,  0.5);
    glVertex3f( 0.5,  0.5,  0.5);
    glVertex3f( 0.5,  0.5, -0.5);

    glColor3f(R, G, B * 0.1);
    glVertex3f(-0.5, -0.5, -0.5);
    glVertex3f( 0.5, -0.5, -0.5);
    glVertex3f( 0.5, -0.5,  0.5);
    glVertex3f(-0.5, -0.5,  0.5);

    glColor3f(R, G * 0.1, B);
    glVertex3f( 0.5, -0.5, -0.5);
    glVertex3f( 0.5,  0.5, -0.5);
    glVertex3f( 0.5,  0.5,  0.5);
    glVertex3f( 0.5, -0.5,  0.5);

    glColor3f(R * 0.1, G, B);
    glVertex3f(-0.5, -0.5, -0.5);
    glVertex3f(-0.5, -0.5,  0.5);
    glVertex3f(-0.5,  0.5,  0.5);
    glVertex3f(-0.5,  0.5, -0.5);
  glEnd;
end;

var
  I: Integer;
  ZPos, Radius, Angle, CubeR, CubeG, CubeB, DepthFade: Single;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'WinLite - OpenGL 1.2 3D Cube Tunnel', Error) then 
    Halt(1);

  Loader.Init(1, 2);

  glClearColor(0.02, 0.02, 0.05, 1.0);
  glViewport(0, 0, WinWidth, WinHeight);

  glEnable(GL_DEPTH_TEST);
  glShadeModel(GL_SMOOTH);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  glFrustum(-1.33, 1.33, -1.0, 1.0, 1.5, 40.0); 

  glMatrixMode(GL_MODELVIEW);
  Time := 0.0;

  while Window.IsRunning do
  begin
    while Window.GetEvent(Event) do 
    begin
      if (Event.FType = Quit) or ((Event.FType = Keyboard) 
      and (Event.Keyboard.Key = keyEscape) 
      and (Event.Keyboard.State = Pressed)) 
      then 
        Window.StopEvent;
    end;

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

    Time := Time + 0.015;

    for I := 0 to 35 do
    begin
      glLoadIdentity;

      ZPos := -40.0 + I * 1.1 + Frac(Time) * 1.1;
      
      DepthFade := (40.0 + ZPos) / 40.0; 
      if DepthFade < 0 then DepthFade := 0;

      Radius := 1.8 + Sin(Time + I * 0.1) * 0.5;
      Angle := I * 0.25 + Time * 0.5;

      glTranslatef(Sin(Angle) * Radius, Cos(Angle) * Radius, ZPos);

      glRotatef(Time * 45.0 + I * 5.0, 1.0, 0.0, 0.0);
      glRotatef(Time * 30.0 + I * 2.0, 0.0, 1.0, 0.0);
      glRotatef(Time * 15.0,           0.0, 0.0, 1.0);

      glScalef(0.6, 0.6, 0.6);

      CubeR := (Sin(Time + I * 0.15) * 0.5 + 0.5) * DepthFade;
      CubeG := (Sin(Time + I * 0.15 + 2.0) * 0.5 + 0.5) * DepthFade;
      CubeB := (Sin(Time + I * 0.15 + 4.0) * 0.5 + 0.5) * DepthFade;

      DrawCube(CubeR, CubeG, CubeB);
    end;

    Window.Present;
  end;
  
  Window.Done;
  Loader.Done;
end.
