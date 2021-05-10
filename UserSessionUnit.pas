unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes, IWAppForm,
  uLogin, uIndex, uProcessa, uConsolida, uReport1,
  clsAux
  ;

type
  TIWUserSession = class(TIWUserSessionBase)
    procedure IWUserSessionBaseCreate(Sender: TObject);
  private
    FIDUsuario: string;
    FUserName: string;
    FLastLogin: TDateTime;
    aux: Auxiliar;
  public
    FProcessa: TIWFRM_Processa;
    LOGGED: Boolean;
    LOGGED2: Boolean;
    ActivePage, friendlyPageName, frm_title: string;

    property UserName: string read FUserName write FUserName;
    property IDUsuario: string read FIDUsuario write FIDUsuario;
    property LastLogin: TDateTime read FLastLogin write FLastLogin;

    procedure DoLogin(USR, PASS:string);
    function getUserMenu(): String;
    function getStdMenu(): String;
    function addNavGroup(title, link, icon, span, vspan, open: string): String;
    function addNavItem(title, link, icon: string): String;
    function closeGroup():string;


  end;

implementation
{$R *.dfm}
//var
//FProcessa: TIWFRM_Processa;
//FConsolida: TIWFRM_Consolida;


procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
begin

  LOGGED:= false;

end;

procedure TIWUserSession.DoLogin(USR, PASS:string);
begin


  //get username/id from DB
  UserName:= USR;
  IDUsuario:= 'SB037635';

  LOGGED:= true;

  //Get template on user preferences (create data on DB)

  //Sample
  if trim(UserName) = 'AND' then begin
    //WebApplication.ShowMessage('IWMaster_black');
    //IWServerController.MasterTemplate:='IWMaster_black.html';
  end;


  if trim(UserName) <> 'AND' then begin
    //WebApplication.ShowMessage('IWMaster');
    //IWServerController.MasterTemplate:='IWMaster.html';
  end;




end;


function TIWUserSession.addNavGroup(title, link, icon, span, vspan, open: string): String;
var
  active: string;
begin

  //nav-icon fas fa-copy

  if open='menu-open' then
    active:= 'active'
  else
    active:= '';

  Result:=
  '  <li class="nav-item '+open+'">                                   '+chr(13)+
  '    <a href="'+link+'" class="nav-link '+active+'">                '+sLineBreak+
  '      <i class="'+icon+'"></i>                                     '+sLineBreak+
  '        <p>                                                        '+sLineBreak+
  '          '+title+'                                                '+sLineBreak+
  '        <i class="fas fa-angle-left right"></i>                    '+sLineBreak+
  '        <span class="right badge badge-'+span+'">'+vspan+'</span>  '+sLineBreak+
  '      </p>                                                         '+sLineBreak+
  '    </a>                                                           '+sLineBreak+
  '    <ul class="nav nav-treeview">                                  '+sLineBreak
  ;

end;

function TIWUserSession.closeGroup():string;
begin

  Result:=
  '    </ul> ' +sLineBreak+
  '  </li> '   +sLineBreak
  ;

end;

function TIWUserSession.addNavItem(title, link, icon: string): String;
var
  active: string;
begin



  active:= '';
  if link = ActivePage then
    active:= 'active';

  //strAux:= Format('javascript:fncExecutar(%s, 0);', [quotedstr(link)]);
  link:= 'javascript:fncExecutar('+QuotedStr(link)+',0);';


  Result:=
  '      <li class="nav-item">                                '+sLineBreak+
  '        <a href="'+link+'" class="nav-link '+active+'">    '+sLineBreak+
  '          <i class="nav-icon '+icon+'"></i>                '+sLineBreak+
  '          <p style="text-transform: capitalize">           '+sLineBreak+
  '            '+title+'</p>                                  '+sLineBreak+
  '        </a>                                               '+sLineBreak+
  '      </li>                                                '+sLineBreak
  ;

end;

function TIWUserSession.getStdMenu(): String;
var
  menu, activeMain, openMain: string;
  activeItem1, activeItem2, activeItem3: string;
