unit IClienteController;

interface

uses
  ClientesDTO, System.Generics.Collections;

type
  IClientesController = interface
    ['{D2BEBE4E-2FC6-4F6D-9B1A-3E7D14A2F673}']
    function BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
    function BuscarPorCodigo(const Codigo: string): TClientesDTO;
  end;

implementation

end.

