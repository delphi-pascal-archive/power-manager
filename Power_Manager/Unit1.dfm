object Form1: TForm1
  Left = 269
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Power Manager'
  ClientHeight = 315
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 312
    Top = 64
    Width = 21
    Height = 13
    Caption = #1089#1077#1082'.'
    Enabled = False
  end
  object Label2: TLabel
    Left = 312
    Top = 130
    Width = 21
    Height = 13
    Caption = #1089#1077#1082'.'
    Enabled = False
  end
  object Button1: TButton
    Left = 40
    Top = 32
    Width = 320
    Height = 25
    Caption = #1046#1076#1091#1097#1080#1081' '#1088#1077#1078#1080#1084
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 40
    Top = 98
    Width = 320
    Height = 25
    Caption = #1057#1087#1103#1097#1080#1081' '#1088#1077#1078#1080#1084
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 40
    Top = 164
    Width = 320
    Height = 25
    Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' (Winkey + L)'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 40
    Top = 196
    Width = 320
    Height = 25
    Caption = #1057#1084#1077#1085#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 40
    Top = 228
    Width = 320
    Height = 25
    Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 40
    Top = 260
    Width = 320
    Height = 25
    Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1079#1082#1072
    TabOrder = 5
    OnClick = Button6Click
  end
  object CheckBox1: TCheckBox
    Left = 56
    Top = 63
    Width = 209
    Height = 17
    Caption = #1042#1099#1074#1077#1089#1090#1080' '#1080#1079' '#1078#1076#1091#1097#1077#1075#1086' '#1088#1077#1078#1080#1084#1072' '#1095#1077#1088#1077#1079
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 6
  end
  object SpinEdit1: TSpinEdit
    Left = 264
    Top = 60
    Width = 41
    Height = 22
    Enabled = False
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 60
  end
  object CheckBox2: TCheckBox
    Left = 56
    Top = 129
    Width = 209
    Height = 17
    Caption = #1042#1099#1074#1077#1089#1090#1080' '#1080#1079' '#1089#1087#1103#1097#1077#1075#1086' '#1088#1077#1078#1080#1084#1072' '#1095#1077#1088#1077#1079
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 8
  end
  object SpinEdit2: TSpinEdit
    Left = 264
    Top = 126
    Width = 41
    Height = 22
    Enabled = False
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 60
  end
  object PowerManager1: TPowerManager
    OnWakeUp = PowerManager1WakeUp
    Left = 71
    Top = 17
  end
end
