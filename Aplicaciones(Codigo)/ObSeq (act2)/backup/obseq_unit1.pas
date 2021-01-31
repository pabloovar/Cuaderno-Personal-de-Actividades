unit ObSeq_unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, biotools;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  tipo: String;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var

  texto: TStrings;
begin
  if Opendialog1.execute then
  begin
    memo1.clear;
    memo1.lines.loadfromfile(OpenDialog1.FileName);
    edit1.Caption:=OpenDialog1.FileName;
    texto:= memo1.lines;
    tipo:=DetectarTipo(memo1.lines);
    edit2.caption:=tipo;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Sec:String;
begin
  memo2.clear;
  memo2.lines.add(ObSecuencia(memo1.lines, tipo));
end;

end.

