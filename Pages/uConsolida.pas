unit uConsolida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWCompText, IWCompEdit,
  Data.Win.ADODB,
  clsAux, uTag_TR, uTag_TD
  ;

type
  TIWFRM_Consolida = class(TIWBase)
  IWT_DATATABLE: TIWText;
  IWE_Filter: TIWEdit;
  IWL_Status: TIWLabel;
  IWSQL: TIWLabel;
  IWT_MODAL_HIST: TIWText;
  procedure prc_Acao(EventParams: TStringList); override;
  procedure IWAppFormCreate(Sender: TObject);
  procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
  procedure IWAppFormShow(Sender: TObject);

  private
    aux: Auxiliar2;
    html : string;
    ttCols ,tagCol1 , tagCol2 : string;

    function getDataTable(filtro:string): string;
    function getDataTableJSON(): string;
    function getDataTableTH(th:string): string;
    function getDataTableBody1(): string;
    function getDataTableBody2(): string;
    function getDataTableBody3(): string;
    function getStepProgress(typeTAG:string): string;

    procedure ListarAliquotas;
    //procedure Consultar;
    function addTagAliq(qtAlt:integer): string;
    procedure drawModalHist(ID_PRODUTO:string);
    function getGridHist: string;
    function drawChekAlterados: string;

  public
    const
      PAGE_ID = 'FRM_CONSOLIDA';
      FRM_TITLE = 'SGX - PPS Consolida';
      FRIENDLY_NAME = 'PPS Consolidação';
  end;

var
  IWFRM_Consolida: TIWFRM_Consolida;

implementation
{$R *.dfm}
uses
  ServerController;



procedure TIWFRM_Consolida.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  //

  //***IWL_Status.Text:= '';
  //***IWT_DATATABLE.RawText:= true;
  //IWT_DATATABLE.Text:= getDataTableJSON;
  //IWT_DATATABLE.Text:= getDataTable('');

  UserSession.ActivePage:= PAGE_ID;
  UserSession.frm_title:= FRM_TITLE;
  UserSession.friendlyPageName:= FRIENDLY_NAME;

  //IWT_DATATABLE.Text:= '';
  //IWT_MODAL_HIST.Text:= '';

  //ListarAliquotas;

end;

procedure TIWFRM_Consolida.IWAppFormShow(Sender: TObject);
begin

  IWT_MODAL_HIST.Text:= ' ';
  ListarAliquotas;

end;

function TIWFRM_Consolida.getStepProgress(typeTAG:string): string;
var
  html: string;
  moveStep: integer;
begin

  moveStep:= 1;

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
      '  steps[currentStep-1].classList.add('+QuotedStr('current')+');                    '+sLineBreak+
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

procedure TIWFRM_Consolida.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin
  inherited;



  if AName = 'Step_ProgressBar' then          //{%Step_ProgressBar%}
    VValue := getStepProgress('body');

  if AName = 'Step_ProgressBar_SCRIPT' then   //{%Step_ProgressBar_SCRIPT%}
    VValue := getStepProgress('script');



  if AName = 'IW_CHKALTERADOS' then begin  //{%IW_CHKALTERADOS%}

    VValue:= drawChekAlterados;

  end;





   if AName ='IWT_DATATABLE' then
   begin
      VValue:= '<h1> teste </h1>';
   end;


end;


procedure TIWFRM_Consolida.prc_Acao(EventParams: TStringList);
var
  filtro: string;
begin

  inherited;



  if Acao = 'Hist' then begin
    drawModalHist(IdAcao);
  end;



  if Acao = 'filtraConsolidacao' then begin

    UserSession.DM.filtroConsolidacao:=  IdAcao;
    ListarAliquotas;

  end;







  filtro:= IWE_Filter.Text;

  if Acao = 'ProcDataTable' then begin

    //IWT_DATATABLE.RawText:= true;
    IWL_Status.Text:= 'Loading DataTable...';
    //IWT_DATATABLE.Text:= 'Loading---...'; //create function to load some secs
    //sleep(5000);
    //WebApplication.ShowMessage('Limpando html datatable...');
    IWT_DATATABLE.Text:= getDataTable(filtro);
    //IWT_DATATABLE.Text:= getDataTableJSON;
    IWL_Status.Text:= '';

  end;

  if Acao = 'ProcDataTable_Json' then begin
    //gera novo json base filtros da consulta
    IWT_DATATABLE.Text:= getDataTableJSON();
  end;


end;

function TIWFRM_Consolida.getDataTableTH(th:string): string;
var
  th1, th2: string;
begin

 th1:=
  '          <tr>                                            '+sLineBreak+
  '              <th>ID</th>                                 '+sLineBreak+
  '              <th>Field1</th>                             '+sLineBreak+
  '              <th>Field2</th>                             '+sLineBreak+
  '              <th>Field3</th>                             '+sLineBreak+
  '          </tr>                                           '+sLineBreak;



  th2:=
  '          <tr>                                            '+sLineBreak+
  '              <th rowspan="2">Name</th>                   '+sLineBreak+
  '              <th colspan="2">HR Information</th>         '+sLineBreak+
  '              <th colspan="3">Contact</th>                '+sLineBreak+
  '          </tr>                                           '+sLineBreak+
  '          <tr>                                            '+sLineBreak+
  '              <th>Position</th>                           '+sLineBreak+
  '              <th>Salary</th>                             '+sLineBreak+
  '              <th>Office</th>                             '+sLineBreak+
  '              <th>Extn.</th>                              '+sLineBreak+
  '              <th>E-mail</th>                             '+sLineBreak+
  '          </tr>                                           '+sLineBreak
  ;


  if th='th1' then
     Result:= th1
  else
     Result:= th2;

end;

