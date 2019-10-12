unit Unit1sobirator;
  // помогатор по сборке кубика рубика 12,10,2019
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Image2: TImage;
    Button1: TButton;
    Button2: TButton;
    MainMenu1: TMainMenu;
    Here1: TMenuItem;
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Here1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Susanin(cm,sp: string): string; // пути решения
    procedure f55;
    procedure gonka;
  end;
type pd= packed array [0..5039,0..2186]of byte;
type TPlace=array[0..2]of integer;//координаты кубика (индекс)
type hik=record // описание одного кубика
        p: TPlace;
        m: integer;// индекс модели
        s: byte;// спин
        end;
type cb2= array[0..1,0..1,0..1]of hik; // main cube
type Quadrige=array[0..3]of TPlace;//четверка
type Quadrigez=array of Quadrige;//четверки базового слоя
type Quadrigez4=array[0..3] of Quadrige;//четверки базового слоя

type rayan=array[0..5]of tcolor;
const ManyQ: array[0..2]of Quadrigez4=( // группы четверок базовых слоев????????
    (((0, 0, 0),(0, 0, 1),(0, 1, 1),(0, 1, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0))),
    (((0, 0, 0),(1, 0, 0),(1, 0, 1),(0, 0, 1)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0))),
    (((0, 0, 0),(0, 1, 0),(1, 1, 0),(1, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0)),
    ((0, 0, 0),(0, 0, 0),(0, 0, 0),(0, 0, 0))));
const fact: array[0..12]of longword=(1,1,2, 6, 24, 120, 720, 5040, 40320, 362880,
3628800, 39916800, 479001600); // факториалы
var
  Form1: TForm1;
  bm,bim,rex: tbitmap;
  pp: pd; // база ходов

  c0b: cb2=  // обнуленный куб
    ((((p:(0,0,0);m:0;s:0),(p:(0,0,1);m:0;s:0)),
      ((p:(0,1,0);m:0;s:0),(p:(0,1,1);m:0;s:0))),
     (((p:(1,0,0);m:0;s:0),(p:(1,0,1);m:0;s:0)),
      ((p:(1,1,0);m:0;s:0),(p:(1,1,1);m:0;s:0))));

  abba: array [0..20]of tcolor;
  rain: rayan=(clred,clred or clgreen,clgreen,clblue,clsilver,clyellow);
  rain1,rain2,rain3: rayan;// цвета
  aj: array [0..20]of tpoint=(
(x:145;y: 129),
(x:166;y: 156),
(x:122;y: 160),
(x:209;y: 89),
(x:243;y: 76),
(x:223;y: 117),
(x:221;y: 187),
(x:250;y: 160),
(x:215;y: 227),
(x:123;y: 224),
(x:159;y: 224),
(x:137;y: 270),
(x:60;y: 175),
(x:75;y: 235),
(x:37;y: 167),
(x:90;y: 91),
(x:71;y: 128),
(x:47;y: 76),
(x:133;y: 64),
(x:105;y: 44),
(x:181;y: 42)
  );
only: boolean=true;

implementation

{$R *.dfm}
{$R FILEX3.RES}
//\/*{$R FILEX3.RES}*****************************************************************
procedure abbat; // сканироваание цветов с картинки
var i: integer;
begin
if only then
for i:=0 to 20 do
abba[i]:=form1.image2.canvas.pixels[aj[i].x, aj[i].y];
//only:=false;
end;

//\/********       комбинаторика           ***************************
//\/******************************************************************
function NumToPer(x: word): string;//   номер в перестановку
var i,j,k,n,d,m: word;
    dig: array [1..7] of boolean;
    s: string;
begin
inc(x);
s:='';// результат
n:=7;
for i:=1 to 7 do dig[i]:=true;
for i:=n downto 1 do
  begin
    m:=x mod fact[i-1]; //
    d:=x div fact[i-1]; //
    if m>0 then
      inc(d)
      else
      m:=m+fact[i-1];
    x:=m;
    k:=0;
    for j:=1 to 7 do
      begin
        if dig[j] then inc(k);
        if k=d then
          begin
            dig[j]:=false;
            s:=s+inttostr(j);
            break;
          end;
      end;
  end;
if length(s)<>7 then s:='0';
result:=s;
end;
// use:  showmessage(NumToPer(77))

