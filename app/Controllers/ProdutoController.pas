unit ProdutoController;

interface

uses
  IProdutosController, IProdutosRepository, ProdutosDTO, System.Generics.Collections;

type
  TProdutoController = class(TInterfacedObject, IProdutoController)
  private
    FRepository: IProdutoRepository;
  public
    constructor Create(ARepository: IProdutoRepository);
    function BuscarPorDescricao(const Descricao: string): TObjectList<TProdutosDTO>;
    function BuscarPorCodigo(const Codigo: string): TProdutosDTO;
  end;

implementation

constructor TProdutoController.Create(ARepository: IProdutoRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TProdutoController.BuscarPorCodigo(
  const Codigo: string): TProdutosDTO;
begin
  Result := FRepository.BuscarPorCodigo(Codigo);
end;

function TProdutoController.BuscarPorDescricao(const Descricao: string): TObjectList<TProdutosDTO>;
begin
  Result := FRepository.BuscarPorDescricao(Descricao);
end;

end.

