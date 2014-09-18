{-----------------------------------------
Unité Delphi 3D
 fonctions 3d de base pour l'affichage de
 polygones et d'ensembles de polygones

 Le type T3dshape (object et non class)
  est un ensemble limité à 999 polygones
(paramétrable dans la taille de l'array[??] of T3dpoly)

 De même le type Polygone contient par défaut au maximum
 10 points (modifiable dans array[??] or T3dpoint


--A faire : essayer de rendre l'allocation mémoire dynamique pour ce qui est du
stockage des types d3d
-----------------------------------------}
unit d3d;
interface
uses windows,graphics, sysutils,dialogs{,d3d_output};
//////////////////////Type Vecteur 3D//////////////////////////////
type T3dvertex = object
  x: real;
  y: real;
  z: real;
  procedure create(a,b,c: real); //overload;
  //procedure create(p1,p2: T3dpoint); overload;
  function norm: real;
  procedure normalize(NewNorm: real);
  end;
//////////////////////Type point 3D//////////////////////////////
type T3dPoint = object
	x: real;
	y: real;
	z: real;
	procedure render(var a,b: integer);
	procedure create(a,b,c: real);
	procedure vector(a,b,c: real);
	procedure rotation(p: T3dpoint; w:T3dvertex ;angle:real);
	end;


//////////////////////Type liste de points 3D//////////////////////////////
//////////////   T3dpointList : liste des points d'un polygone (au maximum 10)
type T3dpointlist = array[1..10] of T3dPoint;
//////////////////////Type polygone 3D//////////////////////////////
type T3dPoly = object
	Pointlist: T3dPointlist;	//liste des points
	nbp: word;			//nombre de points
        isellipse: boolean;	//si c'est une ellipse
        outcol: Tcolor;	       //couleur de contour
        incol: Tcolor;	       //couleur de remplissage
        filled: boolean;           //indique si l'on doit remplir le polygone avec la couleur incol
        barycentre: T3dpoint; //le barycentre du polygone
        radius: real;              // le rayon = distance du barycentre au point le  plus eloigné
	//creation
	procedure loadfromfile(filename: string);
	procedure savetofile(filename: string);
	procedure create(clout,clin:Tcolor;ellipse,fill:boolean);
	procedure addpoint(p: T3dpoint);
	procedure finalize; //finalise la creation en calculant le barycentre et le rayon
	//dessin
	procedure draw;
	procedure undraw;
	//Transformations
	procedure vector(v: t3dvertex);
	procedure rotation(p: T3dpoint; w:T3dvertex ;angle:real);
  
	end;
//////////////////////////////////////
// T3d polylist : liste des polygones d'une shape (au maximum 20)
type T3dPolylist = array[1..999] of T3dPoly;
//////////////////////Type ensemble polygones 3d////////////////
type T3dShape = object
	Polylist: T3dPolylist;     // liste des polygones
	nb: integer;		// nombre de polygones
	barycentre : t3dpoint;
	radius: real;
	// creation
	procedure create;
	procedure loadfromfile(filename: string);
	procedure savetofile(filename: string);
	procedure newpoly(clout,clin:Tcolor;ellipse,fill:boolean);
	procedure addpoint(p: T3dpoint);
	procedure finalize; //calcul du barycentre et du rayon
	// dessin
	procedure draw;
	procedure undraw;
	//
	procedure algopeintre; // tri des polygones dans le tableau par leur distance à la camera
	//transformations
  procedure setxy(p: t3dpoint); //fixe le barycentre à p
	procedure vector(v: t3dvertex);
	procedure rotation(p: T3dpoint; w:T3dvertex ;angle:real);
  end;

//////////////////////Fin objets//////////////////////////////

procedure setparams(canvas: Tcanvas;invisiblecol: Tcolor;pfuite,fuitex,fuitey,maxx,maxy:integer);
function dist3d(p1,p2: T3dpoint):real; // distance entre deux points
function p3d(a,b,c:real):T3dpoint;	 // retourne un point formé des 2 entiers spécifiés
function v3d(a,b,c: real):T3dvertex; overload;
function v3d(p1,p2: T3dpoint):T3dvertex; overload;
function prodscal(v1,v2: T3dvertex):real;
function prodvect(v1,v2: T3dvertex):T3dvertex;
procedure setcam(pcam,dcam : T3dpoint); // fixe la camera
procedure cls;

var
  camera  : T3dpoint;
  cameradir : T3dpoint;
  cameraayz: real;
  cameraaxz: real;
const
  Origin: T3dpoint = (x:0;y:0;z:0);
  Vect0: T3dvertex = (x:0;y:0;z:0);
  Vecti: T3dvertex = (x:1;y:0;z:0);
  Vectj: T3dvertex = (x:0;y:1;z:0);
  Vectk: T3dvertex = (x:0;y:0;z:1);

implementation
var
  Fuitez  : Integer;
  pfuitex : integer;
  pfuitey : integer;
  invisiblecolor : Tcolor;
  currentcanvas : Tcanvas;
  getmaxx: integer;
  getmaxy: integer;

////////////////////////
// gestion de l'unité //
////////////////////////
function prodvect(v1,v2: T3dvertex):T3dvertex;
begin
prodvect.create(v1.y * v2.z - v1.z * v2.y,
                v1.z * v2.x - v1.x * v2.z,
                v1.x * v2.y - v1.y * v2.x);
end;

function prodscal(v1,v2: T3dvertex):real;
begin
prodscal := v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
end;

procedure cls;
begin
with currentcanvas do begin
brush.Color := invisiblecolor;
brush.Style := bssolid;
pen.color := invisiblecolor;
rectangle(cliprect);
end;
end;

procedure setcam(pcam,dcam: T3dpoint);
begin
camera := pcam;
cameradir := dcam;
end;

function v3d(a,b,c:real): T3dvertex;
begin
v3d.create(a,b,c);
end;

function v3d(p1,p2:t3dpoint): t3dvertex;
begin
//v3d.create(p1,p2);
v3d.create(p2.x-p1.x,p2.y-p1.y,p2.z-p1.z);
end;

function p3d(a,b,c: real):T3dpoint;
begin
p3d.create(a,b,c);
end;

function dist3d(p1,p2: T3dpoint):real;
begin
dist3d := sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y)+sqr(p1.z-p2.z));
end;

