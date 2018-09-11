object fraInputDatas: TfraInputDatas
  Left = 0
  Top = 0
  Width = 629
  Height = 408
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Consolas'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  DesignSize = (
    629
    408)
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 84
    Height = 15
    Caption = #36755#20837#35774#35745#32534#21495
  end
  object cmbMeterList: TComboBox
    Left = 8
    Top = 29
    Width = 161
    Height = 23
    ImeMode = imDisable
    TabOrder = 0
    OnKeyPress = cmbMeterListKeyPress
  end
  object Memo1: TMemo
    Left = 376
    Top = 3
    Width = 253
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      #27979#35797#34920#20013#21482#26377'D01YBP'#65292'M18ZPR'#65292'R15'
      #12289'R16YBP'#19977#20010#34920#65292#35831#36873#25321#36825#20123#20202
      #22120#36827#34892#27979#35797#12290)
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object grdInput: TStringGrid
    Left = 3
    Top = 95
    Width = 609
    Height = 90
    Anchors = [akLeft, akTop, akRight]
    DefaultColWidth = 90
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs, goAlwaysShowEditor]
    PopupMenu = popInput
    TabOrder = 2
  end
  object grdRecent: TStringGrid
    Left = 8
    Top = 260
    Width = 609
    Height = 133
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultColWidth = 90
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    TabOrder = 3
  end
  object dtpDefault: TDateTimePicker
    Left = 8
    Top = 66
    Width = 105
    Height = 23
    Date = 43349.058782048610000000
    Time = 43349.058782048610000000
    ImeMode = imDisable
    TabOrder = 4
  end
  object popInput: TPopupMenu
    Left = 404
    Top = 112
    object piConfirmInput: TMenuItem
      Caption = #30830#23450#65306#26816#26597#24182#20445#23384
      OnClick = piConfirmInputClick
    end
    object piReInput: TMenuItem
      Caption = #37325#26032#36755#20837
      OnClick = piReInputClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object piShowHisData: TMenuItem
      Caption = #26174#31034#21382#21490#25968#25454
      OnClick = piShowHisDataClick
    end
  end
end
