inherited IWFRM_Index1: TIWFRM_Index1
  DesignLeft = 2
  DesignTop = 2
  object IWT_CONTENT: TIWText [0]
    Left = 65
    Top = 80
    Width = 136
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
    Left = 248
    Top = 64
    Width = 257
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
    Left = 464
    Top = 256
  end
end