procedure setparams(canvas: Tcanvas;invisiblecol: Tcolor;pfuite,fuitex,fuitey,maxx,maxy:integer);
begin
currentcanvas := canvas;
fuitez := pfuite;
pfuitex := fuitex;
pfuitey := fuitey;
invisiblecolor := invisiblecol;
getmaxx := maxx;
getmaxy := maxy;
camera.create(round(maxx/2),round(maxy/2),0);
end;

//////////////////////////////////
//     procedures shape         //
//////////////////////////////////
procedure T3dshape.setxy(p: T3dpoint);
begin
vector(v3d(barycentre,p));
end;

procedure T3dshape.finalize;
var
count,i,j:integer;
sumx,sumy,sumz:real;
max,a:real;
begin
polylist[nb].finalize; //finalise le dernier polygone non finalisé
sumx := 0; sumy := 0; sumz := 0; count := 0; max := 0;
for i:=1 to nb do
  with polylist[i] do
  begin
  for j := 1 to nbp do
    begin
    sumx := sumx + pointlist[j].x;
    sumy := sumy + pointlist[j].y;
    sumz := sumz + pointlist[j].z;
    inc(count);
    end;
  end;
//showmessage(floattostr(sumx/count));
barycentre.create(sumx/count,sumy/count,sumz/count);
for i:=1 to nb do
  for j := 1 to polylist[i].nbp do
    begin
    a := dist3d(barycentre,polylist[i].pointlist[j]);
    if a>max then max := a;
    end;
radius := max;
end;

procedure T3dShape.savetofile(filename: string);
var
f: file of T3dshape;
begin
assignfile(f,filename);
rewrite(f);
write(f,self);
closefile(f);
end;

procedure T3dShape.loadfromfile(filename: string);
var
f: file of T3dshape;
begin
if not fileexists(filename) then exit;
assignfile(f,filename);
reset(f);
read(f,self);
closefile(f);
end;

procedure T3dshape.newpoly(clout,clin:Tcolor;ellipse,fill:boolean);
begin
if nb<>0 then polylist[nb].finalize;
inc(nb);
polylist[nb].create(clout,clin,ellipse,fill);
end;

procedure T3dshape.addpoint(p:T3dpoint);
begin
polylist[nb].addpoint(p);
end;

procedure T3dshape.create;
begin
nb := 0;
end;

procedure T3dshape.algopeintre;
var
i,j: integer;
temp : t3dpoly;
begin
//for i := 1 to nb do polylist[i].calcxyz; //calcul des coordonnees du barycentre fait par finalize
//algorithme du peintre, tri des surfaces par leur barycentre
for j := nb downto 2 do
    begin
    for i := 1 to (nb-1) do
      begin
        if (dist3d(polylist[i].barycentre,camera) < dist3d(polylist[i+1].barycentre,camera)) then
        begin
        temp := polylist[i];
        polylist[i] := polylist[i+1];
        polylist[i+1] := temp;
        end;
      end;
    end;
