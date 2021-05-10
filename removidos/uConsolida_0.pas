//from uformbase Theme2
unit uConsolida_0;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLControls, IWHTMLTag;

type
  TIWFRM_Consolida0 = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    procedure IWLinkClientesAsyncClick(Sender: TObject;
      EventParams: TStringList);
  private

  public
    const
      PAGE_ID = 'FRM_CONSOLIDA';

    procedure DoSelectMenu(EventParams: TStringList);
    procedure DoLogoff(EventParams: TStringList);

  end;

const
  MENU_PROCPPS = 'PROCESSA_PPS';
  MENU_CONSOLIDA = 'CONSOLIDA';

implementation

uses
  ServerController, UserSessionUnit;
  //umain, uLogin,  uProcPPS, uConsolida;

{$R *.dfm}


{ TIWFormBase }

procedure TIWFRM_Consolida0.DoLogoff(EventParams: TStringList);
begin
  //WebApplication.TerminateAndRedirect('http://www.criareinformatica.com.br');
  //TIWFormLogin.Create(WebApplication).Show;
end;

procedure TIWFRM_Consolida0.DoSelectMenu(EventParams: TStringList);
begin


end;

procedure TIWFRM_Consolida0.IWLinkClientesAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  WebApplication.ShowMessage('çink');
end;

end.
