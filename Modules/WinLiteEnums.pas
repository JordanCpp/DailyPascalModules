unit WinLiteEnums;

{$mode objfpc}{$H+}

interface

type
  TButtonState = (
    Released = 0,
    Pressed  = 1
  );

  TMouseButton = (
    Left   = 1,
    Right  = 2,
    Middle = 3
  );

  TMouseScroll = (
    Vertical   = 1,
    Horizontal = 2
  );

  TEventType = (
    None = 0,
    Quit = 1,
    MouseMove,
    MouseClick,
    Resize,
    Keyboard,
    GainedFocus,
    LostFocus,
    MouseScroll
  );

 TKey = (
    keyUnknown = 1,
    keyLSystem,
    keyRSystem,
    keyMenu,
    keySemicolon,
    keySlash,
    keyEqual,
    keyHyphen,
    keyLBracket,
    keyRBracket,
    keyComma,
    keyPeriod,
    keyQuote,
    keyBackslash,
    keyTilde,
    keyEscape,
    keySpace,
    keyEnter,
    keyBackspace,
    keyTab,
    keyPageUp,
    keyPageDown,
    keyEnd,
    keyHome,
    keyInsert,
    keyDelete,
    keyAdd,
    keySubtract,
    keyMultiply,
    keyDivide,
    keyPause,
    keyF1,
    keyF2,
    keyF3,
    keyF4,
    keyF5,
    keyF6,
    keyF7,
    keyF8,
    keyF9,
    keyF10,
    keyF11,
    keyF12,
    keyF13,
    keyF14,
    keyF15,
    keyLeft,
    keyRight,
    keyUp,
    keyDown,
    keyNumpad0,
    keyNumpad1,
    keyNumpad2,
    keyNumpad3,
    keyNumpad4,
    keyNumpad5,
    keyNumpad6,
    keyNumpad7,
    keyNumpad8,
    keyNumpad9,
    keyA,
    keyZ,
    keyE,
    keyR,
    keyT,
    keyY,
    keyU,
    keyI,
    keyO,
    keyP,
    keyQ,
    keyS,
    keyD,
    keyF,
    keyG,
    keyH,
    keyJ,
    keyK,
    keyL,
    keyM,
    keyW,
    keyX,
    keyC,
    keyV,
    keyB,
    keyN,
    keyNum0,
    keyNum1,
    keyNum2,
    keyNum3,
    keyNum4,
    keyNum5,
    keyNum6,
    keyNum7,
    keyNum8,
    keyNum9,
    keyLeftShift,
    keyRightShift,
    keyLeftControl,
    keyRightControl
  );

implementation

end.