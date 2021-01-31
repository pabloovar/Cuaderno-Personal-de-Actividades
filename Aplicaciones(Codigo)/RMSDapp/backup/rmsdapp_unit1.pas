unit RMSDapp_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, biotools;

type
  Ttabla = array[1..6] of array[1..6] of real;



  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);


  private

  public

  end;

var
  Form1: TForm1;
  p: TPDB;
  cys1, cys2, cys3: integer;


implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  nomfi: string;
begin
  nomfi:= cargarPDB(p);
  if nomfi<>'' then        //correcciones para que se ve la ruta si no se slecciona ninguna proteína
  begin
  edit1.text:= nomfi;
  memo1.lines.LoadFromFile(edit1.text);

  end else
  begin
    edit1.text:= '';
    memo1.clear;
    memo2.clear;
  end;
end;
//Una vez tenemos cargada la proteína debemos encontrar las tres primeras cisteínas de la misma
//para ello recorremos la proteína hasta que tengamos las tres. Una vez las tengamos calculamos las distancias relativas entre sus átomos

procedure TForm1.Button2Click(Sender: TObject);
var
  i,j: integer;

begin
   i:= 1;
    cys1:= 0;
    cys2:= 0;
    cys3:= 0;
   //el siguiente bucle permite obtener el número de residuos de las tres primeras cisteínas
   //Cuando se obtiene la primera se busca la segunda, que debe de ser distinta de la primera. Se pasa a la
   //tercera, que debe ser distinta a las anteriores dos. Una vez se tienen las tres se termina el bucle
   while i<=3 do
    begin
    for j:= 0 to p.NumResiduos do
    begin
      if (i=1) and (p.res[j].ID3 = 'CYS') then
      begin
      cys1:= p.res[j].NumRes;
      i:=i+1;
      continue
      end;
      if (i=2) and (p.res[j].ID3 = 'CYS') and (p.res[j].NumRes<>cys1) then
      begin
      cys2:= p.res[j].NumRes;
      i:=i+1;
      continue
      end;
      if (i=3) and (p.res[j].ID3 = 'CYS') and (p.res[j].NumRes<>cys1) and (p.res[j].NumRes<>cys2) then
      begin
      cys3:= p.res[j].NumRes;
      i:= i+1;
      continue
      end;
    end;

   end;

   if (cys1<>0) and (cys1<>0) and (cys1<>0) then
   begin
  memo2.lines.add('Primeras tres cisteínas se corresponden con los siguientes residuos');
  memo2.lines.add('');

  memo2.lines.add('CYS1: ' + inttostr(cys1));
  memo2.lines.add('CYS2: ' + inttostr(cys2));
  memo2.lines.add('CYS3: ' + inttostr(cys3));
    end else memo2.lines.add('NO SE ENCONTRARON TRES CISTEÍNAS EN SU PROTEÍNA');

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  k, h, g, f: integer;
  tabla1, tabla2, tabla3: TTabla;

  m, n, i: integer;
  suma: real;
  RMSD_12, RMSD_13, RMSD_23:real;
begin

  f:= 1;
         //primer bucle
  for k:= p.res[cys1].atm1 to p.res[cys1].AtmN do
   begin
     g:= 1; //reinicio del contador del segundo
     for h:= p.res[cys1].atm1 to p.res[cys1].AtmN do
      begin
      tabla1[f,g] := distancia(p.atm[k].coor, p.atm[h].coor);
       g:= g+1;
      end;
     f:= f+1;
   end;

   f:=1;
   for k:= p.res[cys2].atm1 to p.res[cys2].AtmN do
   begin
      g:=1;    //segundo bucle
     for h:= p.res[cys2].atm1 to p.res[cys2].AtmN do
     begin
      tabla2[f,g] := distancia(p.atm[k].coor, p.atm[h].coor);
      g:=g+1;
      end;
      f:= f+1;
   end;

   f:=1;
  for k:= p.res[cys3].atm1 to p.res[cys3].AtmN do
   begin
     g:=1;
     for h:= p.res[cys3].atm1 to p.res[cys3].AtmN do
      begin
       tabla3[f,g] := distancia(p.atm[k].coor, p.atm[h].coor);
       g:=g+1;
      end;
      f:= f+1;
      end;



  //CALCULO DE RMSD
  suma:= 0;
  //RMSD 1-2
  for m:=1 to 6 do
   for n:=1 to 6 do
     begin
        suma:= suma + sqr(tabla1[m,n]-tabla2[m, n]);
     end;
   RMSD_12:=sqrt(suma)/6;

    suma:= 0;
  //RMSD 1-3
  for m:=1 to 6 do
   for n:=1 to 6 do
     begin
        suma:= suma + sqr(tabla1[m,n]-tabla3[m, n])
     end;
   RMSD_13:=sqrt(suma)/6;

   suma:= 0;
  //RMSD 2-3
  for m:=1 to 6 do
   for n:=1 to 6 do
     begin
        suma:= suma + sqr(tabla2[m,n]-tabla3[m, n])
     end;
   RMSD_23:=sqrt(suma)/6;
   memo2.lines.add('');
   memo2.lines.add('----------RMSD entre las CYS----------');
   memo2.lines.add('');
   memo2.lines.add('RMSD entre CYS1 y CYS2:  ' + floattostr(RMSD_12));
   memo2.lines.add('RMSD entre CYS1 y CYS3:  ' + floattostr(RMSD_13));
   memo2.lines.add('RMSD entre CYS2 y CYS3:  ' + floattostr(RMSD_23));

end;



end.

