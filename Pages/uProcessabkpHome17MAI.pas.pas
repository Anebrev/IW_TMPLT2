unit uProcessa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton,
  Data.Win.ADODB, IWAppForm, SweetAlerts,
  clsAuxiliar
  ;

type
  TIWFRM_Processa = class(TIWBase)
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    procedure prc_Acao(EventParams: TStringList); override;
  private
    checked: boolean;
    aux: Auxiliar;
    function getStepProgress(typeTAG:string): string;
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
  ServerController, uConsolida;

procedure TIWFRM_Processa.IWAppFormCreate(Sender: TObject);
begin
  inherited;


    UserSession.ActivePage:= PAGE_ID;
    UserSession.frm_title:= FRM_TITLE;
    UserSession.friendlyPageName:= FRIENDLY_NAME;
    checked:= false;
     //IWFRM_Processa.UpdateMode:=  tiwforupdatmode  'umPartial';

end;

function TIWFRM_Processa.getStepProgress(typeTAG:string): string;
var
  html: string;
  moveStep: integer;
begin

  moveStep:= 0;

  if typeTAG='body' then begin

    html:=
    '  <div class="container">                                                             '+sLineBreak+
    '      <div id="stepProgressBar">                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Processamento</p> <div class="bullet">1</div>      '+sLineBreak+
    '          </div>                                                                      '+sLineBreak+
    '          <div class="step">                                                          '+sLineBreak+
    '              <p class="step-text">Consolidação</p> <div class="bullet">2</div>       '+sLineBreak+
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
      '  steps[currentStep - 1].classList.add('+QuotedStr('current')+');                  '+sLineBreak+
      '  bullets[currentStep - 1].classList.add('+QuotedStr('current')+')                 '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  avanca('+moveStep.ToString+');                                                   '+sLineBreak+
      '                                                                                   '+sLineBreak+
      '  //Ativação de botões                                                             '+sLineBreak+
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
      '       //AVANÇA ETAPA                                                              '+sLineBreak+
      '       //Completa atual / desmarca indicação de etapa atual                        '+sLineBreak+
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

procedure TIWFRM_Processa.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
var
  FQue: TADOQuery;
  lintab, html, tabtd, campo: string;
  i: integer;
  chave: string;
begin
  inherited;   //remover e ver se ainda pega o active page

  if AName = 'Step_ProgressBar' then   //{%Step_ProgressBar%}
    VValue := getStepProgress('body');

  if AName = 'Step_ProgressBar_SCRIPT' then   //{%Step_ProgressBar_SCRIPT%}
    VValue := getStepProgress('script');



  if AName = 'Grid' then
  begin


    FQue:=  ServerController.UserSession.DM.ListarProcessos();//Controller.DM.ListarProcessos;

    FQue.First;
    while NOT FQue.eof do
    begin
      chave := trim(FQue.FieldByName('IDPROC').AsInteger.ToString);
      lintab := lintab + ' <tr> '+SLineBreak;
      tabtd:= '<td onclick="javascript:fncExecutar(''Sel'', '''+chave+''');"></td> ' + SLineBreak;

      for i := 0 to FQue.Fields.Count -1 do
      begin
        campo:= FQue.Fields[i].AsString.Trim;
        tabtd:= tabtd + ' <td> '+campo+' </td> '+ SLineBreak;
      end;
      lintab:=lintab + tabtd + ' </tr> '+SLineBreak;
      tabtd:='';
      FQue.Next;
    end;

    html:=
    '<table id="GRID" class="table table-bordered table-striped table-hover" style="width:100%"> '+SLineBreak+
    '    <thead>                                                              '+SLineBreak+
    '        <tr>                                                             '+SLineBreak+
    '            <th style="text-align: center;"></th>                        '+SLineBreak+
    '            <th style="text-align: center;">Processo</th>                '+SLineBreak+
    '            <th style="text-align: center;">Usuario</th>                 '+SLineBreak+
    '            <th style="text-align: center;">Data Processamento</th>      '+SLineBreak+
    '            <th style="text-align: center;">Vigencia Inicial</th>        '+SLineBreak+
    '            <th style="text-align: center;">Vigencia Final</th>          '+SLineBreak+
    '            <th style="text-align: center;">Status</th>                  '+SLineBreak+
    '        </tr>                                                            '+SLineBreak+
    '    </thead>                                                             '+SLineBreak+
    '    <tbody>                                                              '+SLineBreak+
            lintab +
    '    </tbody>                                                             '+SLineBreak+
    ' </table>                                                                '+SLineBreak;

    VValue := html;


    //UserSession.DM.aux1.fechaCon(UserSession.DM.CONN);
    aux.fechaCon(UserSession.DM.CONN);

  end;



end;



procedure TIWFRM_Processa.prc_Acao(EventParams: TStringList);
begin
  inherited;


  if Acao = 'Sel' then begin



    if ( UserSession.GIDPROC=IdAcao.ToString )  then begin
      if checked then begin
        checked:= false;
        UserSession.GIDPROC:= '';
      end;
    end
    else begin
      checked:= true;
      UserSession.GIDPROC:= IdAcao.ToString;
    end;


     //IDPROC.Text := IdAcao;
   end;


  //if Acao = 'Cons' then
  //begin
  //
  // //call consolidação
  // //TIWAppForm(WebApplication.ActiveForm).Release;
  // //TfrmListarAliquotas2.Create(WebApplication).Show;
  //
  //  AddToInitProc(swalError('ATENÇÃO','Selecione um processo para avançar para a próxima etapa.'));
  //  TIWAppForm(WebApplication.ActiveForm).Release;
  //  TIWFRM_Consolida.Create(WebApplication).Show;
  //
  //
  // //prc_Acao('', 0);
  //



    if (Acao = 'Consolidar') then begin


      if UserSession.GIDPROC='' then
        AddToInitProc(swalError('ATENÇÃO','Selecione um processo para avançar para a próxima etapa.'))
        //WebApplication.ShowMessage('Selecione um processo para avançar para a próxima etapa')
      else begin
        TIWAppForm(WebApplication.ActiveForm).Release;
        TIWFRM_Consolida.Create(WebApplication).Show;
      end;

    end;

end;





end.

