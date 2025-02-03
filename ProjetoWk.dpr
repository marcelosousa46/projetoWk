program ProjetoWk;

uses
  Vcl.Forms,
  uPrincipal in 'presentation\Views\uPrincipal.pas' {fPrincipal},
  uPedidos in 'presentation\Views\uPedidos.pas' {fPedidos},
  ClientesDTO in 'app\DTOs\ClientesDTO.pas',
  PedidosDadosGeraisDTO in 'app\DTOs\PedidosDadosGeraisDTO.pas',
  ProdutosDTO in 'app\DTOs\ProdutosDTO.pas',
  PedidosProdutosDTO in 'app\DTOs\PedidosProdutosDTO.pas',
  DBConnection in 'infrastructure\Persistence\DBConnection.pas' {DM: TDataModule},
  ConfigReader in 'infrastructure\Config\ConfigReader.pas',
  IClienteRepository in 'domain\Interfaces\IClienteRepository.pas',
  ClienteRepository in 'infrastructure\Persistence\ClienteRepository.pas',
  ClienteController in 'app\Controllers\ClienteController.pas',
  FrmConsultaClientes in 'presentation\Views\FrmConsultaClientes.pas' {fConsultaClientes},
  IClienteController in 'domain\Interfaces\IClienteController.pas',
  IProdutosController in 'domain\Interfaces\IProdutosController.pas',
  ProdutoController in 'app\Controllers\ProdutoController.pas',
  IProdutosRepository in 'domain\Interfaces\IProdutosRepository.pas',
  ProdutosRepository in 'infrastructure\Persistence\ProdutosRepository.pas',
  FrmConsultaProdutos in 'presentation\Views\FrmConsultaProdutos.pas' {fConsultaProdutos},
  PedidosController in 'app\Controllers\PedidosController.pas',
  IPedidosController in 'domain\Interfaces\IPedidosController.pas',
  PedidoService in 'app\Services\PedidoService.pas',
  IPedidosService in 'domain\Interfaces\IPedidosService.pas',
  IPedidosRepository in 'domain\Interfaces\IPedidosRepository.pas',
  PedidoRepository in 'infrastructure\Persistence\PedidoRepository.pas',
  Utils in 'shared\Utils\Utils.pas',
  PedidoCompletoDTO in 'app\DTOs\PedidoCompletoDTO.pas',
  FrmConsultaPedidos in 'presentation\Views\FrmConsultaPedidos.pas' {fConsultaPedidos};

{$R *.res}

begin
 // ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
