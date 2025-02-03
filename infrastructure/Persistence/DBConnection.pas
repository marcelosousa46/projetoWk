unit DBConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, ConfigReader, FireDAC.Phys.MongoDBDef, FireDAC.Comp.UI,
  FireDAC.Phys.MongoDB;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    fdQueryConsulta: TFDQuery;
    FDTransaction: TFDTransaction;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDPhysMongoDriverLink1: TFDPhysMongoDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
  private
    FConfig: TConfigReader;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConectarBanco;
    function CriarQuery: TFDQuery;

  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDM.ConectarBanco;
begin
  FDConnection.Close;
  FDConnection.Params.Clear;

  // Obtendo configurações do arquivo INI
  FDConnection.Params.Add('DriverID=MySQL');
  FDConnection.Params.Add('Server=' + FConfig.GetDatabaseConfig('Host'));
  FDConnection.Params.Add('Database=' + FConfig.GetDatabaseConfig('Database'));
  FDConnection.Params.Add('User_Name=' + FConfig.GetDatabaseConfig('User'));
  FDConnection.Params.Add('Password=' + FConfig.GetDatabaseConfig('Password'));
  FDConnection.Params.Add('Port=' + FConfig.GetDatabaseConfig('Port'));
  FDConnection.Params.Add('CharacterSet=' + FConfig.GetDatabaseConfig('Charset'));

  try
    FDConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco: ' + E.Message);
  end;
end;

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfig := TConfigReader.Create;
  FDPhysMySQLDriverLink.VendorLib := ExtractFilePath(ParamStr(0)) + 'Libs\libmysql.dll';
end;

function TDM.CriarQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDConnection;
end;

destructor TDM.Destroy;
begin
  FConfig.Free;
  inherited;
end;

end.
