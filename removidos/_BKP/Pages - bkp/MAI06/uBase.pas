unit uBase;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLControls, IWHTMLTag,
  IWCompLabel;




type
  TIWBase = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWLabel1: TIWLabel;

    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    procedure prc_Acao(EventParams: TStringList); virtual;

  private

  public
    IdAcao: Integer;
    Acao: string;

  end;


implementation
{$R *.dfm}
uses
  ServerController, UserSessionUnit, uLogin, uIndex, uProcessa, uConsolida;


procedure TIWBase.IWAppFormCreate(Sender: TObject);
begin

  WebApplication.RegisterCallBack('prc_Acao', prc_Acao);

end;



{$REGION 'GOME,LOGOUT'}

{$ENDREGION}



procedure TIWBase.prc_Acao(EventParams: TStringList);
var
  sl: TStringList;
  i, CountParam: Integer;
  s: string;
begin

  sl:= TStringList.Create;
  //CountParam:= 0;


  try

    Acao:= '';
    IdAcao:= 0;
    sl.StrictDelimiter:= true;
    sl.CommaText:= EventParams.Values['Params'];
    s:= sl.CommaText;

    CountParam:= TStringList(sl).Count;


    for i := 0 to Pred(CountParam) do begin

      if i=0 then
        Acao:= sl.ValueFromIndex[i];

      if i=1 then
        IdAcao:= StrToInt(sl.ValueFromIndex[i]);

    end;


    if Acao = 'Logout' then begin

      //WebApplication.ShowMessage('Redirecting to Page Login...');


      TIWFRM_Login(WebApplication.ActiveForm).Release;
      TIWFRM_Login.Create(WebApplication).Show;

      //OLD:
      //self.Release;
      //IWFRM_Login:= TIWFRM_Login.create(Self);
      //IWFRM_Login.Show;

    end;

    if Acao = 'Settings' then begin

      WebApplication.ShowMessage('Opção disponível apenas para o grupo Admin!!');

    end;


    //if Acao = 'frmProcessa' then begin
    if Acao = 'FRM_PROCESSA' then begin

      //WebApplication.ShowMessage('Redirecting to Page PROCESSA...');
      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Processa.Create(WebApplication).Show;



    end;

    if Acao = 'frmConsolida' then begin

      //WebApplication.ShowMessage('Redirecting to Page CONSOLIDA...');
      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Consolida.Create(WebApplication).Show;

    end;





    if Acao = 'H1' then begin

      IWLabel1.Text:= '<h1> Conteúdo H1 </h1>';

    end;


    //Outras opções
    If IdAcao = 1 then begin


    end;



  except

  end;

end;






procedure TIWBase.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin


  if AName = 'User' then
    if Length(UserSession.UserName) > 15 then
      VValue := Copy(UserSession.UserName,1,15)+'...'
    else
      VValue := UpperCase(UserSession.UserName);

  if AName = 'Matricula' then
    VValue := UpperCase(UserSession.IDUsuario);


  //if AName = 'PagePath' then
  //  VValue := 'Home | Processa'; //get PageName from usersession.PageName




  if AName = 'USER_MENU' then   //{%USER_MENU%}
  begin


    VValue := UserSession.getUserMenu;

  end;



end;













//procedure TIWBase.IWBTN_PGPROCESSAAsyncClick(Sender: TObject; EventParams: TStringList);
//begin
//
//  WebApplication.ShowMessage('[uBase] ASYNK - Direcionando para Page PROCESSA!!');
//
//
//  //Load method 1 -- create form on usersession and load when called
//  //TIWAppForm(WebApplication.ActiveForm).Hide;
//  //UserSession.FProcessa.Show;
//
//
//  //Load method 2 - create/Load from uBase
//  //TIWAppForm(WebApplication.ActiveForm).Release;
//  //TIWFRM_Processa.Create(WebApplication).Show;
//
//
//  //Load method 3 -- function call from UserSession
//  //Load from UserSession
//  //UserSession.AcaoMenu('processa');
//
//
//  //Load method 4 - Components
//  htmlPROCESSA:= '<h3>PAGE PROCESSA</h3>';
//
//
//
//  //teste:
//  html:= '....';
//  //TIWFormBase.Create(WebApplication).Show;
//  //WebApplication.ActiveForm.Destroy;
//  //IWFRM_Processa.Show;
//  //Release;
//
//
//end;


//procedure TIWBase.IWBTN_PGCONSOLIDAAsyncClick(Sender: TObject; EventParams: TStringList);
//begin
//
//  WebApplication.ShowMessage('ASYNK - Direcionando para Page CONSOLIDA!!');
//
//  //Method 1
//  //TIWAppForm(WebApplication.ActiveForm).Hide;
//  //IWFRM_Consolida.Show;
//
//  htmlCONSOLIDA:= '<h3>PAGE CONSOLIDA</h3>';
//
//end;


//procedure TIWBase.IWBTN_PGXMLAsyncClick(Sender: TObject;  EventParams: TStringList);
//begin
//
//  WebApplication.ShowMessage('ASYNK - Direcionando para Page GERA XML!!');
//
//end;













//procedure TIWBase.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
//begin
//
//  html := '<div> <h1>injecting html </h1></div>'+SLineBreak;
//  VValue := html;
//  html := '';
//
//end;

//initialization
  //TIWBase.SetAsMainForm;









end.
