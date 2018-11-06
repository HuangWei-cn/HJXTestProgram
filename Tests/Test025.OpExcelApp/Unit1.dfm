object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 538
  ClientWidth = 946
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 761
    Height = 538
    ActivePage = TabSheet4
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'XLSApp Variant'
      object Button1: TButton
        Left = 220
        Top = 8
        Width = 133
        Height = 25
        Caption = #21019#24314'ExcelApp'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 220
        Top = 39
        Width = 133
        Height = 25
        Caption = #25171#24320#19968#20010#25991#20214
        TabOrder = 1
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
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 215
        Top = 300
        Width = 138
        Height = 25
        Caption = #20851#38381'ExcelApp'
        TabOrder = 3
        OnClick = Button4Click
      end
      object ListBox1: TListBox
        Left = 8
        Top = 8
        Width = 201
        Height = 317
        ItemHeight = 13
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Use Excel Object'
      ImageIndex = 1
      object ListBox2: TListBox
        Left = 8
        Top = 12
        Width = 201
        Height = 317
        ItemHeight = 13
        TabOrder = 0
      end
      object Button5: TButton
        Left = 224
        Top = 12
        Width = 117
        Height = 25
        Caption = 'Open a Excel file'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Use XLSReadWriteII 6'
      ImageIndex = 2
      object Button6: TButton
        Left = 236
        Top = 28
        Width = 173
        Height = 25
        Caption = #27979#35797#35835#20889#21547'chart'#30340#25991#20214
        TabOrder = 0
        OnClick = Button6Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Use NativeExcel'
      ImageIndex = 3
      object Button7: TButton
        Left = 252
        Top = 24
        Width = 189
        Height = 25
        Caption = #27979#35797#35835#20889#21253#21547'Chart'#30340#25991#20214
        TabOrder = 0
        OnClick = Button7Click
      end
      object ListBox3: TListBox
        Left = 12
        Top = 12
        Width = 217
        Height = 409
        ItemHeight = 13
        TabOrder = 1
      end
      object Button8: TButton
        Left = 252
        Top = 64
        Width = 189
        Height = 29
        Hint = #25171#24320#24037#20316#31807#65292#24182#22312#31532#19968#20010#21253#21547'Chart'#30340#24037#20316#34920#30340#31532#20108#21015#20889#20837#38543#26426#25968#25454#65292#28982#21518#20445#23384
        Caption = #25171#24320#24037#20316#31807#24182#20889#20837#25968#25454
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = Button8Click
      end
    end
  end
  object Panel1: TPanel
    Left = 761
    Top = 0
    Width = 185
    Height = 538
    Align = alRight
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Excel'#24037#20316#31807'|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 24
    Top = 488
  end
  object SaveDialog1: TSaveDialog
    Left = 104
    Top = 488
  end
  object ExcelApplication1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = True
    Left = 296
    Top = 408
  end
  object ExcelWorkbook1: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 296
    Top = 460
  end
  object ExcelWorkbook2: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 388
    Top = 460
  end
  object ExcelWorksheet1: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 496
    Top = 464
  end
  object ExcelWorksheet2: TExcelWorksheet
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 592
    Top = 464
  end
  object XRW1: TXLSReadWriteII5
    ComponentVersion = '6.00.46a'
    Version = xvExcel2007
    DirectRead = False
    DirectWrite = False
    Left = 692
    Top = 464
  end
  object XRW2: TXLSReadWriteII5
    ComponentVersion = '6.00.46a'
    Version = xvExcel2007
    DirectRead = False
    DirectWrite = False
    Left = 769
    Top = 464
  end
end
