unit Editeurmodels;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, d3d, Menus, StdCtrls, ComCtrls, ExtCtrls, clipbrd;

type TPrgVar = record
    name: string;
    value: string;
    valtyp: integer;
    end;
type Tprgvarlst = array[1..99] of Tprgvar;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Ouvrir1: TMenuItem;
    Enregistrer1: TMenuItem;
    N1: TMenuItem;
    Fermer1: TMenuItem;
    Redit: TRichEdit;
    Aide1: TMenuItem;
    Aide2: TMenuItem;
    Prvisualisation1: TMenuItem;
    Rafrachir1: TMenuItem;
    Nouveau1: TMenuItem;
    Options1: TMenuItem;
    couper1: TMenuItem;
    Copier1: TMenuItem;
    Coller1: TMenuItem;
    FormatD3D1: TMenuItem;
    Exporter1: TMenuItem;
    Importer1: TMenuItem;
    Enregistrer2: TMenuItem;
    N2: TMenuItem;
    PopupMenu1: TPopupMenu;
    Couper2: TMenuItem;
    Copier2: TMenuItem;
    Coller2: TMenuItem;
    N3: TMenuItem;
    Couleur1: TMenuItem;
    ErrorLst: TListBox;
    PopupMenu2: TPopupMenu;
    Vider1: TMenuItem;
    Cacher1: TMenuItem;
    TimerError: TTimer;
    N4: TMenuItem;
    Colorationsyntaxique1: TMenuItem;
    Status: TStatusBar;
    Preview: TImage;
    procedure Fermer1Click(Sender: TObject);
    procedure Ouvrir1Click(Sender: TObject);
    function texttoshape: T3dshape;
    procedure openshapefile(filename: string);
    procedure openpolyfile(filename: string);
    procedure Enregistrer1Click(Sender: TObject);
    procedure Aide2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Rafrachir1Click(Sender: TObject);
    procedure Nouveau1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PreviewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure couper1Click(Sender: TObject);
    procedure Copier1Click(Sender: TObject);
    procedure Coller1Click(Sender: TObject);
    procedure Couper2Click(Sender: TObject);
    procedure Copier2Click(Sender: TObject);
    procedure Coller2Click(Sender: TObject);
    procedure PreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Exporter1Click(Sender: TObject);
    procedure Importer1Click(Sender: TObject);
    procedure Enregistrer2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Couleur1Click(Sender: TObject);
    procedure Editsetfont(id: integer);
    procedure Colorize(All:Boolean);
    procedure Vider1Click(Sender: TObject);
    procedure Cacher1Click(Sender: TObject);
    procedure TimerErrorTimer(Sender: TObject);
    procedure ReditChange(Sender: TObject);
    procedure Colorationsyntaxique1Click(Sender: TObject);
    function Calc(var s:string; Prgvars: Tprgvarlst; MaxPrgVar: integer; i: integer):boolean;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

const MaxKeyWords = 11;

type Tkeyword = record
  str: string;
  sid: integer;
  end;

type Tkeywordlst = array[1..MaxKeyWords] of Tkeyword;

procedure noblanks(var s:string);
function isinteger(s: string):boolean;
function iscolor(s: string):boolean;

const keywords: Tkeywordlst = ((str:'#shape';sid:1),
                               (str:'#poly';sid:1),
                               (str:'const';sid:1),
                               (str:'declare';sid:1),
                               (str:'for';sid:1),
                               (str:'to';sid:1),
                               (str:'end';sid:1),
                               (str:'new';sid:1),
                               (str:'in';sid:2),
                               (str:'out';sid:2),
                               (str:'points';sid:2));

var
  Form1: TForm1;
  Shape: T3dShape;
  poly: T3dPoly;
  dragpreview: boolean;
  lastmx,lastmy:integer;
  CurrentFile: string;
  silentsave: boolean;
  shapezoom: real;
  toggle_zoom: boolean;
  Errorflashcount: integer;

implementation

uses aide;

{$R *.dfm}


////////////////
// Coloration //
////////////////
procedure Tform1.Colorize(All:boolean);  //true : Colore le texte entier
var                                      //false : Colore uniquement la ligne courante
i,found:integer;
downpos,size,newstart,memcursorpos:integer;
docolor: boolean;
tempchar: char;
begin
//recherche de la borne inferieure et de la taille de la zone à éditer
if (not All) then
  begin
    //si seule la ligne courante est à colorer
    downpos := redit.selstart;
    size := 0;
    if downpos <> 0 then         //calcul de downpos, n° du premier caractère de la ligne courante
    repeat dec(downpos) until (redit.text[downpos]=chr(13)) or (downpos=0);
    if downpos+size<>length(redit.Text) then  //calcul de size, nombre de caractères de la ligne courante
    repeat inc(size) until (redit.text[downpos+size]=chr(13)) or (downpos+size=length(redit.Text));

    //colorier tout en la couleur de base avant de recolorier
    memcursorpos := redit.SelStart;
    redit.SelStart := downpos;
    redit.SelLength := size+1;
    editsetfont(0); //mettre en style police normal

    redit.SelStart := memcursorpos;  //remet le curseur à sa position intiale
    redit.SelLength := 0;

  end
