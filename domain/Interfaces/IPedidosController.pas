unit IPedidosController;

interface

uses
  PedidosDadosGeraisDTO, System.Generics.Collections, Datasnap.DBClient;

type
  IPedidoController = interface
    ['{D1B2C3D4-E5F6-4789-ABCD-1234567890EF}']
    function CriarPedido(Pedido: TPedidosDadosGeraisDTO; Produtos: TClientDataSet): Boolean;
  end;

implementation

end.