function TIWFRM_Consolida.getDataTableBody1(): string;
begin

  Result:=
  '          <tr>                                                 '+sLineBreak+
  '              <td>Tiger Nixon</td>                             '+sLineBreak+
  '              <td>System Architect</td>                        '+sLineBreak+
  '              <td>$320,800</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>5421</td>                                    '+sLineBreak+
  '              <td>t.nixon@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Garrett Winters</td>                         '+sLineBreak+
  '              <td>Accountant</td>                              '+sLineBreak+
  '              <td>$170,750</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>8422</td>                                    '+sLineBreak+
  '              <td>g.winters@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Ashton Cox</td>                              '+sLineBreak+
  '              <td>Junior Technical Author</td>                 '+sLineBreak+
  '              <td>$86,000</td>                                 '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>1562</td>                                    '+sLineBreak+
  '              <td>a.cox@datatables.net</td>                    '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Cedric Kelly</td>                            '+sLineBreak+
  '              <td>Senior Javascript Developer</td>             '+sLineBreak+
  '              <td>$433,060</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>6224</td>                                    '+sLineBreak+
  '              <td>c.kelly@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Airi Satou</td>                              '+sLineBreak+
  '              <td>Accountant</td>                              '+sLineBreak+
  '              <td>$162,700</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>5407</td>                                    '+sLineBreak+
  '              <td>a.satou@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Brielle Williamson</td>                      '+sLineBreak+
  '              <td>Integration Specialist</td>                  '+sLineBreak+
  '              <td>$372,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>4804</td>                                    '+sLineBreak+
  '              <td>b.williamson@datatables.net</td>             '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Herrod Chandler</td>                         '+sLineBreak+
  '              <td>Sales Assistant</td>                         '+sLineBreak+
  '              <td>$137,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>9608</td>                                    '+sLineBreak+
  '              <td>h.chandler@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Rhona Davidson</td>                          '+sLineBreak+
  '              <td>Integration Specialist</td>                  '+sLineBreak+
  '              <td>$327,900</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>6200</td>                                    '+sLineBreak+
  '              <td>r.davidson@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Colleen Hurst</td>                           '+sLineBreak+
  '              <td>Javascript Developer</td>                    '+sLineBreak+
  '              <td>$205,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>2360</td>                                    '+sLineBreak+
  '              <td>c.hurst@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Sonya Frost</td>                             '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$103,600</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>1667</td>                                    '+sLineBreak+
  '              <td>s.frost@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jena Gaines</td>                             '+sLineBreak+
  '              <td>Office Manager</td>                          '+sLineBreak+
  '              <td>$90,560</td>                                 '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>3814</td>                                    '+sLineBreak+
  '              <td>j.gaines@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Quinn Flynn</td>                             '+sLineBreak+
  '              <td>Support Lead</td>                            '+sLineBreak+
  '              <td>$342,000</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>9497</td>                                    '+sLineBreak+
  '              <td>q.flynn@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Charde Marshall</td>                         '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$470,600</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>6741</td>                                    '+sLineBreak+
  '              <td>c.marshall@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Haley Kennedy</td>                           '+sLineBreak+
  '              <td>Senior Marketing Designer</td>               '+sLineBreak+
  '              <td>$313,500</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>3597</td>                                    '+sLineBreak+
  '              <td>h.kennedy@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Tatyana Fitzpatrick</td>                     '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$385,750</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>1965</td>                                    '+sLineBreak+
  '              <td>t.fitzpatrick@datatables.net</td>            '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Michael Silva</td>                           '+sLineBreak+
  '              <td>Marketing Designer</td>                      '+sLineBreak+
  '              <td>$198,500</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>1581</td>                                    '+sLineBreak+
  '              <td>m.silva@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Paul Byrd</td>                               '+sLineBreak+
  '              <td>Chief Financial Officer (CFO)</td>           '+sLineBreak+
  '              <td>$725,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>3059</td>                                    '+sLineBreak+
  '              <td>p.byrd@datatables.net</td>                   '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Gloria Little</td>                           '+sLineBreak+
  '              <td>Systems Administrator</td>                   '+sLineBreak+
  '              <td>$237,500</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>1721</td>                                    '+sLineBreak+
  '              <td>g.little@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Bradley Greer</td>                           '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$132,000</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>2558</td>                                    '+sLineBreak+
  '              <td>b.greer@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Dai Rios</td>                                '+sLineBreak+
  '              <td>Personnel Lead</td>                          '+sLineBreak+
  '              <td>$217,500</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>2290</td>                                    '+sLineBreak+
  '              <td>d.rios@datatables.net</td>                   '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jenette Caldwell</td>                        '+sLineBreak+
  '              <td>Development Lead</td>                        '+sLineBreak+
  '              <td>$345,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>1937</td>                                    '+sLineBreak+
  '              <td>j.caldwell@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Yuri Berry</td>                              '+sLineBreak+
  '              <td>Chief Marketing Officer (CMO)</td>           '+sLineBreak+
  '              <td>$675,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>6154</td>                                    '+sLineBreak+
  '              <td>y.berry@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Caesar Vance</td>                            '+sLineBreak+
  '              <td>Pre-Sales Support</td>                       '+sLineBreak+
  '              <td>$106,450</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>8330</td>                                    '+sLineBreak+
  '              <td>c.vance@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Doris Wilder</td>                            '+sLineBreak+
  '              <td>Sales Assistant</td>                         '+sLineBreak+
  '              <td>$85,600</td>                                 '+sLineBreak+
  '              <td>Sydney</td>                                  '+sLineBreak+
  '              <td>3023</td>                                    '+sLineBreak+
  '              <td>d.wilder@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Angelica Ramos</td>                          '+sLineBreak+
  '              <td>Chief Executive Officer (CEO)</td>           '+sLineBreak+
  '              <td>$1,200,000</td>                              '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>5797</td>                                    '+sLineBreak+
  '              <td>a.ramos@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Gavin Joyce</td>                             '+sLineBreak+
  '              <td>Developer</td>                               '+sLineBreak+
  '              <td>$92,575</td>                                 '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>8822</td>                                    '+sLineBreak+
  '              <td>g.joyce@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jennifer Chang</td>                          '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$357,650</td>                                '+sLineBreak+
  '              <td>Singapore</td>                               '+sLineBreak+
  '              <td>9239</td>                                    '+sLineBreak+
  '              <td>j.chang@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Brenden Wagner</td>                          '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$206,850</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>1314</td>                                    '+sLineBreak+
  '              <td>b.wagner@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Fiona Green</td>                             '+sLineBreak+
  '              <td>Chief Operating Officer (COO)</td>           '+sLineBreak+
  '              <td>$850,000</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>2947</td>                                    '+sLineBreak+
  '              <td>f.green@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Shou Itou</td>                               '+sLineBreak+
  '              <td>Regional Marketing</td>                      '+sLineBreak+
  '              <td>$163,000</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>8899</td>                                    '+sLineBreak+
  '              <td>s.itou@datatables.net</td>                   '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Michelle House</td>                          '+sLineBreak+
  '              <td>Integration Specialist</td>                  '+sLineBreak+
  '              <td>$95,400</td>                                 '+sLineBreak+
  '              <td>Sydney</td>                                  '+sLineBreak+
  '              <td>2769</td>                                    '+sLineBreak+
  '              <td>m.house@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Suki Burks</td>                              '+sLineBreak+
  '              <td>Developer</td>                               '+sLineBreak+
  '              <td>$114,500</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>6832</td>                                    '+sLineBreak+
  '              <td>s.burks@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Prescott Bartlett</td>                       '+sLineBreak+
  '              <td>Technical Author</td>                        '+sLineBreak+
  '              <td>$145,000</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>3606</td>                                    '+sLineBreak+
  '              <td>p.bartlett@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Gavin Cortez</td>                            '+sLineBreak+
  '              <td>Team Leader</td>                             '+sLineBreak+
  '              <td>$235,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>2860</td>                                    '+sLineBreak+
  '              <td>g.cortez@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Martena Mccray</td>                          '+sLineBreak+
  '              <td>Post-Sales support</td>                      '+sLineBreak+
  '              <td>$324,050</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>8240</td>                                    '+sLineBreak+
  '              <td>m.mccray@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Unity Butler</td>                            '+sLineBreak+
  '              <td>Marketing Designer</td>                      '+sLineBreak+
  '              <td>$85,675</td>                                 '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>5384</td>                                    '+sLineBreak+
  '              <td>u.butler@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Howard Hatfield</td>                         '+sLineBreak+
  '              <td>Office Manager</td>                          '+sLineBreak+
  '              <td>$164,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>7031</td>                                    '+sLineBreak+
  '              <td>h.hatfield@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Hope Fuentes</td>                            '+sLineBreak+
  '              <td>Secretary</td>                               '+sLineBreak+
  '              <td>$109,850</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>6318</td>                                    '+sLineBreak+
  '              <td>h.fuentes@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Vivian Harrell</td>                          '+sLineBreak+
  '              <td>Financial Controller</td>                    '+sLineBreak+
  '              <td>$452,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>9422</td>                                    '+sLineBreak+
  '              <td>v.harrell@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Timothy Mooney</td>                          '+sLineBreak+
  '              <td>Office Manager</td>                          '+sLineBreak+
  '              <td>$136,200</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>7580</td>                                    '+sLineBreak+
  '              <td>t.mooney@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jackson Bradshaw</td>                        '+sLineBreak+
  '              <td>Director</td>                                '+sLineBreak+
  '              <td>$645,750</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>1042</td>                                    '+sLineBreak+
  '              <td>j.bradshaw@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Olivia Liang</td>                            '+sLineBreak+
  '              <td>Support Engineer</td>                        '+sLineBreak+
  '              <td>$234,500</td>                                '+sLineBreak+
  '              <td>Singapore</td>                               '+sLineBreak+
  '              <td>2120</td>                                    '+sLineBreak+
  '              <td>o.liang@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Bruno Nash</td>                              '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$163,500</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>6222</td>                                    '+sLineBreak+
  '              <td>b.nash@datatables.net</td>                   '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Sakura Yamamoto</td>                         '+sLineBreak+
  '              <td>Support Engineer</td>                        '+sLineBreak+
  '              <td>$139,575</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>9383</td>                                    '+sLineBreak+
  '              <td>s.yamamoto@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Thor Walton</td>                             '+sLineBreak+
  '              <td>Developer</td>                               '+sLineBreak+
  '              <td>$98,540</td>                                 '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>8327</td>                                    '+sLineBreak+
  '              <td>t.walton@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Finn Camacho</td>                            '+sLineBreak+
  '              <td>Support Engineer</td>                        '+sLineBreak+
  '              <td>$87,500</td>                                 '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>2927</td>                                    '+sLineBreak+
  '              <td>f.camacho@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Serge Baldwin</td>                           '+sLineBreak+
  '              <td>Data Coordinator</td>                        '+sLineBreak+
  '              <td>$138,575</td>                                '+sLineBreak+
  '              <td>Singapore</td>                               '+sLineBreak+
  '              <td>8352</td>                                    '+sLineBreak+
  '              <td>s.baldwin@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Zenaida Frank</td>                           '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$125,250</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>7439</td>                                    '+sLineBreak+
  '              <td>z.frank@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Zorita Serrano</td>                          '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$115,000</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>4389</td>                                    '+sLineBreak+
  '              <td>z.serrano@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jennifer Acosta</td>                         '+sLineBreak+
  '              <td>Junior Javascript Developer</td>             '+sLineBreak+
  '              <td>$75,650</td>                                 '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>3431</td>                                    '+sLineBreak+
  '              <td>j.acosta@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Cara Stevens</td>                            '+sLineBreak+
  '              <td>Sales Assistant</td>                         '+sLineBreak+
  '              <td>$145,600</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>3990</td>                                    '+sLineBreak+
  '              <td>c.stevens@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Hermione Butler</td>                         '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$356,250</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>1016</td>                                    '+sLineBreak+
  '              <td>h.butler@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Lael Greer</td>                              '+sLineBreak+
  '              <td>Systems Administrator</td>                   '+sLineBreak+
  '              <td>$103,500</td>                                '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>6733</td>                                    '+sLineBreak+
  '              <td>l.greer@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jonas Alexander</td>                         '+sLineBreak+
  '              <td>Developer</td>                               '+sLineBreak+
  '              <td>$86,500</td>                                 '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>8196</td>                                    '+sLineBreak+
  '              <td>j.alexander@datatables.net</td>              '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '              <td>Shad Decker</td>                             '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$183,000</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>6373</td>                                    '+sLineBreak+
  '              <td>s.decker@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Michael Bruce</td>                           '+sLineBreak+
  '              <td>Javascript Developer</td>                    '+sLineBreak+
  '              <td>$183,000</td>                                '+sLineBreak+
  '              <td>Singapore</td>                               '+sLineBreak+
  '              <td>5384</td>                                    '+sLineBreak+
  '              <td>m.bruce@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Donna Snider</td>                            '+sLineBreak+
  '              <td>Customer Support</td>                        '+sLineBreak+
  '              <td>$112,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>4226</td>                                    '+sLineBreak+
  '              <td>d.snider@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak
  ;