else
  begin
  //si tout le texte est à colorer
  downpos := 0;
  size := length(redit.Text);
  end;
//////////coloration syntaxique
for i := 1 to MaxKeyWords do  //pour chacun des Mots clés
  begin
  found := Redit.FindText(keywords[i].str,downpos,size,[stMatchcase]);  //trouver la premiere occurence
  while found <> -1 do   //tant que l'on a pas atteint la derniere occurence
    begin
      docolor := true;
      //coloration uniquement si le mot cle est précédé et suivit d'un saut de ligne ou d'un espace
      if (found <> 0) then
        begin
        tempchar := redit.Text[found];
        if (tempchar <> chr(10)) and (tempchar <> ' ') and (tempchar<>chr(13)) then docolor := false;
        end;
      if (found + length(keywords[i].str) <> length(redit.Text)) then
        begin
        tempchar := redit.Text[found+length(keywords[i].str)+1];
        if (tempchar <> chr(10)) and (tempchar <> ' ') and (tempchar<>chr(13)) then docolor := false;
        end;

      if docolor then
        begin
        memcursorpos := redit.SelStart;     //colore l'occurence
        redit.SelStart := found;
        redit.SelLength := length(keywords[i].str);
        editsetfont(keywords[i].sid);       //avec le style lui correspondant

        redit.SelStart := memcursorpos;
        redit.SelLength := 0;
        editsetfont(0);     //remet la selection à ses paramètres initiaux
        end;
      newstart := found + length(keywords[i].str); //définit la nouvelle plage

      found := Redit.FindText(keywords[i].str,newstart,size + downpos - newstart,[stMatchcase]);
      //cherche l'occurence suivante (si l'on dépasse la borne superieure (downpos+size) on a found = -1)
    end;
  end;
//tester toutes les lignes ne contenant pas de code pour les mettre en tant
//que commentaire. ---> a faire
end;

procedure Tform1.Editsetfont(id:integer);//Définit le coloris de la sélection
begin
with Redit.SelAttributes do
  case id of
    0:  begin //coloris normal
        style := [];
        color := clblack;
        end;
    1:  begin //coloris gras noir
        style := [fsbold];
        color := clblack;
        end;
    2:  begin //coloris gras bleu
        style := [fsbold];
        color := clblue;
        end;
    3:  begin //coloris vert italique
        style := [fsitalic];
        color := clgreen;
        end;
  end;
end;

///////////////
// Convertir //
///////////////
function Tform1.texttoshape: T3dshape;   //RICHEDIT -> SHAPE
var
s: T3dshape;
i,j,k,kbis,l:integer;
filled,ellipse: boolean;
currentline: string;
pointsadded: integer;

first,second:integer;
pointscoord: array[1..3] of string;
//
valtab: array[1..10] of real;
valcount:integer;
lastvalstart:integer;
optab: array[1..9] of char;
valstring: string;
//

inprgvarlst: integer;
hadnew : boolean;

inconst: boolean;
inpoints: boolean;
arevalidpoints: boolean;

PrgVars: Tprgvarlst;
MaxPrgVar: integer;
PrgVarknown : boolean;

Retcolor: Longint;
isreserved: boolean;

ForLoopStartLine: array[1..10] of integer;
Forcounterid: array[1..10] of integer;
ForLoopEndVal: array[1..10] of integer;
Forloopcnt: integer;

forstr : string;
forval1: string;
forval2: string;
begin
hadnew := false;
s.create; //crée une nouvelle shape : s, qui va servir de retour vide à la procedure en cas d'erreur
if (Redit.FindText('const',0,length(redit.Text),[stmatchcase])<>-1) and
(Redit.FindText('declare',0,length(redit.Text),[stmatchcase])=-1) then
  begin
  messagedlg('Erreur, mot clé <Declare> requis après <Const>',mterror,[mbOk],0);
  texttoshape := s;
  exit;
  end;
maxprgvar := Redit.FindText('const',0,length(redit.Text),[stmatchcase])+1;
if (Redit.FindText('const',maxprgvar,length(redit.Text)-maxprgvar,[stmatchcase])<>-1) then
  begin
  messagedlg('Erreur, mot clé <Const> dupliqué dans la déclaration',mterror,[mbOk],0);
  texttoshape := s;
  exit;
  end;

Forloopcnt := 0;
maxprgvar := 0;

errorlst.Clear;
if errorlst.Visible then
  begin
  errorlst.Visible := false;
  redit.Height := redit.Height + errorlst.Height;
  redit.Refresh;
  end;

