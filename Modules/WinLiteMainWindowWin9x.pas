{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteMainWindowWin9x;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Windows, Messages, WinLiteEnums, WinLiteEvents, WinLiteQueue, WinLiteKeyMapper;

const

{$IFNDEF FPC}
  VK_LWIN        = $5B;
  VK_RWIN        = $5C;
  VK_APPS        = $5D;

  VK_OEM_1       = $BA; // ';:' (keySemicolon)
  VK_OEM_2       = $BF; // '/?' (keySlash)
  VK_OEM_PLUS    = $BB; // '=+' (keyEqual)
  VK_OEM_MINUS   = $BD; // '-_' (keyHyphen)
  VK_OEM_4       = $DB; // '[{' (keyLBracket)
  VK_OEM_6       = $DD; // ']}' (keyRBracket)
  VK_OEM_COMMA   = $BC; // ',<' (keyComma)
  VK_OEM_PERIOD  = $BE; // '.>' (keyPeriod)
  VK_OEM_7       = $DE; // '"'' (keyQuote)
  VK_OEM_5       = $DC; // '\|' (keyBackslash)
  VK_OEM_3       = $C0; // '`~' (keyTilde)

  VK_ESCAPE      = $1B; // Escape (keyEscape)
  VK_SPACE       = $20; // Пробел (keySpace)
  VK_RETURN      = $0D; // Enter (keyEnter)
  VK_BACK        = $08; // Backspace (keyBackspace)
  VK_TAB         = $09; // Tab (keyTab)

  VK_PRIOR       = $21; // Page Up (keyPageUp)
  VK_NEXT        = $22; // Page Down (keyPageDown)
  VK_END         = $23; // End (keyEnd)
  VK_HOME        = $24; // Home (keyHome)
  VK_INSERT      = $2D; // Insert (keyInsert)
  VK_DELETE      = $2E; // Delete (keyDelete)

  VK_ADD         = $6B; // Numpad + (keyAdd)
  VK_SUBTRACT    = $6D; // Numpad - (keySubtract)
  VK_MULTIPLY    = $6A; // Numpad * (keyMultiply)
  VK_DIVIDE      = $6F; // Numpad / (keyDivide)
  VK_PAUSE       = $13; // Pause / Break (keyPause)

  VK_F1          = $70;
  VK_F2          = $71;
  VK_F3          = $72;
  VK_F4          = $73;
  VK_F5          = $74;
  VK_F6          = $75;
  VK_F7          = $76;
  VK_F8          = $77;
  VK_F9          = $78;
  VK_F10         = $79;
  VK_F11         = $7A;
  VK_F12         = $7B;
  VK_F13         = $7C;
  VK_F14         = $7D;
  VK_F15         = $7E;

  VK_LEFT        = $25;
  VK_RIGHT       = $26;
  VK_UP          = $26;
  VK_DOWN        = $28;

  VK_NUMPAD0     = $60;
  VK_NUMPAD1     = $61;
  VK_NUMPAD2     = $62;
  VK_NUMPAD3     = $63;
  VK_NUMPAD4     = $64;
  VK_NUMPAD5     = $65;
  VK_NUMPAD6     = $66;
  VK_NUMPAD7     = $67;
  VK_NUMPAD8     = $68;
  VK_NUMPAD9     = $69;

  VK_LSHIFT      = $A0; // Левый Shift (keyLeftShift)
  VK_RSHIFT      = $A1; // Правый Shift (keyRightShift)
  VK_LCONTROL    = $A2; // Левый Ctrl (keyLeftControl)
  VK_RCONTROL    = $A3; // Правый Ctrl (keyRightControl)
{$ENDIF}

  {$IFNDEF FPC}
  GWLP_USERDATA = -21;
  WM_MOUSEHWHEEL = $020E;
  {$ENDIF}

  WindowClassName: PChar = 'MainWindow';

type
  {$IFNDEF FPC}
  LONG_PTR = Longint;
  LONG = Longint;
  {$ENDIF}

  PMainWindow = ^TMainWindow;

  TMainWindow = object
  private
    FHwnd     : HWND;
    FHdc      : HDC;
    FEvents   : TQueue;
    FKeyMapper: TKeyMapper;

    procedure InitKeyMapper;
    function Handler(AMessage: UINT; AWParam: WPARAM; ALParam: LPARAM): LRESULT;
  public
    procedure Done;

    function Create(W, H: Integer; const ATitle: string; out AError: string): Boolean;
    procedure PollEvents;
    function GetEvent(out AnEvent: TEvent): Boolean;
    procedure StopEvent;
    function IsRunning: Boolean;
    procedure SetTitle(const ATitle: string);

    function GetHwnd: HWND;
    function GetHdc: HDC;
  end;

implementation

{$IFNDEF FPC}
function SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: LONG_PTR): LONG_PTR;
begin
  Result := SetWindowLong(hWnd, nIndex, dwNewLong);
