object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #20998#24067#22270#27979#35797#31243#24207
  ClientHeight = 542
  ClientWidth = 824
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 185
    Top = 41
    Height = 501
    ExplicitLeft = 416
    ExplicitTop = 240
    ExplicitHeight = 100
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 824
    Height = 41
    Align = alTop
    Caption = 'pnlMain'
    TabOrder = 0
    object btnOpenProject: TButton
      Left = 39
      Top = 5
      Width = 75
      Height = 25
      Caption = #25171#24320#24037#31243
      TabOrder = 0
      OnClick = btnOpenProjectClick
    end
    object btnNewDM: TButton
      Left = 136
      Top = 5
      Width = 75
      Height = 25
      Caption = #21019#24314#26032#22270
      TabOrder = 1
      OnClick = btnNewDMClick
    end
    object pnlLED: TPanel
      Left = 10
      Top = 8
      Width = 23
      Height = 20
      Caption = 'pnlLED'
      Color = clMaroon
      ParentBackground = False
      ShowCaption = False
      TabOrder = 2
    end
  end
  object pnlMeterList: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 501
    Align = alLeft
    Caption = 'pnlMeterList'
    TabOrder = 1
  end
  object pnl1: TPanel
    Left = 188
    Top = 41
    Width = 636
    Height = 501
    Align = alClient
    Caption = 'pnl1'
    TabOrder = 2
  end
  object dlgOpenProject: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Left = 316
    Top = 185
  end
end
