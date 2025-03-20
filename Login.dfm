object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Login | emailClient'
  ClientHeight = 313
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label10: TLabel
    Left = 160
    Top = 8
    Width = 108
    Height = 46
    Caption = 'Login'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Showcard Gothic'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 64
    Top = 133
    Width = 50
    Height = 15
    Caption = 'Passwort:'
  end
  object Label3: TLabel
    Left = 77
    Top = 88
    Width = 37
    Height = 15
    Caption = 'e-mail:'
  end
  object Button3: TButton
    Left = 335
    Top = 256
    Width = 71
    Height = 31
    Caption = #10060' Exit'
    TabOrder = 0
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 335
    Top = 132
    Width = 40
    Height = 20
    Caption = #55357#56384
    TabOrder = 1
    OnMouseEnter = Button4MouseEnter
    OnMouseLeave = Button4MouseLeave
  end
  object EditPassword: TEdit
    Left = 120
    Top = 130
    Width = 209
    Height = 23
    PasswordChar = '*'
    TabOrder = 2
  end
  object EditEmail: TEdit
    Left = 120
    Top = 85
    Width = 209
    Height = 23
    TabOrder = 3
  end
  object Button2: TButton
    Left = 120
    Top = 256
    Width = 105
    Height = 31
    Caption = #55357#56593' Login'
    TabOrder = 4
    OnClick = Button2Click
  end
end