end;

function TIWFRM_Consolida.getDataTableBody2(): string;
begin

  Result:=
  '          <tr>                                                 '+sLineBreak+
  '              <td>Tiger Nixon</td>                             '+sLineBreak+
  '              <td>System Architect</td>                        '+sLineBreak+
  '              <td>$320,800</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>5421</td>                                    '+sLineBreak+
  '              <td>t.nixon@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Garrett Winters</td>                         '+sLineBreak+
  '              <td>Accountant</td>                              '+sLineBreak+
  '              <td>$170,750</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>8422</td>                                    '+sLineBreak+
  '              <td>g.winters@datatables.net</td>                '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Ashton Cox</td>                              '+sLineBreak+
  '              <td>Junior Technical Author</td>                 '+sLineBreak+
  '              <td>$86,000</td>                                 '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>1562</td>                                    '+sLineBreak+
  '              <td>a.cox@datatables.net</td>                    '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Cedric Kelly</td>                            '+sLineBreak+
  '              <td>Senior Javascript Developer</td>             '+sLineBreak+
  '              <td>$433,060</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>6224</td>                                    '+sLineBreak+
  '              <td>c.kelly@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Airi Satou</td>                              '+sLineBreak+
  '              <td>Accountant</td>                              '+sLineBreak+
  '              <td>$162,700</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>5407</td>                                    '+sLineBreak+
  '              <td>a.satou@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Brielle Williamson</td>                      '+sLineBreak+
  '              <td>Integration Specialist</td>                  '+sLineBreak+
  '              <td>$372,000</td>                                '+sLineBreak+
  '              <td>New York</td>                                '+sLineBreak+
  '              <td>4804</td>                                    '+sLineBreak+
  '              <td>b.williamson@datatables.net</td>             '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Herrod Chandler</td>                         '+sLineBreak+
  '              <td>Sales Assistant</td>                         '+sLineBreak+
  '              <td>$137,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>9608</td>                                    '+sLineBreak+
  '              <td>h.chandler@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Rhona Davidson</td>                          '+sLineBreak+
  '              <td>Integration Specialist</td>                  '+sLineBreak+
  '              <td>$327,900</td>                                '+sLineBreak+
  '              <td>Tokyo</td>                                   '+sLineBreak+
  '              <td>6200</td>                                    '+sLineBreak+
  '              <td>r.davidson@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Colleen Hurst</td>                           '+sLineBreak+
  '              <td>Javascript Developer</td>                    '+sLineBreak+
  '              <td>$205,500</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>2360</td>                                    '+sLineBreak+
  '              <td>c.hurst@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Sonya Frost</td>                             '+sLineBreak+
  '              <td>Software Engineer</td>                       '+sLineBreak+
  '              <td>$103,600</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>1667</td>                                    '+sLineBreak+
  '              <td>s.frost@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Jena Gaines</td>                             '+sLineBreak+
  '              <td>Office Manager</td>                          '+sLineBreak+
  '              <td>$90,560</td>                                 '+sLineBreak+
  '              <td>London</td>                                  '+sLineBreak+
  '              <td>3814</td>                                    '+sLineBreak+
  '              <td>j.gaines@datatables.net</td>                 '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Quinn Flynn</td>                             '+sLineBreak+
  '              <td>Support Lead</td>                            '+sLineBreak+
  '              <td>$342,000</td>                                '+sLineBreak+
  '              <td>Edinburgh</td>                               '+sLineBreak+
  '              <td>9497</td>                                    '+sLineBreak+
  '              <td>q.flynn@datatables.net</td>                  '+sLineBreak+
  '          </tr>                                                '+sLineBreak+
  '          <tr>                                                 '+sLineBreak+
  '              <td>Charde Marshall</td>                         '+sLineBreak+
  '              <td>Regional Director</td>                       '+sLineBreak+
  '              <td>$470,600</td>                                '+sLineBreak+
  '              <td>San Francisco</td>                           '+sLineBreak+
  '              <td>6741</td>                                    '+sLineBreak+
  '              <td>c.marshall@datatables.net</td>               '+sLineBreak+
  '          </tr>                                                '+sLineBreak;

