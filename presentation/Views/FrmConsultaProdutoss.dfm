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
  PixelsPerInch = 96
  TextHeight = 15
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 63
    Align = alTop
    TabOrder = 0
    object edtCodigoCliente: TEdit
      Left = 40
      Top = 8
      Width = 121
      Height = 23
      TabOrder = 0
    end
    object btnSelecionar: TButton
      Left = 272
      Top = 7
      Width = 89
      Height = 25
      Caption = 'Selecionar'
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 63
    Width = 624
    Height = 315
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 316
    object dbgProdutos: TDBGrid
      Left = 1
      Top = 1
      Width = 622
      Height = 313
      Align = alClient
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object pnFooter: TPanel
    Left = 0
    Top = 378
    Width = 624
    Height = 63
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 379
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
