program Test;

{$mode objfpc}{$H+}

uses
  Painter,
  WinLiteEnums,
  WinLiteEvents,
  WinLiteSoftwareWindow;

const
  WinWidth = 800;
  WinHeight = 600;
  BytesPerPixel = 4;

var
  Win: TSoftwareWindow;
  Ev: TEvent;
  Err: string;
  PixelBuffer: array of Byte;
  BufferSize: NativeInt;
  Render: TPainter;
  FrameCounter: Integer;

begin
  if not Win.CreateWindow(WinWidth, WinHeight, 'WinLite Hello World (Object Pascal)', Err) then
  begin
    WriteLn('Error: ', Err);
    Halt(1);
  end;

  Win.SetTitle('WinLite Software Render - Press ESC to exit');

  BufferSize := WinWidth * WinHeight * BytesPerPixel;
  SetLength(PixelBuffer, BufferSize);
  Render.Init(WinWidth, WinHeight, BytesPerPixel, @PixelBuffer[0], BufferSize);

  FrameCounter := 0;

  while Win.IsRunning do
  begin
    while Win.GetEvent(Ev) do
    begin
      case Ev.FType of
        TEventType.Quit:
          begin
            Win.StopEvent;
          end;

        TEventType.Keyboard:
          begin
            if (Ev.Keyboard.Key = keyEscape) and (Ev.Keyboard.State = TButtonState.Pressed) then
              Win.StopEvent;
          end;
      end;
    end;

    Inc(FrameCounter);

    Render.SetColor(MakeColor(10, 20, 40 + (FrameCounter mod 30)));
    Render.Clear;

    Render.SetColor(MakeColor(0, 255, 128));
    Render.Line(0, 0, WinWidth - 1, (FrameCounter * 4) mod WinHeight);
    Render.Line(WinWidth - 1, WinHeight - 1, 0, WinHeight - 1 - ((FrameCounter * 4) mod WinHeight));

    Render.SetColor(MakeColor(255, 64, 64));
    Render.Fill(WinWidth div 2 - 50, WinHeight div 2 - 50, 100, 100);

    Win.Present(@PixelBuffer[0], BytesPerPixel, WinWidth, WinHeight);
  end;

  Win.Done;
end.