inconst := false;
inpoints := false;
pointsadded := 1;
i := 1;
while i<Redit.Lines.Count do  //pour chaque ligne
//for i := 1 to Redit.Lines.Count-1 do //pour chaque ligne
  with Redit.Lines do
  begin
  currentline := strings[i];
  noblanks(currentline); //supprimme tous les espaces de la ligne courante
  if copy(strings[i],1,5) = 'const' then inconst := true; //declare des constantes
  if copy(strings[i],1,7) = 'declare' then inconst := false;

  ////////////// Variables ///////////////////

  if inconst and (pos('=',currentline)>0) then
    //declaration des variables - on les stoque dans Prgvars
    begin
    Prgvars[Maxprgvar+1].valtyp := 0;
    Prgvars[Maxprgvar+1].name := copy(currentline,1,pos('=',currentline)-1);
    Prgvarknown := false;
    for k := 1 to Maxprgvar do if Prgvars[Maxprgvar+1].name = Prgvars[k].name then prgvarknown := true;
    Prgvars[Maxprgvar+1].value := copy(currentline,pos('=',currentline)+1,length(currentline)-pos('=',currentline));
    if isinteger(Prgvars[Maxprgvar+1].value) then Prgvars[Maxprgvar+1].valtyp := 1; //type entier
    if iscolor(Prgvars[Maxprgvar+1].value) then Prgvars[Maxprgvar+1].valtyp := 2;   //type couleur
    if identtocolor(Prgvars[Maxprgvar+1].value,Retcolor) then Prgvars[Maxprgvar+1].valtyp := 2;   //type couleur 
    if Prgvars[Maxprgvar+1].valtyp = 0 then errorlst.Items.Add('Ligne '+inttostr(i+1)+' : variable de type inconnu')
      else inc(Maxprgvar); //si variable de type inconnu ajout d'une erreur à la liste
    if prgvarknown then
      begin
      dec(Maxprgvar);
      errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Identificateur dupliqué');
      end;
    if isinteger(Prgvars[Maxprgvar].name) or iscolor(Prgvars[Maxprgvar].name) then
      begin
      dec(Maxprgvar);
      errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Nom de variable non autorisé');
      end;
    isreserved := false;
    for k := 1 to Maxkeywords do if Prgvars[Maxprgvar].name = Keywords[k].str then isreserved := true;
    if isreserved then
      begin
      dec(Maxprgvar);
      errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Nom de variable réservé');
      end;
    end;

  if not inconst then
    begin
    //si l'on ne declare pas de variables
    inprgvarlst := 0;
    filled := false;
    ellipse := false;

  ////////////// Boucle For ///////////////////

  /////////END
    if copy(strings[i],1,3) = 'end' then //fin d'une boucle for
      begin
      if forloopcnt = 0 then errorlst.Items.Add('Ligne '+inttostr(i+1)+' : end ne termine ici aucune boucle') else
        begin
        if strtoint(prgvars[forcounterid[forloopcnt]].value)=forloopendval[forloopcnt] then
          begin
          //fin de la boucle
          //désalloue la variable de la mémoire
          for k := forcounterid[forloopcnt] to maxprgvar do prgvars[k] := prgvars[k+1];
          dec(maxprgvar);
          dec(forloopcnt);
          end
        else
          begin
          //dans la boucle : saute à l'étape commandée par le for
          i := forloopstartline[forloopcnt];
          currentline := strings[i];
          noblanks(currentline);
          //juste inc du compteur
          prgvars[forcounterid[forloopcnt]].value := inttostr(strtoint(prgvars[forcounterid[forloopcnt]].value)+1);
          //
          end;
        end;
      end;

  //////////FOR
    if copy(strings[i],1,3) = 'for' then //debut d'une boucle for
      begin
      if (pos('=',currentline)<=0) or (pos('to',currentline)<=0) then
        errorlst.Items.Add('Ligne '+inttostr(i+1)+' : paramètres manquants pour la boucle for')
      else
        begin
        forstr := copy(currentline,4,pos('=',currentline)-4);
        forval1 := copy(currentline,pos('=',currentline)+1,pos('to',currentline)-pos('=',currentline)-1);
        forval2 := copy(currentline,pos('to',currentline)+2,length(currentline)-pos('to',currentline)-1);

        //recherche de valeurs si forval1 et forval2 sont des calculs
        if not isinteger(forval1) then calc(forval1,prgvars,maxprgvar,i);
        if not isinteger(forval2) then calc(forval2,prgvars,maxprgvar,i);  //on essaie de calculer le tout

        if forval2<forval1 then
          errorlst.items.add('Ligne '+inttostr(i+1)+' : Les bornes doivent être rangée en ordre croissant') else
        if isinteger(forval1) and isinteger(forval2) then
          begin
          //si les valeurs sont entieres
          forloopendval[forloopcnt+1] := strtoint(forval2);
          //test si le nom de variable est acceptable
          Prgvarknown := false;
          for k := 1 to Maxprgvar do if forstr = Prgvars[k].name then prgvarknown := true;
          isreserved := false;
          for k := 1 to Maxkeywords do if forstr = Keywords[k].str then isreserved := true;
          if isinteger(forstr) or iscolor(forstr) then
            errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Nom de variable non autorisé');
          if isreserved then
            errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Nom de variable réservé');
          if prgvarknown then
            errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Identificateur dupliqué');
          if (not isreserved) and (not prgvarknown) and (not isinteger(forstr))
            and (not iscolor(forstr)) then
            begin
            //si tout est acceptable
            inc(forloopcnt);
            forloopstartline[forloopcnt] := i+1; //la boucle commence à la ligne d'après
            //on renseigne la variable en tant que déclarée par l'utilisateur
            inc(maxprgvar);
            Prgvars[maxprgvar].name := forstr;
            Prgvars[maxprgvar].value := forval1;
            Prgvars[maxprgvar].valtyp := 1; //entier
            forcounterid[forloopcnt] := maxprgvar;
            end;
          end
        else errorlst.items.Add('Ligne '+inttostr(i+1)+' : bornes de la boucle for non entieres');
        end;
      end;

  ////////////// New polygone ///////////////////

    if copy(Strings[i],1,3) = 'new' then //ajout d'un nouveau polygone
      begin
      hadnew := true;
      if (pos('ellipse',strings[i])>0) or (pos('/e',strings[i])>0) then ellipse := true;
      if (pos('filled',strings[i])>0 ) or (pos('/f',strings[i])>0) then filled := true;
      if pointsadded<>0 then
        begin
        pointsadded := 0;
        s.newpoly(clblack,clblack,ellipse,filled);
        inpoints := false; //on sort de la declaration des points du polygone précédant
        end
      else
        errorlst.Items.Add('Ligne '+inttostr(i+1)+' : définition d''un polygone sans points');
      end;

  ////////////// Points ///////////////////

    if copy(Strings[i],1,6) = 'points' then
      begin
      inpoints := true;
      end;
    if inpoints then
      begin
      //declaration des points

      if (currentline <> '')  and ('points'<>currentline) and (pos(',',currentline)>0) then
        begin
        //extraction
        if not hadnew then
          begin
          messagedlg('Impossible de déclarer des points sans polygone refférant. <new> absent',mterror,[mbok],0);
          texttoshape := s;
          exit;
          end;
        first := pos(',',currentline);
        second := pos(',',copy(currentline,first+1,length(currentline)-first)) + first;
        pointscoord[1] := copy(currentline,1,first-1);
        pointscoord[2] := copy(currentline,first+1,second-first-1);
        pointscoord[3] := copy(currentline,second+1,length(currentline)-second);
        //Calcul du resultat des opérations dans la declaration des points

        arevalidpoints := true;
        for j := 1 to 3 do if not isinteger(pointscoord[j]) then
          begin
          //si le texte n'est pas directement un entier, l'éditer pour qu'il en soit un
          if not calc(pointscoord[j],prgvars,maxprgvar,i) then
            arevalidpoints := false;
          end;
          //fin de la boucle qui passe pour chaque coordonnée (en j) dans la boucle en i de lignes

        if arevalidpoints then
          begin
          s.addpoint(p3d(strtofloat(pointscoord[1]),strtofloat(pointscoord[2]),strtofloat(pointscoord[3])));
          inc(pointsadded);
          end
          else errorlst.Items.add('Ligne '+inttostr(i+1)+' : Erreur dans la définition des points '+currentline);
        end;

      end
    else
      begin

  ////////////// Couleurs : In ///////////////////

      //Ligne pour définir la couleur interieure
      if copy(Strings[i],1,2) = 'in' then
        begin
        if not hadnew then
          begin
          messagedlg('Impossible de déclarer une couleur [in] sans polygone refférant. <new> absent',mterror,[mbok],0);
          texttoshape := s;
          exit;
          end;
        if iscolor(copy(currentline,3,9)) then
          s.Polylist[s.nb].incol := stringtocolor(copy(currentline,3,9))
        else
          begin
          //dans le cas ou ce qui suit le in n'est pas directement $02ffffff
          for j := 1 to Maxprgvar do if copy(currentline,3,9)=prgvars[j].name then inprgvarlst := j;
          if inprgvarlst<>0 then
            begin
            //si variable
            if prgvars[inprgvarlst].valtyp = 2 then s.Polylist[s.nb].incol := stringtocolor(prgvars[inprgvarlst].value)
              else errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Type variable incompatible');
            end
          else
            begin
            if identtocolor(copy(currentline,3,9),RetColor) then s.Polylist[s.nb].incol := retcolor else
            errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Couleur [in] indéfinie'); //ni variable ni $color ni cst delphi
            end;
          end;
        end;

  ////////////// Couleurs : Out ///////////////////

      //Ligne qui définit la couleur exterieure
      if copy(Strings[i],1,3) = 'out' then
        begin
        if not hadnew then
          begin
          messagedlg('Impossible de déclarer une couleur [out] sans polygone refférant. <new> absent',mterror,[mbok],0);
          texttoshape := s;
          exit;
          end;
        if iscolor(copy(currentline,4,9)) then
          s.Polylist[s.nb].incol := stringtocolor(copy(currentline,4,9))
        else
          begin
          //dans le cas ou ce qui suit le in n'est pas directement $02ffffff
          for j := 1 to Maxprgvar do if copy(currentline,4,9)=prgvars[j].name then inprgvarlst := j;
          if inprgvarlst<>0 then
            begin
            //si variable
            if prgvars[inprgvarlst].valtyp = 2 then s.Polylist[s.nb].outcol := stringtocolor(prgvars[inprgvarlst].value)
              else errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Type variable incompatible');
            end
          else
            begin
            if identtocolor(copy(currentline,4,9),RetColor) then s.Polylist[s.nb].outcol := retcolor else
            errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Couleur [out] indéfinie'); //ni variable ni $color no cst delphi
            end;
          end;
        end;
      end;

    end;
  inc(i);
  end;
