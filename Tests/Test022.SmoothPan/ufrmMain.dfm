object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 633
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 633
    Align = alLeft
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = 104
    ExplicitTop = 248
    ExplicitHeight = 41
    object Button1: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'SG'#25991#20214'|*.sg'
    Left = 112
    Top = 192
  end
end
