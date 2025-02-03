unit ProdutosRepository;

interface

uses
  IProdutosRepository, ProdutosDTO, System.Generics.Collections, FireDAC.Comp.Client, DBConnection,
  FireDAC.Stan.Param, Data.DB;

type
  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  public
    function ObterTodos: TObjectList<TProdutosDTO>;
    function BuscarPorDescricao(const Descricao: string): TObjectList<TProdutosDTO>;
    function BuscarPorCodigo(const Codigo: string): TProdutosDTO;
  end;

implementation

uses
  System.SysUtils;

{ TProdutoRepository }

function TProdutoRepository.ObterTodos: TObjectList<TProdutosDTO>;
var
  Query: TFDQuery;
  Produto: TProdutosDTO;
begin
  Result := TObjectList<TProdutosDTO>.Create;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos';
    Query.Open;

    while not Query.Eof do
    begin
      Produto := TProdutosDTO.Create;
      Produto.Codigo := Query.FieldByName('codigo').AsInteger;
      Produto.Descricao := Query.FieldByName('descricao').AsString;
      Produto.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;

      Result.Add(Produto);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepository.BuscarPorCodigo(const Codigo: string): TProdutosDTO;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :Codigo';
    Query.ParamByName('Codigo').AsString := Codigo;
    Query.Open;
    if not Query.IsEmpty then
    begin
      Result := TProdutosDTO.Create;
      Result.Codigo := Query.FieldByName('codigo').AsInteger;
      Result.Descricao := Query.FieldByName('descricao').AsString;
      Result.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepository.BuscarPorDescricao(const Descricao: string): TObjectList<TProdutosDTO>;
var
  Query: TFDQuery;
  Produto: TProdutosDTO;
begin
  Result := TObjectList<TProdutosDTO>.Create;
  Query := DM.CriarQuery;
  try
    Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE descricao LIKE :Descricao';
    Query.ParamByName('descricao').AsString := '%' + Descricao + '%';
    Query.Open;

    while not Query.Eof do
    begin
      Produto := TProdutosDTO.Create;
      Produto.Codigo := Query.FieldByName('codigo').AsInteger;
      Produto.Descricao := Query.FieldByName('descricao').AsString;
      Produto.PrecoVenda := Query.FieldByName('preco_venda').AsCurrency;

      Result.Add(Produto);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

end.

