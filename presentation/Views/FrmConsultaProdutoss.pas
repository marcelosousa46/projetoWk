unit FrmConsultaProdutoss;

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
    edtCodigoCliente: TEdit;
    btnSelecionar: TButton;
    dbgProdutos: TDBGrid;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
  private
    procedure ConfigurarProdutoDataSet;
    procedure CarregarProdutos(Lista: TObjectList<TProdutosDTO>);
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

procedure TfConsultaProdutos.ConfigurarProdutoDataSet;
begin
  cdsProdutos.Close;
  cdsProdutos.FieldDefs.Clear;
  cdsProdutos.FieldDefs.Add('Codigo', ftInteger);
  cdsProdutos.FieldDefs.Add('Descricao', ftString, 255);
  cdsProdutos.FieldDefs.Add('PrecoVenda', ftCurrency, 10);
  cdsProdutos.CreateDataSet;

  dsProdutos.DataSet := cdsProdutos;
  dbgProdutos.DataSource := dsProdutos;

end;

constructor TfConsultaProdutos.Create(AOwner: TComponent;
  AController: IProdutoController);
begin

end;

end.
