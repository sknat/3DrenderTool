unit test23d;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, d3d, StdCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;
  function createblock(p1,p2: T3dpoint):T3dshape;

var
  Form1: TForm1;
  b: array[1..10] of T3dshape;
  v,c: t3dpoint;

implementation

{$R *.dfm}

function createblock(p1,p2: T3dpoint):T3dshape;
var
s: T3dshape;
begin
with s do begin
create;
newpoly(clblue,clgreen,false,true);
addpoint(p1);    //face avant
addpoint(p3d(p2.x,p1.y,p1.z));
addpoint(p3d(p2.x,p2.y,p1.z));
addpoint(p3d(p1.x,p2.y,p1.z));
newpoly(clblue,clred,false,true);
addpoint(p3d(p1.x,p1.y,p2.z));    //face arriere
addpoint(p3d(p2.x,p1.y,p2.z));
addpoint(p3d(p2.x,p2.y,p2.z));
addpoint(p3d(p1.x,p2.y,p2.z));
newpoly(clblue,clred,false,true);
addpoint(p3d(p2.x,p1.y,p1.z));    //face droite
addpoint(p3d(p2.x,p2.y,p1.z));
addpoint(p2);
addpoint(p3d(p2.x,p1.y,p2.z));
newpoly(clblue,clred,false,true);
addpoint(p3d(p1.x,p1.y,p1.z));    //face gauche
addpoint(p3d(p1.x,p2.y,p1.z));
addpoint(p3d(p1.x,p2.y,p2.z));
addpoint(p3d(p1.x,p1.y,p2.z));
newpoly(clblue,clyellow,false,true);
addpoint(p2);    //face haut
addpoint(p3d(p2.x,p2.y,p1.z));
addpoint(p3d(p1.x,p2.y,p1.z));
addpoint(p3d(p1.x,p2.y,p2.z));
newpoly(clblue,clblack,false,true);
addpoint(p3d(p2.x,p1.y,p2.z));    //face gauche
addpoint(p3d(p2.x,p1.y,p1.z));
addpoint(p3d(p1.x,p1.y,p1.z));
addpoint(p3d(p1.x,p1.y,p2.z));
finalize;
end;
createblock := s;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
doublebuffered := true;
setparams(form1.Canvas,clwhite,50,250,250,500,500);
camera.create(0,0,-800);
cameradir.create(0,0,0);
b[1] := createblock(p3d(300,0,50),p3d(500,500,75));
b[2] := createblock(p3d(-100,0,50),p3d(100,500,75));
b[3] := createblock(p3d(-100,0,100),p3d(100,500,125));
b[4] := createblock(p3d(300,0,100),p3d(500,500,125));
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
i:integer;
begin
cls;
if key = 'r' then b[1].rotation(b[1].barycentre,vectj,pi/12);

if key='o' then
  begin
  camera.vector(0,0,5);
  end;
  
if key='l' then
  begin
  camera.vector(0,0,-5);
  end;

if key = 'm' then
  begin
  //c.vector(5,0,0);
  //cameradir.x := cameradir.x + 1
  cameraaxz := cameraaxz + pi/2;
  //setcam(c,v);
  end;
if key = 'k' then
  begin
  //c.vector(-5,0,0);
  //cameradir.x := cameradir.x - 1
  cameraaxz := cameraaxz - pi/2;
  //setcam(c,v);
  end;

for i := 4 downto 1 do begin
if key = 'z' then
  begin
  b[i].vector(v3d(0,0,-10));
  end;
if key = 's' then
  begin
  b[i].vector(v3d(0,0,10));
  end;
if key = 'd' then
  begin
  b[i].vector(v3d(-10,0,0));
  end;
if key = 'q' then
  begin
  b[i].vector(v3d(10,0,0));
  end;
b[i].algopeintre;
b[i].draw;
form1.Canvas.TextOut(32,32,floattostr(cameraaxz));
end;
end;

end.
