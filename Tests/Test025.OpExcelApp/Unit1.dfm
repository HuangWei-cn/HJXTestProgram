object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 337
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 201
    Height = 317
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 220
    Top = 8
    Width = 133
    Height = 25
    Caption = #21019#24314'ExcelApp'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 220
    Top = 39
    Width = 133
    Height = 25
    Caption = #25171#24320#19968#20010#25991#20214
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 220
    Top = 70
    Width = 133
    Height = 25
    Hint = #36873#25321#19968#20010#24037#20316#34920#65292#28982#21518#25353#36825#20010#25353#38062
    Caption = #25335#36125#24037#20316#34920
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 215
    Top = 300
    Width = 138
    Height = 25
    Caption = #20851#38381'ExcelApp'
    TabOrder = 4
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Excel'#24037#20316#31807'|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 44
    Top = 264
  end
  object SaveDialog1: TSaveDialog
    Left = 124
    Top = 264
  end
end
