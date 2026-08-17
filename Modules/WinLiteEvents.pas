unit WinLiteEvents;

{$mode objfpc}{$H+}

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