if (pointsadded = 0) or ((pointsadded = 1) and (s.nb = 0)) then
  begin
  s.create;
  errorlst.Items.add('Erreur définition d''un polygone sans points');
  end
else
s.finalize;

if errorlst.Items.Count <> 0 then
  begin
  redit.Height := redit.Height - errorlst.Height;
  errorlst.Visible := true;
  redit.Refresh;
  timererror.Enabled := true;
  end;
texttoshape := s;
end;

procedure Tform1.openshapefile(filename: string);
var
i,j:integer;
s:string;
begin
/////////////////////Ouvrir SHAPE
shape.loadfromfile(filename);
Redit.Lines.Add('#shape');
Redit.Lines.Add('');
Redit.Lines.Add('const');
Redit.Lines.Add('');
Redit.Lines.Add('declare');
with shape do begin
  for i:=1 to nb do
    begin
    Redit.Lines.Add('');
    with polylist[i] do begin
      s:='new';
      if isellipse then s := s + ' /e';
      if filled then s := s+' /f';
      Redit.lines.add(s);
      Redit.Lines.Add('out '+colortostring(outcol));
      Redit.Lines.Add('in '+colortostring(incol));
      Redit.Lines.Add('points');
      for j := 1 to polylist[i].nbp do
        with Pointlist[j] do
        begin
        Redit.lines.add(inttostr(round(x))+','+inttostr(round(y))+','+inttostr(round(z)));
        end;
      end;
    end;
  end;
