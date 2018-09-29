object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 567
  ClientWidth = 870
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
    Height = 567
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 16
      Width = 169
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'Excel'#25991#20214'|*.xls;*.xlsx'
    Left = 344
    Top = 192
  end
end