function PerToNum(x: string): word; // перестановку в номер
var i,j,k,n: word;
    dig: array[1..7] of boolean;
    c: char;
begin
result:=0;
for c:='1' to '7' do if pos(c,x)=0 then exit; // защита от бредового х
for i:=1 to 7 do dig[i]:=true;
for i:=1 to length(x) do
  begin
    n:=strtoint(x[i]);
    k:=0;
    dig[n]:=false;
    for j:=1 to n do
      if dig[j] then inc(k);
    result:=result+k*fact[7-i];
  end;
end;
// use: i:=PerToNum('1263754');
function SpinToNum(x: string): word; // спин-строку в номер
begin
result:=
strtoint(x[7])+
3*(strtoint(x[6]))+
3*3*(strtoint(x[5]))+
3*3*3*(strtoint(x[4]))+
3*3*3*3*(strtoint(x[3]))+
3*3*3*3*3*(strtoint(x[2]))+
3*3*3*3*3*3*(strtoint(x[1]));
end;


function NumToSpin(x: word): string; //  номер в спин-строку
const s: string='012';
var i: integer;
begin
result:='';
for i:=0 to 6 do
  begin
    result:=s[1+x mod 3]+result;
    x:=x div 3;
  end;
end;

//******************************
//**************
///******************************

function Place(x,y,z: integer):TPlace;
begin
Result[0]:=x;
Result[1]:=y;
Result[2]:=z;
end;

function spinka_get(x: cb2): string; // спин в строку
begin
result:=
 inttostr(x[1,1,1].s)
+inttostr(x[0,1,1].s)
+inttostr(x[0,1,0].s)
+inttostr(x[1,1,0].s)
+inttostr(x[1,0,0].s)
+inttostr(x[1,0,1].s)
+inttostr(x[0,0,1].s);
end;


procedure spinka_set(y: string; out x: cb2 ); //спин-строка в куб
begin
x[1,1,1].s:=strtoint(y[1]);
x[0,1,1].s:=strtoint(y[2]);
x[0,1,0].s:=strtoint(y[3]);
x[1,1,0].s:=strtoint(y[4]);
x[1,0,0].s:=strtoint(y[5]);
x[1,0,1].s:=strtoint(y[6]);
x[0,0,1].s:=strtoint(y[7]);
end;

function comba_get(x: cb2): string;  // комба в строку
const s: string='5347621';

  function rap(y: hik): char;
  begin
  result:=s[y.p[0]+2*y.p[1]+4*y.p[2]];
  end;
begin
result:=
 rap(x[1,1,1])
+rap(x[0,1,1])
+rap(x[0,1,0])
+rap(x[1,1,0])
+rap(x[1,0,0])
+rap(x[1,0,1])
+rap(x[0,0,1]);
end;   // s:=comba_get(cktest);

procedure comba_set(y: string; out x: cb2);  // комба-строка в куб

  function fn(x: char): tplace;
  begin
    case x of    // string='5347621';
      '1': result:=place(1,1,1);
      '2': result:=place(0,1,1);
      '3': result:=place(0,1,0);
      '4': result:=place(1,1,0);
      '5': result:=place(1,0,0);
      '6': result:=place(1,0,1);
      '7': result:=place(0,0,1);
    end;
  end;
begin
x[0,0,0].p:=place(0,0,0);
x[1,1,1].p:=fn(y[1]);
x[0,1,1].p:=fn(y[2]);
x[0,1,0].p:=fn(y[3]);
x[1,1,0].p:=fn(y[4]);
x[1,0,0].p:=fn(y[5]);
x[1,0,1].p:=fn(y[6]);
x[0,0,1].p:=fn(y[7]);
end;


procedure cub_Move(out x: cb2; const a: integer; clok: boolean); // мув куба без моделей
var j: integer;
    g: Quadrige;
    tim: hik;
begin
g:=ManyQ[a][0];
for j:=0 to 3 do g[j,a]:=g[j,a]+1; //получаю индексы мест
for j:=0 to 3 do //4 места
  with x[g[j,0],g[j,1],g[j,2]] do  //
    s:=(6-a-s) mod 3;// меняю спин