end;

function GetWindowLongPtr(hWnd: HWND; nIndex: Integer): LONG_PTR;
begin
  Result := GetWindowLong(hWnd, nIndex);
end;
{$ENDIF}

function WndProc(HHwnd: HWND; UMessage: UINT; AWParam: WPARAM; ALParam: LPARAM): LRESULT; stdcall;
var
  This        : PMainWindow;
  CreateStruct: PCreateStruct;
begin
  if UMessage = WM_NCCREATE then
  begin
    CreateStruct := PCreateStruct(ALParam);
    This := PMainWindow(CreateStruct^.lpCreateParams);
    SetWindowLongPtr(HHwnd, GWLP_USERDATA, LONG_PTR(This));
    This^.FHwnd := HHwnd;
  end
  else
    This := PMainWindow(GetWindowLongPtr(HHwnd, GWLP_USERDATA));

  if This <> nil then
  begin
    Result := This^.Handler(UMessage, AWParam, ALParam);
    Exit;
  end;
  Result := DefWindowProc(HHwnd, UMessage, AWParam, ALParam);
end;

{ TMainWindow private methods }

procedure TMainWindow.InitKeyMapper;
begin
  FKeyMapper.Init;

FKeyMapper.Add(VK_LWIN, keyLSystem);
FKeyMapper.Add(VK_RWIN, keyRSystem);
FKeyMapper.Add(VK_APPS, keyMenu);

FKeyMapper.Add(VK_OEM_1, keySemicolon);
FKeyMapper.Add(VK_OEM_2, keySlash);
FKeyMapper.Add(VK_OEM_PLUS, keyEqual);
FKeyMapper.Add(VK_OEM_MINUS, keyHyphen);
FKeyMapper.Add(VK_OEM_4, keyLBracket);
FKeyMapper.Add(VK_OEM_6, keyRBracket);
FKeyMapper.Add(VK_OEM_COMMA, keyComma);
FKeyMapper.Add(VK_OEM_PERIOD, keyPeriod);
FKeyMapper.Add(VK_OEM_7, keyQuote);
FKeyMapper.Add(VK_OEM_5, keyBackslash);
FKeyMapper.Add(VK_OEM_3, keyTilde);

FKeyMapper.Add(VK_ESCAPE, keyEscape);
FKeyMapper.Add(VK_SPACE, keySpace);
FKeyMapper.Add(VK_RETURN, keyEnter);
FKeyMapper.Add(VK_BACK, keyBackspace);
FKeyMapper.Add(VK_TAB, keyTab);

FKeyMapper.Add(VK_PRIOR, keyPageUp);
FKeyMapper.Add(VK_NEXT, keyPageDown);
FKeyMapper.Add(VK_END, keyEnd);
FKeyMapper.Add(VK_HOME, keyHome);
FKeyMapper.Add(VK_INSERT, keyInsert);
FKeyMapper.Add(VK_DELETE, keyDelete);

FKeyMapper.Add(VK_ADD, keyAdd);
FKeyMapper.Add(VK_SUBTRACT, keySubtract);
FKeyMapper.Add(VK_MULTIPLY, keyMultiply);
FKeyMapper.Add(VK_DIVIDE, keyDivide);
FKeyMapper.Add(VK_PAUSE, keyPause);

