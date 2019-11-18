object Form1: TForm1
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = #1047#1072#1083#1077#1081' '#1101#1090#1086
  ClientHeight = 469
  ClientWidth = 630
  Color = 5275647
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 187
    Top = 248
    Width = 84
    Height = 69
    OnMouseDown = Image2MouseDown
    OnMouseMove = Image2MouseMove
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 450
    Width = 630
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object Button1: TButton
    Left = 464
    Top = 8
    Width = 147
    Height = 49
    Caption = 'Go!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 383
    Top = 8
    Width = 75
    Height = 49
    Caption = 'Clear'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 296
    Top = 8
    Width = 81
    Height = 57
    ItemIndex = 0
    Items.Strings = (
      #1079#1072#1083#1080#1074#1082#1072
      #1087#1086#1074#1086#1088#1086#1090)
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 176
    object Open1: TMenuItem
      Caption = 'Open'
      OnClick = Open1Click
    end
    object Undo1: TMenuItem
      Caption = 'Undo'
      OnClick = Undo1Click
    end
    object Here1: TMenuItem
      Caption = 'Here'
      OnClick = Here1Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 240
    Top = 176
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.bmp|*.bmp'
    InitialDir = '.'
    Left = 64
    Top = 176
  end
end