if colorationsyntaxique1.Checked then colorize(true);
end;

/////////////////////////////////
//// Traitement des chaines  ////
/////////////////////////////////
function Tform1.Calc(var s:string; Prgvars: Tprgvarlst; MaxPrgVar: integer; i: integer):boolean;
var
valtab: array[1..10] of real;
valcount:integer;
lastvalstart:integer;
optab: array[1..9] of char;
valstring: string;

isvalidintg: boolean;
inprgvarlst: integer;
k,kbis,l: integer;
begin
isvalidintg := true;
lastvalstart := 0;
valcount := 0;

          for k:=1 to length(s) do
            if (s[k]='*') or (s[k]='+') or (s[k]='-')
            or (s[k]='/') or (k=length(s))
            then
              begin
              kbis := k;
              if k<>length(s) then
              optab[valcount+1]:=s[k] //on met l'opération dans sa case
              else inc(kbis);
              valstring:=copy(s,lastvalstart+1,kbis-lastvalstart-1);//chaine juste avant l'opération (en k)
              if isinteger(valstring) then valtab[valcount+1] := strtoint(valstring)
                else
                begin
                //recherche d'un quelconque variable
                inprgvarlst := 0;
                for l := 1 to Maxprgvar do if valstring=prgvars[l].name then inprgvarlst := l;
                  if inprgvarlst<>0 then
                  begin
                  //si variable
                    if prgvars[inprgvarlst].valtyp = 1 then valtab[valcount+1] := strtoint(prgvars[inprgvarlst].value)
                    else
                      begin
                      errorlst.Items.Add('Ligne '+inttostr(i+1)+' : Type variable incompatible');
                      isvalidintg := false;
                      end;
                  end
                  else isvalidintg := false;
                end;
              inc(valcount);
              lastvalstart := k;
              end;
              //maintenant on a un tableau remplis


          //traitement des deux tableaux pour effectuer les opérations
          k := 1;
          while k<=valcount-1 do
            begin
            //multiplications et divisions
            if optab[k]='*' then
              begin
              valtab[k] := valtab[k]*valtab[k+1];
              for l := k+1 to valcount-1 do valtab[l] := valtab[l+1];
              for l := k to valcount-2 do optab[l] := optab[l+1];
              dec(valcount);
              end;
            if optab[k]='/' then
              begin
              valtab[k] := valtab[k]/valtab[k+1];
              for l := k+1 to valcount-1 do valtab[l] := valtab[l+1];
              for l := k to valcount-2 do optab[l] := optab[l+1];
              dec(valcount);
              end;
            if (optab[k]='+') or (optab[k]='-') then inc(k);
            end;
          k:=1;
          while k<=valcount-1 do
            begin
            //additions et soustractions
            if optab[k]='+' then
              begin
              valtab[k] := valtab[k]+valtab[k+1];
              for l := k+1 to valcount-1 do valtab[l] := valtab[l+1];
              for l := k to valcount-2 do optab[l] := optab[l+1];
              dec(valcount);
              end;
            if optab[k]='-' then
              begin
              valtab[k] := valtab[k]-valtab[k+1];
              for l := k+1 to valcount-1 do valtab[l] := valtab[l+1];
              for l := k to valcount-2 do optab[l] := optab[l+1];
              dec(valcount);
              end;
            //inc(k);
            end;
          if valcount<>1 then isvalidintg := false else s := floattostr(valtab[1]);
calc := isvalidintg;
end;

procedure noblanks(var s:string);    //supprimme tous les espaces de s
var
i:integer;
begin
i := pos(' ',s);
while i>0 do
  begin
  delete(s,i,1);
  i := pos(' ',s);
  end;
end;

