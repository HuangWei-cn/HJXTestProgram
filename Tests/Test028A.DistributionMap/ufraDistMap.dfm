object fraDistMap: TfraDistMap
  Left = 0
  Top = 0
  Width = 649
  Height = 336
  TabOrder = 0
  object pnlFunc: TPanel
    Left = 0
    Top = 0
    Width = 649
    Height = 41
    Align = alTop
    Caption = 'pnlFunc'
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      649
      41)
    object btnShowCustomPanel: TSpeedButton
      Left = 620
      Top = 9
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #9660
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      OnClick = btnShowCustomPanelClick
    end
    object btnLastData: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = #26368#26032#25968#25454
      TabOrder = 0
      OnClick = btnLastDataClick
    end
    object btnSpecialDate: TButton
      Left = 89
      Top = 10
      Width = 75
      Height = 25
      Caption = #25351#23450#26085#26399
      TabOrder = 1
      OnClick = btnSpecialDateClick
    end
    object dtpData: TDateTimePicker
      Left = 170
      Top = 13
      Width = 107
      Height = 21
      Date = 43964.698127569440000000
      Time = 43964.698127569440000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier Std'
      Font.Style = [fsBold]
      ImeMode = imDisable
      ParentFont = False
      TabOrder = 2
    end
    object btnAddNewLine: TButton
      Left = 328
      Top = 10
      Width = 75
      Height = 25
      Caption = #26032#22686#26354#32447
      TabOrder = 3
      OnClick = btnAddNewLineClick
    end
    object dtpNewLineDate: TDateTimePicker
      Left = 409
      Top = 13
      Width = 85
      Height = 21
      Date = 43965.833526296290000000
      Time = 43965.833526296290000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier Std'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
  object chtDistMap: TChart
    Left = 0
    Top = 105
    Width = 649
    Height = 231
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    Border.Visible = True
    Foot.Font.Color = clBlue
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    LeftWall.Color = 14745599
    Legend.Alignment = laTop
    Legend.Font.Name = 'Verdana'
    Legend.LegendStyle = lsSeries
    Legend.Shadow.Transparency = 0
    RightWall.Color = 14745599
    Title.Font.Height = -19
    Title.Font.Name = #40657#20307
    Title.Text.Strings = (
      #35266#27979#25968#25454#20998#24067#22270)
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = 15000804
    BottomAxis.Grid.Style = psDash
    BottomAxis.LabelsFormat.Font.Name = 'Courier New'
    BottomAxis.TicksInner.Color = 11119017
    BottomAxis.Title.Caption = #20202#22120#32534#21495
    BottomAxis.Title.Font.Name = 'Verdana'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = 11119017
    DepthAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthAxis.TicksInner.Color = 11119017
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = 11119017
    DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthTopAxis.TicksInner.Color = 11119017
    DepthTopAxis.Title.Font.Name = 'Verdana'
    LeftAxis.Axis.Color = 4210752
    LeftAxis.AxisValuesFormat = '0.00'
    LeftAxis.Grid.Color = 15000804
    LeftAxis.Grid.Style = psDash
    LeftAxis.LabelsFormat.Font.Name = 'Courier New'
    LeftAxis.TicksInner.Color = 11119017
    LeftAxis.Title.Caption = #29289#29702#37327
    LeftAxis.Title.Font.Name = 'Verdana'
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = 11119017
    RightAxis.LabelsFormat.Font.Name = 'Verdana'
    RightAxis.TicksInner.Color = 11119017
    RightAxis.Title.Font.Name = 'Verdana'
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = 11119017
    TopAxis.LabelsFormat.Font.Name = 'Verdana'
    TopAxis.TicksInner.Color = 11119017
    TopAxis.Title.Font.Name = 'Verdana'
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    Color = clWhite
    PopupMenu = PopupMenu1
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object pgbLoadDatas: TProgressBar
      Left = 1
      Top = 225
      Width = 647
      Height = 5
      Align = alBottom
      Smooth = True
      TabOrder = 0
      Visible = False
    end
    object srsFirst: TLineSeries
      Title = '2019-06-30'
      Brush.BackColor = clDefault
      Pointer.HorizSize = 3
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 3
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {
        04050000000000000000488240FF060000005030315A57590000000000A48540
        FF060000005030325A57590000000000588640FF060000005030335A57590000
        000000548540FF06000000503031444B440000000000FC8240FF060000005030
        32444B44}
      Detail = {0000000000}
    end
  end
  object pnlCustom: TPanel
    Left = 0
    Top = 41
    Width = 649
    Height = 64
    Align = alTop
    TabOrder = 2
    Visible = False
    object edtChartTitle: TLabeledEdit
      Left = 113
      Top = 6
      Width = 313
      Height = 21
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = #33258#23450#20041#22270#34920#26631#39064
      EditLabel.Layout = tlCenter
      LabelPosition = lpLeft
      TabOrder = 0
      OnKeyPress = edtChartTitleKeyPress
    end
    object edtAxisTitle: TLabeledEdit
      Left = 113
      Top = 33
      Width = 313
      Height = 21
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = #33258#23450#20041#22352#26631#36724#26631#39064
      LabelPosition = lpLeft
      TabOrder = 1
      OnKeyPress = edtAxisTitleKeyPress
    end
  end
  object TeeGDIPlus1: TTeeGDIPlus
    Active = True
    AntiAliasText = gpfBest
    TeePanel = chtDistMap
  end
  object PopupMenu1: TPopupMenu
    Left = 504
    Top = 61
    object piSetup: TMenuItem
      Caption = #35774#32622
      OnClick = piSetupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object piCopyChartAsBitmap: TMenuItem
      Caption = #25335#36125#22270#20687
      OnClick = piCopyChartAsBitmapClick
    end
  end
end
