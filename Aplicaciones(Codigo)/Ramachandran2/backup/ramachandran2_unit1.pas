unit Ramachandran2_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, biotools,
  strutils, menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    OpenDialog1: TOpenDialog;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  Form1: TForm1;
  datos: TtablaDatos;
  p: TPDB;

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

procedure TForm1.Button2Click(Sender: TObject);
var
  linea, relleno, fondo: TColor;
  j,k: integer;

begin
  linea:= Shape2.Brush.Color;        //Selección de línea, relleno y fondo gracias a las shape
  relleno:= Shape3.Brush.Color;
  fondo:= Shape1.Brush.Color;
  memo2.clear;
  for j:=1 to p.NumSubunidades do
  begin
    setlength(datos, 2, p.sub[j].resN-p.sub[j].res1 -1);  //2 filas y lo otro columnas
    memo2.visible:=False;                                 //Se hace invisible no refresca
    for k:= p.sub[j].res1+1 to p.sub[j].resn-1 do
    begin
       datos[0, k - p.sub[j].res1-1]:= p.res[k].phi;     //calculo de los ángulos phi y psi
       datos[1, k - p.sub[j].res1-1]:= p.res[k].psi;
       memo2.lines.add(padright(p.res[k].ID3 + inttostr(p.res[k].NumRes) + p.res[k].subunidad, 10)
                       + padleft(formatfloat('0.00', p.res[k].phi + 180/pi), 10)
                       + padleft(formatfloat('0.00', p.res[k].psi + 180/pi), 10));

    end;
    memo2.Visible:=True;
    plotXY(datos, Image1.Canvas, 0, 1, false, false, linea, relleno, fondo);


  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.clear;
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then shape1.brush.color:= colorDialog1.color;
end;

procedure TForm1.Shape2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then shape2.brush.color:= colorDialog1.color;
end;

procedure TForm1.Shape3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if ColorDialog1.Execute then shape3.brush.color:= colorDialog1.color;
end;
















end.

