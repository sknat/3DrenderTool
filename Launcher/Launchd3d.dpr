program Launchd3d;

uses
  Forms,
  D3dLauncher in 'D3dLauncher.pas' {Form1},
  Tutoriel in 'Tutoriel.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
