{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteMainWindowXLib;

{$mode objfpc}{$H+}

interface

uses
  x, xlib, xutil, keysym,
  WinLiteEnums, WinLiteEvents, WinLiteQueue, WinLiteKeyMapper;

type
  PMainWindow = ^TMainWindow;
  TMainWindow = object
  public
    FDisplay    : PDisplay;
    FWindow     : TWindow;
    FWMDelete   : TAtom;
    FEvents     : TQueue;
    FKeyMapper  : TKeyMapper;
    FLastMouseX : Integer;
    FLastMouseY : Integer;

    procedure InitKeyMapper;
  public
    procedure Done;
    function Create(W, H: Integer; const ATitle: string; out AError: string): Boolean;
    function CreateWithVisual(W, H: Integer; const ATitle: string; AVisualInfo: PXVisualInfo; out AError: string): Boolean;
    procedure PollEvents;
    function GetEvent(out AnEvent: TEvent): Boolean;
    procedure StopEvent;
    function IsRunning: Boolean;
    procedure SetTitle(const ATitle: string);
  end;

implementation

{ TMainWindow private methods }

procedure TMainWindow.InitKeyMapper;
begin
  FKeyMapper.Init;

  FKeyMapper.Add(XK_Super_L, TKey.keyLSystem);
  FKeyMapper.Add(XK_Super_R, TKey.keyRSystem);
  FKeyMapper.Add(XK_Menu, TKey.keyMenu);

  FKeyMapper.Add(XK_semicolon, TKey.keySemicolon);
  FKeyMapper.Add(XK_slash, TKey.keySlash);
  FKeyMapper.Add(XK_equal, TKey.keyEqual);
  FKeyMapper.Add(XK_minus, TKey.keyHyphen);
  FKeyMapper.Add(XK_bracketleft, TKey.keyLBracket);
  FKeyMapper.Add(XK_bracketright, TKey.keyRBracket);
  FKeyMapper.Add(XK_comma, TKey.keyComma);
  FKeyMapper.Add(XK_period, TKey.keyPeriod);
  FKeyMapper.Add(XK_apostrophe, TKey.keyQuote);
  FKeyMapper.Add(XK_backslash, TKey.keyBackslash);
  FKeyMapper.Add(XK_grave, TKey.keyTilde);

  FKeyMapper.Add(XK_Escape, TKey.keyEscape);
  FKeyMapper.Add(XK_space, TKey.keySpace);
  FKeyMapper.Add(XK_Return, TKey.keyEnter);
  FKeyMapper.Add(XK_KP_Enter, TKey.keyEnter);
  FKeyMapper.Add(XK_BackSpace, TKey.keyBackspace);
  FKeyMapper.Add(XK_Tab, TKey.keyTab);

  FKeyMapper.Add(XK_Prior, TKey.keyPageUp);
  FKeyMapper.Add(XK_Next, TKey.keyPageDown);
  FKeyMapper.Add(XK_End, TKey.keyEnd);
  FKeyMapper.Add(XK_Home, TKey.keyHome);
  FKeyMapper.Add(XK_Insert, TKey.keyInsert);
  FKeyMapper.Add(XK_Delete, TKey.keyDelete);

  FKeyMapper.Add(XK_KP_Add, TKey.keyAdd);
  FKeyMapper.Add(XK_KP_Subtract, TKey.keySubtract);
  FKeyMapper.Add(XK_KP_Multiply, TKey.keyMultiply);
  FKeyMapper.Add(XK_KP_Divide, TKey.keyDivide);
  FKeyMapper.Add(XK_Pause, TKey.keyPause);

  FKeyMapper.Add(XK_F1, TKey.keyF1);
  FKeyMapper.Add(XK_F2, TKey.keyF2);
  FKeyMapper.Add(XK_F3, TKey.keyF3);
  FKeyMapper.Add(XK_F4, TKey.keyF4);
  FKeyMapper.Add(XK_F5, TKey.keyF5);
  FKeyMapper.Add(XK_F6, TKey.keyF6);
  FKeyMapper.Add(XK_F7, TKey.keyF7);
  FKeyMapper.Add(XK_F8, TKey.keyF8);
  FKeyMapper.Add(XK_F9, TKey.keyF9);
  FKeyMapper.Add(XK_F10, TKey.keyF10);
  FKeyMapper.Add(XK_F11, TKey.keyF11);
  FKeyMapper.Add(XK_F12, TKey.keyF12);
  FKeyMapper.Add(XK_F13, TKey.keyF13);
  FKeyMapper.Add(XK_F14, TKey.keyF14);
  FKeyMapper.Add(XK_F15, TKey.keyF15);

  FKeyMapper.Add(XK_Left, TKey.keyLeft);
  FKeyMapper.Add(XK_Right, TKey.keyRight);
  FKeyMapper.Add(XK_Up, TKey.keyUp);
  FKeyMapper.Add(XK_Down, TKey.keyDown);

  FKeyMapper.Add(XK_KP_0, TKey.keyNumpad0);
  FKeyMapper.Add(XK_KP_1, TKey.keyNumpad1);
  FKeyMapper.Add(XK_KP_2, TKey.keyNumpad2);
  FKeyMapper.Add(XK_KP_3, TKey.keyNumpad3);
  FKeyMapper.Add(XK_KP_4, TKey.keyNumpad4);
  FKeyMapper.Add(XK_KP_5, TKey.keyNumpad5);
  FKeyMapper.Add(XK_KP_6, TKey.keyNumpad6);
  FKeyMapper.Add(XK_KP_7, TKey.keyNumpad7);
  FKeyMapper.Add(XK_KP_8, TKey.keyNumpad8);
  FKeyMapper.Add(XK_KP_9, TKey.keyNumpad9);

  FKeyMapper.Add(XK_a, TKey.keyA); FKeyMapper.Add(XK_A, TKey.keyA);
  FKeyMapper.Add(XK_b, TKey.keyB); FKeyMapper.Add(XK_B, TKey.keyB);
  FKeyMapper.Add(XK_c, TKey.keyC); FKeyMapper.Add(XK_C, TKey.keyC);
  FKeyMapper.Add(XK_d, TKey.keyD); FKeyMapper.Add(XK_D, TKey.keyD);
  FKeyMapper.Add(XK_e, TKey.keyE); FKeyMapper.Add(XK_E, TKey.keyE);
  FKeyMapper.Add(XK_f, TKey.keyF); FKeyMapper.Add(XK_F, TKey.keyF);
  FKeyMapper.Add(XK_g, TKey.keyG); FKeyMapper.Add(XK_G, TKey.keyG);
  FKeyMapper.Add(XK_h, TKey.keyH); FKeyMapper.Add(XK_H, TKey.keyH);
  FKeyMapper.Add(XK_i, TKey.keyI); FKeyMapper.Add(XK_I, TKey.keyI);
  FKeyMapper.Add(XK_j, TKey.keyJ); FKeyMapper.Add(XK_J, TKey.keyJ);
  FKeyMapper.Add(XK_k, TKey.keyK); FKeyMapper.Add(XK_K, TKey.keyK);
  FKeyMapper.Add(XK_l, TKey.keyL); FKeyMapper.Add(XK_L, TKey.keyL);
  FKeyMapper.Add(XK_m, TKey.keyM); FKeyMapper.Add(XK_M, TKey.keyM);
  FKeyMapper.Add(XK_n, TKey.keyN); FKeyMapper.Add(XK_N, TKey.keyN);
  FKeyMapper.Add(XK_o, TKey.keyO); FKeyMapper.Add(XK_O, TKey.keyO);
  FKeyMapper.Add(XK_p, TKey.keyP); FKeyMapper.Add(XK_P, TKey.keyP);
  FKeyMapper.Add(XK_q, TKey.keyQ); FKeyMapper.Add(XK_Q, TKey.keyQ);
  FKeyMapper.Add(XK_r, TKey.keyR); FKeyMapper.Add(XK_R, TKey.keyR);
  FKeyMapper.Add(XK_s, TKey.keyS); FKeyMapper.Add(XK_S, TKey.keyS);
  FKeyMapper.Add(XK_t, TKey.keyT); FKeyMapper.Add(XK_T, TKey.keyT);
  FKeyMapper.Add(XK_u, TKey.keyU); FKeyMapper.Add(XK_U, TKey.keyU);
  FKeyMapper.Add(XK_v, TKey.keyV); FKeyMapper.Add(XK_V, TKey.keyV);
  FKeyMapper.Add(XK_w, TKey.keyW); FKeyMapper.Add(XK_W, TKey.keyW);
  FKeyMapper.Add(XK_x, TKey.keyX); FKeyMapper.Add(XK_X, TKey.keyX);
  FKeyMapper.Add(XK_y, TKey.keyY); FKeyMapper.Add(XK_Y, TKey.keyY);
  FKeyMapper.Add(XK_z, TKey.keyZ); FKeyMapper.Add(XK_Z, TKey.keyZ);

  FKeyMapper.Add(XK_0, TKey.keyNum0);
  FKeyMapper.Add(XK_1, TKey.keyNum1);
  FKeyMapper.Add(XK_2, TKey.keyNum2);
  FKeyMapper.Add(XK_3, TKey.keyNum3);
  FKeyMapper.Add(XK_4, TKey.keyNum4);
  FKeyMapper.Add(XK_5, TKey.keyNum5);
  FKeyMapper.Add(XK_6, TKey.keyNum6);
  FKeyMapper.Add(XK_7, TKey.keyNum7);
  FKeyMapper.Add(XK_8, TKey.keyNum8);
  FKeyMapper.Add(XK_9, TKey.keyNum9);

  FKeyMapper.Add(XK_Shift_L, TKey.keyLeftShift);
  FKeyMapper.Add(XK_Shift_R, TKey.keyRightShift);
  FKeyMapper.Add(XK_Control_L, TKey.keyLeftControl);
  FKeyMapper.Add(XK_Control_R, TKey.keyRightControl);
end;


{ TMainWindow public methods }

procedure TMainWindow.Done;
begin
  if FDisplay <> nil then
  begin
    if FWindow <> 0 then
    begin
      XDestroyWindow(FDisplay, FWindow);
      FWindow := 0;
    end;
    XCloseDisplay(FDisplay);
    FDisplay := nil;
  end;
  FEvents.Done;
end;

function TMainWindow.Create(W, H: Integer; const ATitle: string; out AError: string): Boolean;
var
  Root: TWindow;
  Visual: PVisual;
  Screen: Integer;
  ValueMask: Cardinal;
  Attributes: TXSetWindowAttributes;
begin
  Result := False;
  FWindow := 0;
  FLastMouseX := 0;
  FLastMouseY := 0;
  
  FDisplay := XOpenDisplay(nil);
  if FDisplay = nil then
  begin
    AError := 'XOpenDisplay fail';
    Exit;
  end;

  Screen := XDefaultScreen(FDisplay);
  Root := XRootWindow(FDisplay, Screen);
  Visual := XDefaultVisual(FDisplay, Screen);

  Attributes.background_pixel := XBlackPixel(FDisplay, Screen);
  Attributes.event_mask := ExposureMask or KeyPressMask or KeyReleaseMask or
                           ButtonPressMask or ButtonReleaseMask or PointerMotionMask or
                           StructureNotifyMask or FocusChangeMask;
  
  ValueMask := CWBackPixel or CWEventMask;

  FWindow := XCreateWindow(
    FDisplay, Root, 
    0, 0, W, H, 0, 
    XDefaultDepth(FDisplay, Screen), 
    InputOutput, Visual, 
    ValueMask, @Attributes
  );

  if FWindow = 0 then
  begin
    XCloseDisplay(FDisplay);
    FDisplay := nil;
    AError := 'XCreateWindow fail';
    Exit;
  end;

  Self.SetTitle(ATitle);

  FWMDelete := XInternAtom(FDisplay, 'WM_DELETE_WINDOW', False);
  XSetWMProtocols(FDisplay, FWindow, @FWMDelete, 1);

  XMapWindow(FDisplay, FWindow);
  XFlush(FDisplay);

  FEvents.Init;
  Self.InitKeyMapper;

  Result := True;
end;

function TMainWindow.CreateWithVisual(W, H: Integer; const ATitle: string; AVisualInfo: PXVisualInfo; out AError: string): Boolean;
var
  Root: TWindow;
  Screen: Integer;
  ValueMask: Cardinal;
  Attributes: TXSetWindowAttributes;
begin
  Result := False;
  FWindow := 0;
  FLastMouseX := 0;
  FLastMouseY := 0;

  FDisplay := XOpenDisplay(nil);
  if FDisplay = nil then
  begin
    AError := 'XOpenDisplay fail';
    Exit;
  end;

  Screen := XDefaultScreen(FDisplay);
  Root := XRootWindow(FDisplay, Screen);

  Attributes.colormap := XCreateColormap(FDisplay, Root, AVisualInfo^.visual, AllocNone);
  Attributes.background_pixel := XBlackPixel(FDisplay, Screen);
  Attributes.event_mask := ExposureMask or KeyPressMask or KeyReleaseMask or
                           ButtonPressMask or ButtonReleaseMask or PointerMotionMask or
                           StructureNotifyMask or FocusChangeMask;
  
  ValueMask := CWBackPixel or CWEventMask or CWColormap;

  FWindow := XCreateWindow(
    FDisplay, Root, 
    0, 0, W, H, 0, 
    AVisualInfo^.depth, 
    InputOutput, AVisualInfo^.visual, 
    ValueMask, @Attributes
  );

  if FWindow = 0 then
  begin
    XCloseDisplay(FDisplay);
    FDisplay := nil;
    AError := 'XCreateWindow fail';
    Exit;
  end;

  Self.SetTitle(ATitle);

  FWMDelete := XInternAtom(FDisplay, 'WM_DELETE_WINDOW', False);
  XSetWMProtocols(FDisplay, FWindow, @FWMDelete, 1);

  XMapWindow(FDisplay, FWindow);
  XFlush(FDisplay);

  FEvents.Init;
  Self.InitKeyMapper;

  Result := True;
end;


procedure TMainWindow.PollEvents;
var
  XEv: TXEvent;
  WinEvent: TEvent;
  KeySymObj: TKeySym;
begin
  if FDisplay = nil then Exit;

  while XPending(FDisplay) > 0 do
  begin
    XNextEvent(FDisplay, @XEv);
    FillChar(WinEvent, SizeOf(TEvent), 0);
    WinEvent.FType := TEventType.None;

    case XEv._type of
      KeyPress, KeyRelease:
        begin
          WinEvent.FType := TEventType.Keyboard;
          if XEv._type = KeyPress then
            WinEvent.Keyboard.State := TButtonState.Pressed
          else
            WinEvent.Keyboard.State := TButtonState.Released;

          KeySymObj := XLookupKeysym(@XEv.xkey, 0);
          WinEvent.Keyboard.Key := FKeyMapper.FindKey(KeySymObj);
        end;

      ButtonPress, ButtonRelease:
        begin
          if XEv.xbutton.button in [1..3] then
          begin
            WinEvent.FType := TEventType.MouseClick;
            if XEv._type = ButtonPress then
              WinEvent.Mouse.State := TButtonState.Pressed
            else
              WinEvent.Mouse.State := TButtonState.Released;

            WinEvent.Mouse.PosX := XEv.xbutton.x;
            WinEvent.Mouse.PosY := XEv.xbutton.y;
            WinEvent.Mouse.PosRelX := XEv.xbutton.x - FLastMouseX;
            WinEvent.Mouse.PosRelY := XEv.xbutton.y - FLastMouseY;
            
            FLastMouseX := XEv.xbutton.x;
            FLastMouseY := XEv.xbutton.y;
            
            case XEv.xbutton.button of
              1: WinEvent.Mouse.Button := TMouseButton.Left;
              2: WinEvent.Mouse.Button := TMouseButton.Middle;
              3: WinEvent.Mouse.Button := TMouseButton.Right;
            end;
          end
          else if (XEv._type = ButtonPress) and (XEv.xbutton.button in [4..7]) then
          begin
            WinEvent.FType := TEventType.MouseScroll;
            WinEvent.Mouse.State := TButtonState.Pressed;
            WinEvent.Mouse.PosX := XEv.xbutton.x;
            WinEvent.Mouse.PosY := XEv.xbutton.y;
            WinEvent.Mouse.PosRelX := XEv.xbutton.x - FLastMouseX;
            WinEvent.Mouse.PosRelY := XEv.xbutton.y - FLastMouseY;
            
            FLastMouseX := XEv.xbutton.x;
            FLastMouseY := XEv.xbutton.y;
            
            case XEv.xbutton.button of
              4: begin
                   WinEvent.Mouse.Scroll := TMouseScroll.Vertical;
                   WinEvent.Mouse.Delta := 1;
                 end;
              5: begin
                   WinEvent.Mouse.Scroll := TMouseScroll.Vertical;
                   WinEvent.Mouse.Delta := -1;
                 end;
              6: begin
                   WinEvent.Mouse.Scroll := TMouseScroll.Horizontal;
                   WinEvent.Mouse.Delta := -1;
                 end;
              7: begin
                   WinEvent.Mouse.Scroll := TMouseScroll.Horizontal;
                   WinEvent.Mouse.Delta := 1;
                 end;
            end;
          end;
        end;

      MotionNotify:
        begin
          WinEvent.FType := TEventType.MouseMove;
          WinEvent.Mouse.PosX := XEv.xmotion.x;
          WinEvent.Mouse.PosY := XEv.xmotion.y;
          WinEvent.Mouse.PosRelX := XEv.xmotion.x - FLastMouseX;
          WinEvent.Mouse.PosRelY := XEv.xmotion.y - FLastMouseY;
          
          FLastMouseX := XEv.xmotion.x;
          FLastMouseY := XEv.xmotion.y;
        end;

      ConfigureNotify:
        begin
          WinEvent.FType := TEventType.Resize;
          WinEvent.Resize.Width := XEv.xconfigure.width;
          WinEvent.Resize.Height := XEv.xconfigure.height;
        end;

      FocusIn:
        begin
          WinEvent.FType := TEventType.GainedFocus;
        end;

      FocusOut:
        begin
          WinEvent.FType := TEventType.LostFocus;
        end;

      ClientMessage:
        begin
          if (XEv.xclient.format = 32) and (TAtom(XEv.xclient.data.l[0]) = FWMDelete) then
          begin
            WinEvent.FType := TEventType.Quit;
            FEvents.Push(WinEvent);
            Self.StopEvent;
            Exit;
          end;
        end;
    end;

    if WinEvent.FType <> TEventType.None then
      FEvents.Push(WinEvent);
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
  if (FDisplay <> nil) and (FWindow <> 0) then
  begin
    XStoreName(FDisplay, FWindow, PChar(ATitle));
    XFlush(FDisplay);
  end;
end;

end.
