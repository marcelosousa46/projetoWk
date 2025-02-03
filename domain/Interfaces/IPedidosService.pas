unit IPedidosService;

interface

uses
  PedidosDadosGeraisDTO, PedidosProdutosDTO, System.Generics.Collections,
  PedidoCompletoDTO;


type
  IPedidoService = interface
    ['{D1234567-89AB-CDEF-0123-456789ABCDEF}']
    function GravarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TList<TPedidosProdutosDTO>): Boolean;
    function BuscarPedidoCompleto(NumeroPedido: Integer): TPedidoCompletoDTO;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
    function BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
    function BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
  end;

implementation

end.

