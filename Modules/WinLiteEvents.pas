{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit WinLiteEvents;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  WinLiteEnums;

type
  TGainedFocus = record
  end;

  TLostFocus = record
  end;

  TQuit = record
  end;

  TKeyboard = record
    State: TButtonState;
    Key: TKey;
  end;

  TResize = record
    Width: Integer;
    Height: Integer;
  end;

  TMouse = record
    State: TButtonState;
    Button: TMouseButton;
    Scroll: TMouseScroll;
    PosX: Integer;
    PosY: Integer;
    PosRelX: Integer;
    PosRelY: Integer;
    Delta: Integer;
  end;

TEvent = record
    FType: TEventType;
    case TEventType of
      None: (TypeOnly: TEventType);
      Quit: (Quit: TQuit);
      MouseMove,
      MouseClick,
      MouseScroll: (Mouse: TMouse);
      Resize: (Resize: TResize);
      Keyboard: (Keyboard: TKeyboard);
      GainedFocus: (GainedFocus: TGainedFocus);
      LostFocus: (LostFocus: TLostFocus);
  end;

implementation

end.