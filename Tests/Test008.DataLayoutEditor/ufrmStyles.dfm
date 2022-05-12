object frmStyles: TfrmStyles
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'frmStyles'
  ClientHeight = 463
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 176
    Top = 44
    Width = 48
    Height = 13
    Caption = #26679#24335#21517#31216
  end
  object Label2: TLabel
    Left = 200
    Top = 71
    Width = 24
    Height = 13
    Caption = #31867#22411
  end
  object Label3: TLabel
    Left = 176
    Top = 98
    Width = 48
    Height = 13
    Caption = #20202#22120#31867#22411
  end
  object Label4: TLabel
    Left = 176
    Top = 125
    Width = 48
    Height = 13
    Caption = #32972#26223#39068#33394
  end
  object Label5: TLabel
    Left = 176
    Top = 153
    Width = 48
    Height = 13
    Caption = #32447#26465#39068#33394
  end
  object Label6: TLabel
    Left = 200
    Top = 181
    Width = 24
    Height = 13
    Caption = #32447#23485
  end
  object Label7: TLabel
    Left = 176
    Top = 226
    Width = 48
    Height = 13
    Caption = #23383#20307#21517#31216
  end
  object Label8: TLabel
    Left = 176
    Top = 253
    Width = 48
    Height = 13
    Caption = #23383#20307#22823#23567
  end
  object Label9: TLabel
    Left = 176
    Top = 280
    Width = 48
    Height = 13
    Caption = #23383#20307#39068#33394
  end
  object Label10: TLabel
    Left = 188
    Top = 308
    Width = 36
    Height = 13
    Caption = #36879#26126#24230
  end
  object Label11: TLabel
    Left = 16
    Top = 12
    Width = 36
    Height = 13
    Caption = #26679#24335#24211
  end
  object Bevel1: TBevel
    Left = 163
    Top = 31
    Width = 202
    Height = 178
  end
  object Bevel2: TBevel
    Left = 163
    Top = 214
    Width = 202
    Height = 120
  end
  object Bevel3: TBevel
    Left = 163
    Top = 340
    Width = 126
    Height = 105
  end
  object Label12: TLabel
    Left = 163
    Top = 12
    Width = 48
    Height = 13
    Caption = #26679#24335#23450#20041
  end
  object lstStyles: TListBox
    Left = 16
    Top = 31
    Width = 133
    Height = 414
    ItemHeight = 13
    PopupMenu = popStyleList
    TabOrder = 0
    OnClick = lstStylesClick
  end
  object edtDefName: TEdit
    Left = 230
    Top = 41
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edtDefName'
    OnChange = actChangedExecute
  end
  object cbxDefType: TComboBox
    Left = 230
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'cbxDefType'
    OnChange = actChangedExecute
  end
  object cbxMeterType: TComboBox
    Left = 230
    Top = 95
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'cbxMeterType'
    OnChange = actChangedExecute
  end
  object clrBKColor: TColorBox
    Left = 230
    Top = 122
    Width = 121
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 4
    OnChange = actChangedExecute
  end
  object edtLineWidth: TEdit
    Left = 230
    Top = 178
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 5
    Text = 'edtLineWidth'
    OnChange = actChangedExecute
  end
  object clrLineColor: TColorBox
    Left = 230
    Top = 150
    Width = 121
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 6
    OnChange = actChangedExecute
  end
  object edtFontSize: TEdit
    Left = 230
    Top = 250
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 7
    Text = 'edtFontSize'
    OnChange = actChangedExecute
  end
  object clrFontColor: TColorBox
    Left = 230
    Top = 277
    Width = 121
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 8
    OnChange = actChangedExecute
  end
  object chkAutoFit: TCheckBox
    Left = 182
    Top = 348
    Width = 97
    Height = 17
    Caption = #33258#36866#24212#25991#23383
    TabOrder = 9
    OnClick = actChangedExecute
  end
  object chkUseGDIPlus: TCheckBox
    Left = 182
    Top = 371
    Width = 97
    Height = 17
    Caption = #20351#29992'DGI+'
    TabOrder = 10
    OnClick = actChangedExecute
  end
  object chkShowBorder: TCheckBox
    Left = 182
    Top = 394
    Width = 97
    Height = 17
    Caption = #26174#31034#36793#26694
    TabOrder = 11
    OnClick = actChangedExecute
  end
  object tbrTrans: TTrackBar
    Left = 230
    Top = 305
    Width = 128
    Height = 21
    Max = 100
    Position = 80
    TabOrder = 12
  end
  object chkAlignRight: TCheckBox
    Left = 182
    Top = 417
    Width = 97
    Height = 17
    Caption = #21491#23545#40784
    TabOrder = 13
    OnClick = actChangedExecute
  end
  object btnOK: TButton
    Left = 396
    Top = 16
    Width = 116
    Height = 25
    Caption = #30830#23450
    TabOrder = 14
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 396
    Top = 47
    Width = 116
    Height = 25
    Caption = #21462#28040'/'#36864#20986
    TabOrder = 15
    OnClick = btnCancelClick
  end
  object btnSetAsDefault: TButton
    Left = 396
    Top = 78
    Width = 116
    Height = 25
    Caption = #35774#20026#24403#21069#26679#24335
    TabOrder = 16
    OnClick = btnSetAsDefaultClick
  end
  object btnUpdate: TButton
    Left = 396
    Top = 120
    Width = 116
    Height = 25
    Caption = #26356#26032#35774#32622
    TabOrder = 17
    OnClick = btnUpdateClick
  end
  object cbxFonts: TComboBox
    Left = 230
    Top = 223
    Width = 121
    Height = 21
    TabOrder = 18
    OnChange = actChangedExecute
  end
  object btnSaveStyles: TButton
    Left = 396
    Top = 151
    Width = 116
    Height = 25
    Caption = #20445#23384#26679#24335#34920
    TabOrder = 19
    OnClick = btnSaveStylesClick
  end
  object btnApplyNow: TButton
    Left = 295
    Top = 340
    Width = 70
    Height = 48
    Caption = #23558#24403#21069#26679#24335#13#24212#29992#21040#22270#32440
    TabOrder = 20
    WordWrap = True
    OnClick = btnApplyNowClick
  end
  object popStyleList: TPopupMenu
    Left = 392
    Top = 276
    object piAddNew: TMenuItem
      Caption = #26032#22686
      OnClick = piAddNewClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object piSetCurrentUse: TMenuItem
      Caption = #35774#20026#24403#21069#26679#24335
      OnClick = piSetCurrentUseClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object piDelete: TMenuItem
      Caption = #21024#38500
      OnClick = piDeleteClick
    end
  end
  object ActionManager1: TActionManager
    Left = 448
    Top = 288
    StyleName = 'Platform Default'
    object actChanged: TAction
      Caption = 'actChanged'
      OnExecute = actChangedExecute
    end
  end
end