inherited IWFRM_Consolida: TIWFRM_Consolida
  OnShow = IWAppFormShow
  DesignLeft = 2
  DesignTop = 2
  inherited IWLabel1: TIWLabel
    Width = 123
    Caption = '<uConsolida Page>'
    ExplicitWidth = 123
  end
  object IWT_DATATABLE: TIWText [1]
    Left = 32
    Top = 56
    Width = 169
    Height = 65
    BGColor = clNone
    ConvertSpaces = False
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWT_DATATABLE'
    Lines.Strings = (
      '{%IWT_DATATABLE%}')
    RawText = True
    UseFrame = False
    WantReturns = True
  end
  object IWE_Filter: TIWEdit [2]
    Left = 232
    Top = 64
    Width = 121
    Height = 21
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWE_Filter'
    SubmitOnAsyncEvent = True
    TabOrder = 0
    Text = 'IWE_Filter'
  end
  object IWL_Status: TIWLabel [3]
    Left = 232
    Top = 112
    Width = 71
    Height = 16
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    HasTabOrder = False
    FriendlyName = 'IWL_Status'
    Caption = 'IWL_Status'
  end
  object IWSQL: TIWLabel [4]
    Left = 112
    Top = 288
    Width = 42
    Height = 16
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    HasTabOrder = False
    FriendlyName = 'IWSQL'
    Caption = 'IWSQL'
  end
  object IWT_MODAL_HIST: TIWText [5]
    Left = 33
    Top = 127
    Width = 121
    Height = 41
    BGColor = clNone
    ConvertSpaces = False
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWT_MODAL_HIST'
    Lines.Strings = (
      'IWT_MODAL_HIST')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
end
