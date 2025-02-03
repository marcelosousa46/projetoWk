object DM: TDM
  Height = 286
  Width = 606
  PixelsPerInch = 96
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Database=pedidosWK'
      'Password=root'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 112
    Top = 40
  end
  object fdQueryConsulta: TFDQuery
    Connection = FDConnection
    Left = 352
    Top = 40
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 112
    Top = 104
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\WorkArea\ProjetoWk\Win32\Debug\Libs\libmysql.dll'
    Left = 104
    Top = 192
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 368
    Top = 160
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 216
    Top = 120
  end
end
