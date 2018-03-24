unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.Menus, Vcl.ActnPopup,
  Vcl.Imaging.pngimage, Vcl.WinXCtrls, StrUtils, math, Funktionsrechner;

type
  TForm1 = class(TForm)
    MalKasten: TPaintBox;
    EdtEingabeFunktion: TEdit;
    Panel1: TPanel;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    MainMenu1: TMainMenu;
    T1: TMenuItem;
    Die1: TMenuItem;
    ist1: TMenuItem;
    Programm1: TMenuItem;
    Schlieen1: TMenuItem;
    test1: TMenuItem;
    Minimieren1: TMenuItem;
    SaveAs1: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    Funktion1CheckBox: TCheckBox;
    DesignPanel: TPanel;
    Funktion2Edit: TEdit;
    Funktion2Check: TCheckBox;
    procedure Malen;
    procedure Button1Click(Sender: TObject);
    procedure EdtEingabeFunktionChange(Sender: TObject);
    procedure Malx;
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Funktionzeichnen;
    procedure Schlieen1Click(Sender: TObject);
    procedure Minimieren1Click(Sender: TObject);
    procedure Abstuerzen1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintToFile(const FileName: String);
    procedure SaveAs1Click(Sender: TObject);
    procedure MalKastenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MalKastenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MalKastenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Die1Click(Sender: TObject);
    procedure ist1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Funktion1, Funktion2: String;
  XWert, XWertMinus : Extended;
  OldPositionX: Integer = -1;
  OldPositionY: Integer = -1;
  XVerschiebung, YVerschiebung: Extended;
  Alterwert: Integer = 0;


implementation

{$R *.dfm}



procedure TForm1.PaintToFile(const FileName: string);
var
  Bitmap: TBitmap;
  begin
    Bitmap := TBitmap.Create;
  try
    Bitmap.SetSize(Malkasten.Width, Malkasten.Height);
    FunktionZeichnen;
    BitBlt(Bitmap.Canvas.Handle, 0, 0, Malkasten.Width, Malkasten.Height, MalKasten.Canvas.Handle, 0, 0, SRCCOPY);
    Bitmap.SaveToFile(FileName);
  finally
    Bitmap.Free;
  end;
end;

procedure TForm1.Malx;
begin
with MalKasten.Canvas do
  begin
    Pen.Color:= cl3dlight;
    Moveto(0,500);
    LineTo(800, 0);
  end;
end;


procedure TForm1.Minimieren1Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
var
FileName: String;
begin
  FileName:= InputBox('Save as', 'File Name', '');
  PaintToFile(FileName);

end;

procedure TForm1.Schlieen1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Malen;
  Funktionzeichnen;
  Timer1.Enabled:= false;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Funktionzeichnen;
end;

function PixelwertZuKoordinatensystem(Pixelwert, Verschiebung, Skalierung: Extended): Extended;
begin
  Result:= (Pixelwert-Verschiebung)/Skalierung;
end;

function KoordinatensystemZuPixelwert(Koordinatensystem, Verschiebung, Skalierung: Extended): Integer;
begin
  Result:= Round(-(Koordinatensystem*Skalierung)+Verschiebung);
end;



function Graphen (Eingabe: String; xWert: Extended):Extended;
var
Ergebnis: Extended;
begin
    result:= BerechneY(xWert, Eingabe);
    //Writeln(FloatToStr(xWert) + ' -> ' + FloatToStr(result));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  YVerschiebung:= MalKasten.Height div 2;
  XVerschiebung:= MalKasten.Width div 2;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  AlterWert:= AlterWert+(WheelDelta div 120);
  TrackBar1.Position:= AlterWert;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Malen;
end;

