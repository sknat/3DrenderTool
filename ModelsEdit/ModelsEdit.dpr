program ModelsEdit;

uses
  Forms,
  Editeurmodels in 'Editeurmodels.pas' {Form1},
  d3d in '..\Moteur\d3d.pas',
  aide in 'aide.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
