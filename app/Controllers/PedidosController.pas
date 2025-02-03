unit PedidosController;

interface

uses
  PedidosDadosGeraisDTO, PedidosProdutosDTO, IPedidosService, System.Generics.Collections;

type
  TPedidoController = class
  private
    FPedidoService: IPedidoService;
  public
    constructor Create(APedidoService: IPedidoService);
    function SalvarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TList<TPedidosProdutosDTO>): Boolean;
  end;

implementation

constructor TPedidoController.Create(APedidoService: IPedidoService);
begin
  FPedidoService := APedidoService;
end;

function TPedidoController.SalvarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TList<TPedidosProdutosDTO>): Boolean;
begin
  Result := FPedidoService.GravarPedido(Pedido, Produtos);
end;

end.

