unit uIndex;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWVCLBaseContainer, IWContainer,
  IWHTMLContainer, IWHTML40Container, IWRegion, IWCompText,


  IWAppForm, IWApplication, IWColor, IWTypes,
  IWHTMLControls, IWHTMLTag, IWCompMemo, IWCompCheckbox;



type
  TIWFRM_Index = class(TIWBase)
    BTNH1: TIWButton;
    IWR_PGPROCESSA: TIWRegion;
    IWLabel2: TIWLabel;
    BTNH2: TIWButton;
    IWButton1: TIWButton;
    IWMemo: TIWMemo;
    IWT_CONTENT: TIWText;
    IWCheckBox: TIWCheckBox;
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTNH1AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNH2AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWButton1AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure prc_Acao(EventParams: TStringList); override;
    procedure IWCheckBoxHTMLTag(ASender: TObject; ATag: TIWHTMLTag);

  private
    htmlINDEX:string;//, htmlPROCESSA, htmlCONSOLIDA: string;
  public
    { Public declarations }
  end;

var
  IWFRM_Index: TIWFRM_Index;

const
  PAGE_ID = 'FRM_INDEX';


implementation
{$R *.dfm}
uses
  ServerController, uProcessa, uConsolida;


procedure TIWFRM_Index.IWAppFormCreate(Sender: TObject);
begin
  inherited;


  UserSession.DoLogin('USR', 'PASS');



  htmlINDEX:= '<h1>[uIndex]Form uMain [From Delphi]</h1>';
  //IWMemo.Text:= 'Conteúdo sem formatação';
  IWT_CONTENT.Text:= IWMemo.Text;

  UserSession.ActivePage:= PAGE_ID;

end;


procedure TIWFRM_Index.prc_Acao(EventParams: TStringList);
begin

   inherited;



    if Acao = 'InjectContent' then begin

      IWT_CONTENT.RawText:= IWCheckBox.Checked;
      IWT_CONTENT.Text:= IWMemo.Text;
      //WebApplication.fo



    end;






end;





procedure TIWFRM_Index.BTNH1AsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  IWMemo.Text:= '<h1> Conteúdo H1 </h1>';
end;

procedure TIWFRM_Index.BTNH2AsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  IWMemo.Text:= '<h2> Conteúdo H2 </h2>';
end;

procedure TIWFRM_Index.IWButton1AsyncClick(Sender: TObject; EventParams: TStringList);
begin
  inherited;
  IWMemo.Text:= '<h3> Conteúdo H3 </h3>';
end;

procedure TIWFRM_Index.IWCheckBoxHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  inherited;


  //testar alteração de tag
  //ATag.Add('placeholder="Informe o CNPJ da Empresa"');
  //ATag.Add('data-inputmask="''mask'': ''99.999.999/9999-99''" data-mask');

end;

procedure TIWFRM_Index.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin
  inherited;


  //htmlINDEX:=    '<h1>Form uMain [From Delphi]</h1>'; //testing...


  if AName = 'PG_INDEX' then   // {%PG_INDEX%}
  begin

    VValue := htmlINDEX;
    //Show componentes  //the html will bind the elements {%#%}

  end;


  if AName = 'IWT_CONTENT' then   // {%IWT_CONTENT%}
  begin

    //VValue := '<>' + IWT_CONTENT + <>;

  end;






//  if AName = 'PG_PROCESSA' then   // {%PG_PROCESSA%}
//  begin
//
//    VValue := htmlPROCESSA;
//    //Show componentes
//
//  end;
//
//
//  if AName = 'PG_CONSOLIDA' then   // {%PG_PROCESSA%}
//  begin
//
//    VValue := htmlCONSOLIDA;
//    //Show componentes
//
//  end;

end;





initialization
  TIWFRM_Index.SetAsMainForm;



end.
