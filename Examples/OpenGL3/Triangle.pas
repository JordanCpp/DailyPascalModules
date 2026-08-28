{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program Triangle;

{$mode objfpc}{$H+}

uses
  Support, SysUtils, WinLiteEnums, WinLiteEvents, WinLiteWindow, OpenGL;

const
  WinWidth  = 800; 
  WinHeight = 600; 

function CreateShaderProgram: GLuint;
var
  VertexShader, FragmentShader: GLuint;
  VSCode, FSCode: PGLchar;
begin
  VSCode := 
    '#version 330 core'#10 +
    'layout (location = 0) in vec3 aPos;'#10 +
    'layout (location = 1) in vec3 aColor;'#10 +
    'out vec3 ourColor;'#10 +
    'void main() {'#10 +
    '   gl_Position = vec4(aPos, 1.0);'#10 +
    '   ourColor = aColor;'#10 +
    '}';

  FSCode := 
    '#version 330 core'#10 +
    'in vec3 ourColor;'#10 +
    'out vec4 FragColor;'#10 +
    'void main() {'#10 +
    '   FragColor = vec4(ourColor, 1.0);'#10 +
    '}';

  VertexShader := glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(VertexShader, 1, @VSCode, nil);
  glCompileShader(VertexShader);

  FragmentShader := glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(FragmentShader, 1, @FSCode, nil);
  glCompileShader(FragmentShader);

  Result := glCreateProgram();
  glAttachShader(Result, VertexShader);
  glAttachShader(Result, FragmentShader);
  glLinkProgram(Result);

  glDeleteShader(VertexShader);
  glDeleteShader(FragmentShader);
end;

var
  Window: TOpenGL1Window; 
  Event : TEvent; 
  Error : string;
  Loader: TOpenGLLoader;

  ShaderProgram: GLuint;
  VBO, VAO: GLuint;

  Vertices: array[0..17] of GLfloat = 
  (
     0.0,  0.5, 0.0,    1.0, 0.0, 0.0,
    -0.5, -0.5, 0.0,    0.0, 1.0, 0.0,
     0.5, -0.5, 0.0,    0.0, 0.0, 1.0
  );

begin
  if not Window.CreateWindow(WinWidth, WinHeight, 'OpenGL 3 - Triangle', Error) then 
    Halt(1);

  Loader.Init(3, 3);

  ShaderProgram := CreateShaderProgram();

  glGenVertexArrays(1, @VAO);
  glGenBuffers(1, @VBO);

  glBindVertexArray(VAO);

  glBindBuffer(GL_ARRAY_BUFFER, VBO);
  glBufferData(GL_ARRAY_BUFFER, SizeOf(Vertices), @Vertices, GL_STATIC_DRAW);

  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * SizeOf(GLfloat), nil);
  glEnableVertexAttribArray(0);

  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * SizeOf(GLfloat), Pointer(3 * SizeOf(GLfloat)));
  glEnableVertexAttribArray(1);

  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);

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

    glUseProgram(ShaderProgram);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);

    Window.Present;
  end;
  
  glDeleteVertexArrays(1, @VAO);
  glDeleteBuffers(1, @VBO);
  glDeleteProgram(ShaderProgram);

  Window.Done;
  Loader.Done;
end.
