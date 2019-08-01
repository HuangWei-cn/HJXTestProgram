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
    TabOrder = 0
    ExplicitLeft = 204
    ExplicitTop = 128
    ExplicitWidth = 185
    object btnLastData: TButton
      Left = 60
      Top = 8
      Width = 75
      Height = 25
      Caption = #26368#26032#25968#25454
      TabOrder = 0
      OnClick = btnLastDataClick
    end
  end
  object chtDistMap: TChart
    Left = 0
    Top = 41
    Width = 649
    Height = 295
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    BackWall.Brush.Gradient.Visible = True
    BackWall.Transparent = False
    Foot.Font.Color = clBlue
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    Gradient.Visible = True
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
    BottomAxis.Grid.Color = 11119017
    BottomAxis.LabelsFormat.Font.Name = 'Verdana'
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
    LeftAxis.Grid.Color = 11119017
    LeftAxis.LabelsFormat.Font.Name = 'Verdana'
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
    TabOrder = 1
    ExplicitLeft = 120
    ExplicitTop = 112
    ExplicitWidth = 400
    ExplicitHeight = 250
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Title = '2019-06-30'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
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
  object TeeGDIPlus1: TTeeGDIPlus
    Active = True
    AntiAliasText = gpfBest
    TeePanel = chtDistMap
  end
end
