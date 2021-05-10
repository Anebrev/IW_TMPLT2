unit uBASE1;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompButton, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompEdit, IWHTMLControls, IWHTMLTag;

type
  TIWFormBase = class(TIWAppForm)
    IWTemplateProcessorHTML1: TIWTemplateProcessorHTML;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
    //procedure IWLinkClientesAsyncClick(Sender: TObject; EventParams: TStringList);
  private

  public
    idAcao: integer;
    Acao: string;
    //procedure DoSelectMenu(EventParams: TStringList);
    //procedure DoLogoff(EventParams: TStringList);
    procedure prc_Acao(EventParams : TStringList); virtual;

  end;

const
  MENU_CLIENTES = 'CLIENTES';

implementation
{$R *.dfm}
uses ServerController, UserSessionUnit, uLogin1, uclientes, uIndex1, uDataTable, uMain1;




{ TIWFormBase }

procedure TIWFormBase.IWAppFormCreate(Sender: TObject);
begin

  WebApplication.RegisterCallBack('prc_Acao', prc_Acao);

end;


procedure TIWFormBase.IWTemplateProcessorHTML1UnknownTag(const AName: string; var VValue: string);
begin


  if AName = 'USER_MENU' then begin

      VValue:=
      '  <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">                                   '+
      '    <div class="menu_section">                                                                            '+
      '      <h3>General</h3>                                                                                    '+
      '      <ul class="nav side-menu">                                                                          '+
      '        <li><a><i class="fa fa-home"></i> OPTIONS 1 <span class="fa fa-chevron-down"></span></a>          '+
      '          <ul class="nav child_menu">                                                                     '+
      '            <li><a href="javascript:fncExecutar(''pgDataTable'', 0);">Data Table</a></li>                 '+
      '            <li><a href="index2.html">Dashboard1</a></li>                                                 '+
      '            <li><a href="index3.html">Dashboard2</a></li>                                                 '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '        <li><a><i class="fa fa-edit"></i> Forms <span class="fa fa-chevron-down"></span></a>              '+
      '          <ul class="nav child_menu">                                                                     '+
      '            <li><a href="form.html">General Form</a></li>                                                 '+
      '            <li><a href="form_advanced.html">Advanced Components</a></li>                                 '+
      '            <li><a href="form_validation.html">Form Validation</a></li>                                   '+
      '            <li><a href="form_wizards.html">Form Wizard</a></li>                                          '+
      '            <li><a href="form_upload.html">Form Upload</a></li>                                           '+
      '            <li><a href="form_buttons.html">Form Buttons</a></li>                                         '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '        <li><a><i class="fa fa-table"></i> Tables <span class="fa fa-chevron-down"></span></a>            '+
      '          <ul class="nav child_menu">                                                                     '+
      '            <li><a href="tables.html">Tables</a></li>                                                     '+
      '            <li><a href="tables_dynamic.html">Table Dynamic</a></li>                                      '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '        <li><a><i class="fa fa-clone"></i>Layouts <span class="fa fa-chevron-down"></span></a>            '+
      '          <ul class="nav child_menu">                                                                     '+
      '            <li><a href="fixed_sidebar.html">Fixed Sidebar</a></li>                                       '+
      '            <li><a href="fixed_footer.html">Fixed Footer</a></li>                                         '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '      </ul>                                                                                               '+
      '    </div>                                                                                                '+
      '    <div class="menu_section">                                                                            '+
      '      <h3>Live On</h3>                                                                                    '+
      '      <ul class="nav side-menu">                                                                          '+
      '        <li><a><i class="fa fa-bug"></i> Additional Pages <span class="fa fa-chevron-down"></span></a>    '+
      '          <ul class="nav child_menu">                                                                     '+
      '            <li><a href="e_commerce.html">E-commerce</a></li>                                             '+
      '            <li><a href="projects.html">Projects</a></li>                                                 '+
      '            <li><a href="project_detail.html">Project Detail</a></li>                                     '+
      '            <li><a href="contacts.html">Contacts</a></li>                                                 '+
      '            <li><a href="profile.html">Profile</a></li>                                                   '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '                                                                                                          '+
      '        <li><a><i class="fa fa-sitemap"></i> Multilevel Menu <span class="fa fa-chevron-down"></span></a> '+
      '          <ul class="nav child_menu">                                                                     '+
      '              <li><a href="#level1_1">Level One</a>                                                       '+
      '              <li><a>Level One<span class="fa fa-chevron-down"></span></a>                                '+
      '                <ul class="nav child_menu">                                                               '+
      '                  <li class="sub_menu"><a href="level2.html">Level Two</a>                                '+
      '                  </li>                                                                                   '+
      '                  <li><a href="#level2_1">Level Two</a>                                                   '+
      '                  </li>                                                                                   '+
      '                  <li><a href="#level2_2">Level Two</a>                                                   '+
      '                  </li>                                                                                   '+
      '                </ul>                                                                                     '+
      '              </li>                                                                                       '+
      '              <li><a href="#level1_2">Level One</a>                                                       '+
      '              </li>                                                                                       '+
      '          </ul>                                                                                           '+
      '        </li>                                                                                             '+
      '        <li>                                                                                              '+
      '             <a href="javascript:void(0)">                                                                '+
      '                <i class="fa fa-laptop"></i> Landing Page                                                 '+
      '                <span class="label label-success pull-right">Coming Soon</span>                           '+
      '             </a>                                                                                         '+
      '         </li>                                                                                            '+
      '      </ul>                                                                                               '+
      '    </div>                                                                                                '+
      '                                                                                                          '+
      '  </div>                                                                                                  '
      ;
  end;