if clok then
  begin // перетасовка кубов
    tim:=x[g[0][0]][g[0][1]][g[0][2]]; //0>1>2>3
    x[g[0][0]][g[0][1]][g[0][2]]:=x[g[3][0]][g[3][1]][g[3][2]];
    x[g[3][0]][g[3][1]][g[3][2]]:=x[g[2][0]][g[2][1]][g[2][2]];
    x[g[2][0]][g[2][1]][g[2][2]]:=x[g[1][0]][g[1][1]][g[1][2]];
    x[g[1][0]][g[1][1]][g[1][2]]:=tim;
  end
  else
  begin
    tim:=x[g[0][0]][g[0][1]][g[0][2]]; //0<1<2<3
    x[g[0][0]][g[0][1]][g[0][2]]:=x[g[1][0]][g[1][1]][g[1][2]];
    x[g[1][0]][g[1][1]][g[1][2]]:=x[g[2][0]][g[2][1]][g[2][2]];
    x[g[2][0]][g[2][1]][g[2][2]]:=x[g[3][0]][g[3][1]][g[3][2]];
    x[g[3][0]][g[3][1]][g[3][2]]:=tim;
  end;// с
end;

function tform1.Susanin(cm,sp: string): string; // пути решения
var prot0: string;
    i,j,k,n,m: integer;
    by2,by1: cb2; // несколько кубов тренировачных
    pe: tpoint;
    aa: array of tpoint;

  procedure proton(x: tpoint); // наука и жизнь
  const dir: array[boolean]of string=('+','-');
  const lay: array[0..2]of char=('Л','П','В');
  begin
  prot0:=prot0+lay[x.X]+dir[x.Y=1];
  end;

  procedure prc;
  var i,j: integer;
  begin
    for i:=0 to 2 do
      for j:=0 to 1 do
        begin
          by2:=by1;
          //cub_move(by2,i,j>0);
          cub_move(by2,i,j=0);
          n:=pp[PerToNum(comba_get(by2)),SpinToNum(spinka_get(by2))];
          if n<k then
            begin
              pe:=point(i,j);
              proton(pe);// ходы сборки запоминать
              inc(m);
              setlength(aa,m);
              aa[m-1]:=pe;
              k:=n;
              by1:=by2;
              exit;
            end;
        end;
  end;
begin
prot0:='';
setlength(aa,0); m:=0;
by1:=c0b;
k:=pp[PerToNum(cm),SpinToNum(sp)];
comba_set(cm,by1); spinka_set(sp,by1);
if k<>$11 then while k>0 do prc;
result:=prot0;
end;




procedure ppp; // таблица сложности ходов
var t: TResourceStream;
begin
t:=TResourceStream.CreateFromID(HInstance,  // считываю с ресурса
         103, rt_RCDATA);
t.Read(pp, sizeof(pp));
t.free;
end;


function goodspin(x: string): boolean;
const cc: array[boolean]of integer=(1,-1);
var i,j,k: integer;
begin
j:=15;
for i:=1 to 7 do
  case x[i] of
    '1': inc(j,cc[odd(i)]);
    '2': inc(j,cc[not odd(i)]);
  end;
result:=(j mod 3)=0;
end;





function dddo(rain: rayan): string; // строю спиинг из палитры и картинки
var i: integer; ddd: string;
begin
ddd:='3333333';
  if (abba[0]=rain[4])or(abba[0]=rain[5]) then ddd[1]:='2';
  if (abba[1]=rain[4])or(abba[1]=rain[5]) then ddd[1]:='1';
  if (abba[2]=rain[4])or(abba[2]=rain[5]) then ddd[1]:='0';

  if (abba[3]=rain[4])or(abba[3]=rain[5]) then ddd[2]:='2';
  if (abba[5]=rain[4])or(abba[5]=rain[5]) then ddd[2]:='1';
  if (abba[4]=rain[4])or(abba[4]=rain[5]) then ddd[2]:='0';

  if (abba[11]=rain[4])or(abba[11]=rain[5]) then ddd[4]:='2';
  if (abba[10]=rain[4])or(abba[10]=rain[5]) then ddd[4]:='1';
  if (abba[9]=rain[4])or(abba[9]=rain[5]) then ddd[4]:='0';

  if (abba[15]=rain[4])or(abba[15]=rain[5]) then ddd[6]:='2';
  if (abba[17]=rain[4])or(abba[17]=rain[5]) then ddd[6]:='1';
  if (abba[16]=rain[4])or(abba[16]=rain[5]) then ddd[6]:='0';

  if (abba[18]=rain[4])or(abba[18]=rain[5]) then ddd[7]:='2';
  if (abba[19]=rain[4])or(abba[19]=rain[5]) then ddd[7]:='1';
  if (abba[20]=rain[4])or(abba[20]=rain[5]) then ddd[7]:='0';

  if (abba[8]=rain[4])or(abba[8]=rain[5]) then ddd[3]:='2';
  if (abba[6]=rain[4])or(abba[6]=rain[5]) then ddd[3]:='1';
  if (abba[7]=rain[4])or(abba[7]=rain[5]) then ddd[3]:='0';
  if (abba[13]=rain[4])or(abba[13]=rain[5]) then ddd[5]:='2';
  if (abba[14]=rain[4])or(abba[14]=rain[5]) then ddd[5]:='1';
  if (abba[12]=rain[4])or(abba[12]=rain[5]) then ddd[5]:='0';
