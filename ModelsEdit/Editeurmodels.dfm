object Form1: TForm1
  Left = 114
  Top = 114
  BorderStyle = bsSingle
  Caption = 'Editeur de mod'#232'les d3d'
  ClientHeight = 550
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    868
    550)
  PixelsPerInch = 96
  TextHeight = 13
  object Preview: TImage
    Left = 335
    Top = -1
    Width = 530
    Height = 530
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = PreviewMouseDown
    OnMouseMove = PreviewMouseMove
    OnMouseUp = PreviewMouseUp
  end
  object Redit: TRichEdit
    Left = 0
    Top = 0
    Width = 329
    Height = 529
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = ReditChange
  end
  object ErrorLst: TListBox
    Left = 0
    Top = 432
    Width = 329
    Height = 97
    ItemHeight = 13
    PopupMenu = PopupMenu2
    TabOrder = 1
    Visible = False
  end
  object Status: TStatusBar
    Left = 0
    Top = 531
    Width = 868
    Height = 19
    Panels = <
      item
        Text = 'Nombre de Polygones :'
        Width = 200
      end
      item
        Text = 'Nombre de Points :'
        Width = 200
      end>
  end
  object MainMenu1: TMainMenu
    Left = 336
    Top = 8
    object Fichier1: TMenuItem
      Caption = 'Fichier'
      object Nouveau1: TMenuItem
        Caption = 'Nouveau'
        ShortCut = 16462
        OnClick = Nouveau1Click
      end
      object Ouvrir1: TMenuItem
        Caption = 'Ouvrir...'
        ShortCut = 16463
        OnClick = Ouvrir1Click
      end
      object Enregistrer2: TMenuItem
        Caption = 'Enregistrer'
        ShortCut = 16467
        OnClick = Enregistrer2Click
      end
      object Enregistrer1: TMenuItem
        Caption = 'Enregistrer sous...'
        OnClick = Enregistrer1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object FormatD3D1: TMenuItem
        Caption = 'Format D3D'
        object Exporter1: TMenuItem
          Caption = 'Exporter...'
          OnClick = Exporter1Click
        end
        object Importer1: TMenuItem
          Caption = 'Importer...'
          OnClick = Importer1Click
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Colorationsyntaxique1: TMenuItem
        Caption = 'Coloration syntaxique'
        Checked = True
        OnClick = Colorationsyntaxique1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Fermer1: TMenuItem
        Caption = 'Fermer'
        ShortCut = 16465
        OnClick = Fermer1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Edition'
      object couper1: TMenuItem
        Caption = 'Couper'
        ShortCut = 16472
        OnClick = couper1Click
      end
      object Copier1: TMenuItem
        Caption = 'Copier'
        ShortCut = 16451
        OnClick = Copier1Click
      end
      object Coller1: TMenuItem
        Caption = 'Coller'
        ShortCut = 16470
        OnClick = Coller1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Couleur1: TMenuItem
        Caption = 'Couleur...'
        ShortCut = 45
        OnClick = Couleur1Click
      end
    end
    object Prvisualisation1: TMenuItem
      Caption = 'Pr'#233'visualisation'
      object Rafrachir1: TMenuItem
        Caption = 'Rafra'#238'chir'
        ShortCut = 116
        OnClick = Rafrachir1Click
      end
    end
    object Aide1: TMenuItem
      Caption = '?'
      object Aide2: TMenuItem
        Caption = 'Aide'
        ShortCut = 112
        OnClick = Aide2Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 368
    Top = 8
    object Couper2: TMenuItem
      Caption = 'Couper'
      OnClick = Couper2Click
    end
    object Copier2: TMenuItem
      Caption = 'Copier'
      OnClick = Copier2Click
    end
    object Coller2: TMenuItem
      Caption = 'Coller'
      OnClick = Coller2Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 400
    Top = 8
    object Vider1: TMenuItem
      Caption = 'Vider'
      OnClick = Vider1Click
    end
    object Cacher1: TMenuItem
      Caption = 'Cacher'
      OnClick = Cacher1Click
    end
  end
  object TimerError: TTimer
    Enabled = False
    Interval = 25
    OnTimer = TimerErrorTimer
    Left = 432
    Top = 8
  end
end
