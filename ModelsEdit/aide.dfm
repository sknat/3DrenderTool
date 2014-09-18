object Form2: TForm2
  Left = 251
  Top = 254
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Aide'
  ClientHeight = 282
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Text: TStaticText
    Left = 8
    Top = 8
    Width = 409
    Height = 225
    AutoSize = False
    Caption = 'Text'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 168
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
end