end;

function TIWFRM_Consolida.getDataTableBody3(): string;
begin

  Result:=
  '         <tr>                                                  '+
  '              <td>Tiger Nixon</td>                             '+
  '              <td>System Architect</td>                        '+
  '              <td>$320,800</td>                                '+
  '              <td>Edinburgh</td>                               '+
  '              <td>5421</td>                                    '+
  '              <td>t.nixon@datatables.net</td>                  '+
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>Garrett Winters</td>                         '+
  '              <td>Accountant</td>                              '+
  '              <td>$170,750</td>                                '+
  '              <td>Tokyo</td>                                   '+
  '              <td>8422</td>                                    '+
  '              <td>g.winters@datatables.net</td>                '+
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '+
  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +

  '          <tr>                                                 '+
  '              <td>aa1</td><td>aa2</td><td>aa3</td><td>aa4</td><td>aa5</td><td>aa6</td>' +
  '          </tr>                                                '
  ;

end;

function TIWFRM_Consolida.getDataTable(filtro:string): string;
var
  html:string;
begin

  html:=
  '<div class="container mb-3 mt-3">                                                     '+sLineBreak+
  '    <table id="DTB_TAG" class="table table-bordered table-striped table-hover">       '+sLineBreak+
//'    <table class="table table-striped table-bordered mydatatable" style="width:100%"> '+sLineBreak+
  '      <thead>                                                                         '+sLineBreak+
  '         '+getDataTableTH('th2')+
  '      </thead>                                                                        '+sLineBreak+
  '      <tbody>                                                                         '+sLineBreak;


  if (length(filtro) > 0) then
    html:= html + getDataTableBody2()
  else
    html:= html + getDataTableBody1();


  if (filtro='body3') then
    html:= html + getDataTableBody3();


  html:= html +
  '      </tbody>                                                                        '+sLineBreak+
  '      <tfoot>                                                                         '+sLineBreak+
  '      </tfoot>                                                                        '+sLineBreak+
  '    </table>                                                                          '+sLineBreak+
  '</div>                                                                                '+sLineBreak
  ;

  aux:= Auxiliar2.Create();
  aux.saveTXT(html, 'dataTable_TAG.html');

  Result:= html;

