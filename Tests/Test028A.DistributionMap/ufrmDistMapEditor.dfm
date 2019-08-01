object frmDMEditor: TfrmDMEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20998#24067#22270#23450#20041#30028#38754
  ClientHeight = 446
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object lbl1: TLabel
    Left = 24
    Top = 16
    Width = 60
    Height = 14
    Caption = #20998#24067#22270#21517#31216
  end
  object lbl2: TLabel
    Left = 36
    Top = 44
    Width = 48
    Height = 14
    Caption = #22270#24418#26631#39064
  end
  object lbl3: TLabel
    Left = 42
    Top = 80
    Width = 48
    Height = 14
    Caption = #20202#22120#31867#22411
  end
  object lbl4: TLabel
    Left = 54
    Top = 108
    Width = 36
    Height = 14
    Caption = #29289#29702#37327
  end
  object edtDMName: TEdit
    Left = 96
    Top = 13
    Width = 305
    Height = 22
    TabOrder = 0
    Text = 'edtDMName'
  end
  object edtTitle: TEdit
    Left = 96
    Top = 41
    Width = 305
    Height = 22
    TabOrder = 1
    Text = 'edtTitle'
  end
  object cbbMeterType: TComboBox
    Left = 96
    Top = 77
    Width = 185
    Height = 22
    Style = csDropDownList
    TabOrder = 2
    OnClick = cbbMeterTypeClick
  end
  object cbbPD: TComboBox
    Left = 96
    Top = 105
    Width = 185
    Height = 22
    Style = csDropDownList
    TabOrder = 3
  end
  object lstSelectedMeters: TListBox
    Left = 24
    Top = 140
    Width = 377
    Height = 277
    Columns = 2
    ItemHeight = 14
    TabOrder = 4
  end
  object btnSelecMeters: TButton
    Left = 326
    Top = 109
    Width = 75
    Height = 25
    Caption = #25361#36873#20202#22120
    TabOrder = 5
    OnClick = btnSelecMetersClick
  end
  object btnSaveDefine: TButton
    Left = 444
    Top = 12
    Width = 75
    Height = 25
    Caption = #20445#23384#23450#20041
    TabOrder = 6
    OnClick = btnSaveDefineClick
  end
  object btnTest: TButton
    Left = 444
    Top = 44
    Width = 75
    Height = 25
    Caption = #27979#35797
    TabOrder = 7
    OnClick = btnTestClick
  end
end