function isinteger(s: string):boolean;  //retourne si s est entier ou non
var
i:integer;
begin
if s='' then begin isinteger := false; exit; end;
isinteger := true;
for i:=1 to length(s) do
if ((s[i]<>'0') and (s[i]<>'3') and (s[i]<>'6')
and (s[i]<>'1') and (s[i]<>'4') and (s[i]<>'7')
and (s[i]<>'2') and (s[i]<>'5') and (s[i]<>'8')
and (s[i]<>'9')) then isinteger := false;
end;

function iscolor(s: string):boolean;   //retourne si s est une couleur de la forme $02ffffff
var
i: integer;
begin
if s='' then begin iscolor := false; exit; end;
iscolor := true;
if length(s)<>9 then begin iscolor := false; exit; end;
if s[1] <> '$' then iscolor := false;
if s[2] <> '0' then iscolor := false;
s := uppercase(s);
if (s[2] <> '0') and (s[2] <> '1') and (s[2] <> '2') then iscolor := false;
for i:=3 to 9 do
  if (not isinteger(s[i])) and (s[i]<>'A') and (s[i]<>'B') and (s[i]<>'C')
  and (s[i]<>'D') and (s[i]<>'E') and (s[i]<>'F')  then iscolor := false;
end;

////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////

//////polygone //a voir

// objects -> texte


procedure Tform1.openpolyfile(filename: string);
var
i:integer;
s: string;
poly: T3dpoly;
begin
///////////////Ouvrir poly
poly.loadfromfile(filename);
Redit.Lines.Add('#poly');
Redit.Lines.Add('');
Redit.Lines.Add('const');
Redit.Lines.Add('');
Redit.Lines.Add('declare');
with poly do
      begin
      s:='new';
      if isellipse then s := s + ' /e';
      if filled then s := s+' /f';
      Redit.lines.add(s);
      Redit.Lines.Add('out '+colortostring(outcol));
      Redit.Lines.Add('in '+colortostring(incol));
      Redit.Lines.Add('points');
      for i := 1 to nbp do
        with Pointlist[i] do
        begin
        Redit.lines.add(inttostr(round(x))+','+inttostr(round(y))+','+inttostr(round(z)));
        end;
      end;
if colorationsyntaxique1.Checked then colorize(true);
end;
/////////////////////////////////////////////////////////////
////////////        Gestion de la fiche          ////////////
/////////////////////////////////////////////////////////////

procedure TForm1.FormCreate(Sender: TObject);
var
f: textfile;
s: string;
begin
Errorflashcount := 0;
Redit.Lines.Add('#shape');
Redit.Lines.Add('');
Redit.Lines.Add('const');
Redit.Lines.Add('');
Redit.Lines.Add('declare');
shapezoom := 1.5;
silentsave := false;
CurrentFile := 'Sans Titre';
form1.Caption := 'Editeur de modèles d3d - '+ CurrentFile;
dragpreview := false;
lastmx := 0;
lastmy := 0;
setparams(Preview.Canvas,clwhite,50,round(preview.Width/2),round(preview.Height/2),preview.width,preview.Height);
if (paramstr(1) <> '') then
  begin
  if not fileexists(paramstr(1)) then
    begin
    messagedlg('Fichier à charger introuvable',mterror,[mbok],0);
    exit;
    end;
    if uppercase(extractfileext(paramstr(1))) = '.D3S' then
      begin

  assignfile(f,paramstr(1));
  Redit.Clear;
  CurrentFile := paramstr(1);
  form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
  reset(f);
  while not eof(f) do
    begin
    readln(f,s);
    Redit.Lines.Add(s);
    end;
  closefile(f);

      end;
    if uppercase(extractfileext(paramstr(1))) = '.POLY' then
      begin
      Redit.Clear;
      CurrentFile := paramstr(1);
      form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(Currentfile);
      openpolyfile(paramstr(1))
      end;
    if uppercase(extractfileext(paramstr(1))) = '.SHAPE' then
      begin
      Redit.Clear;
      CurrentFile := paramstr(1);
      form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
      openshapefile(paramstr(1))
      end;
  end;
colorize(true);
redit.Modified := false;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
l,h:integer;
s:string;
begin
preview.Canvas.Font.Size := 20;
s := 'Previsualisation';
l := preview.Canvas.TextWidth(s);
h := preview.Canvas.TextHeight(s);
preview.Canvas.TextOut(round((400-l)/2),round((400-h)/2),s);
end;

////////////////////////////////////////// AFFICHAGE

procedure TForm1.PreviewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin dragpreview := false; end;

procedure TForm1.Rafrachir1Click(Sender: TObject);
var
i: integer;
ptcnt: integer;
begin
cls;
if (Redit.Lines.strings[0] = '#shape') or (Redit.Lines.strings[0] = '#poly') then
  begin
  shape := texttoshape;
  if Redit.Lines.Strings[0] = '#poly' then
    begin
    shape.nb := 1;
    shape.finalize;
    end;
  Status.Panels[0].Text := 'Nombre de Polygones : '+inttostr(shape.nb);
  ptcnt := 0;
  for i := 1 to shape.nb do ptcnt := ptcnt + shape.polylist[i].nbp;
  Status.Panels[1].Text := 'Nombre de Points : '+inttostr(ptcnt);
  shapezoom := 1.5;
  camera.create(0,0,-shapezoom*shape.radius);
  //on met le barycentre de la shape en 0,0,0
  shape.setxy(p3d(0,0,0));
  cameradir := shape.barycentre;
  shape.algopeintre;
  shape.draw;
  end
  else messagedlg('Le type d3d n''est pas corectement spécifié ligne 1',mterror,[mbok],0);
