unit uMain1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWHTMLControls, IWCompMemo, IWCompText,
  uBASE1
  ;

type
  TIWFRM_Main1 = class(TIWFormBase)
    IWT_CONTENT: TIWText;
    IWMemo1: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure prc_Acao(EventParams : TStringList); override;
  end;

var
  IWFRM_Main1: TIWFRM_Main1;

implementation
{$R *.dfm}



procedure TIWFRM_Main1.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  //WebApplication.RegisterCallBack('prc_Acao', prc_Acao);


  IWMemo1.Text:= 'texto sem formatacao';
  IWT_CONTENT.Caption:= IWMemo1.Text;

end;

procedure TIWFRM_Main1.prc_Acao(EventParams : TStringList);
begin

  inherited;


  if Acao = 'Fechar' then begin

    //self.Release;
    //IWFormLogin:= TIWFormLogin.create(Self);
    //IWFormLogin.Show;

  end;


  if Acao = 'InjectContent' then begin

      IWT_CONTENT.RawText:= true;
      IWT_CONTENT.Text:= IWMemo1.Text;
      //'<h1> teste </h1>';

  end;




end;



end.
