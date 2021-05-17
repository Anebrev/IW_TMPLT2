object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 375
  Width = 360
  object BASE_AS400: TADOConnection
    KeepConnection = False
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