end;

function TIWFRM_Consolida.getDataTableJSON(): string;
var
  html:string;
begin


  html:=
  '<div class="container mb-3 mt-3">                                                     '+
  '    <table class="table table-striped table-bordered mydatatable" style="width:100%"> '+
  '      <thead>                                                                         '+
  '         '+getDataTableTH('th1')+
  '      </thead>                                                                        '+
  '      <tfoot>                                                                         '+
  '      </tfoot>                                                                        '+
  '    </table>                                                                          '+
  '  </div>                                                                              '
  ;

  Result:= html;

end;





function TIWFRM_Consolida.addTagAliq(qtAlt:integer): string;
var
  span: string;
begin

  if qtAlt >=50 then begin
     span:= '<span class="numberCircle clrRed"><span>' + qtAlt.ToString +'</span></span>';
  end;

  if qtAlt <50 then begin
     span:= '<span class="numberCircle clrOrange"><span>' + qtAlt.ToString +'</span></span>';
  end;

  if qtAlt <10 then begin
     span:= '<span class="numberCircle clrBlueciel"><span>' + qtAlt.ToString +'</span></span>';
  end;


  Result:= span;

end;

procedure TIWFRM_Consolida.ListarAliquotas;
var
  //i, linTemAlt: Integer;
  colspan, aliq, tipo: string;
  tabela: string; //tagCol3
  lQue, lQue2, lQue3: TADOQuery;
  campo: string;
  tabtd: string;
  IDP_CDE_CDP: string; //IDProcesso + Cod.Empresa + Cod.Produto
  qtAlteracao: string;

  colorClass:string;
  tHeadClass:string;

  KEY_LINE, KEY_LINE_OLD: string;
  ALIQ_Line, TP_Line, ID_COL, VALOR: string;
  QT_COL: integer;

  TR_Dinamica: TTag_TR;
  TD: TTag_TD;
