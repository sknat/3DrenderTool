unit aide;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Text: TStaticText;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
text.Caption :=

'Editeur de Modèles 3D'+chr(13)+chr(13)+
'Pour commencer tout modèle 3d, la première ligne doit être :'+chr(13)+
'#shape pour un ensemble de polygones'+chr(13)+
'#poly pour un unique polygone'+chr(13)+chr(13)+
'Un exemple de shape est présent dans le fichier Tutoriel.d3s'+chr(13)+
'Selectionner Fichier -> Ouvrir -> Tutoriel.d3s'+chr(13)+chr(13)+
'Les fonctionnalités sont dans l''ensemble les mêmes que pour'+chr(13)+
'un editeur de texte standart.'+chr(13)+
'Pour ''compiler'', afficher une forme déclarée, cliquer sur'+chr(13)+
'Prévisualisation -> Rafraîchir'+chr(13)+chr(13)+
'La fonction Edition -> Couleur permet de selectionner une couleur'+chr(13)+
'et d''en afficher le code (hexadécimal ou constante delphi) au'+chr(13)+
'niveau du curseur dans la fenêtre d''édition'+chr(13);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
close;
end;

end.