end;

procedure T3dshape.draw;
var i : integer;
begin
for i := 1 to nb do
begin
polylist[i].draw;
end;
end;

procedure T3dshape.undraw;
var i : integer;
begin
for i := 1 to nb do polylist[i].undraw;
end;

procedure T3dshape.vector(v: T3dvertex);
var i : integer;
begin
for i := 1 to nb do polylist[i].vector(v);
barycentre.vector(v.x,v.y,v.z);
end;

procedure T3dshape.rotation(p: T3dpoint; w:T3dvertex ;angle:real);
var i : integer;
begin
for i := 1 to nb do polylist[i].rotation(p,w,angle);
barycentre.rotation(p,w,angle);
end;

//////////////////////////////////
//    procedures polygone       //
//////////////////////////////////
procedure T3dpoly.savetofile(filename: string);
var
f: file of T3dpoly;
begin
assignfile(f,filename);
rewrite(f);
write(f,self);
closefile(f);
end;

procedure T3dpoly.loadfromfile(filename: string);
var
f: file of T3dpoly;
begin
if not fileexists(filename) then exit;
assignfile(f,filename);
reset(f);
read(f,self);
closefile(f);
end;

procedure T3dpoly.create(clout,clin:Tcolor;ellipse,fill:boolean);
begin
nbp := 0;
outcol := clout;
incol := clin;
isellipse := ellipse;
filled := fill;
end;

procedure T3dpoly.addpoint(p : T3dpoint);
begin
pointlist[nbp+1] := p;
inc(nbp);
end;

procedure T3dpoly.finalize;
var
sx,sy,sz: real;
i:integer;
max,a: real;
begin
sx := 0;
sy := 0;
sz := 0;
a := 1;
for i:=1 to nbp do
  begin
  sx := sx + pointlist[i].x;
  sy := sy + pointlist[i].y;
  sz := sz + pointlist[i].z;
  end;
barycentre.create(sx/nbp,sy/nbp,sz/nbp);
max := 0;
for i := 1 to nbp do
  begin
  a := dist3d(barycentre,pointlist[i]);
  if a > max then max := a;
  end;
radius := a;
end;


procedure T3dpoly.draw;
var
tempp2d: array[1..10] of Tpoint;
i:integer;
begin
  //calcxyz;
  //if barycentre.z<camera.z-10 then exit;
  for i:=1 to nbp do
  begin
    pointlist[i].render(tempp2d[i].x,tempp2d[i].y);
  end;
    tempp2d[nbp+1]:=tempp2d[1];
  if filled then
     begin
     currentcanvas.Brush.color := incol;
     if not isellipse then currentcanvas.Polygon(slice(tempp2d,nbp+1));
     end;
  currentcanvas.pen.color := outcol;
  if isellipse then
    begin
    if not filled then currentcanvas.Brush.Style := bsclear else currentcanvas.Brush.Style := bssolid;
    currentcanvas.Ellipse(tempp2d[1].X,tempp2d[1].Y,tempp2d[2].X,tempp2d[2].Y);
    currentcanvas.Brush.Style := bssolid;
    end
  else currentcanvas.Polyline(slice(tempp2d,nbp+1));
end;

procedure T3dpoly.undraw;
var
tempp2d: array[1..10] of Tpoint;
i:integer;
begin
  for i:=1 to nbp do
  begin
    pointlist[i].render(tempp2d[i].x,tempp2d[i].y);
  end;
    tempp2d[nbp+1]:=tempp2d[1];
  if filled then
     begin
     currentcanvas.Brush.color := invisiblecolor;
     if not isellipse then currentcanvas.Polygon(slice(tempp2d,nbp+1));
     end;
  currentcanvas.pen.color := invisiblecolor;
  if isellipse then
    begin
    if not filled then currentcanvas.Brush.Style := bsclear else currentcanvas.Brush.Style := bssolid;
    currentcanvas.Ellipse(tempp2d[1].X,tempp2d[1].Y,tempp2d[2].X,tempp2d[2].Y);
    currentcanvas.Brush.Style := bssolid;
    end
  else currentcanvas.Polyline(slice(tempp2d,nbp+1));
end;

/////////////transformations////////////

procedure T3dpoly.vector(v: T3dvertex);
var
i:integer;
begin
  for i:=1 to nbp do pointlist[i].vector(v.x,v.y,v.z);
  barycentre.vector(v.x,v.y,v.z);
end;

procedure T3dpoly.rotation(p: T3dpoint; w:T3dvertex ;angle:real);
var
i:integer;
begin
  for i:=1 to nbp do pointlist[i].rotation(p,w,angle);
  barycentre.rotation(p,w,angle);
