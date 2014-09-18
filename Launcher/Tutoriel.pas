unit Tutoriel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellapi;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    tutotext: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
ShellExecute(Handle,nil,pchar('..\modelsedit\modelsedit'),pchar('..\models\src\tutoriel.d3s'),nil,SW_NORMAL)
end;

procedure TForm2.FormShow(Sender: TObject);
begin
Tutotext.Caption :=
'Delphi 3D'+chr(13)+chr(13)+
'Cette librairie à pour unique but de réinventer la roue (enfin un début de roue...)'+chr(13)+
'Dans le principe, elle a pour objectif de définir des structures de l''espace, et de'+chr(13)+
'les afficher à l''écran'+chr(13)+chr(13)+
'L''application Editeur permet une défintion simplifiée, sous la forme de lignes de code'+chr(13)+
'Les modèles sont stockés soit sous la forme de code source (fichier .d3s - de données texte'+chr(13)+
'brutes) ou peuvent être exportés sous la forme de .poly/.shape, formes compilées de modèles'+chr(13)+
'3d, qui peuvent être chargés directement depuis delphi en utilisant shape.loadfromfile(filename)'+chr(13)+chr(13)+
'Pour accéder à l''Editeur :'+chr(13)+
' - Dans le menu principal'+chr(13)+
' - Si dessous, le raccourci ouvre l''Editeur avec préchargé un exemple expliquant son fonctionnement'+chr(13)+chr(13)+
'Histoire de voir ce que le moteur donne dans de ''vraies'' conditions,'+chr(13)+
'des jeux sont disponnibles (le pluriel comançant à 2 ;)'+chr(13)+chr(13)+
'  --Skwitchi';
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
close;
end;

end.
