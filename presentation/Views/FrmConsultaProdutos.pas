unit FrmConsultaProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, ProdutosDTO,
  System.Generics.Collections, IProdutosController;

type
  TfConsultaProdutos = class(TForm)
    pnTop: TPanel;
    Panel2: TPanel;
    pnFooter: TPanel;
    edtCodigoProduto: TEdit;
    btnSelecionar: TButton;
    dbgProdutos: TDBGrid;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
    Label1: TLabel;
    rgConsulta: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FController: IProdutoController;
    procedure ConfigurarProdutoDataSet;
    procedure CarregarProdutos(Lista: TObjectList<TProdutosDTO>);
    procedure BuscarProdutos;
  public
    constructor Create(AOwner: TComponent; AController: IProdutoController); reintroduce;
  end;

var
  fConsultaProdutos: TfConsultaProdutos;

implementation

{$R *.dfm}

{ TfConsultaProdutos }

procedure TfConsultaProdutos.CarregarProdutos(Lista: TObjectList<TProdutosDTO>);
var
  Produto: TProdutosDTO;
begin
  cdsProdutos.DisableControls;
  try
    cdsProdutos.EmptyDataSet;

    for Produto in Lista do
    begin
      cdsProdutos.Append;
      cdsProdutos.FieldByName('Codigo').AsInteger := Produto.Codigo;
      cdsProdutos.FieldByName('Descricao').AsString := Produto.Descricao;
      cdsProdutos.FieldByName('PrecoVenda').AsCurrency := Produto.PrecoVenda;
      cdsProdutos.Post;
    end;
  finally
    cdsProdutos.EnableControls;
    cdsProdutos.First;
  end;
end;

procedure TfConsultaProdutos.btnSelecionarClick(Sender: TObject);
begin
  if not cdsProdutos.IsEmpty then
    ModalResult := mrOk;

end;

procedure TfConsultaProdutos.BuscarProdutos;
var
  Produtos: TObjectList<TProdutosDTO>;
  Produto: TProdutosDTO;
begin
  Produtos := TObjectList<TProdutosDTO>.Create;

  try
    if Trim(edtCodigoProduto.Text) = '' then
      Produtos := FController.BuscarPorDescricao('%')
    else
    begin
      case rgConsulta.ItemIndex of
        0: begin
             Produto := FController.BuscarPorCodigo(edtCodigoProduto.Text);
             if Assigned(Produto) then
               Produtos.Add(Produto);
           end;
        1: Produtos := FController.BuscarPorDescricao('%' + Trim(edtCodigoProduto.Text) + '%');
      end;
    end;

    if Assigned(Produtos) then
      CarregarProdutos(Produtos);

  finally
    Produtos.Free;
  end;
end;

procedure TfConsultaProdutos.ConfigurarProdutoDataSet;
begin
  cdsProdutos.Close;
  cdsProdutos.FieldDefs.Clear;
  cdsProdutos.IndexFieldNames := 'Codigo';
  cdsProdutos.FieldDefs.Add('Codigo', ftInteger);
  cdsProdutos.FieldDefs.Add('Descricao', ftString, 255);
  cdsProdutos.FieldDefs.Add('PrecoVenda', ftCurrency);
  cdsProdutos.CreateDataSet;

  dsProdutos.DataSet := cdsProdutos;
  dbgProdutos.DataSource := dsProdutos;

  dbgProdutos.Columns[0].Width := 80;
  dbgProdutos.Columns[1].Width := 328;
  dbgProdutos.Columns[2].Width := 80;

end;

constructor TfConsultaProdutos.Create(AOwner: TComponent;
  AController: IProdutoController);
begin
  inherited Create(AOwner);
  FController := AController;

end;

procedure TfConsultaProdutos.dbgProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsProdutos.IsEmpty then
    begin
      ModalResult := mrOk;
    end;
  end;

end;

procedure TfConsultaProdutos.edtCodigoProdutoExit(Sender: TObject);
begin
  BuscarProdutos;
end;

procedure TfConsultaProdutos.FormCreate(Sender: TObject);
begin
  ConfigurarProdutoDataSet;
  BuscarProdutos;

end;

end.
