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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
text.Caption :=

'Editeur de Mod�les 3D'+chr(13)+chr(13)+
'Pour commencer tout mod�le 3d, la premi�re ligne doit �tre :'+chr(13)+
'#shape pour un ensemble de polygones'+chr(13)+
'#poly pour un unique polygone'+chr(13)+chr(13)+
'Un exemple de shape est pr�sent dans le fichier Tutoriel.d3s'+chr(13)+
'Selectionner Fichier -> Ouvrir -> Tutoriel.d3s'+chr(13)+chr(13)+
'Les fonctionnalit�s sont dans l''ensemble les m�mes que pour'+chr(13)+
'un editeur de texte standart.'+chr(13)+
'Pour ''compiler'', afficher une forme d�clar�e, cliquer sur'+chr(13)+
'Pr�visualisation -> Rafra�chir'+chr(13)+chr(13)+
'La fonction Edition -> Couleur permet de selectionner une couleur'+chr(13)+
'et d''en afficher le code (hexad�cimal ou constante delphi) au'+chr(13)+
'niveau du curseur dans la fen�tre d''�dition'+chr(13);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
close;
end;

end.
