unit Estereodiagrama_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;
  p: TPDB;
  datos: TTablaDatos;
implementation

{$R *.lfm}

{ TForm1 }

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
    memo1.clear
  end;
end;
procedure TForm1.Button2Click(Sender: TObject);    //selección de todos los carbonos alfa
var
  j: integer;
begin
  giroOY(0.087, p); //0.087 radianes on 5 grados
  memo2.clear;
  memo2.visible:= false;
  for j:= 1 to p.NumFichas do
  begin
    memo2.Lines.Add(writePDB(p.atm[j]));
  end;
  memo2.Visible:= true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if SaveDialog1.execute then
  memo2.lines.SaveToFile(SaveDialog1.FileName);
end;



{procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
  a: integer;
begin
  for j:= 0 to p.NumResiduos do
  begin
    if p.res[j].ID3= 'PHE' then
    begin
      a:=j;
      break
      end;
  end;
  setlength(datos,2, 11); //dimensionamos al número de átomos de una fenialanina


  for j:= p.res[a].Atm1 to p.res[a].AtmN do
   begin
     p.atm[j].coor:=  giroOY(0.087
     datos[1,j]:=  p.atm[j].coor.Y;
   end;    }



 // plotXY(datos, image1.canvas, 0, 1, true, true);    //sin transformar

  {CAT:= alinear_ejeZ(CAI);

 for j:=0 to high(CAI) do
  begin
    datos[0,j]:= CAT[j].X;   //primera fila
    datos[1,j]:= CAT[j].Y;
  end;

  plotXY(datos, image2.canvas, 0, 1, true, true, clgreen,clgreen,clblack,3,40,true);       //plot transformado
end;   }



end.