FKeyMapper.Add(VK_F1, keyF1);
FKeyMapper.Add(VK_F2, keyF2);
FKeyMapper.Add(VK_F3, keyF3);
FKeyMapper.Add(VK_F4, keyF4);
FKeyMapper.Add(VK_F5, keyF5);
FKeyMapper.Add(VK_F6, keyF6);
FKeyMapper.Add(VK_F7, keyF7);
FKeyMapper.Add(VK_F8, keyF8);
FKeyMapper.Add(VK_F9, keyF9);
FKeyMapper.Add(VK_F10, keyF10);
FKeyMapper.Add(VK_F11, keyF11);
FKeyMapper.Add(VK_F12, keyF12);
FKeyMapper.Add(VK_F13, keyF13);
FKeyMapper.Add(VK_F14, keyF14);
FKeyMapper.Add(VK_F15, keyF15);

FKeyMapper.Add(VK_LEFT, keyLeft);
FKeyMapper.Add(VK_RIGHT, keyRight);
FKeyMapper.Add(VK_UP, keyUp);
FKeyMapper.Add(VK_DOWN, keyDown);

FKeyMapper.Add(VK_NUMPAD0, keyNumpad0);
FKeyMapper.Add(VK_NUMPAD1, keyNumpad1);
FKeyMapper.Add(VK_NUMPAD2, keyNumpad2);
FKeyMapper.Add(VK_NUMPAD3, keyNumpad3);
FKeyMapper.Add(VK_NUMPAD4, keyNumpad4);
FKeyMapper.Add(VK_NUMPAD5, keyNumpad5);
FKeyMapper.Add(VK_NUMPAD6, keyNumpad6);
FKeyMapper.Add(VK_NUMPAD7, keyNumpad7);
FKeyMapper.Add(VK_NUMPAD8, keyNumpad8);
FKeyMapper.Add(VK_NUMPAD9, keyNumpad9);

FKeyMapper.Add(Ord('A'), keyA);
FKeyMapper.Add(Ord('B'), keyB);
FKeyMapper.Add(Ord('C'), keyC);
FKeyMapper.Add(Ord('D'), keyD);
FKeyMapper.Add(Ord('E'), keyE);
FKeyMapper.Add(Ord('F'), keyF);
FKeyMapper.Add(Ord('G'), keyG);
FKeyMapper.Add(Ord('H'), keyH);
FKeyMapper.Add(Ord('I'), keyI);
FKeyMapper.Add(Ord('J'), keyJ);
FKeyMapper.Add(Ord('K'), keyK);
FKeyMapper.Add(Ord('L'), keyL);
FKeyMapper.Add(Ord('M'), keyM);
FKeyMapper.Add(Ord('N'), keyN);
FKeyMapper.Add(Ord('O'), keyO);
FKeyMapper.Add(Ord('P'), keyP);
FKeyMapper.Add(Ord('Q'), keyQ);
FKeyMapper.Add(Ord('R'), keyR);
FKeyMapper.Add(Ord('S'), keyS);
FKeyMapper.Add(Ord('T'), keyT);
FKeyMapper.Add(Ord('Y'), keyY);
FKeyMapper.Add(Ord('U'), keyU);
FKeyMapper.Add(Ord('V'), keyV);
FKeyMapper.Add(Ord('W'), keyW);
FKeyMapper.Add(Ord('X'), keyX);
FKeyMapper.Add(Ord('Z'), keyZ);

FKeyMapper.Add(Ord('0'), keyNum0);
FKeyMapper.Add(Ord('1'), keyNum1);
FKeyMapper.Add(Ord('2'), keyNum2);
FKeyMapper.Add(Ord('3'), keyNum3);
FKeyMapper.Add(Ord('4'), keyNum4);
FKeyMapper.Add(Ord('5'), keyNum5);
FKeyMapper.Add(Ord('6'), keyNum6);
FKeyMapper.Add(Ord('7'), keyNum7);
FKeyMapper.Add(Ord('8'), keyNum8);
FKeyMapper.Add(Ord('9'), keyNum9);

FKeyMapper.Add(VK_LSHIFT, keyLeftShift);
FKeyMapper.Add(VK_RSHIFT, keyRightShift);
FKeyMapper.Add(VK_LCONTROL, keyLeftControl);
FKeyMapper.Add(VK_RCONTROL, keyRightControl);

