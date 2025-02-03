unit PedidoCompletoDTO;

interface

uses
  PedidosDadosGeraisDTO, ClientesDTO, PedidosProdutosDTO, System.Generics.Collections,
  ProdutosDTO;

type
  TPedidoCompletoDTO = class
  public
    Pedido: TPedidosDadosGeraisDTO;
    Cliente: TClientesDTO;
    Produto: TProdutosDTO;
    PedidoProdutos: TObjectList<TPedidosProdutosDTO>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TPedidoCompletoDTO.Create;
begin
  Pedido := TPedidosDadosGeraisDTO.Create;
  Cliente := TClientesDTO.Create;
  Produto := TProdutosDTO.Create;
  PedidoProdutos := TObjectList<TPedidosProdutosDTO>.Create;
end;

destructor TPedidoCompletoDTO.Destroy;
begin
  Pedido.Free;
  Cliente.Free;
  Produto.Free;
  PedidoProdutos.Free;
  inherited;
end;

end.

