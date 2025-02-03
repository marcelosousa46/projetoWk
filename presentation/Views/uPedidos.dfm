object fPedidos: TfPedidos
  Left = 0
  Top = 0
  Caption = 'Pedidos'
  ClientHeight = 441
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 695
    Height = 137
    Align = alTop
    TabOrder = 0
    object lbNomeCliente: TLabel
      Left = 186
      Top = 11
      Width = 90
      Height = 15
      Caption = 'Nome do Cliente'
    end
    object lbCodigoCliente: TLabel
      Left = 26
      Top = 11
      Width = 96
      Height = 15
      Caption = 'C'#243'digo do Cliente'
    end
    object lbCliente: TLabel
      Left = 186
      Top = 32
      Width = 223
      Height = 15
      AutoSize = False
      Caption = 'Nome do Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object btPesquisaCliente: TSpeedButton
      Left = 150
      Top = 32
      Width = 23
      Height = 23
      Hint = 'Consultar Clientes'
      Caption = '...'
      OnClick = btPesquisaClienteClick
    end
    object pnProdutos: TPanel
      Left = 1
      Top = 69
      Width = 693
      Height = 67
      Align = alBottom
      TabOrder = 1
      object gbProdutos: TGroupBox
        Left = 1
        Top = 1
        Width = 691
        Height = 65
        Align = alClient
        Caption = ' Informa'#231#245'es dos Produtos '
        Enabled = False
        TabOrder = 0
        object lbCodigoProduto: TLabel
          Left = 24
          Top = 16
          Width = 102
          Height = 15
          Caption = 'C'#243'digo do Produto'
        end
        object btPesquisaProduto: TSpeedButton
          Left = 148
          Top = 31
          Width = 23
          Height = 22
          Hint = 'Consultar Produtos'
          Caption = '...'
          OnClick = btPesquisaProdutoClick
        end
        object Label1: TLabel
          Left = 184
          Top = 16
          Width = 54
          Height = 15
          Caption = 'Descri'#231#227'o:'
        end
        object lbDescricaoProduto: TLabel
          Left = 184
          Top = 31
          Width = 218
          Height = 15
          AutoSize = False
          Caption = 'lbDescricaoProduto'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object Label2: TLabel
          Left = 428
          Top = 10
          Width = 89
          Height = 15
          Caption = 'Valor do Produto'
        end
        object Label3: TLabel
          Left = 551
          Top = 10
          Width = 62
          Height = 15
          Caption = 'Quantidade'
        end
        object edtCodigoProduto: TEdit
          Left = 24
          Top = 31
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 0
          OnExit = edtCodigoProdutoExit
        end
        object edtPrecoVenda: TEdit
          Left = 428
          Top = 31
          Width = 121
          Height = 23
          NumbersOnly = True
          TabOrder = 1
        end
        object edtQuantidade: TEdit
          Left = 551
          Top = 31
          Width = 66
          Height = 23
          NumbersOnly = True
          TabOrder = 2
        end
        object Button1: TButton
          Left = 624
          Top = 31
          Width = 63
          Height = 25
          Hint = 'Confirmar item para o pedido'
          Caption = 'Confirmar'
          TabOrder = 3
          OnClick = Button1Click
        end
      end
    end
    object pnControlePedidos: TPanel
      Left = 420
      Top = 1
      Width = 274
      Height = 68
      Align = alRight
      TabOrder = 2
      object gbPedidos: TGroupBox
        Left = 1
        Top = 1
        Width = 272
        Height = 66
        Align = alClient
        Caption = ' Controles dos Pedidos '
        TabOrder = 0
        object Label4: TLabel
          Left = 9
          Top = 19
          Width = 101
          Height = 15
          Caption = 'N'#250'mero do Pedido'
        end
        object SpeedButton1: TSpeedButton
          Left = 114
          Top = 36
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = SpeedButton1Click
        end
        object btnConsultarPedidos: TButton
          Left = 136
          Top = 10
          Width = 63
          Height = 25
          Hint = 'Consultar Pedido'
          Caption = 'Consultar'
          TabOrder = 0
          OnClick = btnConsultarPedidosClick
        end
        object btGravarPedido: TButton
          Left = 139
          Top = 36
          Width = 63
          Height = 25
          Hint = 'Gravar Pedido'
          Caption = 'Gravar'
          Enabled = False
          TabOrder = 1
          OnClick = btGravarPedidoClick
        end
        object edtNumeroPedido: TEdit
          Left = 9
          Top = 36
          Width = 104
          Height = 23
          NumbersOnly = True
          TabOrder = 2
          OnEnter = edtNumeroPedidoEnter
        end
        object btnCancelarPedido: TButton
          Left = 205
          Top = 10
          Width = 63
          Height = 25
          Hint = 'Cancelar Pedido'
          Caption = 'Cancelar'
          TabOrder = 3
          OnClick = btnCancelarPedidoClick
        end
      end
    end
    object edtCodigoCliente: TEdit
      Left = 26
      Top = 32
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 0
      OnExit = edtCodigoClienteExit
    end
  end
  object pnFooter: TPanel
    Left = 0
    Top = 400
    Width = 695
    Height = 41
    Align = alBottom
    TabOrder = 1
    object pnTotal: TPanel
      Left = 509
      Top = 1
      Width = 185
      Height = 39
      Align = alRight
      Alignment = taRightJustify
      Caption = '0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 324
      Top = 1
      Width = 185
      Height = 39
      Align = alRight
      Caption = 'Valor total do itens=>'
      TabOrder = 1
    end
  end
  object pnAll: TPanel
    Left = 0
    Top = 137
    Width = 695
    Height = 263
    Align = alClient
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 693
      Height = 261
      Align = alClient
      DataSource = dsItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = DBGrid1KeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'CodigoProduto'
          Title.Caption = 'C'#243'digo do Produto'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProduto'
          Title.Caption = 'Descri'#231#227'o do Produto'
          Width = 313
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Quantidade'
          Title.Alignment = taCenter
          Width = 73
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValorUnitario'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Unit'#225'rio'
          Width = 84
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValorTotal'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Total'
          Visible = True
        end>
    end
  end
  object cdsItensPedido: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsItensPedidoCalcFields
    Left = 392
    Top = 217
    object cdsItensPedidoCodigoProduto: TIntegerField
      FieldName = 'CodigoProduto'
    end
    object cdsItensPedidoDescricaoProduto: TStringField
      FieldName = 'DescricaoProduto'
      Size = 255
    end
    object cdsItensPedidoQuantidade: TCurrencyField
      FieldName = 'Quantidade'
      currency = False
    end
    object cdsItensPedidoValorUnitario: TCurrencyField
      FieldName = 'ValorUnitario'
    end
    object cdsItensPedidoValorTotal: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'ValorTotal'
      Calculated = True
    end
  end
  object dsItensPedido: TDataSource
    DataSet = cdsItensPedido
    Left = 307
    Top = 217
  end
end
