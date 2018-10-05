object fraTerminal: TfraTerminal
  Left = 0
  Top = 0
  Width = 490
  Height = 291
  TabOrder = 0
  DesignSize = (
    490
    291)
  object edtCmd: TEdit
    Left = 8
    Top = 254
    Width = 473
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = edtCmdKeyPress
    ExplicitTop = 255
  end
  object mmResult: TMemo
    Left = 8
    Top = 10
    Width = 473
    Height = 237
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