end;

procedure TIWFormBase.prc_Acao(EventParams : TStringList);
var
  sl: TStringList;
  i, CountParam: Integer;
  s: string;
begin

  sl:= TStringList.Create;
  IdAcao:= 0;
  //CountParam:= 0;


  try

    sl.StrictDelimiter:= true;
    sl.CommaText:= EventParams.Values['Params'];
    s:= sl.CommaText;

    CountParam:= TStringList(sl).Count;


    for i := 0 to Pred(CountParam) do begin

      if i=0 then
        Acao:= sl.ValueFromIndex[i];

      if i=1 then
        IdAcao:= StrToInt(sl.ValueFromIndex[i]);

    end;



    if Acao = 'pgDataTable' then begin

      //IWFormDataTable:= TIWFormDataTable.Create(self);
      //IWFormDataTable.Show;

       //TIWFRM_Index.Create(WebApplication).Show;
       //Destrói o formulário atual:
       //Release;


       TIWAppForm(WebApplication.ActiveForm).Release;
       TIWFRM_Main.Create(WebApplication).Show;

       //Destrói o formulário atual:
       //WebApplication.ActiveForm.release;
       //Release;


    end;


    if Acao = 'pgIndex' then begin

      //TIWAppForm(WebApplication.ActiveForm).Release; uncomment if problem with callback call
      IWFRM_Index1:= TIWFRM_Index1.Create(self);
      IWFRM_Index1.Show;
      //Release;

    end;


    if Acao = 'Logout' then begin


       TIWAppForm(WebApplication.ActiveForm).Release;
       TIWFormLogin.Create(WebApplication).Show;

      //IWFormLogin := TIWFormLogin.Create(self);
      //IWFormLogin.Show;
      //Release;

    end;




    if IdAcao=0 then begin

    end;


  except

  end;









end;










//procedure TIWFormBase.DoLogoff(EventParams: TStringList);
//begin
//  //WebApplication.TerminateAndRedirect('http://www.criareinformatica.com.br');
//
//end;
//
//procedure TIWFormBase.DoSelectMenu(EventParams: TStringList);
//begin
//  if UpperCase(EventParams.Values['option'])=MENU_CLIENTES then
//    TIWFormClientes.Create(WebApplication).Show
//  else
//    WebApplication.ShowMessage('Cadastro de '+UpperCase(EventParams.Values['option']));
//end;
//
//procedure TIWFormBase.IWAppFormCreate(Sender: TObject);
//const
//  jsTag = '<script language="javascript" type="text/javascript">%s</script>';
//var
//  AjaxFunc: string;
//begin
//  // this is the JavaScript function that I want to call.
//  // This function, in turn, will call IWFormMain.DoSelectMenu()
//  AjaxFunc := 'function doSelectMenu(pOption) {' + #13 +
//      'executeAjaxEvent("&option="+pOption, null,"' + UpperCase(Self.Name) + '.DoSelectMenu", false, null, false);' + #13 +
//      'return true;}';
//  PageContext.ExtraHeader.Add(Format(jsTag, [AjaxFunc]));
//  // If we want to call IWForm2.DoMyAjaxFunc, then we have to register it as a Callback
//  WebApplication.RegisterCallBack(UpperCase(Self.Name) + '.DoSelectMenu', DoSelectMenu);
//
//  // this is the JavaScript function that I want to call.
//  // This function, in turn, will call IWFormMain.DoLogoff()
//  AjaxFunc := 'function doLogoff() {' + #13 +
//      'executeAjaxEvent("&option=", null,"' + UpperCase(Self.Name) + '.DoLogoff", false, null, false);' + #13 +
//      'return true;}';
//  PageContext.ExtraHeader.Add(Format(jsTag, [AjaxFunc]));
//  // If we want to call IWForm2.DoMyAjaxFunc, then we have to register it as a Callback
//  WebApplication.RegisterCallBack(UpperCase(Self.Name) + '.DoLogoff', DoLogoff);
//
//
//end;
//
//procedure TIWFormBase.IWLinkClientesAsyncClick(Sender: TObject; EventParams: TStringList);
//begin
//  WebApplication.ShowMessage('çink');
//end;



end.
