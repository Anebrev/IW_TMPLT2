unit uBase;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLControls, IWHTMLTag,
  IWCompLabel //SweetAlerts
  //UserSessionUnit
  //ServerController
  ;




type
  TIWBase = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    IWLabel1: TIWLabel;

    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    procedure prc_Acao(EventParams: TStringList); virtual;

  private
    //fPAGE_ID, fFRM_TITLE, fFRIENDLY_NAME: string;
  public
    IdAcao: string;
    Acao: string;
    //const
      PAGE_ID, FRM_TITLE, FRIENDLY_NAME: string;

    //property PAGE_ID: string read fPAGE_ID write fPAGE_ID;
  end;


implementation
{$R *.dfm}
uses
  ServerController, uLogin, uIndex,
  uProcessa, uConsolida, uPrevia, uTransmissao, uReport1;


procedure TIWBase.IWAppFormCreate(Sender: TObject);
begin

  WebApplication.RegisterCallBack('prc_Acao', prc_Acao);

  //UserSession.ActivePage:= PAGE_ID;
  //UserSession.frm_title:= FRM_TITLE;
  //UserSession.friendlyPageName:= FRIENDLY_NAME;

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

  try

    Acao:= '';
    IdAcao:= '';//0;
    sl.StrictDelimiter:= true;
    sl.CommaText:= EventParams.Values['Params'];
    s:= sl.CommaText;

    CountParam:= TStringList(sl).Count;


    for i := 0 to Pred(CountParam) do begin

      if i=0 then
        Acao:= sl.ValueFromIndex[i];

      if i=1 then
        IdAcao:= sl.ValueFromIndex[i];
        //IdAcao:= StrToInt(sl.ValueFromIndex[i]);

    end;


    if Acao = 'Logout' then begin

      TIWFRM_Login(WebApplication.ActiveForm).Release;
      TIWFRM_Login.Create(WebApplication).Show;

    end;


    if Acao = 'Settings' then begin

      WebApplication.ShowMessage('Opção disponível apenas para o grupo Admin!!');

    end;




    //Form Index
    if ( (Acao = IWFRM_Index.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin

      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Index.Create(WebApplication).Show;

    end;


    //Form Processa
    if ( (Acao = IWFRM_Processa.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin

      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Processa.Create(WebApplication).Show;

    end;


    //Form Consolida **Movido p/ avançar em FRM_PROCESSA
    //if ( (Acao = IWFRM_Consolida.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin
    //
    //  if UserSession.GIDPROC='' then
    //    //AddToInitProc(swalError('ATENÇÃO','Selecione um processo para avançar para a próxima etapa.'))
    //    WebApplication.ShowMessage('Selecione um processo para avançar para a próxima etapa')
    //  else begin
    //    TIWAppForm(WebApplication.ActiveForm).Release;
    //    TIWFRM_Consolida.Create(WebApplication).Show;
    //  end;
    //
    //end;


    //Form Prévias
    if ( (Acao = IWFRM_Previas.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin

      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Previas.Create(WebApplication).Show;

    end;


    //Form Transmissão
    if ( (Acao = IWFRM_Transmissao.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin

      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_Transmissao.Create(WebApplication).Show;

    end;



    //Report 1
    if ( (Acao = IWFRM_RPT1.PAGE_ID) and (UserSession.ActivePage <> Acao) ) then begin

      TIWAppForm(WebApplication.ActiveForm).Release;
      TIWFRM_RPT1.Create(WebApplication).Show;

    end;





    if Acao = 'H1' then begin

      IWLabel1.Text:= '<h1> Conte�do H1 </h1>';

    end;


    //Another options
    If IdAcao = '1' then begin


    end;



  except

  end;

end;






procedure TIWBase.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin


  if AName = 'app_title' then
    VValue := UserSession.frm_title;


  if AName = 'User' then
    if Length(UserSession.UserName) > 15 then
      VValue := Copy(UserSession.UserName,1,15)+'...'
    else
      VValue := UpperCase(UserSession.UserName);


  if AName = 'Matricula' then
    VValue := UpperCase(UserSession.IDUsuario);


  if AName = 'USER_MENU' then   //{%USER_MENU%}
  begin

    VValue := UserSession.getUserMenu;

  end;


  if AName = 'ACTIVE_PAGE' then   //{%ACTIVE_PAGE%}
  begin

    VValue := UserSession.friendlyPageName;

  end;


  if AName = 'form_title' then   //{%form_title%}
  begin

    VValue :=  UserSession.frm_title;

  end;


    //if AName = 'PagePath' then
  //  VValue := 'Home | Processa'; //get PageName from usersession.PageName







end;






//initialization
  //TIWBase.SetAsMainForm;






end.

