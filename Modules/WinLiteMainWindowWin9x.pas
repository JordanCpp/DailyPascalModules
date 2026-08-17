unit WinLiteMainWindowWin9x;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, WinLiteEnums, WinLiteEvents, WinLiteQueue, WinLiteKeyMapper;

const
  WindowClassName: PChar = 'MainWindow';

type
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

FKeyMapper.Add(VK_LWIN, TKey.keyLSystem);
FKeyMapper.Add(VK_RWIN, TKey.keyRSystem);
FKeyMapper.Add(VK_APPS, TKey.keyMenu);

FKeyMapper.Add(VK_OEM_1, TKey.keySemicolon);
FKeyMapper.Add(VK_OEM_2, TKey.keySlash);
FKeyMapper.Add(VK_OEM_PLUS, TKey.keyEqual);
FKeyMapper.Add(VK_OEM_MINUS, TKey.keyHyphen);
FKeyMapper.Add(VK_OEM_4, TKey.keyLBracket);
FKeyMapper.Add(VK_OEM_6, TKey.keyRBracket);
FKeyMapper.Add(VK_OEM_COMMA, TKey.keyComma);
FKeyMapper.Add(VK_OEM_PERIOD, TKey.keyPeriod);
FKeyMapper.Add(VK_OEM_7, TKey.keyQuote);
FKeyMapper.Add(VK_OEM_5, TKey.keyBackslash);
FKeyMapper.Add(VK_OEM_3, TKey.keyTilde);

FKeyMapper.Add(VK_ESCAPE, TKey.keyEscape);
FKeyMapper.Add(VK_SPACE, TKey.keySpace);
FKeyMapper.Add(VK_RETURN, TKey.keyEnter);
FKeyMapper.Add(VK_BACK, TKey.keyBackspace);
FKeyMapper.Add(VK_TAB, TKey.keyTab);

FKeyMapper.Add(VK_PRIOR, TKey.keyPageUp);
FKeyMapper.Add(VK_NEXT, TKey.keyPageDown);
FKeyMapper.Add(VK_END, TKey.keyEnd);
FKeyMapper.Add(VK_HOME, TKey.keyHome);
FKeyMapper.Add(VK_INSERT, TKey.keyInsert);
FKeyMapper.Add(VK_DELETE, TKey.keyDelete);

FKeyMapper.Add(VK_ADD, TKey.keyAdd);
FKeyMapper.Add(VK_SUBTRACT, TKey.keySubtract);
FKeyMapper.Add(VK_MULTIPLY, TKey.keyMultiply);
FKeyMapper.Add(VK_DIVIDE, TKey.keyDivide);
FKeyMapper.Add(VK_PAUSE, TKey.keyPause);

FKeyMapper.Add(VK_F1, TKey.keyF1);
FKeyMapper.Add(VK_F2, TKey.keyF2);
FKeyMapper.Add(VK_F3, TKey.keyF3);
FKeyMapper.Add(VK_F4, TKey.keyF4);
FKeyMapper.Add(VK_F5, TKey.keyF5);
FKeyMapper.Add(VK_F6, TKey.keyF6);
FKeyMapper.Add(VK_F7, TKey.keyF7);
FKeyMapper.Add(VK_F8, TKey.keyF8);
FKeyMapper.Add(VK_F9, TKey.keyF9);
FKeyMapper.Add(VK_F10, TKey.keyF10);
FKeyMapper.Add(VK_F11, TKey.keyF11);
FKeyMapper.Add(VK_F12, TKey.keyF12);
FKeyMapper.Add(VK_F13, TKey.keyF13);
FKeyMapper.Add(VK_F14, TKey.keyF14);
FKeyMapper.Add(VK_F15, TKey.keyF15);

FKeyMapper.Add(VK_LEFT, TKey.keyLeft);
FKeyMapper.Add(VK_RIGHT, TKey.keyRight);
FKeyMapper.Add(VK_UP, TKey.keyUp);
FKeyMapper.Add(VK_DOWN, TKey.keyDown);

