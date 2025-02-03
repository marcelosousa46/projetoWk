unit IProdutosRepository;

interface

uses
  System.Generics.Collections, ProdutosDTO;

type
  IProdutoRepository = interface
    ['{029018C2-4EE4-46B8-80DA-9D452AB19978}']
    function ObterTodos: TObjectList<TProdutosDTO>;
    function BuscarPorDescricao(const Nome: string): TObjectList<TProdutosDTO>;
    function BuscarPorCodigo(const Codigo: string): TProdutosDTO;
  end;

implementation

end.