end;

////////Mouvements

procedure TForm1.PreviewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
dragpreview := true;
lastmx := x;
lastmy := y;
if button = mbright then toggle_zoom := true else toggle_zoom := false;
end;

procedure TForm1.PreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
v: t3dvertex;

begin
if not dragpreview then exit;
cls;
if (lastmx <> 0) and (lastmy <> 0) then
  begin
    if toggle_zoom then
    begin
    shapezoom := shapezoom + (y - lastmy)/200;
    if shapezoom <1.2 then shapezoom := 1.2;
    if shapezoom > 4 then shapezoom := 4;
    camera.create(0,0,-shapezoom*shape.radius);
    end
    else
    begin
    v.create(1,1,1);
    shape.rotation(shape.barycentre,Vectj,2*pi*-(lastmx-x)/400);
    shape.rotation(shape.barycentre,v3d(1,0,0),2*pi*(lastmy-y)/400);
    end;
    //cls;
    shape.algopeintre;
    shape.draw;
  end;
lastmx := x;
lastmy := y;
end;

///////////////////////////////// IO FICHIER /////////////////////////////////


procedure TForm1.Ouvrir1Click(Sender: TObject); // OUVRIR
var
f: textfile;
s: string[255];
ls: Tstringlist;
opendlg: Topendialog;
begin
if Redit.Modified then
if messagedlg('Voulez vous sauvegarder avant de Continuer?',mtinformation,[mbyes,mbno],0)=mryes
then enregistrer1click(self);
opendlg := Topendialog.Create(Form1);
opendlg.Title := 'Ouvrir un modèle source';
opendlg.InitialDir := '..\models\src';
opendlg.Filter := 'Fichier d3d source|*.d3s';

if opendlg.Execute then
  begin
  assignfile(f,opendlg.FileName);
  Redit.Clear;
  CurrentFile := opendlg.FileName;
  form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
  reset(f);
  ls := Tstringlist.Create;
  try
  while not eof(f) do
    begin
    readln(f,s);
    ls.Add(s);
    end;
  Redit.Lines.Assign(ls); //evite le defilement
  finally
  ls.Free;
  end;
  closefile(f);
  end;
opendlg.Free;
if colorationsyntaxique1.Checked then colorize(true);
Redit.Modified := false;
end;

procedure TForm1.Enregistrer1Click(Sender: TObject);  // SAUVEGARDER SOUS
var
f: textfile;
i: integer;
savedlg: Tsavedialog;
begin
Redit.Modified := false;
savedlg := Tsavedialog.Create(Form1);
savedlg.Title := 'Sauvegarder un modèle source';
savedlg.InitialDir := '..\models\src';
savedlg.Options := [ofOverwritePrompt,ofHideReadOnly,ofEnableSizing];
savedlg.Filter := 'Fichier d3d source|*.d3s';
if silentsave or savedlg.Execute then
  begin
  if silentsave then savedlg.FileName := currentfile;
  if not (extractfileext(savedlg.FileName) = '.d3s') then savedlg.FileName := savedlg.FileName+'.3ds';
  assignfile(f,savedlg.FileName);
  CurrentFile := savedlg.FileName;
  form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
  rewrite(f);
  for i:=0 to redit.lines.count-1 do writeln(f,redit.lines.strings[i]);
  closefile(f);
  end;
savedlg.Free;
end;

procedure TForm1.Enregistrer2Click(Sender: TObject);  //  SAUVEGARDER
begin
if Currentfile = 'Sans Titre' then begin Enregistrer1click(self); exit; end;
if not fileexists(Currentfile) then begin
messagedlg('Fichier spécifié introuvable',mtwarning,[mbok],0); Enregistrer1click(self); exit; end;
silentsave := true;
if uppercase(extractfileext(currentfile)) = '.D3S' then Enregistrer1click(self)
else
  begin
  messagedlg('Extension inconnue',mtwarning,[mbok],0);
  silentsave := false;
  Enregistrer1click(self);
  end;
silentsave := false;
end;

procedure TForm1.Nouveau1Click(Sender: TObject); //////////NOUVEAU
begin
if redit.Lines.Count = 0 then exit;
if messagedlg('Etes vous sur de vouloir commencer un nouveau modèle ?',
mtconfirmation,[mbyes,mbno],0) = mryes then redit.clear;
Redit.Lines.Add('#shape');
Redit.Lines.Add('');
Redit.Lines.Add('const');
Redit.Lines.Add('');
Redit.Lines.Add('declare');
if colorationsyntaxique1.Checked then colorize(true);
end;