end;

////////////////////////////////
//   objet vertex procedures  //
////////////////////////////////
procedure T3dvertex.create(a,b,c: real);
begin
x := a;
y := b;
z := c;
end;

{procedure T3dvertex.create(p1,p2: T3dpoint); overload; -> ici impossible à cause de la dépendance simultanée vecteur/point
begin
x := p2.x-p1.x;
y := p2.y-p1.y;
z := p2.z-p1.z;
end;}

function T3dvertex.norm: real;
begin
norm := sqrt(sqr(x)+sqr(y)+sqr(z));
end;

procedure T3dvertex.normalize(NewNorm: real);
var
n: real;
begin
n := self.norm;
if (x=0) and (y=0) and (z=0) then raise exception.Create('Erreur d3d - Normalisation du vecteur nul');
x := x * NewNorm / n;
y := y * NewNorm / n;
z := z * NewNorm / n;
end;

////////////////////////////////
//   objet point procedures   //
////////////////////////////////

procedure T3dpoint.rotation(p: T3dpoint; w:T3dvertex ;angle:real);
var
u,v,prodv: T3dvertex;
cosa,sina,prods: real;
begin
if (w.x = 0) and (w.y = 0) and (w.z = 0)
  then raise exception.Create('Erreur d3d - rotation de vecteur nul');
if not((p.x=self.x) and (p.y=self.y) and (p.z=self.z)) then
begin
u := v3d(p,self);
w.normalize(1);
prodv := prodvect(u,w);
cosa := cos(angle);
sina := sin(angle);
prods := prodscal(u,w);
v.x := cosa*u.x + (1-cosa)*prods*w.x + sina*prodv.x;
v.y := cosa*u.y + (1-cosa)*prods*w.y + sina*prodv.y;
v.z := cosa*u.z + (1-cosa)*prods*w.z + sina*prodv.z;

p.vector(v.x,v.y,v.z);
self := p;
end;
{
anciennes formules valant pour une rotation autour des axes (Ox), (Oy), (Oz)
if axe = 3 then begin
   xx := x-p.x;
   yy := y-p.y;
   x := xx*cos(angle)-yy*sin(angle)+p.x;
   y := xx*sin(angle)+yy*cos(angle)+p.y;
   end;
if axe = 2 then begin
   xx := x-p.x;
   zz := z-p.z;
   x := xx*cos(angle)-zz*sin(angle)+p.x;
   z := xx*sin(angle)+zz*cos(angle)+p.z;
   end;
if axe = 1 then begin
   yy := y-p.y;
   zz := z-p.z;
   y := yy*cos(angle)-zz*sin(angle)+p.y;
   z := yy*sin(angle)+zz*cos(angle)+p.z;
   end;}
end;

procedure T3dpoint.vector(a,b,c:real);
begin
x := x+a;
y := y+b;
z := z+c;
end;

procedure T3dpoint.create(a,b,c: real);
begin
x := a;
y := b;
z := c;
end;

//////////Algorithme Rendu 3d//////////
procedure T3dpoint.render(var a,b: integer);
var
tx,ty,tz: real;
xx,yy,zz: real;
angle : real;
begin

//rotations inverses de celle effectuée par la camera
tx := x - camera.x + round(getmaxx/2);
ty := y - camera.y + round(getmaxy/2);
tz := z - camera.z;

angle := 1/ (sqrt(sqr(camera.x-cameradir.x)+sqr(camera.z-cameradir.z)));

   xx := tx-camera.x;
   zz := tz-camera.z;
   tx := xx*angle*(cameradir.z-camera.z)-zz*angle*(cameradir.x-camera.x)+camera.x;
   tz := xx*angle*(cameradir.x-camera.x)+zz*angle*(cameradir.z-camera.z)+camera.z;

angle := 1/ (sqrt(sqr(camera.x-cameradir.x)+sqr(camera.z-cameradir.z)));
   xx := tx-camera.y;
   zz := tz-camera.z;
   tx := xx*angle*(cameradir.z-camera.z)-zz*angle*(cameradir.y-camera.y)+camera.y;
   tz := xx*angle*(cameradir.y-camera.y)+zz*angle*(cameradir.z-camera.z)+camera.z;

if tz=0 then
  begin
  a := round(tx);
  b := round(ty);
  end
else
  begin
  a := round(4*(tx-pfuitex)/tz*(fuitez)+pfuitex);
  b := round(4*(ty-pfuitey)/tz*(fuitez)+pfuitey);
  end;

end;
////////////////////////////////
//   Initialisation unité     //
////////////////////////////////

begin
  invisiblecolor := clwhite;
  fuitez := 100;
end.
