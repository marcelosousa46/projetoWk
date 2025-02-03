unit IClienteRepository;

interface

uses
  System.Generics.Collections, ClientesDTO;

type
  IClientesRepository = interface
    ['{E10D7A7C-8F4D-4F61-A4C9-DC37E7349871}']
    function ObterTodos: TObjectList<TClientesDTO>;
    function BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
    function BuscarPorCodigo(const Codigo: string): TClientesDTO;
  end;

implementation

end.

