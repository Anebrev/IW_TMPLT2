unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompButton, IWCompLabel, IWCompEdit,
  IWAppForm
  ;


//  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
//  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
//  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
//  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLControls, IWHTMLTag,
//  IWCompLabel;



type
  TIWFRM_Login = class(TIWBase)
    IWBTN_LOGIN: TIWButton;
    IWEDT_USR: TIWEdit;
    IWEDT_PASS: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBTN_LOGINAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    logged: boolean;
  public
    { Public declarations }
  end;

var
  IWFRM_Login: TIWFRM_Login;

implementation
uses
  ServerController, uIndex, uProcessa;

{$R *.dfm}


procedure TIWFRM_Login.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  IWEDT_USR.Text:= 'AND';
  IWEDT_PASS.Text:= '123456';

end;


procedure TIWFRM_Login.IWBTN_LOGINAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;


  if ((IWEDT_USR.Text = EmptyStr) or (IWEDT_PASS.Text = EmptyStr)) then
    begin
      logged:= false;
      WebApplication.ShowMessage('Informe usu�rio e senha!');
    end
    else
      UserSession.DoLogin(IWEDT_USR.Text, IWEDT_PASS.Text);




    if UserSession.LOGGED then
    begin

      //WebApplication.ShowMessage('redirecting user ' +IWEDT_USR.Text+ ' to Login page...');



      TIWFRM_Login(WebApplication.ActiveForm).Release;
      TIWFRM_Index.Create(WebApplication).Show;


      //OLD: without release
      //TIWFRM_Index.Create(WebApplication).Show;


      //TIWAppForm(WebApplication.ActiveForm).release;
      //TIWAppForm(Self).release;
      //Self.Release;

    end;


end;



//initialization
//  TIWFRM_Login.SetAsMainForm;

end.

