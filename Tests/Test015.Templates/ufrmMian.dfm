object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'TestTemplates'
  ClientHeight = 692
  ClientWidth = 1078
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblAnnotation: TLabel
    Left = 0
    Top = 0
    Width = 1078
    Height = 53
    Align = alTop
    AutoSize = False
    Caption = #26412#31243#24207#29992#20110#27979#35797#27169#26495#21333#20803#65292#20063#29992#26469#27979#35797#27169#26495#20195#30721#12290
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 1087
  end
  object Splitter1: TSplitter
    Left = 225
    Top = 53
    Height = 620
    ExplicitLeft = 520
    ExplicitTop = 312
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 53
    Width = 225
    Height = 620
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitHeight = 639
    object Button1: TButton
      Left = 14
      Top = 37
      Width = 115
      Height = 27
      Caption = #27979#35797'Wps'
      Enabled = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 14
      Top = 71
      Width = 115
      Height = 25
      Caption = 'Button2'
      Enabled = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 14
      Top = 6
      Width = 115
      Height = 25
      Caption = #21152#36733#24037#31243#35774#32622
      TabOrder = 2
      OnClick = Button3Click
    end
    object CategoryPanelGroup1: TCategoryPanelGroup
      Left = 1
      Top = 101
      Width = 223
      Height = 518
      VertScrollBar.Tracking = True
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      TabOrder = 3
      ExplicitHeight = 537
      object CategoryPanel1: TCategoryPanel
        Top = 0
        Height = 377
        Caption = 'Meter List'
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        ExplicitWidth = 221
        object tvwMeters: TTreeView
          Left = 0
          Top = 0
          Width = 202
          Height = 351
          Align = alClient
          Indent = 19
          TabOrder = 0
          OnClick = tvwMetersClick
          OnCreateNodeClass = tvwMetersCreateNodeClass
          ExplicitWidth = 219
        end
      end
      object CategoryPanel2: TCategoryPanel
        Top = 377
        Height = 371
        Caption = 'Templates List'
        TabOrder = 1
        ExplicitTop = 30
        ExplicitWidth = 221
        object tvwTemplates: TTreeView
          Left = 0
          Top = 0
          Width = 202
          Height = 345
          Align = alClient
          Indent = 19
          ReadOnly = True
          TabOrder = 0
          ExplicitWidth = 219
          ExplicitHeight = 0
        end
      end
    end
  end
  object PageControl1: TPageControl
    Left = 228
    Top = 53
    Width = 850
    Height = 620
    ActivePage = TabSheet4
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Test Chart Template'
      ExplicitHeight = 606
      object Panel2: TPanel
        Left = 700
        Top = 0
        Width = 142
        Height = 587
        Align = alRight
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'Panel2'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 606
        object btnNewChartTemplate: TButton
          Left = 4
          Top = 18
          Width = 125
          Height = 25
          Action = actNewChartTemplate
          TabOrder = 0
        end
        object Button6: TButton
          Left = 4
          Top = 49
          Width = 125
          Height = 25
          Caption = 'Button6'
          TabOrder = 1
        end
        object Button7: TButton
          Left = 4
          Top = 80
          Width = 125
          Height = 25
          Caption = 'Button7'
          TabOrder = 2
        end
        object Button8: TButton
          Left = 4
          Top = 111
          Width = 125
          Height = 25
          Caption = 'Button8'
          TabOrder = 3
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 700
        Height = 587
        Align = alClient
        BevelKind = bkSoft
        BevelOuter = bvNone
        Caption = 'Panel3'
        TabOrder = 1
        ExplicitHeight = 606
        object Label3: TLabel
          Left = 0
          Top = 0
          Width = 696
          Height = 18
          Align = alTop
          Caption = #27169#26495#20195#30721
          ExplicitWidth = 64
        end
        object mmCTEditor: TMemo
          Left = 0
          Top = 18
          Width = 696
          Height = 303
          Align = alClient
          Lines.Strings = (
            'mmCTEditor')
          ScrollBars = ssBoth
          TabOrder = 0
          WordWrap = False
          ExplicitHeight = 322
        end
        object Chart1: TChart
          Left = 0
          Top = 321
          Width = 696
          Height = 262
          Title.Text.Strings = (
            'TChart')
          View3D = False
          Align = alBottom
          TabOrder = 1
          ExplicitTop = 340
          DefaultCanvas = 'TGDIPlusCanvas'
          ColorPaletteIndex = 13
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Test WebGrid Template'
      ImageIndex = 1
      ExplicitHeight = 606
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 842
        Height = 106
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          842
          106)
        object LabeledEdit1: TLabeledEdit
          Left = 3
          Top = 24
          Width = 829
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 160
          EditLabel.Height = 18
          EditLabel.Caption = #26631#39064#21450#34920#22836#27491#21017#34920#36798#24335
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 
            '%([a-zA-Z]*|((Meter)([1-9][0-9]*)\.)?(DesignName|(PD|MD)([1-9][0' +
            '-9]*)\.(Name|Alias|DataUnit)))%'
        end
        object LabeledEdit2: TLabeledEdit
          Left = 2
          Top = 72
          Width = 829
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 128
          EditLabel.Height = 18
          EditLabel.Caption = #25968#25454#21306#27491#21017#34920#36798#24335
          Font.Charset = ANSI_CHARSET
          Font.Color = clTeal
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 
            '%(DTScale|Annotation|((Meter)(n|[1-9][0-9]*)\.)?(PD|MD)([1-9][0-' +
            '9]*))%'
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 106
        Width = 842
        Height = 481
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 500
        DesignSize = (
          842
          481)
        object Label1: TLabel
          Left = 5
          Top = 8
          Width = 64
          Height = 18
          Caption = #27169#26495#20195#30721
        end
        object Label2: TLabel
          Left = 5
          Top = 224
          Width = 96
          Height = 18
          Caption = #35299#26512#27169#26495#20195#30721
        end
        object mmWGTEditor: TMemo
          Left = 5
          Top = 32
          Width = 656
          Height = 186
          Anchors = [akLeft, akTop, akRight]
          Lines.Strings = (
            'mmWGTEditor')
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object Panel6: TPanel
          Left = 667
          Top = 0
          Width = 175
          Height = 481
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitHeight = 500
          object btnNewWGT: TButton
            Left = 12
            Top = 9
            Width = 149
            Height = 25
            Action = actNewWebGridTemplate
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object btnParseWGT: TButton
            Left = 12
            Top = 40
            Width = 149
            Height = 25
            Caption = #35299#26512#21344#20301#31526
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object btnTestWGT: TButton
            Left = 12
            Top = 71
            Width = 149
            Height = 25
            Caption = #27979#35797
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object btnTestWGT2Meter: TButton
            Left = 11
            Top = 102
            Width = 150
            Height = 25
            Caption = #20202#22120#27979#35797
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object Button4: TButton
            Left = 11
            Top = 133
            Width = 150
            Height = 25
            Caption = #32534#36753#29616#26377#27169#26495
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Consolas'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
        end
        object mmWGTResult: TMemo
          Left = 5
          Top = 248
          Width = 656
          Height = 230
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            'mmWGTResult')
          ScrollBars = ssBoth
          TabOrder = 2
          ExplicitHeight = 249
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Test XLS DataGrid Template'
      ImageIndex = 2
      ExplicitHeight = 606
      object grdXLTemplates: TStringGrid
        Left = 0
        Top = 21
        Width = 842
        Height = 566
        Align = alClient
        ColCount = 10
        DefaultColWidth = 80
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        TabOrder = 0
        ExplicitHeight = 364
      end
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 842
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 68
        Caption = 'ToolBar1'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        List = True
        ParentFont = False
        ShowCaptions = True
        TabOrder = 1
        DesignSize = (
          842
          21)
        object tbtnOpenXLTmpl: TToolButton
          Left = 0
          Top = 0
          Caption = #36873#25321#27169#26495
          ImageIndex = 0
          OnClick = tbtnOpenXLTmplClick
        end
        object edtXLTmplName: TEdit
          Left = 68
          Top = 0
          Width = 501
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'edtXLTmplName'
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
      object chklstMeters: TCheckListBox
        Left = 0
        Top = 0
        Width = 177
        Height = 587
        Align = alLeft
        ItemHeight = 18
        TabOrder = 0
        ExplicitLeft = 16
        ExplicitTop = 8
        ExplicitHeight = 473
      end
      object btnCreateXLSGrid: TButton
        Left = 200
        Top = 10
        Width = 137
        Height = 25
        Caption = #21019#24314#25968#25454#34920
        TabOrder = 1
        OnClick = btnCreateXLSGridClick
      end
    end
  end
  object staTemplates: TStatusBar
    Left = 0
    Top = 673
    Width = 1078
    Height = 19
    Panels = <
      item
        Text = 'M18zpr'
        Width = 80
      end
      item
        Text = 'CT:'#22810#28857#20301#31227#35745#36807#31243#32447#27169#26495
        Width = 200
      end
      item
        Text = 'WGT:'
        Width = 250
      end
      item
        Text = 'XLT:'
        Width = 250
      end>
    ExplicitLeft = 544
    ExplicitTop = 352
    ExplicitWidth = 0
  end
  object dlgOpenWB: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 120
    Top = 344
  end
  object sSkinManager1: TsSkinManager
    ButtonsOptions.OldGlyphsMode = True
    ExtendedBorders = True
    InternalSkins = <>
    SkinDirectory = 'D:\Embarcadero\Studio\19.0\3dr\AlphaControl\Skins'
    SkinName = 'Topaz 2017'
    SkinInfo = '14'
    ThirdParty.ThirdEdits = 
      'TEdit'#13#10'TMemo'#13#10'TMaskEdit'#13#10'TLabeledEdit'#13#10'THotKey'#13#10'TListBox'#13#10'TCheck' +
      'ListBox'#13#10'TRichEdit'#13#10'TDateTimePicker'
    ThirdParty.ThirdButtons = 'TButton'
    ThirdParty.ThirdBitBtns = 'TBitBtn'
    ThirdParty.ThirdCheckBoxes = 'TCheckBox'#13#10'TRadioButton'#13#10'TGroupButton'
    ThirdParty.ThirdGroupBoxes = 'TGroupBox'#13#10'TRadioGroup'
    ThirdParty.ThirdListViews = 'TListView'
    ThirdParty.ThirdPanels = 'TPanel'
    ThirdParty.ThirdGrids = 'TStringGrid'#13#10'TDrawGrid'
    ThirdParty.ThirdTreeViews = 'TTreeView'
    ThirdParty.ThirdComboBoxes = 'TComboBox'#13#10'TColorBox'
    ThirdParty.ThirdWWEdits = ' '
    ThirdParty.ThirdVirtualTrees = ' '
    ThirdParty.ThirdGridEh = ' '
    ThirdParty.ThirdPageControl = 'TPageControl'
    ThirdParty.ThirdTabControl = 'TTabControl'
    ThirdParty.ThirdToolBar = 'TToolBar'
    ThirdParty.ThirdStatusBar = 'TStatusBar'
    ThirdParty.ThirdSpeedButton = 'TSpeedButton'
    ThirdParty.ThirdScrollControl = 'TScrollBox'
    ThirdParty.ThirdUpDown = 'TUpDown'
    ThirdParty.ThirdScrollBar = 'TScrollBar'
    ThirdParty.ThirdStaticText = 'TStaticText'
    ThirdParty.ThirdNativePaint = ' '
    Left = 336
    Top = 496
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 432
    Top = 496
  end
  object ActionManager1: TActionManager
    Left = 504
    Top = 352
    StyleName = 'Platform Default'
    object actNewChartTemplate: TAction
      Category = 'ChartTemplate'
      Caption = #21019#24314#26032'Chart'#27169#26495
      OnExecute = actNewChartTemplateExecute
    end
    object actNewWebGridTemplate: TAction
      Category = 'WebGridTemplate'
      Caption = #21019#24314#26032'WebGrid'#27169#26495
      OnExecute = actNewWebGridTemplateExecute
    end
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'xls'
    Filter = 'Excel files|*.xls'
    Left = 512
    Top = 186
  end
end
