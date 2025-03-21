object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'emailClient'
  ClientHeight = 360
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label10: TLabel
    Left = 72
    Top = 24
    Width = 232
    Height = 46
    Caption = 'emailClient'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Showcard Gothic'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 96
    Top = 88
    Width = 151
    Height = 15
    Caption = 'Willkommen im emailClient.'
  end
  object Label2: TLabel
    Left = 24
    Top = 109
    Width = 326
    Height = 15
    Caption = 'Dies ist kein e-Mail Programm, bitte nutzen Sie daf'#252'r Outlook.'
  end
  object Label3: TLabel
    Left = 24
    Top = 146
    Width = 345
    Height = 165
    Caption = 
      'Im Grunde handelt es sich um ein Programm, '#13#10'in dem man einen Ac' +
      'count erstellen kann.'#13#10'Es gibt die M'#246'glichkeit sich anzumelden o' +
      'der zu registrieren.'#13#10#13#10'Es gibt Regeln:'#13#10'1. Bitte gehen Sie mit ' +
      'dem Porgamm liebevoll um.'#13#10'2. Um sich zu registrieren, muss man ' +
      'mindestens 16 Jahre alt sein.'#13#10'3. Um sein Passwort zu sehen, mus' +
      's man '#252'ber den '#13#10'    Augenbutton mit der Maus gehen.'#13#10#13#10'Ansonste' +
      'n Viel Spa'#223'! :)'
  end
  object Button1: TButton
    Left = 24
    Top = 327
    Width = 75
    Height = 25
    Caption = 'Zum Login'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 142
    Top = 327
    Width = 105
    Height = 25
    Caption = 'Zur Registrierung'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 290
    Top = 327
    Width = 75
    Height = 25
    Caption = #10060' Exit'
    TabOrder = 2
    OnClick = Button3Click
  end
end
