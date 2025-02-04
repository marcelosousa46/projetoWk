unit PedidoRepository;

interface

uses
  IPedidosRepository, PedidosDadosGeraisDTO, PedidosProdutosDTO, System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.DApt, System.SysUtils, FireDAC.Stan.Param,
  PedidoCompletoDTO, Data.DB;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    FConnection: TFDConnection;
    FTransaction: TFDTransaction;
    function BuscarItensDoPedido(NumeroPedido: Integer): TObjectList<TPedidosProdutosDTO>;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    function InserirPedido(Pedido: TPedidosDadosGeraisDTO): Integer;
    function InserirItemPedido(Produto: TPedidosProdutosDTO): Boolean;
    function UltimoCodigoPedido: Integer;
    function BuscarPedidoCompletoPorNumero(NumeroPedido: Integer): TPedidoCompletoDTO;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
    function BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
    function BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
    procedure Commit;
    procedure Rollback;
    procedure StartTransaction;
  end;

implementation

constructor TPedidoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;

  // Configura a transação
  FTransaction := TFDTransaction.Create(nil);
  FTransaction.Connection := FConnection;
  FConnection.Transaction := FTransaction;
end;

destructor TPedidoRepository.Destroy;
begin
  FTransaction.Free;
  inherited;
end;

function TPedidoRepository.BuscarItensDoPedido(NumeroPedido: Integer): TObjectList<TPedidosProdutosDTO>;
var
  Query: TFDQuery;
  ListaItens: TObjectList<TPedidosProdutosDTO>;
  Produto: TPedidosProdutosDTO;
begin
  ListaItens := TObjectList<TPedidosProdutosDTO>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'SELECT produto_codigo, quantidade, valor_unitario, valor_total ' +
      'FROM pedidos_produtos WHERE numero_pedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.Open;
    while not Query.Eof do
    begin
      Produto := TPedidosProdutosDTO.Create;
      Produto.NumeroPedido := NumeroPedido;
      Produto.ProdutoCodigo := Query.FieldByName('produto_codigo').AsInteger;
      Produto.Quantidade := Query.FieldByName('quantidade').AsInteger;
      Produto.ValorUnitario := Query.FieldByName('valor_unitario').AsCurrency;
      Produto.ValorTotal := Query.FieldByName('valor_total').AsCurrency;
      ListaItens.Add(Produto);
      Query.Next;
    end;
    Result := ListaItens;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.BuscarPedidoCompletoPorNumero(NumeroPedido: Integer): TPedidoCompletoDTO;
var
  Query: TFDQuery;
  Produto: TPedidosProdutosDTO;
begin
  Result := TPedidoCompletoDTO.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    Query.SQL.Text :=
      'SELECT ' +
      '  p.numero_pedido, ' +
      '  p.data_emissao,  ' +
      '  p.cliente_codigo, ' +
      '  p.valor_total AS valor_total_pedido, ' +
      '  c.nome AS cliente_nome, ' +
      '  i.produto_codigo, ' +
      '  pr.descricao AS descricao_produto, ' +
      '  i.quantidade, ' +
      '  i.valor_unitario, ' +
      '  i.valor_total AS valor_total_item ' +
      'FROM pedidos_dados_gerais p  ' +
      'INNER JOIN clientes c ON p.cliente_codigo = c.codigo ' +
      'INNER JOIN pedidos_produtos i ON p.numero_pedido = i.numero_pedido ' +
      'INNER JOIN produtos pr ON i.produto_codigo = pr.codigo  ' +
      'WHERE p.numero_pedido =  :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Result.Pedido.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
      Result.Pedido.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
      Result.Pedido.ClienteCodigo := Query.FieldByName('cliente_codigo').AsInteger;
      Result.Cliente.Codigo := Query.FieldByName('cliente_codigo').AsInteger;
      Result.Cliente.Nome := Query.FieldByName('cliente_nome').AsString;
      Result.Produto.Descricao := Query.FieldByName('descricao_produto').AsString;
    end
    else
    begin
      FreeAndNil(Result);
      Exit;
    end;

    Query.SQL.Text :=
      'SELECT produto_codigo, quantidade, valor_unitario, valor_total ' +
      'FROM pedidos_produtos WHERE numero_pedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.Open;

    while not Query.Eof do
    begin
      Produto := TPedidosProdutosDTO.Create;
      Produto.NumeroPedido  := NumeroPedido;
      Produto.ProdutoCodigo := Query.FieldByName('produto_codigo').AsInteger;
      Produto.Quantidade    := Query.FieldByName('quantidade').AsInteger;
      Produto.ValorUnitario := Query.FieldByName('valor_unitario').AsCurrency;
      Produto.ValorTotal    := Query.FieldByName('valor_total').AsCurrency;

      Result.PedidoProdutos.Add(Produto);
      Query.Next;
    end;

  finally
    if Assigned(Produto) then
      Produto.Free;
    Query.Free;
  end;
end;

function TPedidoRepository.BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
var
  Query: TFDQuery;
  Lista: TObjectList<TPedidoCompletoDTO>;
  PedidoCompleto: TPedidoCompletoDTO;
