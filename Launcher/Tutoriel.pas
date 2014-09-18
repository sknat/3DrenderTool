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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
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
'Cette librairie � pour unique but de r�inventer la roue (enfin un d�but de roue...)'+chr(13)+
'Dans le principe, elle a pour objectif de d�finir des structures de l''espace, et de'+chr(13)+
'les afficher � l''�cran'+chr(13)+chr(13)+
'L''application Editeur permet une d�fintion simplifi�e, sous la forme de lignes de code'+chr(13)+
'Les mod�les sont stock�s soit sous la forme de code source (fichier .d3s - de donn�es texte'+chr(13)+
'brutes) ou peuvent �tre export�s sous la forme de .poly/.shape, formes compil�es de mod�les'+chr(13)+
'3d, qui peuvent �tre charg�s directement depuis delphi en utilisant shape.loadfromfile(filename)'+chr(13)+chr(13)+
'Pour acc�der � l''Editeur :'+chr(13)+
' - Dans le menu principal'+chr(13)+
' - Si dessous, le raccourci ouvre l''Editeur avec pr�charg� un exemple expliquant son fonctionnement'+chr(13)+chr(13)+
'Histoire de voir ce que le moteur donne dans de ''vraies'' conditions,'+chr(13)+
'des jeux sont disponnibles (le pluriel coman�ant � 2 ;)'+chr(13)+chr(13)+
'  --Skwitchi';
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
close;
end;

end.
