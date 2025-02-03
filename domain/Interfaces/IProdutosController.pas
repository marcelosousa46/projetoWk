unit IProdutosController;

interface

uses
  ProdutosDTO, System.Generics.Collections;

type
  IProdutoController = interface
    ['{DD646CC9-E23C-44D4-A380-8A491E3A5B6C}']
    function BuscarPorDescricao(const Descricao: string): TObjectList<TProdutosDTO>;
    function BuscarPorCodigo(const Codigo: string): TProdutosDTO;
  end;

implementation

end.