end;

function TMainWindow.Handler(AMessage: UINT; AWParam: WPARAM; ALParam: LPARAM): LRESULT;
var
  AnEvent: TEvent;
  Pt: TPoint;
begin
  // Исправление: Инициализируем Result нулем по умолчанию для всех веток case
  Result := 0; 
  FillChar(AnEvent, SizeOf(AnEvent), 0);

  case AMessage of
    WM_PAINT:
      begin
        ValidateRect(FHwnd, nil);
        Exit;
      end;

    WM_MOUSEMOVE:
      begin
        AnEvent.FType := MouseMove;
        AnEvent.Mouse.PosX := SmallInt(LoWord(ALParam));
        AnEvent.Mouse.PosY := SmallInt(HiWord(ALParam));
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_LBUTTONDOWN, WM_LBUTTONUP,
    WM_RBUTTONDOWN, WM_RBUTTONUP,
    WM_MBUTTONDOWN, WM_MBUTTONUP:
      begin
        AnEvent.FType := MouseClick;
        AnEvent.Mouse.PosX := SmallInt(LoWord(ALParam));
        AnEvent.Mouse.PosY := SmallInt(HiWord(ALParam));
        
        if (AMessage = WM_LBUTTONDOWN) or (AMessage = WM_RBUTTONDOWN) or (AMessage = WM_MBUTTONDOWN) then
          AnEvent.Mouse.State := Pressed
        else
          AnEvent.Mouse.State := Released;

        if (AMessage = WM_LBUTTONDOWN) or (AMessage = WM_LBUTTONUP) then
          AnEvent.Mouse.Button := Left
        else if (AMessage = WM_RBUTTONDOWN) or (AMessage = WM_RBUTTONUP) then
          AnEvent.Mouse.Button := Right
        else
          AnEvent.Mouse.Button := Middle;

        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_SIZE:
      begin
        AnEvent.FType := Resize;
        AnEvent.Resize.Width := LoWord(ALParam);
        AnEvent.Resize.Height := HiWord(ALParam);
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_CLOSE:
      begin
        AnEvent.FType := Quit;
        FEvents.Push(AnEvent);
        DestroyWindow(FHwnd);
        Exit;
      end;

    WM_DESTROY:
      begin
        PostQuitMessage(0);
        Exit;
      end;

    WM_KEYDOWN, WM_SYSKEYDOWN:
      begin
        AnEvent.FType := Keyboard;
        AnEvent.Keyboard.State := Pressed;
        AnEvent.Keyboard.Key := FKeyMapper.FindKey(AWParam);
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_KEYUP, WM_SYSKEYUP:
      begin
        AnEvent.FType := Keyboard;
        AnEvent.Keyboard.State := Released;
        AnEvent.Keyboard.Key := FKeyMapper.FindKey(AWParam);
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_SETFOCUS:
      begin
        AnEvent.FType := GainedFocus;
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_KILLFOCUS:
      begin
        AnEvent.FType := LostFocus;
        FEvents.Push(AnEvent);
        Exit;
      end;

    WM_MOUSEWHEEL, WM_MOUSEHWHEEL:
      begin
        AnEvent.FType := MouseScroll;
        AnEvent.Mouse.Delta := SmallInt(HiWord(AWParam));
        
        if AMessage = WM_MOUSEWHEEL then
          AnEvent.Mouse.Scroll := Vertical
        else
          AnEvent.Mouse.Scroll := Horizontal;

        Pt.X := SmallInt(LoWord(ALParam));
        Pt.Y := SmallInt(HiWord(ALParam));
        ScreenToClient(FHwnd, Pt);

        AnEvent.Mouse.PosX := Pt.X;
        AnEvent.Mouse.PosY := Pt.Y;

        FEvents.Push(AnEvent);
        Exit;
      end;
  else
    Result := DefWindowProcA(FHwnd, AMessage, AWParam, ALParam);
  end;
end;

{ TMainWindow public methods }

procedure TMainWindow.Done;
begin
  if (FHdc <> 0) and (FHwnd <> 0) then
    ReleaseDC(FHwnd, FHdc);
  FEvents.Done;
