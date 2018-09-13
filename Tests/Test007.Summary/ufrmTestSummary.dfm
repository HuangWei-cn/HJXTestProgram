object frmTestSummary: TfrmTestSummary
  Left = 0
  Top = 0
  Caption = #40644#37329#23777#35266#27979#25968#25454#22788#29702#36741#21161#24037#20855#65288#21151#33021#27979#35797#31243#24207#65289
  ClientHeight = 688
  ClientWidth = 970
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 185
    Top = 0
    Width = 785
    Height = 688
    ActivePage = tabDataReport
    Align = alClient
    TabOrder = 0
    object tabBaseParams: TTabSheet
      Caption = #29305#24615
      inline fraMeterListGrid1: TfraMeterListGrid
        Left = 0
        Top = 0
        Width = 777
        Height = 660
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 777
        ExplicitHeight = 660
        inherited dbgMeters: TDBGridEh
          Width = 777
          Height = 660
        end
      end
    end
    object tabDataViewer: TTabSheet
      Caption = #35266#27979#25968#25454
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 777
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 12
          Top = 8
          Width = 60
          Height = 13
          Caption = #35774#35745#32534#21495#65306
        end
        object lblDesignName: TLabel
          Left = 72
          Top = 8
          Width = 69
          Height = 13
          Caption = 'lblDesignName'
        end
        object Label2: TLabel
          Left = 192
          Top = 8
          Width = 60
          Height = 13
          Caption = #20202#22120#31867#22411#65306
        end
        object lblMeterType: TLabel
          Left = 258
          Top = 8
          Width = 62
          Height = 13
          Caption = 'lblMeterType'
        end
        object Label4: TLabel
          Left = 12
          Top = 25
          Width = 60
          Height = 13
          Caption = #23433#35013#37096#20301#65306
        end
        object Label5: TLabel
          Left = 192
          Top = 25
          Width = 60
          Height = 13
          Caption = #26729#12288#12288#21495#65306
        end
        object lblStake: TLabel
          Left = 258
          Top = 25
          Width = 37
          Height = 13
          Caption = 'lblStake'
        end
        object Label7: TLabel
          Left = 392
          Top = 25
          Width = 60
          Height = 13
          Caption = #23433#35013#39640#31243#65306
        end
        object lblElevation: TLabel
          Left = 458
          Top = 25
          Width = 54
          Height = 13
          Caption = 'lblElevation'
        end
        object lblPosition: TLabel
          Left = 72
          Top = 25
          Width = 47
          Height = 13
          Caption = 'lblPosition'
        end
      end
    end
    object tabDataGraph: TTabSheet
      Caption = #36807#31243#32447
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object scrTLList: TScrollBox
        Left = 0
        Top = 0
        Width = 777
        Height = 660
        VertScrollBar.Smooth = True
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
      end
    end
    object tabDataLayout: TTabSheet
      Caption = #20998#24067#22270
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tabEigenValue: TTabSheet
      Caption = #29305#24449#20540
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tabDataReport: TTabSheet
      Caption = #35266#27979#25968#25454#25253#34920
      ImageIndex = 8
    end
    object tabSummary: TTabSheet
      Caption = #27719#24635#34920
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tabTools: TTabSheet
      Caption = #23567#24037#20855
      ImageIndex = 6
      object btnDataCounts: TButton
        Left = 12
        Top = 20
        Width = 175
        Height = 41
        Caption = #32479#35745#35266#27979#28857#27425
        Style = bsCommandLink
        TabOrder = 0
        OnClick = btnDataCountsClick
      end
      object Button1: TButton
        Left = 12
        Top = 67
        Width = 175
        Height = 41
        Caption = #27979#35797#65306#24377#20986#24335#36807#31243#32447
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Style = bsCommandLink
        TabOrder = 1
        Visible = False
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 28
        Top = 180
        Width = 139
        Height = 25
        Caption = #27979#35797#20202#22120#36873#25321#23545#35805#31383
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object tabParamsEditor: TTabSheet
      Caption = #27979#35797#65306#23646#24615#32534#36753#22120
      ImageIndex = 5
      TabVisible = False
      object lstTestMeters: TListBox
        Left = 0
        Top = 0
        Width = 153
        Height = 660
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = lstTestMetersDblClick
      end
      object Panel2: TPanel
        Left = 648
        Top = 0
        Width = 129
        Height = 660
        Align = alRight
        BevelKind = bkSoft
        TabOrder = 1
        object btnTest_LoadMeters: TButton
          Left = 12
          Top = 11
          Width = 105
          Height = 25
          Caption = 'btnTest_LoadMeters'
          TabOrder = 0
          OnClick = btnTest_LoadMetersClick
        end
      end
      inline fraXLSParamEditor1: TfraXLSParamEditor
        Left = 153
        Top = 0
        Width = 495
        Height = 660
        Align = alClient
        TabOrder = 2
        ExplicitLeft = 153
        ExplicitWidth = 495
        ExplicitHeight = 660
        inherited CategoryPanelGroup1: TCategoryPanelGroup
          Width = 495
          Height = 559
          ExplicitWidth = 495
          ExplicitHeight = 559
          inherited CategoryPanel3: TCategoryPanel
            ExplicitWidth = 493
            inherited vleDataStru: TValueListEditor
              Width = 474
              ExplicitWidth = 474
              ColWidths = (
                150
                318)
              RowHeights = (
                18
                18
                18
                18
                18
                18
                18
                18
                18
                18)
            end
          end
          inherited CategoryPanel2: TCategoryPanel
            ExplicitWidth = 493
            inherited vlePrjParams: TValueListEditor
              Width = 474
              ExplicitWidth = 474
              ColWidths = (
                150
                318)
              RowHeights = (
                18
                18
                18
                18
                18
                18
                18
                18)
            end
          end
          inherited CategoryPanel1: TCategoryPanel
            ExplicitWidth = 493
            inherited vleMeterParams: TValueListEditor
              Width = 474
              ExplicitWidth = 474
              ColWidths = (
                98
                370)
              RowHeights = (
                18
                18
                18
                18
                18
                18
                18
                18
                18
                18
                18
                18
                18)
            end
          end
        end
        inherited Panel1: TPanel
          Width = 495
          ExplicitWidth = 495
          inherited Button1: TButton
            Left = 414
            ExplicitLeft = 414
          end
          inherited Button2: TButton
            Left = 414
            ExplicitLeft = 414
          end
        end
      end
    end
    object tabQuickView: TTabSheet
      Caption = #35266#27979#24773#20917#36895#35272
      ImageIndex = 9
    end
  end
  object pnlLeftPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 688
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'LeftPanel'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 229
      Width = 185
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 459
    end
    object cbsFunctions: TCategoryButtons
      Left = 0
      Top = 0
      Width = 185
      Height = 229
      Align = alTop
      ButtonFlow = cbfVertical
      ButtonWidth = 120
      Categories = <
        item
          Caption = #21442#25968
          Color = 16771818
          Collapsed = False
          Items = <
            item
              Action = actConnectDatabase
            end
            item
              Action = actLoadDataFileList
            end>
        end
        item
          Caption = #27719#24635#34920#21151#33021
          Color = 15400959
          Collapsed = True
          Items = <
            item
              Action = actLoadSummaryDefine
            end
            item
              Caption = #35774#32622#33258#23450#20041#38745#24577#34920
            end
            item
              Caption = #29983#25104#35266#27979#25968#25454#26376#34920
            end>
        end
        item
          Caption = #31649#29702#24037#20855
          Color = 15395839
          Collapsed = True
          Items = <
            item
              Caption = #26597#30475#20202#22120#21488#24080
            end
            item
              Caption = #36827#20986#24211#21488#24080
            end
            item
              Caption = #23433#35013#35760#24405
            end>
        end>
      RegularButtonColor = clWhite
      SelectedButtonColor = 15132390
      TabOrder = 0
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'Excel'#25991#20214'(*.xls, *.xlsx)|*.xls;*.xlsx'
    Left = 84
    Top = 380
  end
  object amMain: TActionManager
    Left = 88
    Top = 272
    StyleName = 'Platform Default'
    object actLoadParams: TAction
      Category = #21021#22987#21270
      Caption = #21152#36733#20202#22120#21442#25968#34920
      Enabled = False
      OnExecute = actLoadParamsExecute
    end
    object actLoadDataFileList: TAction
      Category = #21021#22987#21270
      Caption = #21152#36733#25968#25454#25991#20214#21015#34920
      Enabled = False
      OnExecute = actLoadDataFileListExecute
    end
    object actParamsEditor: TAction
      Category = #21442#25968#32534#36753
      Caption = #21442#25968#32534#36753#22120
      Enabled = False
    end
    object actSummaryCreator: TAction
      Category = #27719#24635#34920#21151#33021
      Caption = #21019#24314#27719#24635#34920
      Enabled = False
    end
    object actSetupCustomStaticReport: TAction
      Category = #27719#24635#34920#21151#33021
      Caption = #33258#23450#20041#38745#24577#34920#35774#35745
      Enabled = False
    end
    object actLoadSummaryDefine: TAction
      Category = #27719#24635#34920#21151#33021
      Caption = #25171#24320#27719#24635#34920#23450#20041
      OnExecute = actLoadSummaryDefineExecute
    end
    object actConnectDatabase: TAction
      Category = #21021#22987#21270
      Caption = #36830#25509#25968#25454#24211
      OnExecute = actConnectDatabaseExecute
    end
    object actShowDataLayout: TAction
      Category = #20998#26512#24037#20855
      Caption = #20998#24067#22270
      OnExecute = actShowDataLayoutExecute
    end
  end
  object dlgOpenDataLayout: TOpenDialog
    Filter = #20998#24067#22270#25991#20214'|*.sg;*.sgp'
    Left = 488
    Top = 392
  end
  object popSetDefaultTrendLineSize: TPopupMenu
    Left = 629
    Top = 460
    object piSetDefaultTLSize: TMenuItem
      Caption = #35774#32622#20026#32570#30465#23485#24230#21644#39640#24230
      OnClick = piSetDefaultTLSizeClick
    end
  end
end
