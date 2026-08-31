{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program Tunnel;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, Math, WinLiteEnums, WinLiteEvents, WinLiteWindow, OpenGL;

const
  WinWidth  = 800; 
  WinHeight = 600; 

  RingsCount    = 30;  
  SectorsCount  = 20;  
  TunnelRadius  = 1.5; 
  RingStep      = 1.0; 

type
  TTexColor = record
    R, G, B, A: Byte;
  end;

var
  Window: TOpenGL1Window; 
  Event : TEvent; 
  Error : string;
  Loader: TOpenGLLoader;

  TimeCounter: Single = 0.0;
  TextureID  : GLuint;

procedure GenerateProceduralTexture;
var
  TexData: array[0..63, 0..63] of TTexColor;
  X, Y: Integer;
begin
  for Y := 0 to 63 do
  begin
    for X := 0 to 63 do
    begin
      if ((X and 8) xor (Y and 8)) <> 0 then
      begin
        TexData[Y, X].R := 30;
        TexData[Y, X].G := 10;
        TexData[Y, X].B := 60;
        TexData[Y, X].A := 255;
      end
      else
      begin
        TexData[Y, X].R := 0;
        TexData[Y, X].G := 190;
        TexData[Y, X].B := 255;
        TexData[Y, X].A := 255;
      end;
    end;
  end;

  glGenTextures(1, @TextureID);
  glBindTexture(GL_TEXTURE_2D, TextureID);
  
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 64, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @TexData);
end;

procedure InitScene;
var
  FogColor: array[0..3] of GLfloat = (0.05, 0.05, 0.1, 1.0);
begin
  glViewport(0, 0, WinWidth, WinHeight);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glFrustum(-0.6, 0.6, -0.45, 0.45, 1.0, 30.0);
  
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_TEXTURE_2D);

  glEnable(GL_FOG);
  glFogi(GL_FOG_MODE, GL_EXP2);       
  glFogf(GL_FOG_DENSITY, 0.08);       
  glFogfv(GL_FOG_COLOR, @FogColor);   
  
  glClearColor(FogColor[0], FogColor[1], FogColor[2], FogColor[3]);

  GenerateProceduralTexture;
end;

procedure RenderTunnel(Time: Single);
var
  Ring, Sector: Integer;
  Z1, Z2: Single;
  Angle: Single;
  XOffset1, YOffset1, XOffset2, YOffset2: Single;
  U1, V1, V2: Single;
begin
  glBindTexture(GL_TEXTURE_2D, TextureID);

  for Ring := 0 to RingsCount - 1 do
  begin
    Z1 := -Ring * RingStep;
    Z2 := -(Ring + 1) * RingStep;

    XOffset1 := Sin(Time + (Z1 * 0.15)) * 0.8;
    YOffset1 := Cos(Time * 0.8 + (Z1 * 0.2)) * 0.6;
    
    XOffset2 := Sin(Time + (Z2 * 0.15)) * 0.8;
    YOffset2 := Cos(Time * 0.8 + (Z2 * 0.2)) * 0.6;

    V1 := (Ring * 0.2) + (Time * 2.0);
    V2 := ((Ring + 1) * 0.2) + (Time * 2.0);

    glBegin(GL_QUAD_STRIP);
    for Sector := 0 to SectorsCount do
    begin
      Angle := (Sector / SectorsCount) * 2.0 * PI;
      
      U1 := Sector / SectorsCount * 4.0; 

      glTexCoord2f(U1, V1);
      glVertex3f(
        XOffset1 + Cos(Angle) * TunnelRadius,
        YOffset1 + Sin(Angle) * TunnelRadius,
        Z1
      );

      glTexCoord2f(U1, V2);
      glVertex3f(
        XOffset2 + Cos(Angle) * TunnelRadius,
        YOffset2 + Sin(Angle) * TunnelRadius,
        Z2
      );
    end;
    glEnd;
  end;
end;

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'OpenGL 1.2 - Infinite 3D Tunnel', Error) then Halt(1);

  Loader.Init(1, 2);
  InitScene;

  while Window.IsRunning do
  begin
    while Window.GetEvent(Event) do 
    begin
      if (Event.FType = Quit) or ((Event.FType = Keyboard) 
      and (Event.Keyboard.Key = keyEscape) 
      and (Event.Keyboard.State = Pressed)) 
      then Window.StopEvent;
    end;

    TimeCounter := TimeCounter + 0.015;

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glLoadIdentity;

    glTranslatef(Sin(TimeCounter * 0.5) * 0.1, Cos(TimeCounter * 0.3) * 0.1, -0.5);

    RenderTunnel(TimeCounter);

    Window.Present;
  end;
  
  glDeleteTextures(1, @TextureID);
  Window.Done;
  Loader.Done;
end.
