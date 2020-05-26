object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #20998#24067#22270#27979#35797#31243#24207
  ClientHeight = 573
  ClientWidth = 832
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 41
    Height = 532
    ExplicitLeft = 424
    ExplicitTop = 256
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 41
    Align = alTop
    Caption = #20027#21151#33021#21306
    TabOrder = 0
    ExplicitLeft = 660
    ExplicitTop = 408
    ExplicitWidth = 185
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 12
      Height = 13
      Caption = '    '
      Color = clMaroon
      ParentColor = False
      Transparent = False
    end
    object btnOpenProject: TButton
      Left = 25
      Top = 2
      Width = 75
      Height = 25
      Caption = #25171#24320#24037#31243
      TabOrder = 0
      OnClick = btnOpenProjectClick
    end
    object btnCreateNewDM: TButton
      Left = 118
      Top = 2
      Width = 75
      Height = 25
      Caption = #21019#24314#26032#22270
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 185
    Height = 532
    Align = alLeft
    Caption = #20202#22120#21015#34920
    TabOrder = 1
    ExplicitLeft = 304
    ExplicitTop = 336
    ExplicitHeight = 41
  end
  object Panel3: TPanel
    Left = 188
    Top = 41
    Width = 644
    Height = 532
    Align = alClient
    BevelOuter = bvNone
    Caption = #20998#24067#22270#21015#34920
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 2
    ExplicitLeft = 191
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Left = 144
    Top = 141
  end
end
