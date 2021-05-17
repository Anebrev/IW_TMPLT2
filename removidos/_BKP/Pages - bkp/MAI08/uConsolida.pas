unit uConsolida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWCompText, IWCompEdit,
  clsAux
  ;

type
  TIWFRM_Consolida = class(TIWBase)
  IWT_DATATABLE: TIWText;
    IWE_Filter: TIWEdit;
    IWL_Status: TIWLabel;
  procedure prc_Acao(EventParams: TStringList); override;
  procedure IWAppFormCreate(Sender: TObject);
  procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);

  private
    aux: Auxiliar;
    function getDataTable(filtro:string): string;
    function getDataTableJSON(): string;
    function getDataTableTH(th:string): string;
    function getDataTableBody1(): string;
    function getDataTableBody2(): string;
    function getDataTableBody3(): string;
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

  IWL_Status.Text:= '';
  IWT_DATATABLE.RawText:= true;
  //IWT_DATATABLE.Text:= getDataTableJSON;
  IWT_DATATABLE.Text:= getDataTable('');

  UserSession.ActivePage:= PAGE_ID;
  UserSession.frm_title:= FRM_TITLE;
  UserSession.friendlyPageName:= FRIENDLY_NAME;

end;


procedure TIWFRM_Consolida.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin
  inherited;

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


   filtro:= IWE_Filter.Text;

    if Acao = 'ProcDataTable' then begin



      //gera novo json base filtros da consulta


      //IWT_DATATABLE.RawText:= true;
      IWL_Status.Text:= 'Loading DataTable...';
      //IWT_DATATABLE.Text:= 'Loading---...'; //create function to load some secs
      //sleep(5000);
      //WebApplication.ShowMessage('Limpando html datatable...');
      IWT_DATATABLE.Text:= getDataTable(filtro);
      //IWT_DATATABLE.Text:= getDataTableJSON;
      IWL_Status.Text:= '';




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


  html:= html +
  '      </tbody>                                                                        '+sLineBreak+
  '      <tfoot>                                                                         '+sLineBreak+
  '      </tfoot>                                                                        '+sLineBreak+
  '    </table>                                                                          '+sLineBreak+
  '</div>                                                                                '+sLineBreak
  ;

  aux:= Auxiliar.Create();
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






end.

