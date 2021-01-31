unit perfiles_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, biotools, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p: TPDB;
  pdb: string; //nombre del fichero de la proteína
  numresini, numresfin, subini, subfin, resini, resfin: integer; //numero inicial y final para las opciones
  escalaH: string;
  h: Tescala;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  image1.canvas.clear;
  image2.canvas.clear;
  image3.canvas.clear;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  j: integer;
begin
  pdb:= CargarPDB(p);
  if pdb<>'' then
  begin
    edit1.text:= extractfilename(pdb);
    ComboBox1.Clear;
    ComboBox2.Clear;
    for j:= 1 to p.NumSubunidades do
    begin
      ComboBox1.Items.Add(p.subs[j]);
      ComboBox2.Items.Add(p.subs[j])
    end;
    //VALORES POR DEFECTO AL CARGAR LA PROTEINA
    ComboBox1.ItemIndex:= 0;                        //para que salga la subunidad en el combobox por defecto
    ComboBox2.ItemIndex:= p.NumSubunidades-1;       //Cuando el Index es 0 se refiere al primer elemento, por lo que si tenemos 3 subunidades, la llamamos por el numero 2
    //Limites de los SpinEdit
    numresini:= p.res[p.sub[1].res1].NumRes;   //se selecciona el primer residuo de la primera subunidad
    numresfin:= p.res[p.sub[p.NumSubunidades].resN].NumRes; //ultimo residuo de la ultima subunidad
    SpinEdit2.Value:= numresini;
    SpinEdit2.MaxValue:=p.res[p.sub[1].resN].NumRes; //ultimo residuo primera subunidad

    SpinEdit3.MaxValue:= numresfin;
    SpinEdit3.Value:= numresfin;


  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  datos: TTablaDatos;
  semiV, swap, j, k, ndatos: integer;
  suma: real;
begin
  if (pdb<>'') and (escalaH<>'') then
  begin
  subini:= combobox1.Itemindex + 1;
  subfin:= combobox2.ItemIndex + 1;
  numresini:= spinedit2.Value;
  numresfin:= spinedit3.Value;
  resini:= p.sub[subini].resindex[numresini];
  resfin:= p.sub[subfin].resindex[numresfin];
  setlength(datos, 2, resfin-resini+1);
  semiV:= SpinEdit1.Value;

  if resfin<resini then
  begin
  swap:= resfin;
  resfin:= resini;
  resini:= swap;
  end;

  for j:= resini to resfin do
  begin
    suma:= 0;  ndatos:= 0; //ndatos contador de semiV
    for k:= max(1, j-semiV) to min(j+semiV, p.NumResiduos) do    //rangos de las medias para los rangos
    begin
      suma:= suma + h[p.secuencia[k]];
      ndatos:= ndatos+1;
    end;
    datos[0, j-resini]:= j;  //aa por el que voy, puede ser que no se empiece por el residuo primero
    datos[1, j-resini]:= suma/ndatos
  end;
  plotXY(datos, image1.Canvas, 0, 1, true, true);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  escalaH:= CargarEscala(h);
  edit2.text:=extractFileName (escalaH);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  datos: TTablaDatos;
  semiV, swap, j, k, ndatos: integer;
  suma1,suma2: real;
  delta: real;
begin
  if (pdb<>'') and (escalaH<>'') then
  begin
  subini:= combobox1.Itemindex + 1;
  subfin:= combobox2.ItemIndex + 1;
  numresini:= spinedit2.Value;
  numresfin:= spinedit3.Value;
  resini:= p.sub[subini].resindex[numresini];
  resfin:= p.sub[subfin].resindex[numresfin];
  setlength(datos, 2, resfin-resini+1);
  semiV:= SpinEdit1.Value;
  delta:= SpinEdit4.Value;

  if resfin<resini then
  begin
  swap:= resfin;
  resfin:= resini;
  resini:= swap;
  end;

  for j:= resini to resfin do
  begin
    suma1:= 0; suma2:= 0;  ndatos:= 0; //ndatos contador de semiV
    for k:= max(1, j-semiV) to min(j+semiV, p.NumResiduos) do    //rangos de las medias para los rangos
    begin
      suma1:= suma1 + (h[p.secuencia[k]]*sin(delta*k)); //primera parte de la fórmula
      suma2:= suma2 + (h[p.secuencia[k]]*cos(delta*k));


    end;
    datos[0, j-resini]:= j;  //aa por el que voy, puede ser que no se empiece por el residuo primero
    datos[1, j-resini]:= sqrt((sqr(suma1)+sqr(suma2)));
  end;

  plotXY(datos,image2.Canvas,0,1,true, true);
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  datos: TTablaDatos;
  semiV, swap, j, k, ndatos: integer;
  suma1,suma2, suma,hmedia: real;
  delta: real;
begin
  if (pdb<>'') and (escalaH<>'') then
  begin
  subini:= combobox1.Itemindex + 1;
  subfin:= combobox2.ItemIndex + 1;
  numresini:= spinedit2.Value;
  numresfin:= spinedit3.Value;
  resini:= p.sub[subini].resindex[numresini];
  resfin:= p.sub[subfin].resindex[numresfin];
  setlength(datos, 2, resfin-resini+1);
  semiV:= SpinEdit1.Value;
  delta:= SpinEdit4.Value;

  if resfin<resini then
  begin
  swap:= resfin;
  resfin:= resini;
  resini:= swap;
  end;

 for j:= resini to resfin do
  begin
     suma:= 0;  ndatos:= 0; //ndatos contador de semiV
    for k:= max(1, j-semiV) to min(j+semiV, p.NumResiduos) do    //rangos de las medias para los rangos
    begin
      suma:= suma + h[p.secuencia[k]];
      ndatos:= ndatos+1;
    end;
    hmedia:= suma/ndatos;         //conseguimos tener un hmedia antes




    suma1:= 0; suma2:= 0;  //ndatos contador de semiV
    for k:= max(1, j-semiV) to min(j+semiV, p.NumResiduos) do    //rangos de las medias para los rangos
    begin
     //primera parte de la fórmula
      suma1:= suma1 +(h[p.secuencia[k]]-hmedia)*sin(delta*k);
      suma2:= suma2 +(h[p.secuencia[k]]-hmedia)*cos(delta*k);
    end;

    datos[0, j-resini]:= j;  //aa por el que voy, puede ser que no se empiece por el residuo primero
    datos[1, j-resini]:= sqrt((sqr(suma1)+sqr(suma2)));

  end;

  plotXY(datos,image3.Canvas,0,1,true, true);
  end;
end;

end.