procedure TForm1.FunktionZeichnen;
var
I: Integer;
Skalierung: Extended;
begin
  Malen;
  Funktion1:= EdtEingabeFunktion.Text;
  Funktion2:= Funktion2Edit.Text;
  Skalierung:= Trackbar1.Position;
  Malkasten.Canvas.TextOut(10,Round(YVerschiebung)-20,FloatToStrF(PixelwertZuKoordinatensystem(0, XVerschiebung, Skalierung), ffFixed, 4, 2));
  Malkasten.Canvas.TextOut(770,Round(YVerschiebung)-20,FloatToStrF(PixelwertZuKoordinatensystem(800, XVerschiebung, Skalierung), ffFixed, 4, 2));
  Malkasten.Canvas.MoveTo(0, KoordinatensystemZuPixelwert(Graphen(Funktion1, PixelwertZuKoordinatensystem(0,XVerschiebung, Skalierung)),yVerschiebung, Skalierung));

  for I := 1 to Malkasten.Width-1 do
  begin
    if Funktion1CheckBox.Checked then
    begin
      Malkasten.Canvas.LineTo(I, KoordinatensystemZuPixelwert(Graphen(Funktion1, PixelwertZuKoordinatensystem(I,XVerschiebung, Skalierung)),yVerschiebung, Skalierung));
    end;
  end;

  Malkasten.Canvas.MoveTo(0, KoordinatensystemZuPixelwert(Graphen(Funktion1, PixelwertZuKoordinatensystem(0,XVerschiebung, Skalierung)),yVerschiebung, Skalierung));

  for I := 1 to Malkasten.Width-1 do
  begin
    if Funktion2Check.Checked then
    begin
      Malkasten.Canvas.LineTo(I, KoordinatensystemZuPixelwert(Graphen(Funktion2, PixelwertZuKoordinatensystem(I,XVerschiebung, Skalierung)),yVerschiebung, Skalierung));
    end;
  end;
end;

procedure TForm1.ist1Click(Sender: TObject);
begin
  ShowMessage('Elias Peeters, ©2018');
end;

procedure TForm1.EdtEingabeFunktionChange(Sender: TObject);
begin
  FunktionZeichnen;
end;

procedure TForm1.Malen;
var
Skalierung: Extended;
begin
  Skalierung:= Trackbar1.Position;
  with MalKasten.Canvas do
  begin
    Rectangle(0, 0, 800, 500);
    MoveTo(KoordinatensystemZuPixelwert(0,XVerschiebung, Skalierung), 0 );
    LineTo(KoordinatensystemZuPixelwert(0,XVerschiebung, Skalierung), 500 );
    MoveTo(0, KoordinatensystemZuPixelwert(0,YVerschiebung, Skalierung));
    LineTo(800, KoordinatensystemZuPixelwert(0,YVerschiebung, Skalierung) );
    {
    MoveTo(0,250);
    LineTo(800, 250);
    MoveTo(400, 0);
    LineTo(400, 500);
    MoveTo(800,250);
    Lineto(790, 240);
    MoveTo(800 ,250);
    Lineto(790, 260);
    MoveTo(400, 0);
    LineTo(390, 10);
    MoveTo(400, 0);
    LineTo(410, 10);
    }
  end;
end;

procedure TForm1.MalKastenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OldPositionX:= X;
  OldPositionY:= Y;
end;

procedure TForm1.MalKastenMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if OldPositionX <> -1 then
  begin
    XVerschiebung:= XVerschiebung + X - OldPositionX;
    YVerschiebung:= YVerschiebung + Y - OldPositionY;
    OldPositionX:= X;
    OldPositionY:= Y;
    FunktionZeichnen;
  end;
end;

procedure TForm1.MalKastenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  OldPositionX:= -1;
end;

procedure TForm1.Abstuerzen1Click(Sender: TObject);
begin
  Form1.Cursor:= crHourGlass;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Malen;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  XVerschiebung:= MalKasten.Width div 2;
  YVerschiebung:= Malkasten.Height div 2;
  Funktionzeichnen;
end;

procedure TForm1.Die1Click(Sender: TObject);
begin
  ShowMessage('Trage eine Funktion im Feld ein. Bewege dich per Drag&Drop auf dem Plotter. Nutze die Trackbar um dich umzuschauen' );
end;

end.