end;

function TMainWindow.Create(W, H: Integer; const ATitle: string; out AError: string): Boolean;
var
  Instance: HINST;
  WC: TWndClassExA;
  Rect: TRect;
  Style: DWORD;
  Width, Height, ScreenW, ScreenH, PosX, PosY: Integer;
  HwndRes: HWND;
begin
  Result := False;
  Instance := GetModuleHandleA(nil);
  if Instance = 0 then
  begin
    AError := 'GetModuleHandleA failed';
    Exit;
  end;

  FillChar(WC, SizeOf(WC), 0);
  WC.cbSize := SizeOf(TWndClassExA);
  WC.hInstance := Instance;
  WC.lpszClassName := WindowClassName;
  WC.lpfnWndProc := @WndProc;
  WC.style := CS_HREDRAW or CS_VREDRAW;
  WC.hbrBackground := HBRUSH(GetStockObject(BLACK_BRUSH));
  WC.hIcon := LoadIconA(0, PChar(IDI_APPLICATION));
  WC.hCursor := LoadCursorA(0, PChar(IDC_ARROW));

  {$IFDEF FPC}
    if not GetClassInfoExA(Instance, WindowClassName, @WC) then
    begin
      if RegisterClassExA(@WC) = 0 then
      begin
        AError := 'RegisterClassExA failed';
        Exit;
      end;
    end;
  {$ELSE}
    if not GetClassInfoExA(Instance, WindowClassName, WC) then
    begin
      if RegisterClassExA(WC) = 0 then
      begin
        AError := 'RegisterClassExA failed';
        Exit;
      end;
    end;
  {$ENDIF}

  Style := WS_OVERLAPPED or WS_SYSMENU or WS_CAPTION or WS_MINIMIZEBOX;
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := LONG(W);
  Rect.Bottom := LONG(H);
  AdjustWindowRect(Rect, Style, False);

  Width := Rect.Right - Rect.Left;
  Height := Rect.Bottom - Rect.Top;

  ScreenW := GetSystemMetrics(SM_CXSCREEN);
  ScreenH := GetSystemMetrics(SM_CYSCREEN);
  PosX := (ScreenW - Width) div 2;
  PosY := (ScreenH - Height) div 2;

  FEvents.Init;
  InitKeyMapper;

  HwndRes := CreateWindowA(WindowClassName, PChar(ATitle), Style, PosX, PosY, Width, Height, 0, 0, Instance, @Self);
  if HwndRes = 0 then
  begin
    FEvents.Done;
    AError := 'CreateWindowA failed';
    Exit;
  end;

  FHwnd := HwndRes;
  FHdc := GetDC(FHwnd);
  if FHdc = 0 then
  begin
    DestroyWindow(FHwnd);
    FEvents.Done;
    AError := 'GetDC failed';
    Exit;
  end;

  ShowWindow(FHwnd, SW_SHOW);
  UpdateWindow(FHwnd);

  Result := True;
end;

procedure TMainWindow.PollEvents;
var
  Msg: TMsg;
begin
  while PeekMessageA(Msg, 0, 0, 0, PM_REMOVE) do
  begin
    TranslateMessage(Msg);
    DispatchMessageA(Msg);
  end;
end;

function TMainWindow.GetEvent(out AnEvent: TEvent): Boolean;
begin
  if not FEvents.Empty then
  begin
    Result := FEvents.Pop(AnEvent);
    Exit;
  end;

  PollEvents;

  if not FEvents.Empty then
  begin
    Result := FEvents.Pop(AnEvent);
    Exit;
  end;

  Result := False;
end;

procedure TMainWindow.StopEvent;
begin
  FEvents.Stop;
end;

function TMainWindow.IsRunning: Boolean;
begin
  Result := FEvents.IsRunning;
end;

procedure TMainWindow.SetTitle(const ATitle: string);
begin
  if FHwnd <> 0 then
    SetWindowTextA(FHwnd, PChar(ATitle));
end;

function TMainWindow.GetHwnd: HWND;
begin
  Result := FHwnd;
end;

function TMainWindow.GetHdc: HDC;
begin
  Result := FHdc;
end;

end.
