program Test;

{$mode objfpc}{$H+}

uses
  BmpLoader;

var
  Loader: TBmpLoader;
  Image : TImage;
  Error : TBmpError;

procedure TestEqual(Condition: Boolean; const Description: string);
begin
  if not Condition then
  begin
    Writeln('Test failed: ' + Description);
  end;
end;

begin
  TestEqual(Loader.Load('LDL_24_256.bmp', Image, Error), 'Not load LDL_24_256.bmp');
  TestEqual(Image.Pixels <> nil,  'Pixels is nil');
  TestEqual(Image.Width  = 256,   'Width not correct');
  TestEqual(Image.Height = 256,   'Height not correct');
  TestEqual(Image.Bpp    = 4,     'Bpp not correct');
  Image.Free;
end.
