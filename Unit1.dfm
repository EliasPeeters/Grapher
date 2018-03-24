object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Funktionsplotter'
  ClientHeight = 574
  ClientWidth = 1211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object MalKasten: TPaintBox
    Left = 0
    Top = 0
    Width = 800
    Height = 500
    Color = clWhite
    ParentColor = False
    OnMouseDown = MalKastenMouseDown
    OnMouseMove = MalKastenMouseMove
    OnMouseUp = MalKastenMouseUp
  end
  object EdtEingabeFunktion: TEdit
    Left = 853
    Top = 88
    Width = 90
    Height = 21
    TabOrder = 0
    Text = 'x^2'
  end
  object Panel1: TPanel
    Left = 814
    Top = 87
    Width = 41
    Height = 21
    Caption = 'f(x)='
    TabOrder = 1
  end
  object TrackBar1: TTrackBar
    Left = 0
    Top = 506
    Width = 800
    Height = 45
    Max = 1000
    Min = 1
    Position = 500
    TabOrder = 2
    ThumbLength = 50
    OnChange = TrackBar1Change
  end
  object Button1: TButton
    Left = 806
    Top = 537
    Width = 129
    Height = 25
    Caption = 'Funktionzeichnen'
    TabOrder = 3
    OnClick = EdtEingabeFunktionChange
  end
  object Button2: TButton
    Left = 806
    Top = 506
    Width = 129
    Height = 25
    Caption = 'center'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Funktion1CheckBox: TCheckBox
    Left = 960
    Top = 90
    Width = 49
    Height = 17
    Caption = 'Visible'
    TabOrder = 5
    OnClick = EdtEingabeFunktionChange
  end
  object DesignPanel: TPanel
    Left = 814
    Top = 115
    Width = 41
    Height = 21
    Caption = 'f(x)='
    TabOrder = 6
  end
  object Funktion2Edit: TEdit
    Left = 853
    Top = 115
    Width = 90
    Height = 21
    TabOrder = 7
    Text = 'x^2'
  end
  object Funktion2Check: TCheckBox
    Left = 960
    Top = 117
    Width = 49
    Height = 17
    Caption = 'Visible'
    TabOrder = 8
    OnClick = EdtEingabeFunktionChange
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
  end
  object MainMenu1: TMainMenu
    Left = 24
    object T1: TMenuItem
      Caption = 'Funktionsplotter'
      object Die1: TMenuItem
        Caption = 'Hilfe'
        OnClick = Die1Click
      end
      object ist1: TMenuItem
        Caption = 'Developer'
        OnClick = ist1Click
      end
    end
    object test1: TMenuItem
      Caption = 'Save'
      object SaveAs1: TMenuItem
        Caption = 'Save As'
        OnClick = SaveAs1Click
      end
    end
    object Programm1: TMenuItem
      Caption = 'Programm'
      object Schlieen1: TMenuItem
        Caption = 'Schlie'#223'en'
        OnClick = Schlieen1Click
      end
      object Minimieren1: TMenuItem
        Caption = 'Minimieren'
        OnClick = Minimieren1Click
      end
    end
  end
end
