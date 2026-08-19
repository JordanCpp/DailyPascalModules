{==============================================================================
  Copyright 2026-present Evgeny Zoshchuk (JordanCpp).
  Distributed under the Boost Software License, Version 1.0.
  (See accompanying file LICENSE_1_0.txt or copy at
  https://boost.org)
==============================================================================}

program PixelPainterPerfTest;
{$APPTYPE CONSOLE}
{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ELSE}
  {$LONGSTRINGS ON}
{$ENDIF}

uses
  SysUtils,
  Math,
  HighResTimer,
  PixelPainter,
  Support;

const
  BenchWidth  = 1024;
  BenchHeight = 768;

  IterClear   = 1000;
  IterPixel   = 20000000;
  IterLine    = 100000;
  IterFill    = 5000;

var
  Timer       : THighResTimer;
  Painter     : TPixelPainter;
  PixelBuffer : TBytes;
  DummySum    : Int64;

function ChecksumBuffer(const B: TBytes): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Length(B) - 1 do
    if B[I] > 0 then
      Result := Result + B[I];
end;

procedure RunBenchmarks;
var
  Start: Double;
  Elapsed: Double;
  PerfResult: Double;
  I: Integer;
  RndX0, RndY0, RndX1, RndY1: Integer;
  WDiv2, HDiv2: Integer;

  B_R, B_G, B_B, B_A : Byte;
  CalcVal            : Integer;
begin
  WriteLn('======================================================================');
  WriteLn('          PIXEL PAINTER PERFORMANCE TEST (Resolution: ', BenchWidth, 'x', BenchHeight, ')');
  WriteLn('======================================================================');
  WriteLn;

  RandSeed := 42;
  DummySum := 0;
  WDiv2 := BenchWidth div 2;
  HDiv2 := BenchHeight div 2;

  // ------------------------------------------------------------------
  // 1. Test: Clear
  // ------------------------------------------------------------------
  Write('Running Clear Benchmark... ');
  B_R := 10; B_G := 20; B_B := 30; B_A := 255;
  Painter.SetColor(MakeColor(B_R, B_G, B_B, B_A));
  Painter.Clear;

  Start := Timer.GetTime;
  for I := 1 to IterClear do
  begin
    CalcVal := I mod 255;

    B_R := Byte(I and $FF);
    B_G := Byte(CalcVal and $FF);
    B_B := 128;
    B_A := 255;

    Painter.SetColor(MakeColor(B_R, B_G, B_B, B_A));
    Painter.Clear;
  end;
  Elapsed := Timer.GetTime - Start;
  if Elapsed <= 0 then Elapsed := 0.00001;

  PerfResult := (1.0 * IterClear) / Elapsed;
  DummySum := DummySum + ChecksumBuffer(PixelBuffer);

  WriteLn('DONE');
  WriteLn('  Iterations:  ', IterClear);
  WriteLn('  Total Time:  ', Elapsed:0:4, ' sec');
  WriteLn('  Performance: ', PerfResult:0:2, ' ops/sec (FPS)');
  WriteLn('----------------------------------------------------------------------');

  // ------------------------------------------------------------------
  // 2. Test: Pixel
  // ------------------------------------------------------------------
  Write('Running Single Pixel Benchmark... ');
  B_R := 255; B_G := 255; B_B := 255; B_A := 255;
  Painter.SetColor(MakeColor(B_R, B_G, B_B, B_A));
  Painter.Pixel(10, 10);

  Start := Timer.GetTime;
  for I := 1 to IterPixel do
  begin
    RndX0 := (I * 31) mod BenchWidth;
    RndY0 := (I * 17) mod BenchHeight;
    Painter.Pixel(RndX0, RndY0);
  end;
  Elapsed := Timer.GetTime - Start;
  if Elapsed <= 0 then Elapsed := 0.00001;

  PerfResult := ((1.0 * IterPixel) / Elapsed) / 1000000.0;
  DummySum := DummySum + ChecksumBuffer(PixelBuffer);

  WriteLn('DONE');
  WriteLn('  Iterations:  ', IterPixel);
  WriteLn('  Total Time:  ', Elapsed:0:4, ' sec');
  WriteLn('  Performance: ', PerfResult:0:2, ' million pixels/sec');
  WriteLn('----------------------------------------------------------------------');

  // ------------------------------------------------------------------
  // 3. Test: Line
  // ------------------------------------------------------------------
  Write('Running Line Drawing Benchmark... ');
  B_R := 0; B_G := 255; B_B := 0; B_A := 255;
  Painter.SetColor(MakeColor(B_R, B_G, B_B, B_A));
  Painter.Line(0, 0, BenchWidth - 1, BenchHeight - 1);

  Start := Timer.GetTime;
  for I := 1 to IterLine do
  begin
    RndX0 := (I * 13) mod BenchWidth;
    RndY0 := (I * 7) mod BenchHeight;
    RndX1 := (I * 93) mod BenchWidth;
    RndY1 := (I * 43) mod BenchHeight;
    Painter.Line(RndX0, RndY0, RndX1, RndY1);
  end;
  Elapsed := Timer.GetTime - Start;
  if Elapsed <= 0 then Elapsed := 0.00001;

  PerfResult := (1.0 * IterLine) / Elapsed;
  DummySum := DummySum + ChecksumBuffer(PixelBuffer);

  WriteLn('DONE');
  WriteLn('  Iterations:  ', IterLine);
  WriteLn('  Total Time:  ', Elapsed:0:4, ' sec');
  WriteLn('  Performance: ', PerfResult:0:2, ' lines/sec');
  WriteLn('----------------------------------------------------------------------');

  // ------------------------------------------------------------------
  // 4. Test: Fill
  // ------------------------------------------------------------------
  Write('Running Area Fill Benchmark... ');
  B_R := 0; B_G := 0; B_B := 255; B_A := 255;
  Painter.SetColor(MakeColor(B_R, B_G, B_B, B_A));
  Painter.Fill(10, 10, 100, 100);

  Start := Timer.GetTime;
  for I := 1 to IterFill do
  begin
    RndX0 := (I * 5) mod WDiv2;
    RndY0 := (I * 11) mod HDiv2;
    RndX1 := 50 + ((I * 23) mod 300);
    RndY1 := 50 + ((I * 19) mod 300);
    Painter.Fill(RndX0, RndY0, RndX1, RndY1);
  end;
  Elapsed := Timer.GetTime - Start;
  if Elapsed <= 0 then Elapsed := 0.00001;

  PerfResult := (1.0 * IterFill) / Elapsed;
  DummySum := DummySum + ChecksumBuffer(PixelBuffer);

  WriteLn('DONE');
  WriteLn('  Iterations:  ', IterFill);
  WriteLn('  Total Time:  ', Elapsed:0:4, ' sec');
  WriteLn('  Performance: ', PerfResult:0:2, ' fills/sec');
  WriteLn('======================================================================');

  if DummySum = 123456789 then WriteLn('Magic matching hit!');
end;

begin
  try
    Timer.Init;

    SetLength(PixelBuffer, BenchWidth * BenchHeight * 4);
    Painter.Init(BenchWidth, BenchHeight, 4, PixelBuffer);

    RunBenchmarks;
  except
    on E: Exception do
      WriteLn('Error during execution: ', E.Message);
  end;

  WriteLn('Press ENTER to exit...');
  ReadLn;
end.
