unit uProcessa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton;

type
  TIWFRM_Processa = class(TIWBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    const
      PAGE_ID = 'FRM_PROCESSA';
      FRM_TITLE = 'SGX - Tabela PPS';
      FRIENDLY_NAME = 'PPS Processamento';
  end;

var
  IWFRM_Processa: TIWFRM_Processa;



implementation
{$R *.dfm}
uses
  ServerController;

procedure TIWFRM_Processa.IWAppFormCreate(Sender: TObject);
begin
  inherited;


    UserSession.ActivePage:= PAGE_ID;
    UserSession.frm_title:= FRM_TITLE;
    UserSession.friendlyPageName:= FRIENDLY_NAME;

     //IWFRM_Processa.UpdateMode:=  tiwforupdatmode  'umPartial';

end;

end.