FKeyMapper.Add(VK_NUMPAD0, TKey.keyNumpad0);
FKeyMapper.Add(VK_NUMPAD1, TKey.keyNumpad1);
FKeyMapper.Add(VK_NUMPAD2, TKey.keyNumpad2);
FKeyMapper.Add(VK_NUMPAD3, TKey.keyNumpad3);
FKeyMapper.Add(VK_NUMPAD4, TKey.keyNumpad4);
FKeyMapper.Add(VK_NUMPAD5, TKey.keyNumpad5);
FKeyMapper.Add(VK_NUMPAD6, TKey.keyNumpad6);
FKeyMapper.Add(VK_NUMPAD7, TKey.keyNumpad7);
FKeyMapper.Add(VK_NUMPAD8, TKey.keyNumpad8);
FKeyMapper.Add(VK_NUMPAD9, TKey.keyNumpad9);

FKeyMapper.Add(Ord('A'), TKey.keyA);
FKeyMapper.Add(Ord('B'), TKey.keyB);
FKeyMapper.Add(Ord('C'), TKey.keyC);
FKeyMapper.Add(Ord('D'), TKey.keyD);
FKeyMapper.Add(Ord('E'), TKey.keyE);
FKeyMapper.Add(Ord('F'), TKey.keyF);
FKeyMapper.Add(Ord('G'), TKey.keyG);
FKeyMapper.Add(Ord('H'), TKey.keyH);
FKeyMapper.Add(Ord('I'), TKey.keyI);
FKeyMapper.Add(Ord('J'), TKey.keyJ);
FKeyMapper.Add(Ord('K'), TKey.keyK);
FKeyMapper.Add(Ord('L'), TKey.keyL);
FKeyMapper.Add(Ord('M'), TKey.keyM);
FKeyMapper.Add(Ord('N'), TKey.keyN);
FKeyMapper.Add(Ord('O'), TKey.keyO);
FKeyMapper.Add(Ord('P'), TKey.keyP);
FKeyMapper.Add(Ord('Q'), TKey.keyQ);
FKeyMapper.Add(Ord('R'), TKey.keyR);
FKeyMapper.Add(Ord('S'), TKey.keyS);
FKeyMapper.Add(Ord('T'), TKey.keyT);
FKeyMapper.Add(Ord('Y'), TKey.keyY);
FKeyMapper.Add(Ord('U'), TKey.keyU);
FKeyMapper.Add(Ord('V'), TKey.keyV);
FKeyMapper.Add(Ord('W'), TKey.keyW);
FKeyMapper.Add(Ord('X'), TKey.keyX);
FKeyMapper.Add(Ord('Z'), TKey.keyZ);

FKeyMapper.Add(Ord('0'), TKey.keyNum0);
FKeyMapper.Add(Ord('1'), TKey.keyNum1);
FKeyMapper.Add(Ord('2'), TKey.keyNum2);
FKeyMapper.Add(Ord('3'), TKey.keyNum3);
FKeyMapper.Add(Ord('4'), TKey.keyNum4);
FKeyMapper.Add(Ord('5'), TKey.keyNum5);
FKeyMapper.Add(Ord('6'), TKey.keyNum6);
FKeyMapper.Add(Ord('7'), TKey.keyNum7);
FKeyMapper.Add(Ord('8'), TKey.keyNum8);
FKeyMapper.Add(Ord('9'), TKey.keyNum9);

FKeyMapper.Add(VK_LSHIFT, TKey.keyLeftShift);
FKeyMapper.Add(VK_RSHIFT, TKey.keyRightShift);
FKeyMapper.Add(VK_LCONTROL, TKey.keyLeftControl);
FKeyMapper.Add(VK_RCONTROL, TKey.keyRightControl);

end;

function TMainWindow.Handler(AMessage: UINT; AWParam: WPARAM; ALParam: LPARAM): LRESULT;
var
  AnEvent: TEvent;
  Pt: TPoint;
