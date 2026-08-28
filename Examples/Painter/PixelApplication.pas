{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit PixelApplication;

{$mode objfpc}{$H+}

interface

uses
  Support,
  SysUtils,
  Math,
  PixelPainter,
  PixelCopier,
  WinLiteEnums,
  WinLiteEvents,
  WinLiteWindow,
  BmpLoader;

type
  TPixelApplication = object
    Window      : TSoftwareWindow;
  end;

implementation

end.
