object IWFormLogin: TIWFormLogin
  Left = 0
  Top = 0
  Width = 555
  Height = 400
  RenderInvisibleControls = False
  AllowPageAccess = True
  ConnectionMode = cmAny
  Title = 'Gerente Criare - Acesso'
  OnCreate = IWAppFormCreate
  Background.Fixed = False
  LayoutMgr = IWTemplateProcessorHTML1
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  XPTheme = True
  DesignLeft = 2
  DesignTop = 2
  object IWEditUserName: TIWEdit
    Left = 176
    Top = 144
    Width = 209
    Height = 21
    ExtraTagParams.Strings = (
      'placeholder="Digite seu nome de usu'#225'rio"'
      'autofocus')
    Css = 'form-control'
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEditUserName'
    Required = True
    SubmitOnAsyncEvent = True
    TabOrder = 0
  end
  object IWEditPassword: TIWEdit
    Left = 176
    Top = 200
    Width = 121
    Height = 21
    ExtraTagParams.Strings = (
      'placeholder="Digite sua senha"')
    Css = 'form-control'
    NonEditableAsLabel = True
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWEditPassword'
    Required = True
    SubmitOnAsyncEvent = True
    TabOrder = 1
    PasswordPrompt = True
  end
  object IWBUTTONLOGIN: TIWButton
    Left = 176
    Top = 280
    Width = 113
    Height = 25
    ExtraTagParams.Strings = (
      'type=submit')
    Css = 'btn btn-lg btn-primary btn-block'
    Caption = 'Entrar'
    Color = clBtnFace
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    FriendlyName = 'IWBUTTONLOGIN'
    TabOrder = 2
    OnAsyncClick = IWBUTTONLOGINAsyncClick
  end
  object IWTemplateProcessorHTML1: TIWTemplateProcessorHTML
    TagType = ttIntraWeb
    RenderStyles = False
    MasterTemplate = 'IWFormLogin.html'
    Left = 224
    Top = 48
  end
end
