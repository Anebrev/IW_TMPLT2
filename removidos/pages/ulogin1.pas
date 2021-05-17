unit ulogin1;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompProgressIndicator, IWCompButton, Vcl.Controls,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit,
  IWHTMLControls;

type
  TIWFormLogin = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWEditUserName: TIWEdit;
    IWEditPassword: TIWEdit;
    IWBUTTONLOGIN: TIWButton;
    procedure IWBUTTONLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
  private

  public


  end;
var
  IWFormLogin: TIWFormLogin;


implementation

uses
  ServerController, uIndex1;


{$R *.dfm}


procedure TIWFormLogin.IWAppFormCreate(Sender: TObject);
begin
    IWEditUserName.Text:= 'AND';
    IWEditPassword.Text:= '123456';
end;

procedure TIWFormLogin.IWBUTTONLOGINAsyncClick(Sender: TObject; EventParams: TStringList);
begin

  if IWEditUserName.Text=EmptyStr then
    WebApplication.ShowMessage('Informe o nome do usuário!')
  else if IWEditPassword.Text=EmptyStr then
    WebApplication.ShowMessage('Informe a senha!')
  else
  begin
    IWServerController.MasterTemplate:='IWMasterPage.html';
    UserSession.UserName:=IWEditUserName.Text;
    // Forma simples - cria dinamicamente um "formulário" e já o mostra:
    TIWFRM_Index1.Create(WebApplication).Show;
    // Destrói o formulário atual:
    Release;
  end;
end;

//initialization
//  TIWFormLogin.SetAsMainForm;

end.