begin
  Lista := TObjectList<TPedidoCompletoDTO>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'SELECT p.numero_pedido, ' +
      '       p.data_emissao, ' +
      '       p.cliente_codigo, ' +
      '       p.valor_total AS valor_total_pedido, ' +
      '       c.nome AS cliente_nome ' +
      'FROM pedidos_dados_gerais p ' +
      'INNER JOIN clientes c ON p.cliente_codigo = c.codigo ' +
      'WHERE c.nome LIKE :nome_cliente';
    Query.ParamByName('nome_cliente').AsString := '%' + NomeCliente + '%';
    Query.Open;
    while not Query.Eof do
    begin
      PedidoCompleto := TPedidoCompletoDTO.Create;
      PedidoCompleto.Pedido.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
      PedidoCompleto.Pedido.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
      PedidoCompleto.Pedido.ClienteCodigo := Query.FieldByName('cliente_codigo').AsInteger;
      PedidoCompleto.Pedido.ValorTotal := Query.FieldByName('valor_total_pedido').AsCurrency;
      PedidoCompleto.Cliente.Codigo := Query.FieldByName('cliente_codigo').AsInteger;
      PedidoCompleto.Cliente.Nome := Query.FieldByName('cliente_nome').AsString;

      PedidoCompleto.PedidoProdutos := BuscarItensDoPedido(PedidoCompleto.Pedido.NumeroPedido);

      Lista.Add(PedidoCompleto);
      Query.Next;
    end;
    Result := Lista;
  finally
    Query.Free;
    Lista.Free;
  end;
end;

function TPedidoRepository.BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
var
  Query: TFDQuery;
  Lista: TObjectList<TPedidoCompletoDTO>;
  PedidoCompleto: TPedidoCompletoDTO;
begin
  Lista := TObjectList<TPedidoCompletoDTO>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'SELECT p.numero_pedido, ' +
      '       p.data_emissao, ' +
      '       p.cliente_codigo, ' +
      '       p.valor_total AS valor_total_pedido, ' +
      '       c.nome AS cliente_nome ' +
      'FROM pedidos_dados_gerais p ' +
      'INNER JOIN clientes c ON p.cliente_codigo = c.codigo';
    Query.Open;
    while not Query.Eof do
    begin
      PedidoCompleto := TPedidoCompletoDTO.Create;
      PedidoCompleto.Pedido.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
      PedidoCompleto.Pedido.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
      PedidoCompleto.Pedido.ClienteCodigo := Query.FieldByName('cliente_codigo').AsInteger;
      PedidoCompleto.Pedido.ValorTotal := Query.FieldByName('valor_total_pedido').AsCurrency;
      PedidoCompleto.Cliente.Codigo := Query.FieldByName('cliente_codigo').AsInteger;
      PedidoCompleto.Cliente.Nome := Query.FieldByName('cliente_nome').AsString;

      PedidoCompleto.PedidoProdutos := BuscarItensDoPedido(PedidoCompleto.Pedido.NumeroPedido);

      Lista.Add(PedidoCompleto);
      Query.Next;
    end;
    Result := Lista;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.CancelarPedido(NumeroPedido: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    Query.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.ExecSQL;

    Query.SQL.Text := 'DELETE FROM pedidos_dados_gerais WHERE numero_pedido = :numero_pedido';
    Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
    Query.ExecSQL;

    Result := True;
  finally
    Query.Free;
  end;
end;

procedure TPedidoRepository.Commit;
begin
  if FConnection.InTransaction then
    FConnection.Commit;
end;

procedure TPedidoRepository.Rollback;
begin
  if FConnection.InTransaction then
    FConnection.Rollback;
end;

procedure TPedidoRepository.StartTransaction;
begin
  if not FConnection.InTransaction then
      FConnection.StartTransaction;
end;

function TPedidoRepository.UltimoCodigoPedido: Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS NovoNumeroPedido';
    Query.Open;
    if not Query.IsEmpty then
      Result := Query.FieldByName('NovoNumeroPedido').AsInteger;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.InserirPedido(Pedido: TPedidosDadosGeraisDTO): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'INSERT INTO pedidos_dados_gerais (data_emissao, cliente_codigo, valor_total) ' +
      'VALUES (:data_emissao, :cliente_codigo, :valor_total)';

    Query.ParamByName('data_emissao').AsDateTime := Pedido.DataEmissao;
    Query.ParamByName('cliente_codigo').AsInteger := Pedido.ClienteCodigo;
    Query.ParamByName('valor_total').AsCurrency := Pedido.ValorTotal;

    Query.ExecSQL;

    // Captura o ID do pedido recém-inserido
    Result := UltimoCodigoPedido;
  finally
    Query.Free;
  end;
end;

function TPedidoRepository.InserirItemPedido(Produto: TPedidosProdutosDTO): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'INSERT INTO pedidos_produtos (numero_pedido, produto_codigo, quantidade, valor_unitario, valor_total) ' +
      'VALUES (:numero_pedido, :produto_codigo, :quantidade, :valor_unitario, :valor_total)';

    Query.ParamByName('numero_pedido').AsInteger := Produto.NumeroPedido;
    Query.ParamByName('produto_codigo').AsInteger := Produto.ProdutoCodigo;
    Query.ParamByName('quantidade').AsInteger := Produto.Quantidade;
    Query.ParamByName('valor_unitario').AsCurrency := Produto.ValorUnitario;
    Query.ParamByName('valor_total').AsCurrency := Produto.ValorTotal;

    Query.ExecSQL;
    Result := True;
  finally
    Query.Free;
  end;
end;

end.

