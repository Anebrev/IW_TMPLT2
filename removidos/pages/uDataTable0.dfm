inherited IWFormDataTable: TIWFormDataTable
  Height = 423
  ExplicitHeight = 423
  DesignLeft = 2
  DesignTop = 2
  object IWT_CONTENT: TIWText [0]
    Left = 24
    Top = 168
    Width = 296
    Height = 137
    BGColor = clNone
    ConvertSpaces = False
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWT_CONTENT'
    Lines.Strings = (
      'IWT_Content')
    RawText = False
    UseFrame = False
    WantReturns = True
  end
  object IWMemo1: TIWMemo [1]
    Left = 24
    Top = 16
    Width = 185
    Height = 129
    BGColor = clNone
    Editable = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    TabOrder = 0
    SubmitOnAsyncEvent = True
    FriendlyName = 'IWMemo1'
  end
  inherited IWTemplateProcessorHTML1: TIWTemplateProcessorHTML
    Left = 488
    Top = 360
  end
end
