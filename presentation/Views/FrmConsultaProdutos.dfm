object fConsultaProdutos: TfConsultaProdutos
  Left = 0
  Top = 0
  Caption = 'Consulta de Produtos'
  ClientHeight = 441
  ClientWidth = 624
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
    Width = 624
    Height = 51
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 1
    ExplicitTop = -5
    object Label1: TLabel
      Left = 12
      Top = 1
      Width = 189
      Height = 15
      Caption = 'Digite C'#243'digo ou Nome do Produto'
    end
    object edtCodigoProduto: TEdit
      Left = 10
      Top = 18
      Width = 215
      Height = 23
      TabOrder = 0
      OnExit = edtCodigoProdutoExit
    end
    object btnSelecionar: TButton
      Left = 229
      Top = 18
      Width = 89
      Height = 25
      Caption = 'Selecionar'
      TabOrder = 1
      OnClick = btnSelecionarClick
    end
    object rgConsulta: TRadioGroup
      Left = 323
      Top = 11
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
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 51
    Width = 624
    Height = 354
    Align = alClient
    TabOrder = 1
    object dbgProdutos: TDBGrid
      Left = 1
      Top = 1
      Width = 622
      Height = 352
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = dbgProdutosKeyDown
    end
  end
  object pnFooter: TPanel
    Left = 0
    Top = 405
    Width = 624
    Height = 36
    Align = alBottom
    Caption = 
      'Use o bot'#227'o seleciar escolher o produto desejado ou tecle <ENTER' +
      '> na grade!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object cdsProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 151
  end
  object dsProdutos: TDataSource
    Left = 408
    Top = 151
  end
end
