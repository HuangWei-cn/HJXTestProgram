object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Update param test'
  ClientHeight = 526
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Consolas'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 197
    Top = 0
    Height = 526
    ExplicitLeft = 304
    ExplicitTop = 212
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 197
    Height = 526
    Align = alLeft
    BevelOuter = bvNone
    Color = 12385983
    ParentBackground = False
    TabOrder = 0
    object btnOpenConfig: TButton
      Left = 10
      Top = 8
      Width = 151
      Height = 41
      Caption = #25171#24320#24037#31243#25991#20214
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 0
      OnClick = btnOpenConfigClick
    end
    object pnlMtLst: TPanel
      Left = 0
      Top = 68
      Width = 197
      Height = 458
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      Caption = 'pnlMtLst'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 200
    Top = 0
    Width = 492
    Height = 526
    Align = alClient
    Caption = 'Panel2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    inline fraTerminal1: TfraTerminal
      Left = 1
      Top = 1
      Width = 490
      Height = 289
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitHeight = 289
      inherited edtCmd: TEdit
        Height = 23
        Ctl3D = False
        ParentCtl3D = False
        ExplicitTop = 254
        ExplicitHeight = 23
      end
      inherited mmResult: TMemo
        Height = 242
        Ctl3D = False
        ParentCtl3D = False
        ExplicitHeight = 242
      end
    end
    object Memo1: TMemo
      Left = 1
      Top = 290
      Width = 490
      Height = 235
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clWhite
      Lines.Strings = (
        #25903#25345#30340#21629#20196#65306
        'CLS - '#28165#31354#20449#24687#31383#21475
        'ListParams - '#21015#20986#21487#26356#26032#30340#21442#25968#21517#31216
        'UPDATEPARAM designname paramname=value')
      TabOrder = 1
      ExplicitLeft = 3
      ExplicitTop = 286
    end
  end
end
