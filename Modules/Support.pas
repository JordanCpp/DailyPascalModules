{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

unit Support;

{$mode objfpc}{$H+}

interface

uses 
  SysUtils;

type
    {$IF FPC_VERSION < 3}
      TBytes = array of Byte;
    {$ELSE}
      TBytes = SysUtils.TBytes;
    {$IFEND}

implementation

end.

