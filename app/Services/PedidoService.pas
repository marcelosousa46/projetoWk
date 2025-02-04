unit PedidoService;

interface

uses
  IPedidosService, PedidosDadosGeraisDTO, PedidosProdutosDTO, System.Generics.Collections, IPedidosRepository,
  PedidoCompletoDTO, Data.DB;

type
  TPedidoService = class(TInterfacedObject, IPedidoService)
  private
    FRepository: IPedidoRepository;
  public
    constructor Create(ARepository: IPedidoRepository);
    function GravarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TList<TPedidosProdutosDTO>): Boolean;
    function BuscarPedidoCompleto(NumeroPedido: Integer): TPedidoCompletoDTO;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
    function BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
    function BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
  end;

implementation

function TPedidoService.BuscarPedidoCompleto(
  NumeroPedido: Integer): TPedidoCompletoDTO;
begin
  Result := FRepository.BuscarPedidoCompletoPorNumero(NumeroPedido);
end;

function TPedidoService.BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
begin
  Result := FRepository.BuscarPedidosPorNomeCliente(NomeCliente);
end;

function TPedidoService.BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
begin
 Result := FRepository.BuscarTodosPedidos;
end;

function TPedidoService.CancelarPedido(NumeroPedido: Integer): Boolean;
begin
  Result := False;
  try
    if FRepository.CancelarPedido(NumeroPedido) then
    begin
      FRepository.Commit;
      Result := True;
    end;
  except
    FRepository.Rollback;
    raise;
  end;
end;

constructor TPedidoService.Create(ARepository: IPedidoRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPedidoService.GravarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TList<TPedidosProdutosDTO>): Boolean;
var
numero_pedido: integer;
begin
  Result := False;
  FRepository.StartTransaction;
  try
    numero_pedido := FRepository.InserirPedido(Pedido);

    for var Produto in Produtos do
    begin
      Produto.NumeroPedido := numero_pedido;
      FRepository.InserirItemPedido(Produto);
    end;

    FRepository.Commit;
    Result := True;
  except
    FRepository.Rollback;
    raise;
  end;
end;

end.

