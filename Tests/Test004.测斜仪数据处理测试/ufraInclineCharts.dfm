object fraInclineCharts: TfraInclineCharts
  Left = 0
  Top = 0
  Width = 443
  Height = 644
  TabOrder = 0
  object pgcInclineCharts: TPageControl
    Left = 0
    Top = 0
    Width = 443
    Height = 644
    ActivePage = tab2D
    Align = alClient
    TabOrder = 0
    object tabEigenValue: TTabSheet
      Caption = #29305#24449#20540
      ImageIndex = 3
      object mmoEigenValue: TMemo
        Left = 0
        Top = 77
        Width = 435
        Height = 539
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object pnlHoleInfo: TPanel
        Left = 0
        Top = 0
        Width = 435
        Height = 77
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #40657#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object lblHoleInfo: TLabel
          Left = 48
          Top = 12
          Width = 280
          Height = 52
          AutoSize = False
          Caption = #35774#35745#32534#21495#65306#13#10#24037#31243#37096#20301#65306#13#10#26729'    '#21495#65306#13#10#21021#20540#26085#26399#65306
          WordWrap = True
        end
      end
    end
    object tab2D: TTabSheet
      Caption = #20108#32500#20301#31227#22270
      OnResize = tab2DResize
      object cht2DA: TChart
        Left = 0
        Top = 0
        Width = 229
        Height = 616
        BackWall.Brush.Gradient.Direction = gdBottomTop
        BackWall.Brush.Gradient.EndColor = clWhite
        BackWall.Brush.Gradient.StartColor = 15395562
        BackWall.Brush.Gradient.Visible = True
        BackWall.Color = clWhite
        Border.Visible = True
        Foot.Font.Color = clBlue
        Foot.Font.Name = 'Verdana'
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        LeftWall.Color = 14745599
        Legend.Alignment = laBottom
        Legend.Font.Name = 'Verdana'
        Legend.Shadow.Transparency = 0
        Legend.Visible = False
        MarginBottom = 2
        MarginLeft = 4
        MarginRight = 4
        MarginTop = 2
        RightWall.Color = 14745599
        Title.Font.Name = 'Verdana'
        Title.Font.Quality = fqNormal
        Title.Margins.Units = maPixels
        Title.Text.Strings = (
          #27979#26012#23380
          'A'#21521#20301#31227#21464#21270#37327#26354#32447)
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFormat.Font.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Caption = #20301#31227'(mm)'
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
        LeftAxis.Inverted = True
        LeftAxis.LabelsFormat.Font.Name = 'Verdana'
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Caption = #28145#24230'(m)'
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
        Zoom.Animated = True
        Align = alLeft
        BevelInner = bvLowered
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = pmChartOp
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object LineA: THorizLineSeries
          Legend.Text = 'A'#21521#20559#31227#21464#21270#37327
          LegendTitle = 'A'#21521#20559#31227#21464#21270#37327
          ColorEachLine = False
          SeriesColor = 8388863
          Title = 'A'#21521#20559#31227#26354#32447
          Brush.BackColor = clDefault
          Pointer.HorizSize = 3
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          Pointer.VertSize = 3
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loAscending
        end
        object axscrltlChartTool1: TAxisScrollTool
          Limit = slBoth
          AxisID = 2
        end
        object axscrltlChartTool2: TAxisScrollTool
          Limit = slBoth
          AxisID = 0
        end
      end
      object cht2DB: TChart
        Left = 229
        Top = 0
        Width = 206
        Height = 616
        BackWall.Brush.Gradient.Direction = gdBottomTop
        BackWall.Brush.Gradient.EndColor = clWhite
        BackWall.Brush.Gradient.StartColor = 15395562
        BackWall.Brush.Gradient.Visible = True
        Border.Visible = True
        Foot.Font.Color = clBlue
        Foot.Font.Name = 'Verdana'
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        LeftWall.Color = 14745599
        Legend.Alignment = laBottom
        Legend.Font.Name = 'Verdana'
        Legend.Shadow.Transparency = 0
        Legend.Visible = False
        MarginBottom = 2
        MarginLeft = 4
        MarginRight = 4
        MarginTop = 2
        RightWall.Color = 14745599
        Title.Font.Name = 'Verdana'
        Title.Text.Strings = (
          #27979#26012#23380
          'B'#21521#20301#31227#21464#21270#37327#26354#32447)
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFormat.Font.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Caption = #20301#31227'(mm)'
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
        LeftAxis.Inverted = True
        LeftAxis.LabelsFormat.Font.Name = 'Verdana'
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Caption = #28145#24230'(m)'
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
        Zoom.Animated = True
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = pmChartOp
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
        object LineB: THorizLineSeries
          Legend.Text = 'A'#21521#20559#31227#21464#21270#37327
          LegendTitle = 'A'#21521#20559#31227#21464#21270#37327
          ColorEachLine = False
          SeriesColor = 6870287
          Title = 'B'#21521#20559#31227#26354#32447
          Brush.BackColor = clDefault
          Pointer.HorizSize = 3
          Pointer.InflateMargins = True
          Pointer.Style = psDiamond
          Pointer.VertSize = 3
          Pointer.Visible = True
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loAscending
        end
        object AxisScrollTool1: TAxisScrollTool
          Limit = slBoth
          AxisID = 2
        end
        object AxisScrollTool2: TAxisScrollTool
          Limit = slBoth
          AxisID = 0
        end
      end
    end
    object tab3D: TTabSheet
      Caption = #19977#32500#20301#31227#22270
      ImageIndex = 1
      object cht3D: TChart
        Left = 0
        Top = 0
        Width = 435
        Height = 616
        AllowPanning = pmNone
        BackWall.Brush.Gradient.Direction = gdBottomTop
        BackWall.Brush.Gradient.EndColor = clWhite
        BackWall.Brush.Gradient.StartColor = 15395562
        BackWall.Brush.Gradient.Visible = True
        BackWall.Color = 4227327
        Border.Visible = True
        BottomWall.Color = clBtnFace
        BottomWall.Transparent = True
        Foot.Font.Color = clBlack
        Foot.Font.Height = -13
        Foot.Font.Name = 'Lucida Console'
        Foot.Font.Style = [fsBold]
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        LeftWall.Color = 4227072
        LeftWall.Transparency = 33
        LeftWall.Transparent = True
        Legend.Color = clBtnFace
        Legend.Font.Height = -12
        Legend.Font.Name = 'Lucida Console'
        Legend.Shadow.Color = -8355712
        Legend.Shadow.Transparency = 0
        Legend.Visible = False
        RightWall.Color = clBtnFace
        RightWall.Transparency = 50
        RightWall.Transparent = True
        SubFoot.Font.Color = clBlack
        SubTitle.Font.Color = clBlack
        Title.Font.Charset = ANSI_CHARSET
        Title.Font.Color = clBlack
        Title.Font.Height = -12
        Title.Font.Name = 'Times New Roman'
        Title.Font.Style = [fsBold]
        Title.Font.Quality = fqBest
        Title.Shadow.Color = 723723
        Title.Shadow.HorizSize = 7
        Title.Shadow.Transparency = 45
        Title.Shadow.VertSize = 7
        Title.Text.Strings = (
          #27979#26012#23380
          #21464#24418#19977#32500#26354#32447)
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 12895428
        BottomAxis.Grid.Visible = False
        BottomAxis.LabelsFormat.Font.Height = -13
        BottomAxis.LabelsFormat.Font.Name = 'Lucida Console'
        BottomAxis.LabelsSeparation = 50
        BottomAxis.MinorTickLength = -3
        BottomAxis.MinorTicks.Color = clBlack
        BottomAxis.TickInnerLength = 6
        BottomAxis.TickLength = 10
        BottomAxis.TicksInner.Color = clBlack
        BottomAxis.Title.Font.Height = -16
        BottomAxis.Title.Font.Name = 'Verdana'
        BottomAxis.Title.Font.Quality = fqBest
        Chart3DPercent = 100
        DepthAxis.Axis.Color = 4210752
        DepthAxis.ExactDateTime = False
        DepthAxis.Grid.Color = 12895428
        DepthAxis.LabelsFormat.Font.Height = -13
        DepthAxis.LabelsFormat.Font.Name = 'Lucida Console'
        DepthAxis.LabelsFormat.Font.Quality = fqBest
        DepthAxis.LabelsFormat.Margins.Units = maPixels
        DepthAxis.LabelsSeparation = 100
        DepthAxis.MinorTickLength = -3
        DepthAxis.MinorTicks.Color = clBlack
        DepthAxis.TickInnerLength = 6
        DepthAxis.TickLength = 0
        DepthAxis.TicksInner.Color = clBlack
        DepthAxis.Title.Font.Height = -16
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Title.Font.Quality = fqBest
        DepthAxis.Title.Font.Shadow.Visible = False
        DepthAxis.Title.BevelWidth = 1
        DepthAxis.Title.Shadow.Visible = False
        DepthAxis.Title.ShapeStyle = fosRoundRectangle
        DepthAxis.Visible = True
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 12895428
        DepthTopAxis.LabelsFormat.Font.Name = 'Lucida Console'
        DepthTopAxis.MinorTickLength = -3
        DepthTopAxis.MinorTicks.Color = clBlack
        DepthTopAxis.TickInnerLength = 6
        DepthTopAxis.TickLength = 0
        DepthTopAxis.TicksInner.Color = clBlack
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 12895428
        LeftAxis.Inverted = True
        LeftAxis.LabelsFormat.Font.Name = 'Lucida Console'
        LeftAxis.MinorTickLength = -3
        LeftAxis.MinorTicks.Color = clBlack
        LeftAxis.PositionPercent = 50.000000000000000000
        LeftAxis.TickInnerLength = 6
        LeftAxis.TickLength = 0
        LeftAxis.TicksInner.Color = clBlack
        LeftAxis.Title.Font.Name = 'Verdana'
        LeftAxis.ZPosition = 50.000000000000000000
        Panning.MouseWheel = pmwNone
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 12895428
        RightAxis.LabelsFormat.Font.Name = 'Lucida Console'
        RightAxis.MinorTickLength = -3
        RightAxis.MinorTicks.Color = clBlack
        RightAxis.TickInnerLength = 6
        RightAxis.TickLength = 0
        RightAxis.TicksInner.Color = clBlack
        RightAxis.Title.Font.Name = 'Verdana'
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 12895428
        TopAxis.Grid.Visible = False
        TopAxis.LabelsFormat.Font.Name = 'Lucida Console'
        TopAxis.MinorTickLength = -3
        TopAxis.MinorTicks.Color = clBlack
        TopAxis.TickInnerLength = 6
        TopAxis.TickLength = 0
        TopAxis.TicksInner.Color = clBlack
        TopAxis.Title.Font.Name = 'Verdana'
        View3DOptions.Elevation = 346
        View3DOptions.HorizOffset = -14
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 50
        View3DOptions.Rotation = 317
        View3DOptions.Zoom = 65
        View3DOptions.ZoomText = ztAuto
        Zoom.Allow = False
        ZoomWheel = pmwNormal
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = pmChartOp
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        PrintMargins = (
          35
          15
          35
          15)
        ColorPaletteIndex = 6
        object Line3D: TPoint3DSeries
          Marks.Brush.Gradient.Visible = True
          Marks.Font.Name = 'Lucida Console'
          Marks.Shadow.Color = -8355712
          Marks.BackColor = clBtnFace
          Marks.Color = clBtnFace
          Title = '3D'#26354#32447
          LinePen.Color = 506371
          LinePen.Width = 2
          Pointer.Depth = 4
          Pointer.InflateMargins = True
          Pointer.Pen.Color = 25600
          Pointer.Style = psDownTriangle
          Pointer.Transparency = 37
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loNone
          ZValues.Name = 'Z'
          ZValues.Order = loNone
        end
        object rtlChartTool1: TRotateTool
          Inertia = 90
          Pen.Color = clWhite
          Pen.Mode = pmXor
        end
        object ctl3d_A: TText3DTool
          Brush.BackColor = clBlack
          Font.Height = -24
          Font.Name = #40657#20307
          Font.Quality = fqBest
          Font.OutLine.Color = 1868850276
          Font.OutLine.Width = 0
          Font.OutLine.Visible = True
          Font.Shadow.Visible = False
          Position.X = 160.000000000000000000
          Position.Y = 640.000000000000000000
          Position.Z = -30.000000000000000000
          Rotation.X = 91.000000000000000000
          Text = 'A'#21521#20559#31227'(mm)'
        end
        object ctl3d_B: TText3DTool
          Brush.BackColor = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Height = -24
          Font.Name = #40657#20307
          Font.Quality = fqBest
          Font.OutLine.Color = 1686077311
          Font.OutLine.Width = 0
          Font.OutLine.Visible = True
          Font.Shadow.Smooth = False
          Font.Shadow.Visible = False
          Position.X = 180.000000000000000000
          Position.Y = 640.000000000000000000
          Position.Z = -15.000000000000000000
          Text = 'B'#21521#20301#31227'(mm)'
        end
        object ctl3d_D: TText3DTool
          Brush.BackColor = clBlack
          Font.Height = -25
          Font.OutLine.Color = 6908265
          Font.OutLine.Width = 0
          Font.OutLine.Visible = True
          Position.X = 50.000000000000000000
          Position.Y = 40.000000000000000000
          Text = #28145#24230'(m)'
        end
        object Ani3DChart: TTeeAnimationTool
          object TRotate3DAnimation
            Loop = True
            Title = #26059#36716
            Chart = cht3D
          end
        end
      end
    end
    object tabHistory: TTabSheet
      Caption = #20301#31227#36807#31243#32447
      ImageIndex = 2
      object chtHistoryLinesA: TChart
        Left = 0
        Top = 18
        Width = 435
        Height = 598
        AllowPanning = pmNone
        BackWall.Brush.Gradient.Direction = gdBottomTop
        BackWall.Brush.Gradient.EndColor = clWhite
        BackWall.Brush.Gradient.MidColor = clWhite
        BackWall.Brush.Gradient.StartColor = 15395562
        BackWall.Brush.Gradient.Visible = True
        BackWall.Color = 14090184
        BackWall.Transparency = 25
        Border.Visible = True
        BottomWall.Transparent = True
        Foot.Font.Color = clBlue
        Foot.Font.Name = 'Verdana'
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        LeftWall.Color = 14745599
        LeftWall.Transparency = 25
        LeftWall.Transparent = True
        Legend.Font.Name = 'Verdana'
        Legend.Shadow.Transparency = 0
        Legend.Visible = False
        RightWall.Color = 14745599
        RightWall.Transparent = True
        Title.CustomPosition = True
        Title.Font.Charset = GB2312_CHARSET
        Title.Font.Height = -13
        Title.Font.Name = #40657#20307
        Title.Font.Quality = fqNormal
        Title.Left = 130
        Title.Text.Strings = (
          #27979#26012#23380'A'#21521#21382#27425#35266#27979#20559#31227#26354#32447)
        Title.Top = 22
        BottomAxis.Axis.Color = clDefault
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFormat.Font.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Caption = #20559#31227'(mm)'
        BottomAxis.Title.Font.Height = -21
        BottomAxis.Title.Font.Name = 'Verdana'
        Chart3DPercent = 100
        DepthAxis.Axis.Color = clDefault
        DepthAxis.Grid.Color = 698984873
        DepthAxis.Grid.Width = 0
        DepthAxis.GridCentered = True
        DepthAxis.LabelsFormat.Font.Name = 'Verdana'
        DepthAxis.LabelsSeparation = 20
        DepthAxis.LabelStyle = talText
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Angle = 360
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Visible = True
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = clDefault
        LeftAxis.Grid.Color = 11119017
        LeftAxis.Inverted = True
        LeftAxis.LabelsFormat.Font.Name = 'Verdana'
        LeftAxis.LabelsFormat.Font.Quality = fqBest
        LeftAxis.LabelsSeparation = 20
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Caption = #28145#24230'(m)'
        LeftAxis.Title.Font.Height = -21
        LeftAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Title.Font.Quality = fqBest
        Panning.MouseWheel = pmwNone
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
        View3DOptions.Elevation = 360
        View3DOptions.HorizOffset = -14
        View3DOptions.OrthoAngle = 155
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 31
        View3DOptions.Rotation = 320
        View3DOptions.VertOffset = 14
        View3DOptions.Zoom = 47
        View3DOptions.ZoomText = ztAuto
        Zoom.MouseButton = mbMiddle
        ZoomWheel = pmwNormal
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = pmChartOp
        TabOrder = 0
        DefaultCanvas = 'TGLCanvas'
        ColorPaletteIndex = 13
        object hrzlnsrsSeries2: THorizLineSeries
          Depth = 0
          Title = '2017-2-11'
          Brush.BackColor = clDefault
          LinePen.Color = 12615680
          LinePen.Width = 3
          OutLine.Color = 1240382
          OutLine.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psCircle
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loAscending
          Transparency = 37
        end
        object hrzlnsrsSeries3: THorizLineSeries
          Depth = 0
          Title = '2017-2-12'
          Brush.BackColor = clDefault
          LinePen.Color = 8388863
          LinePen.Width = 3
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loAscending
          Transparency = 36
        end
        object hrzlnsrsSeries4: THorizLineSeries
          ShowInEditor = False
          Depth = 0
          Title = '2017-2-15'
          Brush.BackColor = clDefault
          DrawStyle = dsCurve
          LinePen.Color = 33023
          LinePen.Width = 3
          OutLine.Color = 1040187392
          OutLine.Width = 2
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loNone
          YValues.Name = 'Y'
          YValues.Order = loAscending
          Transparency = 39
        end
        object rtlChartTool2: TRotateTool
          Inertia = 95
          Pen.Color = 872415232
          Pen.Mode = pmXor
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 435
        Height = 18
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 1
        object btnHisD: TSpeedButton
          Left = 0
          Top = 0
          Width = 18
          Height = 18
          Hint = #26174#31034#31354#38388#20301#31227#37327'|'#31354#38388#20301#31227#26159#30001'A'#12289'B'#20004#20010#26041#21521#21512#25104#30340#20301#31227#65292#26159#27979#28857#30340#23454#38469#13#10#20301#31227#12290#26412#26354#32447#34920#26126#27979#28857#20301#31227#30340#22823#23567#65292#19981#34920#31034#26041#21521#12290
          CustomHint = BalloonHint1
          GroupIndex = 1
          Down = True
          Caption = 'D'
          ParentShowHint = False
          ShowHint = True
          OnClick = btnHisDClick
        end
        object btnHisA: TSpeedButton
          Left = 20
          Top = 0
          Width = 18
          Height = 18
          Hint = 'A'#21521#20301#31227#26354#32447'|'#26174#31034'A'#26041#21521#20301#31227#26354#32447#65292#25968#20540#30340#27491#36127#34920#26126#20301#31227#30340#26041#21521#12290
          CustomHint = BalloonHint1
          GroupIndex = 1
          Caption = 'A'
          ParentShowHint = False
          ShowHint = True
          OnClick = btnHisDClick
        end
        object btnHisB: TSpeedButton
          Left = 40
          Top = 0
          Width = 18
          Height = 18
          Hint = 'B'#21521#20301#31227#26354#32447'|'#26174#31034#27979#28857'B'#26041#21521#20301#31227#65292#25968#20540#27491#36127#34920#26126#20301#31227#26041#21521#12290
          CustomHint = BalloonHint1
          GroupIndex = 1
          Caption = 'B'
          ParentShowHint = False
          ShowHint = True
          OnClick = btnHisDClick
        end
      end
    end
  end
  object TeeGDIPlus1: TTeeGDIPlus
    AntiAliasText = gpfBest
    TeePanel = cht3D
    Left = 36
    Top = 260
  end
  object pmChartOp: TPopupMenu
    OnPopup = pmChartOpPopup
    Left = 112
    Top = 312
    object piCopyChart: TMenuItem
      Caption = #25335#36125#20026'...'
      object piCopyTwoChart: TMenuItem
        Caption = #25335#36125'('#21512#24182#20004#24352#22270')'
        OnClick = piCopyTwoChartClick
      end
      object piCopyAsBitmap: TMenuItem
        Caption = #20301#22270#26684#24335'('#21333#24352')'
        OnClick = piCopyAsBitmapClick
      end
      object piCopyAsWMF: TMenuItem
        Caption = #22270#20803#26684#24335'('#21333#24352')'
        OnClick = piCopyAsWMFClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object piFeatureFunction: TMenuItem
      Caption = #23578#26410#32534#20889#30340#21151#33021
      Enabled = False
    end
    object piAutoRotate: TMenuItem
      AutoCheck = True
      Caption = #33258#21160#26059#36716
      Visible = False
      OnClick = piAutoRotateClick
    end
    object piExportGIF: TMenuItem
      Caption = #23548#20986'3D'#21160#22270
      Visible = False
      OnClick = piExportGIFClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object piEditChart: TMenuItem
      Caption = #35774#32622#22270#24418
      OnClick = piEditChartClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object piSaveToFile: TMenuItem
      Caption = #20445#23384#22270#24418
      OnClick = piSaveToFileClick
    end
  end
  object TeeGDIPlus2: TTeeGDIPlus
    AntiAliasText = gpfBest
    TeePanel = chtHistoryLinesA
    Left = 36
    Top = 200
  end
  object BalloonHint1: TBalloonHint
    HideAfter = 1000
    Left = 208
    Top = 312
  end
  object TeeOpenGL1: TTeeOpenGL
    Active = True
    AmbientLight = 0
    FontStyle = fsBitmap
    Light.Visible = False
    Light.Direction.Z = -1.000000000000000000
    Light.FixedPosition = False
    Light.SpotDegrees = 180.000000000000000000
    Light1.Visible = False
    Light1.Direction.Z = -1.000000000000000000
    Light1.SpotDegrees = 180.000000000000000000
    Light2.Visible = False
    Light2.Direction.Z = -1.000000000000000000
    Light2.SpotDegrees = 180.000000000000000000
    Shininess = 0.500000000000000000
    TeePanel = chtHistoryLinesA
    Left = 104
    Top = 204
  end
  object TeeOpenGL2: TTeeOpenGL
    Active = True
    AmbientLight = 0
    FontStyle = fsBitmap
    Light.Visible = False
    Light.Direction.Z = -1.000000000000000000
    Light.SpotDegrees = 180.000000000000000000
    Light1.Visible = False
    Light1.Direction.Z = -1.000000000000000000
    Light1.SpotDegrees = 180.000000000000000000
    Light2.Visible = False
    Light2.Direction.Z = -1.000000000000000000
    Light2.SpotDegrees = 180.000000000000000000
    Shininess = 0.500000000000000000
    TeePanel = cht3D
    Left = 168
    Top = 208
  end
  object TeeGDIPlus3: TTeeGDIPlus
    Active = True
    AntiAliasText = gpfNormal
    TeePanel = cht3D
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG'#22270#20687#25991#20214'|*.jpg;*.jpeg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Title = #20445#23384#20108#32500#20301#31227#22270
    Left = 309
    Top = 280
  end
end