result:=ddd;
end;


procedure tform1.f55;
label met;
const uu: array[0..2]of integer=(14,10,6);
const nom: array[0..5]of string=('up','botom','right','antiright','left','antileft');
var i,j,k,n: integer; t: tcolor; f: boolean;
vax: array[0..5] of tcolor;
oed: array[0..5]of integer;
haab: array [0..20] of integer;
kiik: array [0..20] of integer;
watt: array[0..6]of set of byte;
lobo: byte;
pean1,pean2,pean3: array[0..6]of boolean;
sss,sss1,sss2,sss3,ddd,ddd1,ddd2,ddd3: string;
nax: array[1..3] of integer;
way: array[1..3] of string;
ss: array [1..3] of string;
dd: array [1..3] of string;// спинаж


  function badpos: boolean;
  begin
  result:=
  (pos('1',sss1)+pos('1',sss2)+pos('1',sss3)
  +pos('2',sss1)+pos('2',sss2)+pos('2',sss3)
  +pos('3',sss1)+pos('3',sss2)+pos('3',sss3)
  +pos('4',sss1)+pos('4',sss2)+pos('4',sss3)
  +pos('5',sss1)+pos('5',sss2)+pos('5',sss3)
  +pos('6',sss1)+pos('6',sss2)+pos('6',sss3)
  +pos('7',sss1)+pos('7',sss2)+pos('7',sss3))<>84;

  {showmessage(inttostr
    (pos('1',sss1)+pos('1',sss2)+pos('1',sss3)
  +pos('2',sss1)+pos('2',sss2)+pos('2',sss3)
  +pos('3',sss1)+pos('3',sss2)+pos('3',sss3)
  +pos('4',sss1)+pos('4',sss2)+pos('4',sss3)
  +pos('5',sss1)+pos('5',sss2)+pos('5',sss3)
  +pos('6',sss1)+pos('6',sss2)+pos('6',sss3)
  +pos('7',sss1)+pos('7',sss2)+pos('7',sss3))
  );   }
  end;
begin
abbat;// читаю цвета кубиков с картинки

vax[0]:=abba[0];
vax[1]:=abba[1];
vax[2]:=abba[2];
k:=3;
for i:=3 to 20 do
  begin
    t:=abba[i];
    f:=true;
    for j:=0 to k-1 do
       if vax[j]=t then f:=false; //n:=i;//
    if f then
      begin
        vax[k]:=t;
        inc(k);
      end;
  end;
//**********************

//**************
for i:=0 to 5 do oed[i]:=0;
for i:=0 to 5 do
  for j:=0 to 20 do
    if vax[i]=abba[j] then inc(oed[i]);//


//*******************************
for i:=0 to 20 do
  for j:=0 to 5 do
    if vax[j]=abba[i] then
      haab[i]:=j;
for i:=0 to 20 do
  kiik[i]:=oed[haab[i]];
for i:=0 to 6 do
  watt[i]:=[haab[i*3+0]]+[haab[i*3+1]]+[haab[i*3+2]];
//*******************************
for i:=0 to 6 do pean1[i]:=true;
for i:=0 to 6 do pean2[i]:=true;
for i:=0 to 6 do pean3[i]:=true;