begin


  tHeadClass:= 'thBlue';

  { Obtendo o total de colunas... }
  ttCols := UserSession.DM.GetTotalColunas2.ToString;
  { Obtendo lista de colunas por aliquota... }
  lQue   := UserSession.DM.ListTotColunasPorAliquota;
  { Obtendo lista de registros... }
  lQue2  := UserSession.DM.ListColunasPorAliquota;


  { Montando colunas por aliquota...  }
  tagCol1:='';
  colspan:='';
  lQue.First;
  while not lQue.Eof do
  begin
    colspan := lQue.FieldByName('TOTAL').AsString;
    aliq    := lQue.FieldByName('PPSICM').AsString;
    qtAlteracao:= lQue.FieldByName('QTALT').AsString; //UserSession.DM.qtAltAliq(StrToFloat(aliq)).ToString;
    tagCol1 := tagCol1 +
    '       <th colspan="'+colspan+'" id="fitPadLL">'+
            aliq.Replace(',','.')+addTagAliq(StrToInt(qtAlteracao))+' </th> '+SLineBreak;
    lQue.Next;



  end;
  lQue.Close;

  tagCol1 := tagCol1 + '       <th rowspan="2" colspan="1" id="fitPad">Ações</th> '+SLineBreak;


  { Montando colunas por tipo...  }
  TR_Dinamica:= TTag_TR.Create; // TR dos campos dinamicos
  TR_Dinamica.ListaTD.Clear;
  tagCol2:='';
  lQue2.First;
  while not lQue2.Eof do
  begin
    aliq := lQue2.FieldByName('CAMPO').AsString;
    tipo := lQue2.FieldByName('VALOR').AsString;
    tagCol2 := tagCol2 + '       <th style="text-align: center;">'+tipo+'</th> '+SLineBreak;

    //tagCol2 := tagCol2 + '       <th style="text-align: center;">'+aliq+'</th> '+SLineBreak;
    //aliq := lQue2.FieldByName('VALOR').AsString;
    //tagCol2 := tagCol2 + '       <th style="text-align: center;">'+aliq+'</th> '+SLineBreak;
    lQue2.Next;

    ID_COL:= concat('a', aliq, tipo);
    TR_Dinamica.AddTadTD(ID_COL, '', '-null-');

  end;





  { Listando os registros... }
  lQue3 := UserSession.DM.ListarAliquotas2(); //old: ListarAliquotas()
  tabela:='';
  KEY_LINE_OLD:= 'start';
  QT_COL:= 0;


  lQue3.First;
  while NOT lQue3.Eof do
  begin


    {Chave da linha}
    KEY_LINE:= lQue3.FieldByName('KEY_LINE').AsString;


    if ( KEY_LINE_OLD='start')  then begin

      {-----------------------------------------------------------------------------------------------}
      { CAMPOS CHAVE ---------------------------------------------------------------------------------}
      {-----------------------------------------------------------------------------------------------}
      tabtd:='';
      QT_COL:= 0;
      campo:= lQue3.FieldByName('PPSPRD').AsString.Trim;
      tabtd:= tabtd +
      '       <td id="fitPad"> '+campo+' </td> ';
      campo:= lQue3.FieldByName('PPSVIGINI').AsString.Trim;
      campo:= Concat(Copy(campo,7,2),'/',Copy(campo,5,2),'/',Copy(campo,1,4)); //YYYYMMDD -> DD/MM/YYYY
      tabtd:= tabtd + ' <td id="fitPad"> '+campo+' </td> ';
      campo:= lQue3.FieldByName('PPSVIGFIM').AsString.Trim;
      campo:= Concat(Copy(campo,7,2),'/',Copy(campo,5,2),'/',Copy(campo,1,4)); //YYYYMMDD -> DD/MM/YYYY
      tabtd:= tabtd + ' <td id="fitPad"> '+campo+' </td> '+ SLineBreak+
      '       ';

      {chave para o botao historico}
      IDP_CDE_CDP := trim(lQue3.FieldByName('PPSID').AsString)+
                    lQue3.FieldByName('PPSEMP').AsString+
                    trim(lQue3.FieldByName('PPSPRD').AsString)+
                    lQue3.FieldByName('PPSVIGINI').AsString +
                    lQue3.FieldByName('PPSVIGFIM').AsString;  // Result : '1HDJFT2021032220211231'

    end;


      {-----------------------------------------------------------------------------------------------}
      { ADD VALORES, ACOES E FINALIZA LINHA ----------------------------------------------------------}
      {-----------------------------------------------------------------------------------------------}
      if ( (KEY_LINE<>KEY_LINE_OLD) and not (KEY_LINE_OLD='start') ) then begin

        {Add TD's}
        for TD in TR_Dinamica.ListaTD do begin

          tabtd:= tabtd +
          '<td id="fitPad" class="'+TD.CalssTag+'"> '+TD.ValueTag+' </td>  ';

        end;


        {Add botao historico}
        tabtd := tabtd + SLineBreak +
        '       <td id="fitPad"> ' + SLineBreak +
        '         <a title="Historico" href="javascript:fncExecutar(''Hist'', '''+IDP_CDE_CDP+''');"> '+SLineBreak+
        '           <i class="fa fa-clock-o fa-lg" aria-hidden="true"></i> '+SLineBreak+
        '         </a> '+SLineBreak+
        '       </td> '+SLineBreak;


        {Finaliza linha}
        tabela := tabela +
        '     <tr>                '+SLineBreak+
                tabtd +
        '     </tr>               '+SLineBreak;




        {reset line}
        {-----------------------------------------------------------------------------------------------}
        { CAMPOS CHAVE ---------------------------------------------------------------------------------}
        {-----------------------------------------------------------------------------------------------}
        tabtd:='';
        QT_COL:= 0;
        campo:= lQue3.FieldByName('PPSPRD').AsString.Trim;
        tabtd:= tabtd +
        '       <td id="fitPad"> '+campo+' </td> ';
        campo:= lQue3.FieldByName('PPSVIGINI').AsString.Trim;
        campo:= Concat(Copy(campo,7,2),'/',Copy(campo,5,2),'/',Copy(campo,1,4)); //YYYYMMDD -> DD/MM/YYYY
        tabtd:= tabtd + ' <td id="fitPad"> '+campo+' </td> ';
        campo:= lQue3.FieldByName('PPSVIGFIM').AsString.Trim;
        campo:= Concat(Copy(campo,7,2),'/',Copy(campo,5,2),'/',Copy(campo,1,4)); //YYYYMMDD -> DD/MM/YYYY
        tabtd:= tabtd + ' <td id="fitPad"> '+campo+' </td> '+ SLineBreak+
        '       ';

        {chave para o botao historico}
        IDP_CDE_CDP := trim(lQue3.FieldByName('PPSID').AsString)+
                      lQue3.FieldByName('PPSEMP').AsString+
                      trim(lQue3.FieldByName('PPSPRD').AsString)+
                      lQue3.FieldByName('PPSVIGINI').AsString +
                      lQue3.FieldByName('PPSVIGFIM').AsString;  // Result : '1HDJFT2021032220211231'

    end;




    {-----------------------------------------------------------------------------------------------}
    { CAMPOS DINÂMICOS (valores) -------------------------------------------------------------------}
    {-----------------------------------------------------------------------------------------------}
    QT_COL:= QT_COL + 1;
    //ID Coluna
    ALIQ_Line := lQue3.FieldByName('ALIQ').AsString.Replace(',','');
    TP_Line   := lQue3.FieldByName('TP').AsString.trim;
    ID_COL    := concat('a', ALIQ_Line, TP_Line);
    VALOR     := FloatToStrF(lQue3.FieldByName('PRC').AsFloat, ffNumber, 15, 0);

    //Destaca alterado
    colorClass:= '';
    If lQue3.FieldByName('QTALT').AsInteger > 0 then
      colorClass:= 'hasChange';

    campo:= VALOR;

    //*****@@@tabtd:= tabtd +
    //*****@@@'<td id="fitPad" class="'+colorClass+'"> '+campo+' </td>  ';


    {Atualiza valores do Campo dinâmico }
    for TD in TR_Dinamica.ListaTD do begin

      if TD.IDTag = ID_COL then begin
        TD.CalssTag:= colorClass;
        TD.ValueTag:= campo;
      end;

    end;



    if lQue3.RecNo = lQue3.RecordCount then begin

        {Add TD's}
        for TD in TR_Dinamica.ListaTD do begin

          tabtd:= tabtd +
          '<td id="fitPad" class="'+TD.CalssTag+'"> '+TD.ValueTag+' </td>  ';

        end;


        {Add botao historico}
        tabtd := tabtd + SLineBreak +
        '       <td id="fitPad"> ' + SLineBreak +
        '         <a title="Historico" href="javascript:fncExecutar(''Hist'', '''+IDP_CDE_CDP+''');"> '+SLineBreak+
        '           <i class="fa fa-clock-o fa-lg" aria-hidden="true"></i> '+SLineBreak+
        '         </a> '+SLineBreak+
        '       </td> '+SLineBreak;


        {Finaliza linha}
        tabela := tabela +
        '     <tr>                '+SLineBreak+
                tabtd +
        '     </tr>               '+SLineBreak;

    end;





    KEY_LINE_OLD:= KEY_LINE;
    lQue3.Next;
   end;




  { guardando resultado da sql...}
  IWSQL.Text := lQue3.SQL.Text;

  ttCols:= IntToStr(StrToInt(ttCols)+1);
  html := '';
  html :=  ' <table id="DTB_TAG" class="table table-bordered table-striped table-hover reservation__fontcolor"> '+SLineBreak+
           '   <thead> '+SLineBreak+
           '     <tr class="'+tHeadClass+'"> '+SLineBreak+
           '       <th colspan="3" rowspan="2" style="text-align: center; vertical-align: middle;">PRODUTO</th> '+SLineBreak+
           '       <th colspan="'+ttCols+'" style="text-align: center; padding-bottom: 20px;">PREÇOS POR ALÍQUOTA</th> '+SLineBreak+
           '     </tr> '+SLineBreak+
           '     <tr class="'+tHeadClass+'"> '+SLineBreak +
                   tagCol1 +
           '     </tr> '+SLineBreak+
           '     <tr class="'+tHeadClass+'"> '+SLineBreak+
           '       <th id="fitPad">CÓD</th> '+SLineBreak+
           '       <th id="fitPad">DT. INICIO</th> '+SLineBreak+
           '       <th id="fitPad">DT. FIM</th> '+SLineBreak+
                   tagCol2+
           '     </tr> '+SLineBreak+
           '   </thead> '+SLineBreak+
           '   <tbody> '+SLineBreak+
                 tabela +
           '   </tbody> '+SLineBreak+
           ' </table> '+SLineBreak;
//
//    GRID1.Text := html;



  aux.saveTXT(tabela, 'DTB_TAG_body.html');
  aux.saveTXT(html, 'DTB_TAG_full.html');

  IWT_DATATABLE.RawText:= true;
  IWT_DATATABLE.Text:= html;


  IWT_MODAL_HIST.RawText:= true;
  IWT_MODAL_HIST.Text:= '';

end;


function TIWFRM_Consolida.getGridHist: string;
var
  PRD, VIGINI, VIGFIM: string;

  i: Integer;
  ttCols, colspan, aliq: string;
  tagCol1, tagCol2, tabela: string; //tagCol3
  lQue, lQue2, lQue3: TADOQuery;
  campo: string;
  tabtd: string;
  //IDP_CDE_CDP: string; //IDProcesso + Cod.Empresa + Cod.Produto
  tHeadClass:string;
begin



  tHeadClass:= 'reservation__fontcolor';

  PRD    := UserSession.GPPSPRD;
  VIGINI := UserSession.GPPSVIGINI;
  VIGFIM := UserSession.GPPSVIGFIM;
  VIGINI := Concat(Copy(VIGINI, 7, 2), '/', Copy(VIGINI, 5, 2),'/',Copy(VIGINI, 1, 4));
  VIGFIM := Concat(Copy(VIGFIM, 7, 2), '/', Copy(VIGFIM, 5, 2),'/',Copy(VIGFIM, 1, 4));



  { Obtendo o total de colunas... }
  ttCols := UserSession.DM.GetTotalColunasHist.ToString;

  { Obtendo lista de colunas por aliquota... }
  lQue   := UserSession.DM.ListTotColunasPorAliquotaHist;

  { Obtendo lista de registros... }
  lQue2  := UserSession.DM.ListColunasPorAliquotaHist;

  { Montando colunas por aliquota...  }
  tagCol1:='';
  colspan:='';
  lQue.First;
  while not lQue.Eof do
  begin
    colspan := lQue.FieldByName('TOTAL').AsString;
    aliq    := lQue.FieldByName('PPSICM').AsString;
    tagCol1 := tagCol1 + '<th colspan="'+colspan+'" style="text-align: center;">'+aliq.Replace(',','.')+'</th> '+SLineBreak;
    lQue.Next;
  end;
  lQue.Close;

  tagCol2:='';
  lQue2.First;
  while not lQue2.Eof do
  begin
    aliq := lQue2.FieldByName('VALOR').AsString;
    tagCol2 := tagCol2 + ' <th style="text-align: center;">'+aliq+'</th> '+SLineBreak;
    lQue2.Next;
  end;


  { Listando os registros... }
  lQue3 := UserSession.DM.ListarAliquotasHist(UserSession.GPPSID, UserSession.GPPSEMP, UserSession.GPPSPRD);
  tabtd:='';
  tabela:='';
  lQue3.First;
  while NOT lQue3.Eof do
  begin
   tabela := tabela + ' <tr> '+SLineBreak;
   for i := 3 to lQue3.Fields.Count -1 do
   begin
     case i of
        3,4 : campo:= Concat(Copy(lQue3.Fields[i].AsString,7,2),'/',Copy(lQue3.Fields[i].AsString,5,2),'/',Copy(lQue3.Fields[i].AsString,1,4)); //YYYYMMDD -> DD/MM/YYYY
       else
             campo:= FloatToStrF(lQue3.Fields[i].AsFloat, ffNumber, 15, 0);
     end;
     tabtd:= tabtd + ' <td id="fitPad"> '+campo+' </td> '+ SLineBreak;
   end;
   tabela:=tabela + tabtd + ' </tr> '+SLineBreak;
   tabtd:='';
   lQue3.Next;
  end;


  html := '';
  html :=
  ' <table id="GRID" class="table table-bordered table-striped table-hover '+tHeadClass+'"> '+SLineBreak+
  '    <thead> '+SLineBreak+
  '        <tr> '+SLineBreak+
  '            <th colspan="2" rowspan="2" style="text-align: center;">VIGÊNCIA</th> '+SLineBreak+
  '            <th colspan="'+ttCols+'" style="text-align: center;">PREÇOS POR ALÍQUOTA</th> '+SLineBreak+
  '        </tr> '+SLineBreak+
  '        <tr> '+SLineBreak +
                    tagCol1 +
  '        </tr> '+SLineBreak+
  '        <tr> '+SLineBreak+
  '            <th>DT. INÍCIO</th> '+SLineBreak+
  '            <th>DT. FIM</th> '+SLineBreak+
                     tagCol2+
  '        </tr> '+SLineBreak+
  '    </thead> '+SLineBreak+
  '    <tbody> '+SLineBreak+
                  tabela +
  '    </tbody> '+SLineBreak+
  ' </table> '+SLineBreak;


  Result:= html;

end;



function TIWFRM_Consolida.drawChekAlterados: string;
var
  html, ident, stsCheckBox: string;
begin

  stsCheckBox:= '';


  if UserSession.DM.filtroConsolidacao='todos' then
    stsCheckBox := 'unchecked';
  if UserSession.DM.filtroConsolidacao='alterados' then
    stsCheckBox := 'checked';


  ident:='                  ';
  html:=
  ident+'<div class="custom-control custom-checkbox">                                                           '+SLineBreak+
  ident+'  <input type="checkbox" name="terms" class="custom-control-input" id="ckhAlterados" '+stsCheckBox+'>  '+SLineBreak+
  ident+'  <label class="custom-control-label" style="padding-top:5px; font-weight:normal"                      '+SLineBreak+
  ident+'    for="ckhAlterados">Exibir somente alterados                                                        '+SLineBreak+
  ident+'  </label>                                                                                             '+SLineBreak+
  ident+'</div>                                                                                                 '+SLineBreak;

  Result:= html;
end;


procedure TIWFRM_Consolida.drawModalHist(ID_PRODUTO:string);
var
  html, GRID: string;
  PRD, VIGINI, VIGFIM: string;

begin


  //'1HDJFT2021032220211231'
  UserSession.GPPSID     :=  Copy(Trim(ID_PRODUTO),  1, 1);
  UserSession.GPPSEMP    :=  Copy(Trim(ID_PRODUTO),  2, 2);
  UserSession.GPPSPRD    :=  Copy(Trim(ID_PRODUTO),  4, 3);
  UserSession.GPPSVIGINI :=  Copy(Trim(ID_PRODUTO),  7, 8);
  UserSession.GPPSVIGFIM :=  Copy(Trim(ID_PRODUTO), 15, 8);

  PRD    := UserSession.GPPSPRD;
  VIGINI := UserSession.GPPSVIGINI;
  VIGFIM := UserSession.GPPSVIGFIM;
  VIGINI := Concat(Copy(VIGINI, 7, 2), '/', Copy(VIGINI, 5, 2),'/',Copy(VIGINI, 1, 4));
  VIGFIM := Concat(Copy(VIGFIM, 7, 2), '/', Copy(VIGFIM, 5, 2),'/',Copy(VIGFIM, 1, 4));



  GRID:= getGridHist;


  html:=
  '  <!-- Modal Historico modal-lg -->                                                                                     '+SLineBreak+
  '  <div class="modal fade" id="ModalHistorico" tabindex="-1" role="dialog" data-keyboard="false" data-backdrop="static"> '+SLineBreak+
  '  <div class="modal-dialog modal-dialog-centered modal-xl" role="document"> <!--style="width:1800px;"-->                '+SLineBreak+
  '    <div class="modal-content">                                                                                         '+SLineBreak+
  '      <div class="modal-header"> <h4 class="modal-title">Historico Alíquota</h4> </div>                                 '+SLineBreak+
  '      <div class="modal-body" >                                                                                         '+SLineBreak+
  '        <div class="container-fluid">                                                                                   '+SLineBreak+
  '          <div class="row">                                                                                             '+SLineBreak+
  '            <div class="col-xs-12">                                                                                     '+SLineBreak+
  '              <div class="form-group">                                                                                  '+SLineBreak+
  '                <label for="prod">Produto: '+PRD+'</label> <br/>                                                        '+SLineBreak+
  '                <label for="datin">Data Inicial: '+VIGINI+'</label> <br/>                                               '+SLineBreak+
  '                <label for="datfi">Data Final: '+VIGFIM+'</label> <br/>                                                 '+SLineBreak+
  '              </div>                                                                                                    '+SLineBreak+
  '            </div>                                                                                                      '+SLineBreak+
  '          </div>                                                                                                        '+SLineBreak+
  '          <div class="row">                                                                                             '+SLineBreak+
  '            <div class="col-xs-12">                                                                                     '+SLineBreak+
  '              <br />                                                                                                    '+SLineBreak+
  '              <div class="table-responsive">                                                                            '+SLineBreak+
  '                '+GRID+'                                                                                                '+SLineBreak+
  '              </div>                                                                                                    '+SLineBreak+
  '            </div>                                                                                                      '+SLineBreak+
  '          </div>                                                                                                        '+SLineBreak+
  '        </div>                                                                                                          '+SLineBreak+
  '      </div>                                                                                                            '+SLineBreak+
  '      <div class="modal-footer">                                                                                        '+SLineBreak+
  '        <button type="button" class="btn btn-default"  data-dismiss="modal" id="BTNCANCELAR">Cancelar</button>          '+SLineBreak+
  '      </div>                                                                                                            '+SLineBreak+
  '    </div>                                                                                                              '+SLineBreak+
  '  </div>                                                                                                                '+SLineBreak+
  '  </div>                                                                                                                '+SLineBreak;


  aux.saveTXT(html, 'ModalHist-FULL.html');
  aux.saveTXT(GRID, 'ModalHist-GRID.html');

  IWT_MODAL_HIST.RawText:= true;
  IWT_MODAL_HIST.Text:= html;


  WebApplication.CallBackResponse.AddJavaScriptToExecute('$(''#ModalHistorico'').modal(''show'');');

end;


end.


