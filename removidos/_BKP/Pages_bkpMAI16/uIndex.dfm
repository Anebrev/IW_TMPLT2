inherited IWFRM_Index: TIWFRM_Index
  Width = 753
  Height = 538
  ExplicitWidth = 753
  ExplicitHeight = 538
  DesignLeft = 2
  DesignTop = 2
  inherited IWLabel1: TIWLabel
    Width = 96
    FriendlyName = 'IWFRM_Index'
    Caption = '<uIndex Page>'
    ExplicitWidth = 96
  end
  object BTNH1: TIWButton [1]
    Left = 584
    Top = 272
    Width = 97
    Height = 25
    Caption = 'H1'
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'BTNH1'
    ScriptEvents = <
      item
        EventCode.Strings = (
          'javascript: fncExecutar('#39'H1'#39', 0);')
        Event = 'onClick'
      end>
    TabOrder = 0
    OnAsyncClick = BTNH1AsyncClick
  end
  object BTNH2: TIWButton [2]
    Left = 584
    Top = 319
    Width = 97
    Height = 25
    Caption = 'H2'
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'BTNH1'
    TabOrder = 1
    OnAsyncClick = BTNH2AsyncClick
  end
  object IWButton1: TIWButton [3]
    Left = 584
    Top = 366
    Width = 97
    Height = 25
    Caption = 'H3'
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'BTNH1'
    TabOrder = 2
    OnAsyncClick = IWButton1AsyncClick
  end
  object IWMemo: TIWMemo [4]
    Left = 36
    Top = 96
    Width = 293
    Height = 137
    BGColor = clNone
    Editable = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    TabOrder = 3
    SubmitOnAsyncEvent = True
    FriendlyName = 'IWMemo'
  end
  object IWT_CONTENT: TIWText [5]
    Left = 384
    Top = 96
    Width = 169
    Height = 137
    BGColor = clNone
    ConvertSpaces = False
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWT_CONTENT'
    Lines.Strings = (
      '<h1>'
      'Conte'#250'do sem formata'#231#227'o'
      '</h1>')
    RawText = True
    UseFrame = False
    WantReturns = True
  end
  object IWCheckBox: TIWCheckBox [6]
    Left = 384
    Top = 341
    Width = 97
    Height = 21
    OnHTMLTag = IWCheckBoxHTMLTag
    Caption = 'Raw Text'
    Editable = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    SubmitOnAsyncEvent = True
    Style = stNormal
    TabOrder = 4
    Checked = True
    FriendlyName = 'IWCheckBox'
  end
  object IWR_PGPROCESSA: TIWRegion [7]
    Left = 20
    Top = 341
    Width = 237
    Height = 188
    RenderInvisibleControls = False
    BorderOptions.NumericWidth = 1
    BorderOptions.BorderWidth = cbwNumeric
    BorderOptions.Style = cbsSolid
    BorderOptions.Color = clNone
    object IWLabel2: TIWLabel
      Left = 56
      Top = 40
      Width = 144
      Height = 16
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      HasTabOrder = False
      FriendlyName = 'IWLabel2'
      Caption = 'Iside IWR_PGPRocessa'
    end
  end
  inherited IWTemplateProcessorHTML1: TIWTemplateProcessorHTML
    Left = 648
    Top = 464
  end
end
