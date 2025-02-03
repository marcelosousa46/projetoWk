unit FrmConsultaPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, Datasnap.DBClient,
  Vcl.Grids, Vcl.DBGrids, PedidoCompletoDTO, IPedidosService, System.Generics.Collections,
  IProdutosController;

type
  TfConsultaPedidos = class(TForm)
    pnTop: TPanel;
    pnAll: TPanel;
    pnFooter: TPanel;
    Label1: TLabel;
    rgConsulta: TRadioGroup;
    edtBusca: TEdit;
    btnSelecionar: TButton;
    dbgPedidos: TDBGrid;
    cdsPedidos: TClientDataSet;
    dsPedidos: TDataSource;
    cdsPedidosnumero_pedido: TIntegerField;
    cdsPedidosdata_emissao: TDateField;
    cdsPedidoscliente_codigo: TIntegerField;
    cdsPedidosvalor_total_pedido: TCurrencyField;
    cdsPedidoscliente_nome: TStringField;
    cdsPedidosproduto_codigo: TIntegerField;
    cdsPedidosdescricao_produto: TStringField;
    cdsPedidosvalor_unitario: TCurrencyField;
    cdsPedidosvalor_total_item: TCurrencyField;
    cdsPedidosquantidade: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure dbgPedidosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtBuscaExit(Sender: TObject);
  private
    FPedidoService: IPedidoService;
    FController: IProdutoController;
    procedure ConfigurarPedidosDataSet;
    procedure CarregarPedido(NumeroPedido: Integer);
    procedure CarregarPedidoNoDataSet(const PedidoCompleto: TPedidoCompletoDTO);
    procedure CarregarTodosPedidosNoDataSet(ListaPedidos: TObjectList<TPedidoCompletoDTO>);
    procedure BuscarPedidos;
  public
    constructor Create(AOwner: TComponent; APedidoService: IPedidoService; AController: IProdutoController); reintroduce;
  end;

var
  fConsultaPedidos: TfConsultaPedidos;

implementation

uses
  PedidosProdutosDTO, ProdutosDTO;

{$R *.dfm}

constructor TfConsultaPedidos.Create(AOwner: TComponent; APedidoService: IPedidoService; AController: IProdutoController);
begin
  inherited Create(AOwner);
  FPedidoService := APedidoService;
  FController := AController;
end;

procedure TfConsultaPedidos.ConfigurarPedidosDataSet;
begin
  cdsPedidos.Close;
  cdsPedidos.FieldDefs.Clear;
  cdsPedidos.IndexFieldNames := 'numero_pedido';

  // Campos do cabeçalho e itens do pedido
  cdsPedidos.FieldDefs.Add('numero_pedido', ftInteger);
  cdsPedidos.FieldDefs.Add('data_emissao', ftDate);
  cdsPedidos.FieldDefs.Add('cliente_codigo', ftInteger);
  cdsPedidos.FieldDefs.Add('valor_total_pedido', ftCurrency);
  cdsPedidos.FieldDefs.Add('cliente_nome', ftString, 255);
  cdsPedidos.FieldDefs.Add('produto_codigo', ftInteger);
  cdsPedidos.FieldDefs.Add('descricao_produto', ftString, 255);
  cdsPedidos.FieldDefs.Add('quantidade', ftInteger);
  cdsPedidos.FieldDefs.Add('valor_unitario', ftCurrency);
  cdsPedidos.FieldDefs.Add('valor_total_item', ftCurrency);
  cdsPedidos.CreateDataSet;

  dsPedidos.DataSet := cdsPedidos;
  dbgPedidos.DataSource := dsPedidos;

  if dbgPedidos.Columns.Count >= 3 then
  begin
    dbgPedidos.Columns[0].Width := 80;
    dbgPedidos.Columns[1].Width := 80;
    dbgPedidos.Columns[2].Width := 80;
    dbgPedidos.Columns[3].Width := 200;
    dbgPedidos.Columns[4].Width := 80;
    dbgPedidos.Columns[5].Width := 200;
    dbgPedidos.Columns[6].Width := 120;
    dbgPedidos.Columns[7].Width := 80;
    dbgPedidos.Columns[8].Width := 120;
    dbgPedidos.Columns[9].Width := 120;

  end;
end;

procedure TfConsultaPedidos.BuscarPedidos;
var
  PedidoCompleto: TPedidoCompletoDTO;
  ListaPedidos: TObjectList<TPedidoCompletoDTO>;
begin
  ListaPedidos := TObjectList<TPedidoCompletoDTO>.Create;

  try
    if Trim(edtBusca.Text) = '' then
      ListaPedidos := FPedidoService.BuscarTodosPedidos
    else
    begin
      case rgConsulta.ItemIndex of
        0: begin
             PedidoCompleto := FPedidoService.BuscarPedidoCompleto(StrToInt(edtBusca.Text));
             if Assigned(PedidoCompleto) then
               ListaPedidos.Add(PedidoCompleto);
           end;
        1: ListaPedidos := FPedidoService.BuscarPedidosPorNomeCliente('%' + Trim(edtBusca.Text) + '%');
      end;
    end;

    if Assigned(ListaPedidos) then
      CarregarTodosPedidosNoDataSet(ListaPedidos);

  finally
    ListaPedidos.Free;
  end;
