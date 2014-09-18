unit D3dLauncher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math, shellapi, tutoriel;

type Tmovebutton = class(Tbutton)
    MoveTimer: Ttimer;
    public
    iniTop: integer;
    goleft,gotop: integer;
    realtop: real;
    inileft: integer;
    realleft: real;
    Nbstep: integer;
    at,bt,al,bl: real;
    t:integer;
    procedure initmove(Newleft, NewTop, StepLength, Stepcount:integer);
    procedure MoveTimerOntimer(Sender: Tobject);
  end;
      

type
  TForm1 = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Menutext(id: integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Btgame1(sender: Tobject);
    procedure Btgame2(sender: Tobject);
    procedure Btgame3(sender: Tobject);
    procedure BtQuit(sender: Tobject);
    procedure Btclose(sender: Tobject);
    procedure BtGame(sender: Tobject);
    procedure BtTuto(sender: Tobject);
    procedure BtEdit(sender: Tobject);
    procedure BtBack(sender: Tobject);
    procedure Redeploy(sender: Tobject);
  end;


var
  Form1: TForm1;
  Buttons: array[0..4] of Tmovebutton;
  Redeployid: integer;
  strgame: array[1..3] of string;
  strname: array[1..3] of string;

implementation

{$R *.dfm}

//////////Classe TMovebutton///////////
// surcharge de Tbutton
procedure Tmovebutton.MoveTimerOntimer(Sender: Tobject);
begin
if t>=Nbstep then Movetimer.Enabled := false;
realLeft := sign(goleft-inileft)*(-bl*t*t*t/3+al*t*t/2)+inileft;
realTop := sign(gotop-initop)*(-bt*t*t*t/3+at*t*t/2)+initop;
Left := round(realleft);
top := round(realtop);
inc(t);
end;

procedure TmoveButton.initmove(Newleft, NewTop, StepLength, Stepcount:integer);
begin
//initialisation du timer
Movetimer := Ttimer.Create(Self);
Movetimer.OnTimer := MovetimerOntimer;
Movetimer.Interval := Steplength;

//valeurs du deplacement
goleft := newleft;
gotop := newtop;
initop := self.Top;
inileft := self.Left;
realtop := 0;
realleft := 0;

//coefficiants de l'eq du mouvement;
at := 6*abs(initop-goTop)/sqr(Stepcount);
bt := at/Stepcount;
al := 6*abs(inileft-goLeft)/sqr(Stepcount);
bl := al/Stepcount;

NbStep := Stepcount;
t := 0;
Movetimer.Enabled := true;
end;
//////////////////////////////////

procedure Tform1.Menutext(id: integer);
begin
case id of
1:  begin
    Buttons[0].Caption := 'Jouer';
    Buttons[0].Hint := 'Choisir un Jeu';
    Buttons[0].OnClick := Btgame;
    Buttons[1].Caption := 'Editer';
    Buttons[1].OnClick := Btedit;
    Buttons[1].Hint := 'Editer un modèle d3d: une forme'+chr(13)+'prédéfinie, utilisable dans les programmes';
    Buttons[2].Caption := 'Aide';
    Buttons[2].OnClick := Bttuto;
    Buttons[2].Hint := 'Afficher l''aide concernant D3d';
    Buttons[3].Caption := 'Quitter';
    Buttons[3].OnClick := Btquit;
    Buttons[4].Visible := false;
    end;
2:  begin
    Buttons[0].Caption := strname[1];
    Buttons[0].OnClick := Btgame1;
    Buttons[0].Hint := '';
    Buttons[1].Caption := strname[2];
    Buttons[1].OnClick := Btgame2;
    Buttons[1].Hint := '';
    Buttons[2].Caption := strname[3];
    Buttons[2].OnClick := Btgame3;
    Buttons[2].Hint := '';
    Buttons[3].Caption := 'Retour';
    Buttons[3].OnClick := Btback;
    Buttons[4].Visible := false;

    end;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i: integer;
f: textfile;
begin
if fileexists('.\gamenames.d3d') then
  begin
  assignfile(f,'.\gamenames.d3d');
  reset(f);
  for i:=1 to 3 do
    begin
    readln(f,strgame[i]);
    readln(f,strname[i]);
    end;
  end
  else
  begin
  for i:=1 to 3 do
    begin
    strgame[i] := '';
    strname[i] := '...';
    end;
  end;
for i:=0 to 4 do
begin
Buttons[i] := Tmovebutton.Create(self);
Buttons[i].Height := 25;
Buttons[i].Width := 105;
Buttons[i].Top := 8;
Buttons[i].Left := 8;
Buttons[i].Parent := Form1;
Buttons[i].initmove(8,8+33*i,10,50);
Buttons[i].ShowHint := true;
end;
menutext(1);
Form1.Width := 129;
Form1.Height := 173;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
buttons[1].initmove(100,100,10,50);
end;

procedure Tform1.Btclose(Sender: Tobject);
begin close; end;

procedure Tform1.BtQuit(sender: Tobject);
var
i: integer;
begin
for i:=0 to 4 do Buttons[i].initmove(8,8,10,50);
timer.Enabled := true;
timer.Interval := 550;
timer.OnTimer := btclose;
end;
procedure Tform1.BtGame(sender: Tobject);
var
i: integer;
begin
//choisir un jeu
for i:=0 to 4 do Buttons[i].initmove(8,8,10,50);
timer.Enabled := true;
timer.Interval := 550;
timer.OnTimer := Redeploy;
Redeployid := 2;
end;
procedure Tform1.BtBack(sender: Tobject);
var
i: integer;
begin
//choisir un jeu
for i:=0 to 4 do Buttons[i].initmove(8,8,10,50);
timer.Enabled := true;
timer.Interval := 550;
timer.OnTimer := Redeploy;
Redeployid := 1;
end;

procedure Tform1.BtTuto(sender: Tobject);
begin
Form2.show;
end;
procedure Tform1.BtEdit(sender: Tobject);
begin
ShellExecute(Handle,nil,pchar('..\modelsedit\modelsedit'),nil,nil,SW_NORMAL);
end;
procedure Tform1.Redeploy(sender: Tobject);
var i:integer;
begin
timer.enabled:=false;
for i:=0 to 4 do Buttons[i].initmove(8,8+33*i,10,50);
menutext(Redeployid);
end;

procedure Tform1.Btgame1(sender: Tobject);
begin
//lancer jeu1
if strgame[1]<>'' then
ShellExecute(Handle,nil,pchar(strgame[1]),nil,nil,SW_NORMAL)
end;
procedure Tform1.Btgame2(sender: Tobject);
begin
//lancer jeu2
if strgame[2]<>'' then
ShellExecute(Handle,nil,pchar(strgame[2]),nil,nil,SW_NORMAL)
end;
procedure Tform1.Btgame3(sender: Tobject);
begin
//lancer jeu3
if strgame[3]<>'' then
ShellExecute(Handle,nil,pchar(strgame[3]),nil,nil,SW_NORMAL)
end;


end.
