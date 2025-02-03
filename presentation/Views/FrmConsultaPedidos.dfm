object fConsultaPedidos: TfConsultaPedidos
  Left = 0
  Top = 0
  Caption = 'fConsultaPedidos'
  ClientHeight = 441
  ClientWidth = 1126
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 1126
    Height = 51
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 0
      Width = 239
      Height = 15
      Caption = 'Digite Nome de Cliente ou Nome do Produto'
    end
    object rgConsulta: TRadioGroup
      Left = 426
      Top = 7
      Width = 185
      Height = 30
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'C'#243'digo'
        'Nome')
      ParentFont = False
      TabOrder = 0
    end
    object edtBusca: TEdit
      Left = 5
      Top = 14
      Width = 310
      Height = 23
      TabOrder = 1
      OnExit = edtBuscaExit
    end
    object btnSelecionar: TButton
      Left = 319
      Top = 13
      Width = 97
      Height = 25
      Caption = 'Selecionar'
      TabOrder = 2
      OnClick = btnSelecionarClick
    end
  end
  object pnAll: TPanel
    Left = 0
    Top = 51
    Width = 1126
    Height = 349
    Align = alClient
    TabOrder = 1
    object dbgPedidos: TDBGrid
      Left = 1
      Top = 1
      Width = 1124
      Height = 347
      Align = alClient
      DataSource = dsPedidos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = dbgPedidosKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'numero_pedido'
          Title.Caption = 'No. Pedido'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'data_emissao'
          Title.Caption = 'Data Emiss'#227'o'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cliente_codigo'
          Title.Caption = 'C'#243'd Cliente'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'cliente_nome'
          Title.Caption = 'Nome do Cliente'
          Width = 145
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'produto_codigo'
          Title.Caption = 'C'#243'd Produto'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao_produto'
          Title.Caption = 'Descri'#231#227'o do Produto'
          Width = 138
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_unitario'
          Title.Caption = 'Vlr Unit'#225'rio'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantidade'
          Title.Caption = 'Quantidade'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_total_item'
          Title.Caption = 'Vlr Total Item'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_total_pedido'
          Title.Alignment = taRightJustify
          Title.Caption = 'Vlr Total Pedido'
          Visible = True
        end>
    end
  end
  object pnFooter: TPanel
    Left = 0
    Top = 400
    Width = 1126
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
  object cdsPedidos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 139
    object cdsPedidosnumero_pedido: TIntegerField
      FieldName = 'numero_pedido'
    end
    object cdsPedidosdata_emissao: TDateField
      FieldName = 'data_emissao'
    end
    object cdsPedidoscliente_codigo: TIntegerField
      FieldName = 'cliente_codigo'
    end
    object cdsPedidoscliente_nome: TStringField
      FieldName = 'cliente_nome'
    end
    object cdsPedidosproduto_codigo: TIntegerField
      FieldName = 'produto_codigo'
    end
    object cdsPedidosdescricao_produto: TStringField
      FieldName = 'descricao_produto'
    end
    object cdsPedidosvalor_unitario: TCurrencyField
      FieldName = 'valor_unitario'
    end
    object cdsPedidosquantidade: TIntegerField
      FieldName = 'quantidade'
    end
    object cdsPedidosvalor_total_item: TCurrencyField
      FieldName = 'valor_total_item'
    end
    object cdsPedidosvalor_total_pedido: TCurrencyField
      FieldName = 'valor_total_pedido'
    end
  end
  object dsPedidos: TDataSource
    DataSet = cdsPedidos
    Left = 240
    Top = 139
  end
end