procedure TForm1.Exporter1Click(Sender: TObject); // EXPORTER
var
savedlg: Tsavedialog;
begin
Redit.Modified := false;
savedlg := Tsavedialog.Create(Form1);
savedlg.Title := 'Exporter en tant que modèle d3d';
savedlg.Options := [ofOverwritePrompt,ofHideReadOnly,ofEnableSizing];
savedlg.InitialDir := '..\models';
  if Redit.Lines.Strings[0] = '#shape' then
    begin
    savedlg.filter := 'Modèle shape (.shape)|*.shape';
    if silentsave or savedlg.Execute then                
      begin
      if silentsave then savedlg.FileName := currentfile;
      CurrentFile := savedlg.FileName;
      if not (extractfileext(savedlg.FileName) = '.shape') then savedlg.FileName := savedlg.FileName + '.shape';
      form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
      texttoshape.savetofile(savedlg.FileName);
      end;
    end;
  if Redit.Lines.Strings[0] = '#poly' then
    begin
    savedlg.filter := 'Modèle polygone (.poly)|*.poly';
    if silentsave or savedlg.Execute then
      begin
      if silentsave then savedlg.FileName := currentfile;
      CurrentFile := savedlg.FileName;
      if not (extractfileext(savedlg.FileName) = '.poly') then savedlg.FileName := savedlg.FileName + '.poly';
      form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
      shape := texttoshape;
      shape.Polylist[1].savetofile(savedlg.FileName);
      end;
    end;
  if (Redit.Lines.Strings[0] <> '#poly') and (Redit.Lines.Strings[0] <> '#shape')
    then messagedlg('Erreur lors de la définition du type ligne 1',mtwarning,[mbok],1);
savedlg.Free;
end;

procedure TForm1.Importer1Click(Sender: TObject); //  IMPORTER
var
opendlg: Topendialog;
begin
if Redit.Modified then
if messagedlg('Voulez vous sauvegarder avant de Continuer?',mtinformation,[mbyes,mbno],0)=mryes
then enregistrer1click(self);
opendlg := Topendialog.Create(Form1);
opendlg.Title := 'Importer un modèle d3d';
opendlg.InitialDir := '..\models';
opendlg.Filter := 'Tous les modèles d3d|*.shape;*.poly|Modèle shape (.shape)|*.shape|Modèle polygone (.poly)|*.poly';
if opendlg.execute then
  begin
  Redit.Clear;
  CurrentFile := opendlg.FileName;
  form1.Caption := 'Editeur de modèles d3d - '+ extractfilename(CurrentFile);
  if uppercase(extractfileext(opendlg.FileName)) = '.SHAPE' then openshapefile(opendlg.FileName);
  if uppercase(extractfileext(opendlg.FileName)) = '.POLY' then openpolyfile(opendlg.FileName);
  end;
opendlg.Free;
Redit.Modified := false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Redit.Modified then
if messagedlg('Voulez vous sauvegarder avant de Continuer?',mtinformation,[mbyes,mbno],0)=mryes
then enregistrer1click(self);
Redit.Modified := false;
end;
////////////////////////////////////////////////////////////////////////////

//////////////////////CUT COPY PASTE
procedure TForm1.couper1Click(Sender: TObject);
begin redit.CutToClipboard; end;
procedure TForm1.Copier1Click(Sender: TObject);
begin redit.CopyToClipboard; end;
procedure TForm1.Coller1Click(Sender: TObject);
begin redit.PasteFromClipboard; end;
procedure TForm1.Couper2Click(Sender: TObject);
begin redit.CutToClipboard; end;
procedure TForm1.Copier2Click(Sender: TObject);
begin redit.CopyToClipboard; end;
procedure TForm1.Coller2Click(Sender: TObject);
begin redit.PasteFromClipboard; end;
/////////////////////////////////////////
procedure TForm1.Aide2Click(Sender: TObject);
begin form2.show; end;
procedure TForm1.Fermer1Click(Sender: TObject);
begin close; end;
procedure TForm1.Vider1Click(Sender: TObject);
begin errorlst.Clear; end;
procedure TForm1.Cacher1Click(Sender: TObject);
begin
errorlst.Visible := false;
redit.Height := redit.Height + errorlst.Height;
redit.Refresh;
end;

///////////conception ajouter couleur
procedure TForm1.Couleur1Click(Sender: TObject);
var
coldlg: Tcolordialog;
clip: Tclipboard;
begin
coldlg := Tcolordialog.Create(form1);
try
if coldlg.Execute then
  begin
  clip := Tclipboard.Create;
  clip.SetTextBuf(pchar(colortostring(coldlg.Color)));
  redit.PasteFromClipboard;
  end;
finally
coldlg.Free;
end;
end;

procedure TForm1.TimerErrorTimer(Sender: TObject);
begin
//timer qui gere le joli effet de dégradé d'alpha lors d'une erreur
if Errorflashcount=0 then
  begin
  Errorflashcount:=52;
  Errorlst.Color := $000000ff;
  errorlst.Repaint;
  end;
if Errorflashcount=1 then
  begin
  Errorflashcount := 0;
  errorlst.Color := clwindow;
  Timererror.Enabled := false;
  end;
if Errorflashcount>1 then
  begin
  Errorlst.Color := Errorlst.Color + $00050500;
  dec(errorflashcount);
  end;

end;

procedure TForm1.ReditChange(Sender: TObject);
begin
colorize(false);
end;

procedure TForm1.Colorationsyntaxique1Click(Sender: TObject);
begin
colorationsyntaxique1.Checked := not colorationsyntaxique1.Checked;
end;

end.
