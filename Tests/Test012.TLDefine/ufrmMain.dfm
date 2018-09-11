object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #27979#35797#39044#23450#20041#21151#33021
  ClientHeight = 674
  ClientWidth = 974
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLeftFunc: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 655
    Align = alLeft
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 655
    Width = 974
    Height = 19
    Panels = <>
  end
  object PageControl1: TPageControl
    Left = 185
    Top = 0
    Width = 789
    Height = 655
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #36807#31243#32447
      object Splitter1: TSplitter
        Left = 0
        Top = 250
        Width = 781
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 377
      end
      object Chart1: TChart
        Left = 0
        Top = 0
        Width = 781
        Height = 250
        Legend.Alignment = laTop
        Legend.LegendStyle = lsSeries
        MarginBottom = 6
        MarginLeft = 6
        MarginRight = 7
        MarginTop = 6
        MarginUnits = muPixels
        Title.Font.Height = -13
        Title.Text.Strings = (
          'TChart')
        BottomAxis.DateTimeFormat = 'dd'
        BottomAxis.Grid.Style = psDot
        BottomAxis.PositionUnits = muPixels
        BottomAxis.SubAxes = <
          item
            DateTimeFormat = 'yyyy'#24180'mm'#26376
            Grid.Visible = False
            Increment = 30.000000000000000000
            Horizontal = True
            OtherSide = False
          end
          item
            DateTimeFormat = 'mm'
            Grid.Visible = False
            Increment = 30.000000000000000000
            Horizontal = True
            OtherSide = False
          end>
        DepthTopAxis.Title.Caption = #65311#65311
        LeftAxis.Grid.Style = psDot
        LeftAxis.Title.Caption = #33655#36733
        Panning.MouseWheel = pmwNone
        RightAxis.Grid.Style = psDot
        RightAxis.Title.Caption = #28201#24230
        View3D = False
        Zoom.MouseWheel = pmwNormal
        Align = alTop
        Color = clWhite
        PopupMenu = PopupMenu1
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 18
        object Series1: TFastLineSeries
          Marks.Emboss.Clip = True
          Marks.Shadow.Clip = True
          Marks.Clip = True
          VertAxis = aCustomVertAxis
          LinePen.Color = 16632904
          XValues.DateTime = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series2: TLineSeries
          Brush.BackColor = clDefault
          DrawStyle = dsCurve
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series3: TLineSeries
          VertAxis = aCustomVertAxis
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object Series4: TLineSeries
          VertAxis = aRightAxis
          Brush.BackColor = clDefault
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object ChartTool1: TAxisScrollTool
          AxisID = 2
        end
        object ChartTool2: TAxisScrollTool
          AxisID = 3
        end
        object ChartTool3: TAxisScrollTool
          AxisID = 0
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 253
        Width = 781
        Height = 374
        Align = alClient
        TabOrder = 1
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 594
          Height = 372
          Align = alClient
          TabOrder = 0
          object Label1: TLabel
            Left = 1
            Top = 1
            Width = 592
            Height = 13
            Align = alTop
            Caption = #39044#23450#20041#20195#30721
            ExplicitWidth = 60
          end
          object Label2: TLabel
            Left = 1
            Top = 186
            Width = 592
            Height = 13
            Align = alTop
            Caption = #35299#26512#32467#26524
            ExplicitWidth = 48
          end
          object memCode: TMemo
            Left = 1
            Top = 14
            Width = 592
            Height = 172
            Align = alTop
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Code New Roman'
            Font.Style = []
            Lines.Strings = (
              'ChartTitle:'#38170#26438#24212#21147#35745'%Name%'#27979#20540#36807#31243#32447';'
              'Axis:Left|0|'#33655#36733'(kN)|0.00;'
              'Axis:Left|1|'#24212#21147'(MPa)|0.00;'
              'Axis:Right|0|'#28201#24230'('#8451')|0.0;'
              'Axis:Bottom|0|'#35266#27979#26085#26399'|yyyy-mm-dd;'
              'PD:1|'#33655#36733'(kN)|LeftAxis[0];'
              'PD:3|'#24212#21147'(MPa)|LeftAxis[1];'
              'PD:2|'#28201#24230'|RightAxis[0];')
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object memDecode: TMemo
            Left = 1
            Top = 199
            Width = 592
            Height = 172
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Consolas'
            Font.Style = []
            Lines.Strings = (
              'memDecode')
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object Panel3: TPanel
          Left = 595
          Top = 1
          Width = 185
          Height = 372
          Align = alRight
          BevelOuter = bvLowered
          TabOrder = 1
          object Button1: TButton
            Left = 10
            Top = 5
            Width = 115
            Height = 25
            Caption = #27979#35797#23450#20041
            TabOrder = 0
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 10
            Top = 36
            Width = 115
            Height = 25
            Caption = #29992#35266#27979#25968#25454#27979#35797#23450#20041
            TabOrder = 1
            OnClick = Button2Click
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 228
    object miSystem: TMenuItem
      Caption = #31995#32479
      object miSYS_Connect: TMenuItem
        Caption = #36830#25509#25968#25454#24211
        OnClick = miSYS_ConnectClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = #25171#24320#39033#30446#37197#32622#25991#20214
    Left = 92
    Top = 280
  end
  object PopupMenu1: TPopupMenu
    Left = 741
    Top = 56
    object N1: TMenuItem
      Caption = #32534#36753#22270#24418
      OnClick = N1Click
    end
  end
end
