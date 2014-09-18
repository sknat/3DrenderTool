object Form2: TForm2
  Left = 198
  Top = 107
  Width = 573
  Height = 342
  Caption = 'Tutoriel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tutotext: TLabel
    Left = 8
    Top = 8
    Width = 35
    Height = 13
    Caption = 'tutotext'
  end
  object Button1: TButton
    Left = 8
    Top = 272
    Width = 161
    Height = 25
    Caption = 'Ouvrir le Tutoriel de L'#39#233'diteur'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Fermer'
    TabOrder = 1
    OnClick = Button2Click
  end
end
