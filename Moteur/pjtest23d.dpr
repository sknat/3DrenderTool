program pjtest23d;

uses
  Forms,
  test23d in 'test23d.pas' {Form1},
  d3d in 'd3d.pas' {Form2},
  d3d_output in 'd3d_output.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
