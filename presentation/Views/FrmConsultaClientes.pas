﻿unit FrmConsultaClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Datasnap.DBClient, IClienteController,
  System.Generics.Collections, ClientesDTO;

type
  TfConsultaClientes = class(TForm)
    pnTop: TPanel;
    pnFooter: TPanel;
    pnAll: TPanel;
    dbgClientes: TDBGrid;
    edtBusca: TEdit;
    btnSelecionar: TButton;
    cdsClientes: TClientDataSet;
    dsClientes: TDataSource;
    Label1: TLabel;
    rgConsulta: TRadioGroup;

    procedure FormCreate(Sender: TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure BuscarClientes;
    procedure edtBuscaExit(Sender: TObject);
    procedure dbgClientesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FController: IClientesController;
    procedure ConfigurarClientDataSet;
    procedure CarregarClientes(Lista: TObjectList<TClientesDTO>);
  public
    constructor Create(AOwner: TComponent; AController: IClientesController); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TfConsultaClientes.Create(AOwner: TComponent; AController: IClientesController);
begin
  inherited Create(AOwner);
  FController := AController;
end;

procedure TfConsultaClientes.dbgClientesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;

    if not cdsClientes.IsEmpty then
    begin
      ModalResult := mrOk;
    end;
  end;

end;

procedure TfConsultaClientes.edtBuscaExit(Sender: TObject);
begin
  BuscarClientes;
end;

procedure TfConsultaClientes.ConfigurarClientDataSet;
begin
  cdsClientes.Close;
  cdsClientes.FieldDefs.Clear;
  cdsClientes.FieldDefs.Add('Codigo', ftInteger);
  cdsClientes.FieldDefs.Add('Nome', ftString, 255);
  cdsClientes.FieldDefs.Add('Cidade', ftString, 100);
  cdsClientes.FieldDefs.Add('UF', ftString, 2);
  cdsClientes.CreateDataSet;

  dsClientes.DataSet := cdsClientes;
  dbgClientes.DataSource := dsClientes;

  dbgClientes.Columns[0].Width := 80;
  dbgClientes.Columns[1].Width := 328;
  dbgClientes.Columns[2].Width := 80;
  dbgClientes.Columns[3].Width := 40;

end;

procedure TfConsultaClientes.FormCreate(Sender: TObject);
begin
  ConfigurarClientDataSet;
  BuscarClientes;
end;

procedure TfConsultaClientes.BuscarClientes;
var
  Clientes: TObjectList<TClientesDTO>;
  Cliente: TClientesDTO;
begin
  Clientes := TObjectList<TClientesDTO>.Create;

  try
    if Trim(edtBusca.Text) = '' then
      Clientes := FController.BuscarPorNome('%')
    else
    begin
      case rgConsulta.ItemIndex of
        0: begin
             Cliente := FController.BuscarPorCodigo(edtBusca.Text);
             if Assigned(Cliente) then
               Clientes.Add(Cliente);
           end;
        1: Clientes := FController.BuscarPorNome('%' + Trim(edtBusca.Text) + '%');
      end;
    end;

    if Assigned(Clientes) then
      CarregarClientes(Clientes);

  finally
    Clientes.Free;
  end;
end;

procedure TfConsultaClientes.CarregarClientes(Lista: TObjectList<TClientesDTO>);
var
  Cliente: TClientesDTO;
begin
  cdsClientes.DisableControls;
  try
    cdsClientes.EmptyDataSet;

    for Cliente in Lista do
    begin
      cdsClientes.Append;
      cdsClientes.FieldByName('Codigo').AsInteger := Cliente.Codigo;
      cdsClientes.FieldByName('Nome').AsString := Cliente.Nome;
      cdsClientes.FieldByName('Cidade').AsString := Cliente.Cidade;
      cdsClientes.FieldByName('UF').AsString := Cliente.UF;
      cdsClientes.Post;
    end;
  finally
    cdsClientes.EnableControls;
    cdsClientes.First;
  end;
end;

procedure TfConsultaClientes.btnSelecionarClick(Sender: TObject);
begin
  if not cdsClientes.IsEmpty then
    ModalResult := mrOk;
end;

end.

