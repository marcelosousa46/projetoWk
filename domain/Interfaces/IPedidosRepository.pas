unit IPedidosRepository;

interface

uses
  System.SysUtils, PedidosDadosGeraisDTO, PedidosProdutosDTO, System.Generics.Collections,
  PedidoCompletoDTO;

type
  IPedidoRepository = interface
    ['{D7654321-89AB-CDEF-0123-456789ABCDEF}']
    function InserirPedido(Pedido: TPedidosDadosGeraisDTO): Integer;
    function InserirItemPedido(Produto: TPedidosProdutosDTO): Boolean;
    function BuscarPedidoCompletoPorNumero(NumeroPedido: Integer): TPedidoCompletoDTO;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
    function BuscarTodosPedidos: TObjectList<TPedidoCompletoDTO>;
    function BuscarPedidosPorNomeCliente(const NomeCliente: string): TObjectList<TPedidoCompletoDTO>;
    procedure Commit;
    procedure Rollback;
  end;

implementation

end.

