unit distancia_PDB_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p1, p2: TPDB;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.Button1Click(Sender: TObject);
begin
  if Opendialog1.execute then
  begin
    memo1.clear;
    memo1.lines.loadfromfile(OpenDialog1.FileName);
    edit1.text:= OpenDialog1.FileName;
    p1:=CargarPDB(memo1.lines)
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
  linea: string;
begin
  memo2.clear;
  memo2.visible:=false;
  for j:= 0 to memo1.lines.count -1 do
  begin
    linea:= memo1.lines[j];
    if copy(linea, 1, 6)='ATOM  ' then memo2.lines.add(linea);

  end;
  memo2.visible:=true;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  atom1,atom2:string;
  num1,num2: string;
  linea: string;
  j: integer;
  p1, p2: Tpunto;
  resultado:real;
  atom1OK,atom2OK: boolean;
begin
  atom1OK:=false;
  atom2OK:=false;
  num1:=inttostr(spinedit1.Value);
  num2:=inttostr(SpinEdit2.Value);
  for j:=0 to memo1.Lines.count-1 do
  begin
    linea:=memo1.lines[j];
    if (copy(linea,1,6)='ATOM  ') and (trim(copy(linea,7,5))=num1) then
       begin
         atom1:=linea;
         atom1OK:=true
       end;
    if (copy(linea,1,6)='ATOM  ') and (trim(copy(linea,7,5))=num2) then
       begin
         atom2:=linea;
         atom2OK:=true
       end;

  end;
  if atom1OK and atom2OK then
     begin

      p1.X:=strtofloat(trim(copy(atom1,31,8)));
      p1.Y:=strtofloat(trim(copy(atom1,39,8)));
      p1.Z:=strtofloat(trim(copy(atom1,47,8)));
      p2.X:=strtofloat(trim(copy(atom2,31,8)));
      p2.Y:=strtofloat(trim(copy(atom2,39,8)));
      p2.Z:=strtofloat(trim(copy(atom2,47,8)));

      resultado:=distancia(p1,p2);

     Label4.Caption:=floattostr(resultado);

     end else showmessage('Uno o más átomos no se encontraron');

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  atm1: integer;
begin
  atm1:=SpinEdit1.Value;

  memo2.clear;
  memo2.Lines.add('-------------------------------');
  memo2.Lines.add(' Datos del átomo: '+ inttostr(atm1));
  memo2.lines.add('-------------------------------');
  memo2.lines.add('');
  memo2.lines.add(' Número de serie:          '+ inttostr(p1.atm[atm1].NumAtom));
  memo2.lines.add(' Símbolo PDB:              '+ p1.atm[atm1].ID);
  memo2.lines.add(' Aminoácido:               '+ p1.atm[atm1].Residuo);
  memo2.lines.add(' Subunidad:                '+ p1.atm[atm1].Subunidad);
  memo2.lines.add(' Número de residuo:        '+ inttostr(p1.atm[atm1].NumRes));
  memo2.lines.add(' Coordenada X:             '+ floattostr(p1.atm[atm1].coor.X));
  memo2.lines.add(' Coordenada Y:             '+ floattostr(p1.atm[atm1].coor.Y));
  memo2.lines.add(' Coordenada Z:             '+ floattostr(p1.atm[atm1].coor.Z));
  memo2.lines.add(' Localización alternativa: '+ p1.atm[atm1].AltLoc);

end;

end.

