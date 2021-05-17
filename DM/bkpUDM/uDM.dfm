object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 375
  Width = 360
  object BASE_AS400: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345;Persist Security Info=True;Use' +
      'r ID=root;Extended Properties="DSN=my2;SERVER=localhost;UID=root' +
      ';PWD=12345;DATABASE=mysql;PORT=3307";Initial Catalog=mysql'
    KeepConnection = False
    Provider = 'MSDASQL.1'
    Left = 48
    Top = 48
  end
  object QAliquotas: TADOQuery
    Parameters = <>
    Left = 40
    Top = 136
  end
  object QGAliquotas: TADOQuery
    Parameters = <>
    Left = 32
    Top = 208
  end
end