begin
  FillChar(AnEvent, SizeOf(AnEvent), 0);

  case AMessage of
    WM_PAINT:
      begin
        ValidateRect(FHwnd, nil);
        Exit(0);
      end;

    WM_MOUSEMOVE:
      begin
        AnEvent.FType := TEventType.MouseMove;
        AnEvent.Mouse.PosX := SmallInt(LoWord(ALParam));
        AnEvent.Mouse.PosY := SmallInt(HiWord(ALParam));
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_LBUTTONDOWN, WM_LBUTTONUP,
    WM_RBUTTONDOWN, WM_RBUTTONUP,
    WM_MBUTTONDOWN, WM_MBUTTONUP:
      begin
        AnEvent.FType := TEventType.MouseClick;
        AnEvent.Mouse.PosX := SmallInt(LoWord(ALParam));
        AnEvent.Mouse.PosY := SmallInt(HiWord(ALParam));
        
        if (AMessage = WM_LBUTTONDOWN) or (AMessage = WM_RBUTTONDOWN) or (AMessage = WM_MBUTTONDOWN) then
          AnEvent.Mouse.State := TButtonState.Pressed
        else
          AnEvent.Mouse.State := TButtonState.Released;

        if (AMessage = WM_LBUTTONDOWN) or (AMessage = WM_LBUTTONUP) then
          AnEvent.Mouse.Button := TMouseButton.Left
        else if (AMessage = WM_RBUTTONDOWN) or (AMessage = WM_RBUTTONUP) then
          AnEvent.Mouse.Button := TMouseButton.Right
        else
          AnEvent.Mouse.Button := TMouseButton.Middle;

        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_SIZE:
      begin
        AnEvent.FType := TEventType.Resize;
        AnEvent.Resize.Width := LoWord(ALParam);
        AnEvent.Resize.Height := HiWord(ALParam);
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_CLOSE:
      begin
        AnEvent.FType := TEventType.Quit;
        FEvents.Push(AnEvent);
        DestroyWindow(FHwnd);
        Exit(0);
      end;

    WM_DESTROY:
      begin
        PostQuitMessage(0);
        Exit(0);
      end;

    WM_KEYDOWN, WM_SYSKEYDOWN:
      begin
        AnEvent.FType := TEventType.Keyboard;
        AnEvent.Keyboard.State := TButtonState.Pressed;
        AnEvent.Keyboard.Key := FKeyMapper.FindKey(AWParam);
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_KEYUP, WM_SYSKEYUP:
      begin
        AnEvent.FType := TEventType.Keyboard;
        AnEvent.Keyboard.State := TButtonState.Released;
        AnEvent.Keyboard.Key := FKeyMapper.FindKey(AWParam);
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_SETFOCUS:
      begin
        AnEvent.FType := TEventType.GainedFocus;
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_KILLFOCUS:
      begin
        AnEvent.FType := TEventType.LostFocus;
        FEvents.Push(AnEvent);
        Exit(0);
      end;

    WM_MOUSEWHEEL, WM_MOUSEHWHEEL:
      begin
        AnEvent.FType := TEventType.MouseScroll;
        AnEvent.Mouse.Delta := SmallInt(HiWord(AWParam));
        
        if AMessage = WM_MOUSEWHEEL then
          AnEvent.Mouse.Scroll := TMouseScroll.Vertical
        else
          AnEvent.Mouse.Scroll := TMouseScroll.Horizontal;

        Pt.X := SmallInt(LoWord(ALParam));
        Pt.Y := SmallInt(HiWord(ALParam));
        ScreenToClient(FHwnd, @Pt);

        AnEvent.Mouse.PosX := Pt.X;
        AnEvent.Mouse.PosY := Pt.Y;

        FEvents.Push(AnEvent);
        Exit(0);
      end;
  else
  end;

  Result := DefWindowProcA(FHwnd, AMessage, AWParam, ALParam);
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

  if not GetClassInfoExA(Instance, WindowClassName, @WC) then
  begin
    if RegisterClassExA(@WC) = 0 then
    begin
      AError := 'RegisterClassExA failed';
      Exit;
    end;
  end;

  Style := WS_OVERLAPPED or WS_SYSMENU or WS_CAPTION or WS_MINIMIZEBOX;
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := LONG(W);
  Rect.Bottom := LONG(H);
  AdjustWindowRect(@Rect, Style, False);

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
  while PeekMessageA(@Msg, 0, 0, 0, PM_REMOVE) do
  begin
    TranslateMessage(@Msg);
    DispatchMessageA(@Msg);
  end;
end;

function TMainWindow.GetEvent(out AnEvent: TEvent): Boolean;
begin
  if not FEvents.Empty then
    Exit(FEvents.Pop(AnEvent));

  PollEvents;

  if not FEvents.Empty then
    Exit(FEvents.Pop(AnEvent));

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
