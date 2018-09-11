object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 679
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 725
    Height = 679
    Align = alClient
    Caption = 'Panel1'
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object mmTemplate: TMemo
      Left = 4
      Top = 26
      Width = 717
      Height = 213
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      Lines.Strings = (
        'Name:'#38170#32034#27979#21147#35745#35266#27979#25968#25454#34920#27169#26495';'
        'ApplyTo:Single;'
        'MeterType:'#38170#32034#27979#21147#35745';'
        'Title:'#38170#32034#27979#21147#35745'%DesignName%'#35266#27979#25104#26524#34920';'
        'Head:'#35774#35745#32534#21495'|%Designname%|'#23433#35013#26102#38388'|%SetupDate%|'#22791#27880';'
        'Head:'#26729#21495'|%Stake%|'#39640#31243'|%Elevation%|'#22791#27880';'
        'Head:'#35266#27979#26085#26399'|'#28201#24230'('#8451')|'#39044#24212#21147'(kN)|'#25439#22833#29575'(%)|'#22791#27880';'
        'DataRow:%DTScale%|%PD2%|%PD1%|%PD3%|%Annotation%;')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      ExplicitLeft = 2
      ExplicitTop = 4
    end
    object memo1: TMemo
      Left = 4
      Top = 239
      Width = 717
      Height = 156
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object Edit2: TEdit
      Left = 4
      Top = 4
      Width = 717
      Height = 22
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 
        '%([a-zA-Z]*|((Meter)([1-9][0-9]*)\.)?(DesignName|(PD|MD)([1-9][0' +
        '-9]*)\.(Name|Alias|DataUnit)))%'
      ExplicitLeft = 2
      ExplicitTop = 0
    end
    object HV: THtmlViewer
      Left = 4
      Top = 395
      Width = 717
      Height = 280
      BorderStyle = htFocused
      HistoryMaxCount = 0
      NoSelect = False
      PrintMarginBottom = 2.000000000000000000
      PrintMarginLeft = 2.000000000000000000
      PrintMarginRight = 2.000000000000000000
      PrintMarginTop = 2.000000000000000000
      PrintScale = 1.000000000000000000
      Align = alClient
      TabOrder = 3
      Touch.InteractiveGestures = [igPan]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
    end
  end
  object Panel2: TPanel
    Left = 725
    Top = 0
    Width = 194
    Height = 679
    Align = alRight
    TabOrder = 1
    object Button1: TButton
      Left = 6
      Top = 12
      Width = 175
      Height = 41
      Caption = #36409#19968#19979
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 6
      Top = 59
      Width = 175
      Height = 41
      Caption = #27979#35797#21464#37327#35782#21035
      Style = bsCommandLink
      TabOrder = 1
      OnClick = Button2Click
    end
    object Edit1: TEdit
      Left = 1
      Top = 657
      Width = 192
      Height = 21
      Align = alBottom
      TabOrder = 2
      Text = 'Edit1'
    end
    object Button3: TButton
      Left = 6
      Top = 106
      Width = 175
      Height = 41
      Caption = #27169#26495#23545#35937#27979#35797
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 492
    Top = 444
    object N1: TMenuItem
      Caption = #31995#32479
      object miConnect: TMenuItem
        Caption = #36830#25509#25968#25454#24211
        OnClick = miConnectClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = #25171#24320#24037#31243#37197#32622#25991#20214
    Left = 765
    Top = 328
  end
end
