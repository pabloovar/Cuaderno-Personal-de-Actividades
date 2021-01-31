unit AlinearZ_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p: TPDB;
  CAI, CAT: TPuntos;   //CAi iniciales, CAT transformados
  Ca1, CaN: integer;
  datos: TTablaDatos;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.Clear;
  image2.canvas.Clear;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  nomfi: string;
begin
  nomfi:= cargarPDB(p);
  if nomfi<>'' then        //correcciones para que se ve la ruta si no se slecciona ninguna proteína
  begin
  edit1.text:= nomfi;
  memo1.lines.LoadFromFile(edit1.text);
  SpinEdit1.maxvalue:= p.NumResiduos;
  SpinEdit2.maxvalue:= p.NumResiduos;
  SpinEdit1.minvalue:= 1;
  SpinEdit2.minvalue:= 1;
  Ca1:= 1; CaN:= p.NumResiduos;
  end else
  begin
    edit1.text:= '';
    memo1.clear
  end;
  end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
begin
  Ca1:= SpinEdit1.Value;
  CaN:= SpinEdit2.Value;
  if Ca1>CaN then
  begin
    j:= Ca1; Ca1:= CaN; CaN:= j;
  end;
  setlength(CAI, CaN-Ca1+1); //dimensionamos CAI que es el número total de C alfa
  setlength(datos, 2, CaN-Ca1+1);

  for j:=Ca1 to CaN do CAI[j-Ca1]:=p.atm[p.res[j].CA].coor;     //el número del Ca va a coincidir con el del residuo
                                                                // obtenemos las coordenadas del átomo Ca del residuo donde está  y cogemos su coordenada
  //con el j-Ca1 dimensionamos ya que si seleccionamos del 40 al 50 el rango es 10, y cuando vaya a hacer el do Ca empezaría en 0, pero si ponemos
 //j sólo CAI[40] no existe, por lo que al restarle Ca1 lo dimensionamos (40-40=0, 41-40=1...) así se van rellenando las posiciones

 for j:= 0 to high(CAI) do
  begin
    datos[0,j]:= CAI[j].X;   //primera fila
    datos[1,j]:= CAI[j].Y;   //segunda fila
                             //z está alineado
  end;

  plotXY(datos, image1.canvas, 0, 1, true, true);    //sin transformar

  CAT:= alinear_ejeZ(CAI);

 for j:=0 to high(CAI) do
  begin
    datos[0,j]:= CAT[j].X;   //primera fila
    datos[1,j]:= CAT[j].Y;
  end;

  plotXY(datos, image2.canvas, 0, 1, true, true, clgreen,clgreen,clblack,3,40,true);       //plot transformado
end;



end.

