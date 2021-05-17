unit uTransmissao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompLabel;

type
  TIWFRM_Transmissao = class(TIWBase)
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    procedure IWAppFormCreate(Sender: TObject);
  private
     function getStepProgress(typeTAG:string): string;
  public
    const
      PAGE_ID = 'FRM_TRANSMISSAO';
      FRM_TITLE = 'SGX - PPS Transmiss�o';
      FRIENDLY_NAME = 'PPS Transmiss�o';
  end;

var
  IWFRM_Transmissao: TIWFRM_Transmissao;

implementation
{$R *.dfm}
uses
  ServerController;


procedure TIWFRM_Transmissao.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  UserSession.ActivePage:= PAGE_ID;
  UserSession.frm_title:= FRM_TITLE;
  UserSession.friendlyPageName:= FRIENDLY_NAME;
end;

procedure TIWFRM_Transmissao.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin
  inherited;


  if AName = 'Step_ProgressBar' then          //{%Step_ProgressBar%}
    VValue := getStepProgress('body');

  if AName = 'Step_ProgressBar_SCRIPT' then   //{%Step_ProgressBar_SCRIPT%}
    VValue := getStepProgress('script');


end;

function TIWFRM_Transmissao.getStepProgress(typeTAG:string): string;
var
  html: string;
  moveStep: integer;
begin

  moveStep:= 3;

  if typeTAG='body' then begin

    html:=
    '  <div class="container">                                                             '+sLineBreak+
    '      <div id="stepProgressBar">                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Processamento</p> <div class="bullet">1</div>      '+sLineBreak+
    '          </div>                                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Consolidacão</p> <div class="bullet">2</div>       '+sLineBreak+
    '          </div>                                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Prévias</p> <div class="bullet">3</div>            '+sLineBreak+
    '          </div>                                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Transmissão SEFAZ</p> <div class="bullet ">4</div> '+sLineBreak+
    '          </div>                                                                      '+sLineBreak+
    '      </div>                                                                          '+sLineBreak+
    '  </div>                                                                              '+sLineBreak
    ;

  end;


  if typeTAG='script' then begin

    html:=
      '<script>                                                                           '+sLineBreak+
      '//const  content  =  document.getElementById('+QuotedStr('content')+';             '+sLineBreak+
      '  const  bullets  =  [...document.querySelectorAll('+QuotedStr('.bullet')+')];     '+sLineBreak+
      '  const  steps  =  [...document.querySelectorAll('+QuotedStr('.step-text')+')];    '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  const MAX_STEPS = 4;                                                             '+sLineBreak+
      '  let currentStep = 1;                                                             '+sLineBreak+
      '  steps[currentStep-1].classList.add('+QuotedStr('current')+');                    '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  avanca('+moveStep.ToString+');                                                   '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  //Ativacao de bot�es                                                             '+sLineBreak+
      '  previousBtn.disabled  = true;                                                    '+sLineBreak+
      '  nextBtn.disabled      = true;                                                    '+sLineBreak+
      '  //finishBtn.disabled    = true;                                                  '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  if (currentStep > 1)  {                                                          '+sLineBreak+
      '    previousBtn.disabled = false;                                                  '+sLineBreak+
      '  };                                                                               '+sLineBreak+
      '  if (currentStep < MAX_STEPS)  {                                                  '+sLineBreak+
      '    nextBtn.disabled = false;                                                      '+sLineBreak+
      '  };                                                                               '+sLineBreak+
      '  //if (currentStep  ===  MAX_STEPS)  {                                            '+sLineBreak+
      '  //  finishBtn.disabled = false;                                                  '+sLineBreak+
      '  //};                                                                             '+sLineBreak+
      '  //content.innerText = `Step Number ${currentStep}`;                              '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  function avanca(qtAvanco){                                                       '+sLineBreak+
      '    debugger;                                                                      '+sLineBreak+
      '    for(var i=1 ; i<=qtAvanco ; i++){                                              '+sLineBreak+
      '       //AVAN�A ETAPA                                                              '+sLineBreak+
      '       //Completa atual / desmarca indica��o de etapa atual                        '+sLineBreak+
      '       bullets[currentStep - 1].classList.add('+QuotedStr('completed')+');         '+sLineBreak+
      '       steps[currentStep - 1].classList.remove('+QuotedStr('current')+');          '+sLineBreak+
      '       //Incrementa indice da etapa / marca como atual:                            '+sLineBreak+
      '       currentStep += 1;                                                           '+sLineBreak+
      '       steps[currentStep-1].classList.add('+QuotedStr('current')+');               '+sLineBreak+
      '       bullets[currentStep - 1].classList.add('+QuotedStr('current')+');           '+sLineBreak+
      '    }                                                                              '+sLineBreak+
      '    //document.write(count+"<br />");                                              '+sLineBreak+
      '  };                                                                               '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '</script>                                                                          '+sLineBreak;


  end;

  Result:= html;

end;



end.