sss1:='       ';
sss1:='*******'; sss2:='*******'; sss3:='*******';
//sss:='1234567';
for i:=0 to 6 do   //
  if (4=kiik[i*3+0])and(4=kiik[i*3+1])and(4=kiik[i*3+2]) then
    begin
      lobo:=i;
      pean1[i]:=false;
      pean2[i]:=false;
      pean3[i]:=false;
      sss1[i+1]:='1'; sss2[i+1]:='1'; sss3[i+1]:='1';
      {       }
      rain1[0]:=vax[haab[i*3+0]];
      rain1[2]:=vax[haab[i*3+1]];
      rain1[4]:=vax[haab[i*3+2]];

      rain2[0]:=vax[haab[i*3+1]];
      rain2[2]:=vax[haab[i*3+2]];
      rain2[4]:=vax[haab[i*3+0]];

      rain3[0]:=vax[haab[i*3+2]];
      rain3[2]:=vax[haab[i*3+0]];
      rain3[4]:=vax[haab[i*3+1]];
    end;
//    showmessage(format('%d',[i]));
for i:=0 to 6 do     // противоположный левому    heaven2:=i;
  begin
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+1]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='2';
      if kiik[i*3+0]=3 then rain1[5]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain1[5]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain1[5]:=vax[haab[i*3+2]];
    end;
  if (haab[3*lobo+1]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='2';
      if kiik[i*3+0]=3 then rain2[5]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain2[5]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain2[5]:=vax[haab[i*3+2]];
    end;
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='2';
      if kiik[i*3+0]=3 then rain3[5]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain3[5]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain3[5]:=vax[haab[i*3+2]];
    end;
  end;



for i:=0 to 6 do // противоположный верхнему     earl:=i;
  begin
  if (haab[3*lobo+1]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='4';
      if kiik[i*3+0]=3 then rain1[1]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain1[1]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain1[1]:=vax[haab[i*3+2]];{}
    end;
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='4';

      if kiik[i*3+0]=3 then rain2[1]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain2[1]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain2[1]:=vax[haab[i*3+2]];
    end;
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+1]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='4';

      if kiik[i*3+0]=3 then rain3[1]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain3[1]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain3[1]:=vax[haab[i*3+2]];
    end;
  end;


for i:=0 to 6 do  //  противоположный  правому   heaven1:=i;
  begin
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='6';
      if kiik[i*3+0]=3 then rain1[3]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain1[3]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain1[3]:=vax[haab[i*3+2]];
    end;
  if (haab[3*lobo+0]in watt[i])and(haab[3*lobo+1]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='6';

      if kiik[i*3+0]=3 then rain2[3]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain2[3]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain2[3]:=vax[haab[i*3+2]];
    end;
  if (haab[3*lobo+1]in watt[i])and(haab[3*lobo+2]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='6';
      if kiik[i*3+0]=3 then rain3[3]:=vax[haab[i*3+0]];
      if kiik[i*3+1]=3 then rain3[3]:=vax[haab[i*3+1]];
      if kiik[i*3+2]=3 then rain3[3]:=vax[haab[i*3+2]];
    end;
  end;


for i:=0 to 6 do // sunn:=i;
  begin
  if (haab[3*lobo+0]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='7';
    end;
  if (haab[3*lobo+1]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='7';
    end;
  if (haab[3*lobo+2]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='7';
    end;
  end;

for i:=0 to 6 do // africa:=i;
  begin
  if (haab[3*lobo+1]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='3';
    end;
  if (haab[3*lobo+2]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='3';
    end;
  if (haab[3*lobo+0]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='3';
    end;
  end;

for i:=0 to 6 do  // india:=i;
  begin
  if (haab[3*lobo+2]in watt[i])and(pean1[i]) then
    begin
      pean1[i]:=false;
      sss1[i+1]:='5';
    end;
  if (haab[3*lobo+0]in watt[i])and(pean2[i]) then
    begin
      pean2[i]:=false;
      sss2[i+1]:='5';
    end;
  if (haab[3*lobo+1]in watt[i])and(pean3[i]) then
    begin
      pean3[i]:=false;
      sss3[i+1]:='5';
    end;
  end;
//*****
with form1.Image2.Canvas do
begin
    for i:=0 to 5 do
        begin
          brush.Color:=rain1[i];
          fillrect(rect(506,i*40,539,i*40+30));
          brush.Style:=bsclear;
          //textout(507,i*40,nom[i]);
        end;
   { for i:=0 to 5 do
        begin
          brush.Color:=rain2[i];
          fillrect(rect(536,i*40,589,i*40+30));
          brush.Style:=bsclear;
          //textout(507,i*40,nom[i]);
        end;
    for i:=0 to 5 do
        begin
          brush.Color:=rain3[i];
          fillrect(rect(566,i*40,589,i*40+30));
          brush.Style:=bsclear;
          //textout(507,i*40,nom[i]);

        end;  }
end;
for i:=1 to 2 do way[i]:='';//

if badpos then goto met;

ddd1:=dddo(rain1); // строю спиинг из палитры и картинки
ddd2:=dddo(rain2); // строю спиинг из палитры и картинки
ddd3:=dddo(rain3); // строю спиинг из палитры и картинки
nax[1]:=pp[PerToNum(sss1),SpinToNum(ddd1)];
nax[2]:=pp[PerToNum(sss2),SpinToNum(ddd2)];
nax[3]:=pp[PerToNum(sss3),SpinToNum(ddd3)];
if nax[1]<>17 then way[1]:=susanin(sss1,ddd1);
if nax[2]<>17 then way[2]:=susanin(sss2,ddd2);
if nax[3]<>17 then way[3]:=susanin(sss3,ddd3);
ss[1]:=sss1; ss[2]:=sss2; ss[3]:=sss3;
dd[1]:=ddd1; dd[2]:=ddd2; dd[3]:=ddd3;
 {
showmessage(''
+format('%s  %s %d',[sss1,ddd1,nax[1]])+#13#10
+format('%s  %s %d',[sss2,ddd2,nax[2]])+#13#10
+format('%s  %s %d',[sss3,ddd3,nax[3]]));
}
met:
i:=1; for j:=2 to 3 do if nax[j]<nax[i] then i:=j;
form1.StatusBar1.Panels[0].Text:=ss[i];//
form1.StatusBar1.Panels[1].Text:=dd[i];//
form1.StatusBar1.Panels[2].Text:=inttostr(nax[i]);//
form1.StatusBar1.Panels[4].Text:=way[i];
//button2.onclick(self);      //
end;


procedure TForm1.FormCreate(Sender: TObject);
var i: integer; s: string;
begin
ppp;// таблица
for i:=0 to 4 do statusbar1.panels[i].width:=56;//85;
 statusbar1.panels[2].width:=25;
 statusbar1.panels[3].width:=1;
 statusbar1.panels[4].width:=300;
bm.LoadFromFile('fire8.bmp');
bm.Width:=290;
image2.Align:=alclient;
image2.picture.LoadFromFile('fire9.bmp');
form1.Color:=rgb(255,127,80);
abbat; // сосканировал цвета с картинки
button1.onclick(self);
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var jertva_color: tcolor;
begin
if x>400 then
  begin


    if image2.Canvas.Pixels[x,y]<>rgb(254,254,254) then
      begin
      if ssleft in shift then image2.canvas.brush.color:=image2.Canvas.Pixels[x,y];
      if ssright in shift then if colordialog1.execute then with image2.Canvas do
         begin
           brush.Color:=colordialog1.Color;
           floodfill(x,y, Pixels[x,y], fsSurface);
         end;
      end;
    exit;
  end;

jertva_color:=image2.Canvas.Pixels[x,y];// уничтожить цвет
if jertva_color=rgb(254,254,254) then exit;
if jertva_color=rgb(0,0,0) then exit;

with image2.canvas do begin
    floodfill(x,y, jertva_color, fsSurface);
end;
end;


procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
statusbar1.Panels[5].Text:=format('x: %d',[x]);
statusbar1.Panels[6].Text:=format('y: %d',[y]);
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
f55;
end;

procedure tform1.gonka;
var i: integer;
begin
form1.image2.Canvas.Draw(0,0,bm);
exit;
with form1.image2.Canvas do
  begin
    brush.color:=clwhite;  // краска
    for i:=0 to 20 do floodfill(aj[i].x,aj[i].y, clblack, fsBorder);
  end;
end;

procedure TForm1.Here1Click(Sender: TObject);
begin
showmessage(paramstr(0))
end;

procedure TForm1.Button2Click(Sender: TObject); // очищение организма
begin
form1.StatusBar1.Panels[0].Text:='';//
form1.StatusBar1.Panels[1].Text:='';//
form1.StatusBar1.Panels[2].Text:='';//
form1.StatusBar1.Panels[4].Text:='';//
gonka;
end;



initialization
bm:=tbitmap.Create();
finalization
bm.Free;

end.
