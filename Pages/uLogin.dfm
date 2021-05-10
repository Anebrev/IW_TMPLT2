inherited IWFRM_Login: TIWFRM_Login
  RenderInvisibleControls = False
  Title = 'Login Form'
  DesignLeft = 2
  DesignTop = 2
  inherited IWLabel1: TIWLabel
    Left = 240
    Width = 95
    Caption = '<uLogin Page>'
    ExplicitLeft = 240
    ExplicitWidth = 95
  end
  object IWBTN_LOGIN: TIWButton [1]
    Left = 24
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Login'
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWBTN_LOGIN'
    TabOrder = 0
    OnAsyncClick = IWBTN_LOGINAsyncClick
  end
  object IWEDT_USR: TIWEdit [2]
    Left = 24
    Top = 80
    Width = 121
    Height = 21
    Css = 'form-control'
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEDT_USR'
    SubmitOnAsyncEvent = True
    TabOrder = 1
  end
  object IWEDT_PASS: TIWEdit [3]
    Left = 24
    Top = 120
    Width = 121
    Height = 21
    Css = 'form-control'
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEDT_PASS'
    SubmitOnAsyncEvent = True
    TabOrder = 2
    PasswordPrompt = True
  end
  inherited IWTemplateProcessorHTML1: TIWTemplateProcessorHTML
    MasterTemplate = 'IWFRM_Login.html'
    Left = 448
    Top = 328
  end
end
