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
  inline fraTerminal1: TfraTerminal
    Left = 224
    Top = 24
    Width = 445
    Height = 289
    TabOrder = 1
    ExplicitLeft = 224
    ExplicitTop = 24
    ExplicitWidth = 445
    ExplicitHeight = 289
    inherited edtCmd: TEdit
      Width = 428
    end
    inherited mmResult: TMemo
      Width = 428
      Height = 235
    end
  end
end
