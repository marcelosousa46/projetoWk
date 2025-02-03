unit ClienteRepository;

interface

uses
  IClienteRepository, ClientesDTO, System.Generics.Collections, FireDAC.Comp.Client, DBConnection,
  FireDAC.Stan.Param, Data.DB;

type
  TClienteRepository = class(TInterfacedObject, IClientesRepository)
  public
    function ObterTodos: TObjectList<TClientesDTO>;
    function BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
    function BuscarPorCodigo(const Codigo: string): TClientesDTO;
  end;

implementation

uses
  System.SysUtils;

{ TClienteRepository }

function TClienteRepository.ObterTodos: TObjectList<TClientesDTO>;
var
  Query: TFDQuery;
  Cliente: TClientesDTO;
begin
  Result := TObjectList<TClientesDTO>.Create;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes';
    Query.Open;

    while not Query.Eof do
    begin
      Cliente := TClientesDTO.Create;
      Cliente.Codigo := Query.FieldByName('codigo').AsInteger;
      Cliente.Nome := Query.FieldByName('nome').AsString;
      Cliente.Cidade := Query.FieldByName('cidade').AsString;
      Cliente.UF := Query.FieldByName('uf').AsString;

      Result.Add(Cliente);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteRepository.BuscarPorCodigo(const Codigo: string): TClientesDTO;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :Codigo';
    Query.ParamByName('Codigo').AsString := Codigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result := TClientesDTO.Create;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Nome := Query.FieldByName('nome').AsString;
      Result.Cidade := Query.FieldByName('cidade').AsString;
      Result.UF := Query.FieldByName('uf').AsString;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteRepository.BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
var
  Query: TFDQuery;
  Cliente: TClientesDTO;
begin
  Result := TObjectList<TClientesDTO>.Create;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE nome LIKE :Nome';
    Query.ParamByName('Nome').AsString := '%' + Nome + '%';
    Query.Open;

    while not Query.Eof do
    begin
      Cliente := TClientesDTO.Create;
      Cliente.Codigo := Query.FieldByName('codigo').AsInteger;
      Cliente.Nome := Query.FieldByName('nome').AsString;
      Cliente.Cidade := Query.FieldByName('cidade').AsString;
      Cliente.UF := Query.FieldByName('uf').AsString;

      Result.Add(Cliente);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.

