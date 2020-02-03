unit uTESTE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.ODBC,
  FireDAC.Phys.ODBCDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    FDConnection1: TFDConnection;
    btn_open: TButton;
    memo: TMemo;
    btn_openAll: TButton;
    procedure btn_openClick(Sender: TObject);
    procedure btn_openAllClick(Sender: TObject);

  private
    function OpenQuery(Id: Integer): String; overload;
    function OpenQuery(Arquivo: String; De, Ate: Integer): String; overload;
  end;

var
  Form3: TForm3;

implementation

uses
  uJSONReconcile;

{$R *.dfm}


procedure TForm3.btn_openClick(Sender: TObject);
begin
  OpenQuery(1);
end;

procedure TForm3.btn_openAllClick(Sender: TObject);
begin
  OpenQuery('Clientes', 1, 50);
end;


function TForm3.OpenQuery(Id: Integer): String;
var vQry : TFDQuery;
    vRec : TJSONReconcile;
    vJS  : TStringList;
    vJsSt: String;
begin
  vQry:= TFDQuery.Create(nil);
  vRec:= TJSONReconcile.Create;
  vJS := TStringList.Create;
  try
    vQry.Connection:= FDConnection1;

    vQry.Close;
    vQry.SQL.Add(Format('select nome NomeCompleto from cliente where id = %d', [Id]));
    vQry.Open;

    vRec.AddPair('%header', vQry, jmtObject);

    vQry.Close;
    vQry.SQL.Clear;
    vQry.SQL.Add(Format('select nome, parentesco from contatos where idCliente = %d',[Id]));
    vQry.Open;

    vRec.AddPair('%contatos', vQry);

    vQry.Close;
    vQry.SQL.Clear;
    vQry.SQL.Add(Format('select rua, numero from endereco where idCliente = %d', [Id]));
    vQry.Open;

    vRec.AddPair('%endereco', vQry, jmtObject);

    vJS.LoadFromFile('C:\Users\Ico\Desktop\json.json');

    vJsSt:= vJS.Text;
    result := vRec.ToJson(vJsSt);

    memo.Lines.Add(result);

  finally
    vQry.Free;
    vRec.Free;
    vJS.Free;
  end;

end;
function TForm3.OpenQuery(Arquivo: String; De, Ate: Integer): String;
const
  DatasetVazio = '{}';
var
  ID: Integer;
  Elemento: String;
begin

  result := '{"' + arquivo  + '": [';
  for ID := De to Ate do
  begin
    Elemento := OpenQuery(ID);
    if Elemento <> DatasetVazio then
    begin
      result := result + Elemento;

      if ID < Ate then
        result := result + ', ' ;
    end;

  end;
  result := Result  + ']';
end;

end.
