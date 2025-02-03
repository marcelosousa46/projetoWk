unit uPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons, System.UITypes,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, FrmConsultaClientes, ClienteRepository, IClienteRepository,
  ClienteController, Datasnap.DBClient, System.Classes, System.Generics.Collections,PedidosProdutosDTO,
  IPedidosService, ProdutoController,ProdutosRepository;

type
  TfPedidos = class(TForm)
    pnTop: TPanel;
    pnFooter: TPanel;
    pnAll: TPanel;
    DBGrid1: TDBGrid;
    edtCodigoCliente: TEdit;
    btPesquisaCliente: TSpeedButton;
    lbNomeCliente: TLabel;
    pnProdutos: TPanel;
    gbProdutos: TGroupBox;
    edtCodigoProduto: TEdit;
    edtPrecoVenda: TEdit;
    edtQuantidade: TEdit;
    lbCodigoProduto: TLabel;
    lbCodigoCliente: TLabel;
    btPesquisaProduto: TSpeedButton;
    lbCliente: TLabel;
    Label1: TLabel;
    lbDescricaoProduto: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    cdsItensPedido: TClientDataSet;
    dsItensPedido: TDataSource;
    cdsItensPedidoCodigoProduto: TIntegerField;
    cdsItensPedidoDescricaoProduto: TStringField;
    cdsItensPedidoQuantidade: TCurrencyField;
    cdsItensPedidoValorUnitario: TCurrencyField;
    cdsItensPedidoValorTotal: TCurrencyField;
    pnTotal: TPanel;
    Panel1: TPanel;
    btGravarPedido: TButton;
    btnConsultarPedidos: TButton;
    pnControlePedidos: TPanel;
    gbPedidos: TGroupBox;
    Label4: TLabel;
    edtNumeroPedido: TEdit;
    btnCancelarPedido: TButton;
    SpeedButton1: TSpeedButton;

    procedure btPesquisaClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure btPesquisaProdutoClick(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cdsItensPedidoCalcFields(DataSet: TDataSet);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btGravarPedidoClick(Sender: TObject);
    procedure btnConsultarPedidosClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtNumeroPedidoEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FLastExitWasCodigoCliente: Boolean;
    FPedidoService: IPedidoService;
    FConsultaCliente: Boolean;
    procedure PesquisarCliente;
    procedure PesquisarProduto;
    procedure PesquisarPedidos;
    procedure ConfirmarProdutos;
    procedure LimparCamposItens;
    procedure CalcularTotal;
    procedure GravarPedido;
    procedure CarregarPedido;
    procedure CancelarPedido;
    procedure CarregarProdutosNaGrid(PedidoProdutos: TObjectList<TPedidosProdutosDTO>);
  public
  end;

var
  fPedidos: TfPedidos;

implementation

{$R *.dfm}

uses DBConnection, ClientesDTO, IClienteController, FrmConsultaProdutos,
  IProdutosRepository, IProdutosController, ProdutosDTO, PedidosController, PedidosDadosGeraisDTO,
  PedidoService, PedidoRepository, Utils, FrmConsultaPedidos,
  PedidoCompletoDTO;

procedure TfPedidos.btGravarPedidoClick(Sender: TObject);
begin
  GravarPedido;
end;

procedure TfPedidos.btnCancelarPedidoClick(Sender: TObject);
begin
  CancelarPedido;
end;

procedure TfPedidos.btnConsultarPedidosClick(Sender: TObject);
begin
 CarregarPedido;
end;

procedure TfPedidos.btPesquisaClienteClick(Sender: TObject);
begin
  PesquisarCliente;
end;

procedure TfPedidos.btPesquisaProdutoClick(Sender: TObject);
begin
  PesquisarProduto;
end;

procedure TfPedidos.Button1Click(Sender: TObject);
begin
  ConfirmarProdutos;
end;

procedure TfPedidos.CalcularTotal;
var
  Total: Currency;
begin
  Total := 0;

  cdsItensPedido.DisableControls;
  try
    cdsItensPedido.First;
    while not cdsItensPedido.Eof do
    begin
      Total := Total + cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
      cdsItensPedido.Next;
    end;
  finally
    btGravarPedido.Enabled := (Total > 0) and (not FConsultaCliente);
    cdsItensPedido.EnableControls;
  end;

  pnTotal.Caption := FormatFloat('R$ ###,##0.00', Total);
end;

procedure TfPedidos.CancelarPedido;
var
  NumeroPedido: Integer;
  PedidoService: TPedidoService;
begin
  NumeroPedido := StrToIntDef(edtNumeroPedido.Text, 0);
  if NumeroPedido = 0 then
  begin
    ShowMessage('Informe um número de pedido válido.');
    edtNumeroPedido.SetFocus;
    Exit;
  end;
  if MessageDlg('Deseja realmente cancela o pedido?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    PedidoService := TPedidoService.Create(TPedidoRepository.Create(DM.FDConnection));
    try
      if PedidoService.CancelarPedido(NumeroPedido) then
      begin
        ShowMessage('Pedido cancelado com sucesso!');
        cdsItensPedido.EmptyDataSet;
        edtNumeroPedido.Clear;
      end
      else
        ShowMessage('Falha ao cancelar o pedido.');
    finally
      PedidoService.Free;

    end;
  end;
end;

procedure TfPedidos.CarregarPedido;
var
  PedidoCompleto: TPedidoCompletoDTO;
  PedidoService: TPedidoService;
begin
  if edtNumeroPedido.Text = EmptyStr then
  begin
    ShowMessage('Favor informar o numero do pedido!');
    edtNumeroPedido.SetFocus;
    exit;
  end;
  PedidoService := TPedidoService.Create(TPedidoRepository.Create(DM.FDConnection));
  try
    PedidoCompleto := PedidoService.BuscarPedidoCompleto(StrToIntDef(edtNumeroPedido.Text, 0));
    if Assigned(PedidoCompleto) then
    begin
      lbCliente.Visible := True;
      lbCliente.Caption := PedidoCompleto.Cliente.Nome;
      FConsultaCliente  := True;
      CarregarProdutosNaGrid(PedidoCompleto.PedidoProdutos);
    end
    else
      ShowMessage('Pedido não encontrado!');
  finally
    PedidoService.Free;
  end;
end;

procedure TfPedidos.CarregarProdutosNaGrid(PedidoProdutos: TObjectList<TPedidosProdutosDTO>);
var
  Produto: TPedidosProdutosDTO;
  ProdutoRepo: IProdutoRepository;
  ProdutoDTO: TProdutosDTO;
begin
  if not cdsItensPedido.Active then
    cdsItensPedido.Open;

  cdsItensPedido.EmptyDataSet;

  ProdutoRepo := TProdutoRepository.Create;

  for Produto in PedidoProdutos do
  begin
    ProdutoDTO := ProdutoRepo.BuscarPorCodigo(IntToStr(Produto.ProdutoCodigo));
    try
      cdsItensPedido.Append;
      cdsItensPedido.FieldByName('CodigoProduto').AsInteger := Produto.ProdutoCodigo;
      cdsItensPedido.FieldByName('Quantidade').AsCurrency := Produto.Quantidade;
      cdsItensPedido.FieldByName('ValorUnitario').AsCurrency := Produto.ValorUnitario;

      if Assigned(ProdutoDTO) then
        cdsItensPedido.FieldByName('DescricaoProduto').AsString := ProdutoDTO.descricao
      else
        cdsItensPedido.FieldByName('DescricaoProduto').AsString := '';
      cdsItensPedido.Post;
    finally
      ProdutoDTO.Free;
    end;
  end;

  cdsItensPedido.First;
  CalcularTotal;
end;

procedure TfPedidos.cdsItensPedidoCalcFields(DataSet: TDataSet);
var
  Quantidade, ValorUnitario: Currency;
begin
  Quantidade := DataSet.FieldByName('Quantidade').AsCurrency;
  ValorUnitario := DataSet.FieldByName('ValorUnitario').AsCurrency;
  DataSet.FieldByName('ValorTotal').AsCurrency := Quantidade * ValorUnitario;
end;

procedure TfPedidos.ConfirmarProdutos;
var
  CodigoProduto: Integer;
  Quantidade,
  PrecoVenda: Currency;
begin
  if not TryStrToInt(edtCodigoProduto.Text, CodigoProduto) then
  begin
    ShowMessage('Código do produto inválido! Insira um número inteiro.');
    edtCodigoProduto.SetFocus;
    exit;
  end;

  if not TryStrToCurr(edtQuantidade.Text, Quantidade) then
  begin
    ShowMessage('Quantidade do produto inválido! Insira um valor correto.');
    edtQuantidade.SetFocus;
    exit;
  end;

  if not TryStrToCurr(edtPrecoVenda.Text, PrecoVenda) then
  begin
    ShowMessage('Preço de venda do produto inválido! Insira um valor correto.');
    edtPrecoVenda.SetFocus;
    exit;
  end;

  if (not cdsItensPedido.Active)  then
    cdsItensPedido.Open;

  if not (cdsItensPedido.State in [dsEdit]) then
    cdsItensPedido.Append;

  cdsItensPedido.FieldByName('CodigoProduto').AsInteger   := CodigoProduto;
  cdsItensPedido.FieldByName('Quantidade').AsCurrency     := Quantidade;
  cdsItensPedido.FieldByName('ValorUnitario').AsCurrency  := PrecoVenda;
  cdsItensPedido.FieldByName('DescricaoProduto').AsString := lbDescricaoProduto.Caption;

  if cdsItensPedido.Active then
  begin
    if cdsItensPedido.State in [dsEdit, dsInsert] then
    begin
      cdsItensPedido.Post;
      edtCodigoProduto.Enabled := true;
      edtCodigoProduto.SetFocus;
      CalcularTotal;
      LimparCamposItens;
    end;
  end;

end;

procedure TfPedidos.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsItensPedido.IsEmpty then
    begin
      edtCodigoProduto.Text := cdsItensPedido.FieldByName('CodigoProduto').AsString;
      lbDescricaoProduto.Caption := cdsItensPedido.FieldByName('DescricaoProduto').AsString;
      edtQuantidade.Text := cdsItensPedido.FieldByName('Quantidade').AsString;
      edtPrecoVenda.Text := cdsItensPedido.FieldByName('ValorUnitario').AsString;
      cdsItensPedido.Edit;

      edtCodigoProduto.Enabled := false;
      edtPrecoVenda.SetFocus;
    end;
  end;

  if (Key = VK_DELETE) and (not cdsItensPedido.IsEmpty) then
  begin
    if MessageDlg('Deseja realmente excluir este item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      cdsItensPedido.Delete;
      CalcularTotal;
    end;
    Key := 0;
  end;
end;

procedure TfPedidos.edtCodigoClienteExit(Sender: TObject);
var
  FrmConsultaCliente: TfConsultaClientes;
  ClienteEncontrado: Boolean;
  Repo: IClientesRepository;
  Cliente: TClientesDTO;
  ClienteRepository: IClientesRepository;
  ClienteController: IClientesController;
begin
  FLastExitWasCodigoCliente := true;
  ClienteRepository := TClienteRepository.Create;
  ClienteController := TClienteController.Create(ClienteRepository);

  if Trim(edtCodigoCliente.Text) = '' then
  begin
    lbCliente.Caption := '';
    btnConsultarPedidos.Enabled := true;
    btnCancelarPedido.Enabled   := true;
    Exit;
  end;

  ClienteEncontrado := False;
  Repo := TClienteRepository.Create;
  Cliente := Repo.BuscarPorCodigo(edtCodigoCliente.Text);
  try
    if Assigned(Cliente) then
    begin
      lbCliente.Caption := Cliente.nome;
      lbCliente.Visible := True;
      ClienteEncontrado := True;
      FConsultaCliente  := false;
      cdsItensPedido.EmptyDataSet;
      edtNumeroPedido.Clear;
    end;
  finally
    Cliente.Free;
  end;

  if not ClienteEncontrado then
  begin
    FrmConsultaCliente := TfConsultaClientes.Create(Self, ClienteController);
    try
      if FrmConsultaCliente.ShowModal = mrOk then
      begin
        edtCodigoCliente.Text := FrmConsultaCliente.cdsClientes.FieldByName('codigo').AsString;
        lbCliente.Caption     := FrmConsultaCliente.cdsClientes.FieldByName('nome').AsString;
        lbCliente.Visible     := True;
        FConsultaCliente      := false;
        cdsItensPedido.EmptyDataSet;
        edtNumeroPedido.Clear;
      end;
    finally
      FrmConsultaCliente.Free;
    end;
  end;
  edtNumeroPedido.SetFocus;
  btnConsultarPedidos.Enabled := true;
  btnCancelarPedido.Enabled   := true;
  if lbCliente.Caption <> EmptyStr then
  begin
    btnConsultarPedidos.Enabled := false;
    btnCancelarPedido.Enabled   := false;
    gbProdutos.Enabled          := true;
    edtCodigoProduto.SetFocus;
  end;

end;

procedure TfPedidos.edtCodigoProdutoExit(Sender: TObject);
var
  FrmConsultaProduto: TfConsultaProdutos;
  ProdutoEncontrado: Boolean;
  Repo: IProdutoRepository;
  Produto: TProdutosDTO;
  ProdutoRepository: IProdutoRepository;
  ProdutoController: IProdutoController;
begin
  ProdutoRepository := TProdutoRepository.Create;
  ProdutoController := TProdutoController.Create(ProdutoRepository);

  if Trim(edtCodigoProduto.Text) = '' then Exit;

  ProdutoEncontrado := False;
  Repo := TProdutoRepository.Create;
  Produto := Repo.BuscarPorCodigo(edtCodigoProduto.Text);
  try
    if Assigned(Produto) then
    begin
      lbDescricaoProduto.Caption := Produto.descricao;
      edtPrecoVenda.Text := FormatFloat('0.00', Produto.PrecoVenda);
      lbDescricaoProduto.Visible := True;
      ProdutoEncontrado := True;
      end;
  finally
    Produto.Free;
  end;

  if not ProdutoEncontrado then
  begin
    FrmConsultaProduto := TfConsultaProdutos.Create(Self, ProdutoController);
    try
      if FrmConsultaProduto.ShowModal = mrOk then
      begin
        edtCodigoProduto.Text      := FrmConsultaProduto.cdsProdutos.FieldByName('codigo').AsString;
        lbDescricaoProduto.Caption := FrmConsultaProduto.cdsProdutos.FieldByName('descricao').AsString;
        lbDescricaoProduto.Visible := True;
      end;
    finally
      FrmConsultaProduto.Free;
    end;
  end;
end;

procedure TfPedidos.edtNumeroPedidoEnter(Sender: TObject);
begin
  if not FLastExitWasCodigoCliente then
  begin
    if Trim(edtCodigoCliente.Text) = '' then
    begin
      lbCliente.Caption := '';
      btnConsultarPedidos.Enabled := true;
      btnCancelarPedido.Enabled   := true;
    end;
  end;
  FLastExitWasCodigoCliente := False;
end;

procedure TfPedidos.FormCreate(Sender: TObject);
begin
  Self.KeyPreview := True;
  if not cdsItensPedido.Active then
     cdsItensPedido.CreateDataSet;
  lbCliente.Caption := '';
  FLastExitWasCodigoCliente := false;
  FConsultaCliente := false;
  FPedidoService := TPedidoService.Create(TPedidoRepository.Create(DM.FDConnection));
end;

procedure TfPedidos.GravarPedido;
var
  PedidoController: TPedidoController;
  PedidoDTO: TPedidosDadosGeraisDTO;
  ProdutosDTO: TList<TPedidosProdutosDTO>;
  ProdutoDTO: TPedidosProdutosDTO;
begin
  if cdsItensPedido.RecordCount = 0 then
  begin
    ShowMessage('Não há informações para gravar o pedido válido.');
    btGravarPedido.Enabled := false;
    edtCodigoCliente.SetFocus;
    Exit;

  end;
  PedidoDTO := TPedidosDadosGeraisDTO.Create;
  try
    PedidoDTO.DataEmissao := Now;
    PedidoDTO.ClienteCodigo := StrToInt(edtCodigoCliente.Text);

    ProdutosDTO := TList<TPedidosProdutosDTO>.Create;
    try
      cdsItensPedido.First;
      while not cdsItensPedido.Eof do
      begin
        ProdutoDTO := TPedidosProdutosDTO.Create;
        ProdutoDTO.ProdutoCodigo := cdsItensPedido.FieldByName('CodigoProduto').AsInteger;
        ProdutoDTO.Quantidade := cdsItensPedido.FieldByName('Quantidade').AsInteger;
        ProdutoDTO.ValorUnitario := cdsItensPedido.FieldByName('ValorUnitario').AsCurrency;
        ProdutoDTO.ValorTotal := cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
        ProdutosDTO.Add(ProdutoDTO);
        PedidoDTO.ValorTotal := PedidoDTO.ValorTotal + cdsItensPedido.FieldByName('ValorTotal').AsCurrency;
        cdsItensPedido.Next;
      end;

      PedidoController := TPedidoController.Create(TPedidoService.Create(TPedidoRepository.Create(DM.FDConnection)));
      try
        if PedidoController.SalvarPedido(PedidoDTO, ProdutosDTO) then
        begin
          ShowMessage('Pedido salvo com sucesso!');
          cdsItensPedido.EmptyDataSet;
          CalcularTotal;
          LimparCamposItens;
          edtCodigoCliente.Clear;
          lbCliente.Caption := '';
        end
        else
          ShowMessage('Erro ao salvar pedido.');
      finally
        PedidoController.Free;
      end;
    finally
      if Assigned(ProdutoDTO) then
         ProdutoDTO.Free;
      ProdutosDTO.Free;
    end;
  finally
    PedidoDTO.Free;
  end;
end;

procedure TfPedidos.LimparCamposItens;
begin
  edtCodigoProduto.Clear;
  edtQuantidade.Clear;
  edtPrecoVenda.Clear;
  lbDescricaoProduto.Caption := '';
end;

procedure TfPedidos.PesquisarCliente;
var
  FrmConsulta: TfConsultaClientes;
  ClienteRepository: IClientesRepository;
  ClienteController: IClientesController;
begin
  ClienteRepository := TClienteRepository.Create;
  ClienteController := TClienteController.Create(ClienteRepository);
  FrmConsulta := TfConsultaClientes.Create(Self, ClienteController);
  try
    if FrmConsulta.ShowModal = mrOk then
    begin
      edtCodigoCliente.Text := FrmConsulta.cdsClientes.FieldByName('Codigo').AsString;
      lbCliente.Caption     := FrmConsulta.cdsClientes.FieldByName('Nome').AsString;
      lbCliente.Visible     := True;
      gbProdutos.Enabled    := True;
      edtCodigoProduto.SetFocus;
    end;
  finally
    FrmConsulta.Free;
  end;
end;

procedure TfPedidos.PesquisarPedidos;
var
  FrmConsulta: TfConsultaPedidos;
  NumeroPedido: Integer;
  ProdutoRepository: IProdutoRepository;
  ProdutoController: IProdutoController;
begin
  ProdutoRepository := TProdutoRepository.Create;
  ProdutoController := TProdutoController.Create(ProdutoRepository);
  FrmConsulta := TfConsultaPedidos.Create(Self, FPedidoService, ProdutoController);
  try
    if FrmConsulta.ShowModal = mrOk then
    begin
      NumeroPedido := FrmConsulta.cdsPedidos.FieldByName('numero_pedido').AsInteger;

      edtNumeroPedido.Text := IntToStr(NumeroPedido);
    end;
  finally
    FrmConsulta.Free;
  end;
end;

procedure TfPedidos.PesquisarProduto;
var
  FrmConsultaProduto: TfConsultaProdutos;
  ProdutoRepository: IProdutoRepository;
  ProdutoController: IProdutoController;
begin
  ProdutoRepository := TProdutoRepository.Create;
  ProdutoController := TProdutoController.Create(ProdutoRepository);
  FrmConsultaProduto := TfConsultaProdutos.Create(Self, ProdutoController);
  try
    if FrmConsultaProduto.ShowModal = mrOk then
    begin
      edtCodigoProduto.Text := FrmConsultaProduto.cdsProdutos.FieldByName('Codigo').AsString;
      lbDescricaoProduto.Caption := FrmConsultaProduto.cdsProdutos.FieldByName('Descricao').AsString;
      edtPrecoVenda.Text := FormatFloat('0.00', FrmConsultaProduto.cdsProdutos.FieldByName('PrecoVenda').AsCurrency);
      lbDescricaoProduto.Visible := True;
      edtQuantidade.SetFocus;
    end;
  finally
    FrmConsultaProduto.Free;
  end;
end;

procedure TfPedidos.SpeedButton1Click(Sender: TObject);
begin
  PesquisarPedidos;
end;

end.