begin


  //Dash bordS
  activeItem1:= '';
  activeItem2:= '';
  activeItem3:= '';


  if ActivePage = IWFRM_Index.PAGE_ID then begin
    openMain:= 'menu-open';
    activeMain:= 'active';
    activeItem2:= 'active';
  end;


  menu:=
  '<li class="nav-item '+openMain+'">                        '+sLineBreak+
  '    <a href="#" class="nav-link '+activeMain+'">          '+sLineBreak+
  '      <i class="nav-icon fas fa-tachometer-alt"></i>      '+sLineBreak+
  '      <p>                                                 '+sLineBreak+
  '        Home                                              '+sLineBreak+
  '        <i class="right fas fa-angle-left"></i>           '+sLineBreak+
  '      </p>                                                '+sLineBreak+
  '    </a>                                                  '+sLineBreak+
  '    <ul class="nav nav-treeview">                         '+sLineBreak+
  '      <li class="nav-item">                               '+sLineBreak+
  '        <a href="#" class="nav-link '+activeItem1+'">     '+sLineBreak+
  '          <i class="far fa-circle nav-icon"></i>          '+sLineBreak+
  '          <p style="text-transform: capitalize">          '+sLineBreak+
  '             Dashboard 1 </p>                             '+sLineBreak+
  '        </a>                                              '+sLineBreak+
  '      </li>                                               '+sLineBreak+
  '      <li class="nav-item">                               '+sLineBreak+
  '        <a href="#" class="nav-link '+activeItem2+'">     '+sLineBreak+
  '          <i class="far fa-circle nav-icon"></i>          '+sLineBreak+
  '          <p style="text-transform: capitalize">          '+sLineBreak+
  '             Dashboard 2 </p>                             '+sLineBreak+
  '        </a>                                              '+sLineBreak+
  '      </li>                                               '+sLineBreak+
  '    </ul>                                                 '+sLineBreak+
  '</li>                                                     '+sLineBreak+
  '<li class="nav-item">                                     '+sLineBreak+
  '    <a href="#" class="nav-link">                         '+sLineBreak+
  '      <i class="nav-icon fas fa-th"></i>                  '+sLineBreak+
  '      <p>                                                 '+sLineBreak+
  '        Atualização                                       '+sLineBreak+
  '        <span class="right badge badge-danger">New</span> '+sLineBreak+
  '      </p>                                                '+sLineBreak+
  '    </a>                                                  '+sLineBreak+
  '</li>                                                     '+sLineBreak
  ;

  Result:= menu;

end;

function TIWUserSession.getUserMenu(): String;
var
  menuStandard, menuUser, open: string;
  itens: TStringList;
begin

  open:= '';

  menuStandard:= getStdMenu;

  aux:= Auxiliar.Create();
  aux.saveTXT(menuStandard, 'menuStd.html');



  ///////////////////////////////////////////////////////////////////////////////
  //Grupo menu 1 - Tabela PPS ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
  //itens:= new ArrayLIst['', ''];
  itens:= TStringList.Create;
  itens.Add(IWFRM_Processa.PAGE_ID);
  itens.Add(IWFRM_Consolida.PAGE_ID);
  //itens.Add(IWFRM_Processa.PAGE_ID);
  //itens.Add(IWFRM_Processa.PAGE_ID);
  if itens.IndexOf(ActivePage) >= 0 then
    open:= 'menu-open';
  menuUser:=
  addNavGroup('Tabela PPS', '#', 'icon', 'info', '4', open)                     +
    addNavItem('Processar tabela PPS', IWFRM_Processa.PAGE_ID, 'far fa-circle') +
    addNavItem('Consolidar', IWFRM_Consolida.PAGE_ID, 'far fa-circle')          +
    addNavItem('Gerar Prévias (XML)', 'FRM_PREVI', 'far fa-circle')             +
    addNavItem('Transmitir SEFAZ', 'FRM_SEFAZ', 'far fa-envelope')              +
  closeGroup;


  ///////////////////////////////////////////////////////////////////////////////
  //Grupo menu 2 - Relatórios ///////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
  itens.Clear;
  open:= '';
  itens.Add(IWFRM_RPT1.PAGE_ID);
  if itens.IndexOf(ActivePage) >= 0 then
    open:= 'menu-open';
  menuUser:= menuUser +
  addNavGroup('Relatórios', '#', 'icon', 'info', '1', open)                     +
    addNavItem('Report "1"', IWFRM_RPT1.PAGE_ID, 'far fa-circle') +
  closeGroup;






  aux.saveTXT(menuUser, 'menuUser.html');
  aux.saveTXT(menuStandard + menuUser, 'menuFinal.html');

  Result:= menuStandard + menuUser;


end;



end.

