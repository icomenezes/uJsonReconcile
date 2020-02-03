unit uJSONReconcile;

interface

Uses Classes, Data.DB, uDWJSONObject;

const
  MAX_FILTER = 20;

Type
  TReplaceJson = record
    macro  : array[0..MAX_FILTER] of string;
    value  : array[0..MAX_FILTER] of string;
  end;

type
  TJsonModeType   = (jmtObject, jmtArray);

TJSONReconcile = class(TObject)
  private
    Value : Integer;

    function ArrayToObject(jArray : String): string;

  public
    f     : TReplaceJson;

    constructor Create();
    destructor Destroy; override;


    procedure AddPair(const Name: string; DataSet : TDataset;
                      ModeTypeJson: TJsonModeType = jmtArray); overload;

    procedure AddPair(const Name: string; JSON : String); overload;
    function ToJson(var JSONDefault: String): string;
end;


implementation

uses
  System.SysUtils, uDWConsts;

{ TReiterar }

procedure TJSONReconcile.AddPair(const Name: string; DataSet: TDataset;
                                 ModeTypeJson: TJsonModeType = jmtArray);
var vJSON    : TJSONValue;
begin
  f.macro[Value]:= Name;
  vJSON:= TJSONValue.Create;
  try
    vJSON.LoadFromDataset('', DataSet, False, jmPureJSON);
    if not (ModeTypeJson = jmtObject) then
      f.value[Value]:= vJSON.ToJSON
    else
      f.value[Value]:= ArrayToObject(vJSON.ToJSON);

  finally
    FreeAndNil(vJSON);
  end;
  Value:= Value + 1;
end;

procedure TJSONReconcile.AddPair(const Name: string; JSON: String);
var vJSON    : TJSONValue;
begin
  f.macro[Value]:= Name;
  try
    f.value[Value]:= JSON;
  finally
  end;
  Value:= Value + 1;
end;

function TJSONReconcile.ArrayToObject(jArray: String): string;
begin
  if jArray[1] = '[' then
    Delete(jArray, 1, 1);

  if jArray[Length(jArray)] = ']' then
    Delete(jArray, Length(jArray), 1);

  Result:= jArray;
end;

constructor TJSONReconcile.Create;
begin
  Value:= 0;
//
end;

destructor TJSONReconcile.Destroy;
begin
  value:= 0;
//
  inherited;
end;

function TJSONReconcile.ToJson(var JSONDefault: String): string;
var i : Integer;
    s : string;
begin
  Result:= '';
  for i:= 0 to MAX_FILTER do begin
    JSONDefault:= StringReplace(JSONDefault,
                                 f.macro[i],
                                 f.value[i],
                [rfReplaceAll,rfIgnoreCase]);
  end;
  Result:= JSONDefault;
end;

end.
