unit uReport1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompLabel;


type
  TIWFRM_RPT1 = class(TIWBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  const
      PAGE_ID = 'FRM_RPT1';
      FRM_TITLE = 'SGX - Report "1"';
      FRIENDLY_NAME = 'PPS Report "1"';
  end;

var
  IWFRM_RPT1: TIWFRM_RPT1;

implementation
{$R *.dfm}
uses
  ServerController;

procedure TIWFRM_RPT1.IWAppFormCreate(Sender: TObject);
begin
  inherited;

    UserSession.ActivePage:= PAGE_ID;
    UserSession.frm_title:= FRM_TITLE;
    UserSession.friendlyPageName:= FRIENDLY_NAME;

end;

end.
