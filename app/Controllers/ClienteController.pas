unit ClienteController;

interface

uses
  IClienteController, IClienteRepository, ClientesDTO, System.Generics.Collections;

type
  TClienteController = class(TInterfacedObject, IClientesController)
  private
    FRepository: IClienteRepository.IClientesRepository;
  public
    constructor Create(ARepository: IClientesRepository);
    function BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
    function BuscarPorCodigo(const Codigo: string): TClientesDTO;
  end;

implementation

constructor TClienteController.Create(ARepository: IClientesRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TClienteController.BuscarPorCodigo(const Codigo: string): TClientesDTO;
begin
  Result := FRepository.BuscarPorCodigo(Codigo);
end;

function TClienteController.BuscarPorNome(const Nome: string): TObjectList<TClientesDTO>;
begin
  Result := FRepository.BuscarPorNome(Nome);
end;

end.