end;

procedure TfConsultaPedidos.CarregarPedido(NumeroPedido: Integer);
var
  PedidoCompleto: TPedidoCompletoDTO;
  ListaPedidos: TObjectList<TPedidoCompletoDTO>;
begin
  if NumeroPedido = 0 then
  begin
    // Se não foi informado nenhum número (ou foi zero), buscar todos os pedidos
    ListaPedidos := FPedidoService.BuscarTodosPedidos;
    if ListaPedidos.Count > 0 then
      CarregarTodosPedidosNoDataSet(ListaPedidos)
    else
      ShowMessage('Nenhum pedido encontrado.');
  end
  else
  begin
    PedidoCompleto := FPedidoService.BuscarPedidoCompleto(NumeroPedido);
    try
      if Assigned(PedidoCompleto) then
        CarregarPedidoNoDataSet(PedidoCompleto)
      else
        ShowMessage('Pedido não encontrado.');
    finally
      PedidoCompleto.Free;
    end;
  end;
end;

procedure TfConsultaPedidos.CarregarPedidoNoDataSet(const PedidoCompleto: TPedidoCompletoDTO);
var
  PedidoProduto: TPedidosProdutosDTO;
begin

  cdsPedidos.EmptyDataSet;
  for PedidoProduto in PedidoCompleto.PedidoProdutos do
  begin
    cdsPedidos.Append;
    cdsPedidos.FieldByName('numero_pedido').AsInteger := PedidoCompleto.Pedido.NumeroPedido;
    cdsPedidos.FieldByName('data_emissao').AsDateTime := PedidoCompleto.Pedido.DataEmissao;
    cdsPedidos.FieldByName('cliente_codigo').AsInteger := PedidoCompleto.Pedido.ClienteCodigo;
    cdsPedidos.FieldByName('valor_total_pedido').AsCurrency := PedidoCompleto.Pedido.ValorTotal;
    cdsPedidos.FieldByName('cliente_nome').AsString := PedidoCompleto.Cliente.Nome;
    cdsPedidos.FieldByName('produto_codigo').AsInteger := PedidoProduto.ProdutoCodigo;
    cdsPedidos.FieldByName('quantidade').AsInteger := PedidoProduto.Quantidade;
    cdsPedidos.FieldByName('valor_unitario').AsCurrency := PedidoProduto.ValorUnitario;
    cdsPedidos.FieldByName('valor_total_item').AsCurrency := PedidoProduto.ValorTotal;


    cdsPedidos.Post;
  end;
  cdsPedidos.First;
end;

procedure TfConsultaPedidos.CarregarTodosPedidosNoDataSet(ListaPedidos: TObjectList<TPedidoCompletoDTO>);
var
  Pedido: TPedidoCompletoDTO;
  Produto: TPedidosProdutosDTO;
  ProdutoDTO: TProdutosDTO;

begin
  cdsPedidos.EmptyDataSet;
  for Pedido in ListaPedidos do
  begin
    for Produto in Pedido.PedidoProdutos do
    begin
      ProdutoDTO := FController.BuscarPorCodigo(IntToStr(Produto.ProdutoCodigo));

      cdsPedidos.Append;
      cdsPedidos.FieldByName('numero_pedido').AsInteger := Pedido.Pedido.NumeroPedido;
      cdsPedidos.FieldByName('data_emissao').AsDateTime := Pedido.Pedido.DataEmissao;
      cdsPedidos.FieldByName('cliente_codigo').AsInteger := Pedido.Pedido.ClienteCodigo;
      cdsPedidos.FieldByName('valor_total_pedido').AsCurrency := Pedido.Pedido.ValorTotal;
      cdsPedidos.FieldByName('cliente_nome').AsString := Pedido.Cliente.Nome;
      cdsPedidos.FieldByName('produto_codigo').AsInteger := Produto.ProdutoCodigo;
      cdsPedidos.FieldByName('descricao_produto').AsString := ProdutoDTO.Descricao;
      cdsPedidos.FieldByName('quantidade').AsInteger := Produto.Quantidade;
      cdsPedidos.FieldByName('valor_unitario').AsCurrency := Produto.ValorUnitario;
      cdsPedidos.FieldByName('valor_total_item').AsCurrency := Produto.ValorTotal;
      cdsPedidos.Post;
    end;
  end;
  cdsPedidos.First;
end;

procedure TfConsultaPedidos.btnSelecionarClick(Sender: TObject);
begin
  if not cdsPedidos.IsEmpty then
    ModalResult := mrOk;
end;

procedure TfConsultaPedidos.dbgPedidosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    if not cdsPedidos.IsEmpty then
      ModalResult := mrOk;
  end;
end;


procedure TfConsultaPedidos.edtBuscaExit(Sender: TObject);
begin
  BuscarPedidos;
end;

procedure TfConsultaPedidos.FormCreate(Sender: TObject);
begin
  ConfigurarPedidosDataSet;
  CarregarPedido(0);
end;

end.

