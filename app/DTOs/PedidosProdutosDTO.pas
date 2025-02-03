unit PedidosProdutosDTO;

interface

type
  TPedidosProdutosDTO = class
  private
    FID: Integer;
    FNumeroPedido: integer;
    FProdutoCodigo: Integer;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    FValorTotal: Currency;
  public
    property ID: Integer read FID write FID;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property ProdutoCodigo: Integer read FProdutoCodigo write FProdutoCodigo;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

implementation

end.

