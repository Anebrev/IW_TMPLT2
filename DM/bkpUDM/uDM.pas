unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,
  vcl.forms,
    //ActiveX,
    Registry,
  //vcl.forms,
  //ActiveX,
  //Registry,
  //classes complementares
  ConfigENV, clsLog, clsAuxiliar
  ;

type
  TDM = class(TDataModule)
    BASE_AS400: TADOConnection;
    QAliquotas: TADOQuery;
    QGAliquotas: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);

  private
    FIDUsuario: string;
    FUserName: string;
    FLastLogin: TDateTime;
    LOGGED: boolean;
    conAS400: string;
    //CONN: TADOConnection;
    ENV: string;

    //logSGX: Log;
    conDataSrcAS400, conBaseAS400, conPersistSecAS400, conProviderAS400: string;
    spPPS_PROC: TADOStoredProc;

    //aux1: Auxiliar;
    //aux2: Auxiliar;
    //function criaProcedures(sobrescrever:boolean): boolean;
    //function criaProcedure_PROCPPS(sobrescrever:Boolean): Boolean;
    function criaProcedures2(sobrescrever: boolean): Boolean;
    function criaProcedure_PROCPPS(sobrescrever: boolean): Boolean;
  public

    PROG_ENV: PRC_FUNCS;
    CONN: TADOConnection;
    aux1: Auxiliar;
    //programaPronto: boolean;
    erroLogin: string;
    property UserName: string read FUserName write FUserName;
    property IDUsuario: string read FIDUsuario write FIDUsuario;
    property LastLogin: TDateTime read FLastLogin write FLastLogin;
    //constructor Create(Sender: TObject);
    function LoginENV(USR, PASS, ENV:string): boolean;

    //Listas
    function ListarProcessos(): TADOQuery;
    function ListarProcessos2(): TADOQuery;


  end;

var
  DM: TDM;

implementation
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
uses
  ServerController;





//{$REGION 'ENV/Login'}
procedure TDM.DataModuleCreate(Sender: TObject);
begin


  //load configs
  //CoInitialize(nil);
  PROG_ENV:= PRC_FUNCS.Create();
  //UserSession.progPronto:= true;
  //UserSession.progPronto:= PROG_ENV.programaPronto;
  //UserSession.programaPronto:= PROG_ENV.programaPronto;
  //logSGX:= PROG_ENV.logICE;
  //aux:= Auxiliar.Create(self);
  //PROG_ENV.aux;

  //teste login
  //if PROG_ENV.programaPronto then begin
  //  LoginENV('SB037635', 'SB037635', 'PY');
  //end;

end;


function TDM.criaProcedures2(sobrescrever: boolean): Boolean;
var
  criou: Boolean;
begin


  criou:= true;

  //CRIA PROCEDURES AS400
  //I) Procedure PPSPROC
  if Not (criaProcedure_PROCPPS(sobrescrever)) then
  begin
    criou:= false;
  end;


  Result:= criou;


end;


function TDM.criaProcedure_PROCPPS(sobrescrever: boolean): Boolean;
var
  qryAux: TADOQuery;
  criou: Boolean;
  qtRows:Integer;
  //strSQL: string;
begin


  criou:= False;
  qtRows:= 0;
  qryAux:= TADOQuery.Create(nil);

  PROG_ENV.aux.conectaBase(BASE_AS400);
  qryAux.Connection:= BASE_AS400;


  //DELETA PROCEDURE PRCSGXPPS
  try

    qryAux.SQL.Text :='select count(*) as qt from qsys2.SYSROUTINES ';
    qryAux.SQL.Add('where routine_name='+''''+'PRCSGXPPS'+'''');
    qryAux.SQL.Add(' and routine_schema = '+''''+'LPDPGICE'+''''+' and routine_type = '+''''+'PROCEDURE'+'''');
    qryAux.Open;
    qtRows:= qryAux.FieldByName('qt').AsInteger;
    if ( (qtRows>0) and (sobrescrever) ) then begin
      qryAux.SQL.Clear;
      qryAux.SQL.Text :='DROP PROCEDURE LPDPGICE.PRCSGXPPS';
      qryAux.ExecSQL;
      qtRows:= 0;
    end;
  except
    On E:Exception do begin
      PROG_ENV.logICE.saveLog(PROG_ENV.INT_NAME+': Erro na PROCEDURE(PRCSGXPPS) de processamento PPS. Erro ['+E.Message+']');
    end;
  end;


  //CRIA PROCEDURE prcICE_REPROCORD
//  if Not (qtRows > 0) then
//  begin
//  try
//    qryAux.SQL.Clear;
//    strSQL:= '';
//    qryAux.SQL.Text :='CREATE PROCEDURE LPDPGICE.PRCSGXPPS ';
//    strSQL:=strSQL +'( IN CIA CHARACTER(2),';
//    strSQL:=strSQL +'  IN ORDEM CHARACTER(6),';
//    strSQL:=strSQL +'  IN ACAO CHARACTER(1),';
//    strSQL:=strSQL +'  IN OPCAO CHARACTER(1) )';
//    strSQL:=strSQL +'LANGUAGE SQL ';
//    strSQL:=strSQL +'SPECIFIC LPDPGICE.PRCICE_REPROCORD ';
//    strSQL:=strSQL +'NOT DETERMINISTIC ';
//    strSQL:=strSQL +'MODIFIES SQL DATA ';
//    strSQL:=strSQL +'CALLED ON NULL INPUT ';
//    strSQL:=strSQL +'SET OPTION  ALWBLK = *ALLREAD , ';
//    strSQL:=strSQL +'ALWCPYDTA = *OPTIMIZE , ';
//    strSQL:=strSQL +'COMMIT = *NONE , ';
//    strSQL:=strSQL +'DECRESULT = (31, 31, 00) , ';
//    strSQL:=strSQL +'DFTRDBCOL = *NONE , ';
//    strSQL:=strSQL +'DYNDFTCOL = *NO , ';
//    strSQL:=strSQL +'DYNUSRPRF = *USER , ';
//    strSQL:=strSQL +'SRTSEQ = *HEX ';
//    strSQL:=strSQL +'CALL LPDPGICE . HICE015C (CIA, ORDEM, ACAO, OPCAO) ';
//    qryAux.SQL.Add(strSQL);
//    qryAux.ExecSQL;
//    criou:= True;
//  except
//  On E:Exception do
//    begin
//      logICE.saveLog(INT_NAME+': Erro na PROCEDURE (PRCICE_REPROCORD) da interface de Ordens. Erro ['+E.Message+']');
//      criou:= False;
//    end;
//  end;
//  end;


  //Atribui a procedure criada no AS400 ao objeto TADOStoredProc
  spPPS_PROC:= TADOStoredProc.Create(nil);
  if (criou Or (qtRows>0) ) then
  begin
    try
    spPPS_PROC.ProcedureName:= 'LPDPGICE.PRCSGXPPS';
    spPPS_PROC.Parameters.Clear;
    aux1.criaParametroSP(spPPS_PROC,'pEMP', ftString, 2, 0);
    aux1.criaParametroSP(spPPS_PROC,'pVIGINI', ftInteger, 8, 0);
    aux1.criaParametroSP(spPPS_PROC,'pVIGFIM', ftInteger, 8, 0);
    aux1.criaParametroSP(spPPS_PROC,'pHIST_MONTH', ftInteger, 5, 0);
    aux1.criaParametroSP(spPPS_PROC,'pSYS', ftString, 40, 0);
    aux1.criaParametroSP(spPPS_PROC,'pUSER', ftString, 10, 0);
    aux1.criaParametroSP(spPPS_PROC,'pHOST', ftString, 10, 0);
    spPPS_PROC.ConnectionString:= BASE_AS400.ConnectionString;
    criou:= True;
    except
      On E:Exception do begin
        PROG_ENV.logICE.saveLog(PROG_ENV.INT_NAME+': Erro na PROCEDURE (PRCSGXPPS) de Processamento PPS. Erro ['+E.Message+']');
        criou:= False;
      end;
    end;
  end;

  Result:= criou;



end;



function TDM.ListarProcessos2(): TADOQuery;
var
  lQue: TADOQuery;
  strAux: string;
begin


  strAux:=  conAS400;
  CONN.ConnectionString:= conAS400;
  strAux:=  CONN.ConnectionString;  //BASE_AS400.ConnectionString;
  aux1.conectaBase2(CONN);

  lQue:= TADOQuery.Create(nil);
  lQue.Connection:= CONN;//BASE_AS400;
  //lQue.SQL.Clear;


  try

    if ENV <> 'TST'  then begin
      lQue.SQL.Add('SELECT ');
      lQue.SQL.Add('RIGHT(REPEAT(''0'', 6) || PPSID, 6) IDPROC, ');
      lQue.SQL.Add('PRCAUDUSR,  ');
      lQue.SQL.Add('TO_CHAR(TO_DATE(PRCDT, ''YYYYMMDD''), ''DD/MM/YYYY'') DTPROC, ');
      lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGINI AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGINI, ');
      lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGFIM AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGFIM, ');
      lQue.SQL.Add('CASE PRCSTATUS ');
      lQue.SQL.Add('	WHEN 0 THEN ''PROCESSADO'' ');
      lQue.SQL.Add('	WHEN 1 THEN ''ENVIADO'' ');
      lQue.SQL.Add('	WHEN 2 THEN ''CONSOLIDADO'' ');
      lQue.SQL.Add('END PRCSTATUS ');
      lQue.SQL.Add('FROM LPDDBICE.PPSPROCC ');
    end;


    if ENV = 'TST'  then begin
      lQue.SQL.Add('SELECT ');
      //lQue.SQL.Add('RIGHT(REPEAT(''0'', 6) || PPSID, 6) IDPROC, ');
      lQue.SQL.Add('PPSID as IDPROC,  ');
      lQue.SQL.Add('PRCAUDUSR,  ');
      lQue.SQL.Add('PRCDT,  ');
      //lQue.SQL.Add('TO_CHAR(TO_DATE(PRCDT, ''YYYYMMDD''), ''DD/MM/YYYY'') DTPROC, ');
      lQue.SQL.Add('PRCVIGINI, PRCVIGFIM, ');
      //lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGINI AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGINI, ');
      //lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGFIM AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGFIM, ');
      lQue.SQL.Add('CASE PRCSTATUS ');
      lQue.SQL.Add('	WHEN 0 THEN ''PROCESSADO'' ');
      lQue.SQL.Add('	WHEN 1 THEN ''ENVIADO'' ');
      lQue.SQL.Add('	WHEN 2 THEN ''CONSOLIDADO'' ');
      lQue.SQL.Add('END PRCSTATUS ');
      lQue.SQL.Add('FROM LPDDBICE.PPSPROCC ');
    end;

    lQue.Open;

  finally
    Result := lQue;
  end;



end;


function TDM.LoginENV(USR, PASS, ENV:string): boolean;
//var
  //strAux: string;
  //strConn: string;
begin

  self.ENV:= ENV;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Connect MySQL //////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //strConn:= 'DRIVER={MySQL ODBC 3.51 Driver}; SERVER=localhost; port=3307; DATABASE=mysql; USER=root; PASSWORD=12345;OPTION=3;';
//  strConn:= 'DRIVER={MySQL ODBC 8.0 Ansi Driver}; SERVER=localhost; port=3307; DATABASE=mysql; USER=root; PASSWORD=12345;OPTION=3';
//  conn:= TADOConnection.Create(nil);
//  conn.ConnectionString:= strConn;
//  LOGGED:= aux1.conectaBase2(conn);
//  conn.Connected:= true;;





  if ENV='PY' then begin
    conDataSrcAS400    := PROG_ENV.conDataSrcAS400_PY;
    conBaseAS400       := PROG_ENV.conBaseAS400_PY;
    conPersistSecAS400 := PROG_ENV.conPersistSecAS400_PY;
    conProviderAS400   := PROG_ENV.conProviderAS400_PY;
  end;

  if ENV='PD' then begin
    conDataSrcAS400    := PROG_ENV.conDataSrcAS400;
    conBaseAS400       := PROG_ENV.conBaseAS400;
    conPersistSecAS400 := PROG_ENV.conPersistSecAS400;
    conProviderAS400   := PROG_ENV.conProviderAS400;
  end;
  conAS400:= aux1.doConnString(conDataSrcAS400, USR, PASS, conProviderAS400, conPersistSecAS400);

  if ENV='TST' then begin
    conAS400:=
    //'DRIVER={MySQL ODBC 8.0 Ansi Driver}; SERVER=localhost; port=3307; DATABASE=mysql; USER=root; PASSWORD=12345;OPTION=3';
    'DRIVER={MySQL ODBC 8.0 Ansi Driver}; SERVER=localhost; port=3307; DATABASE=lpddbice; USER=anebrev; PASSWORD=12345;OPTION=3';
  end;



  //Valida Conn. AS400
  LOGGED:= false;
  TRY
    Try
      //CoInitialize(nil);
      BASE_AS400:= TADOConnection.Create(nil);
      BASE_AS400.ConnectionString:= conAS400;
      aux1.fechaCon(BASE_AS400);
      LOGGED:= aux1.conectaBase2(BASE_AS400);
      aux1.fechaCon(BASE_AS400);
      CONN:= TADOConnection.Create(nil);
      CONN.ConnectionString:= conAS400;
      aux1.fechaCon(CONN);
      LOGGED:= aux1.conectaBase2(CONN);
      aux1.fechaCon(CONN);
    Except
      On E:Exception do
      begin
        erroLogin:= E.Message;
      end;
    End;
  FINALLY
    begin
      if not LOGGED then
      begin
        erroLogin:= 'Falha ao logar no ambiente '+ENV+ '. Erro ['+erroLogin+'].';
      end;
    end;
  END;



  if LOGGED then begin

    //get username/id from DB
    UserName:= 'AND';
    IDUsuario:= USR;



    //Cria procedures no ambiente selecionado
    if LOGGED then begin

      if ENV<>'TST' then
        criaProcedures2(PROG_ENV.recriaProcedure);

    end;


  end;







  Result:= LOGGED;

end;

//{$ENDREGION}














function TDM.ListarProcessos(): TADOQuery;
var
  lQue: TADOQuery;
  strAux: string;

begin



  //strAux:= conas4002.
  strAux:=  CONN.ConnectionString;  //BASE_AS400.ConnectionString;
  aux1.conectaBase2(BASE_AS400);

  lQue:= TADOQuery.Create(nil);
  lQue.Connection:= BASE_AS400;
  //lQue.SQL.Clear;

  try
    lQue.SQL.Add('SELECT ');
    lQue.SQL.Add('RIGHT(REPEAT(''0'', 6) || PPSID, 6) IDPROC, ');
    lQue.SQL.Add('PRCAUDUSR,  ');
    lQue.SQL.Add('TO_CHAR(TO_DATE(PRCDT, ''YYYYMMDD''), ''DD/MM/YYYY'') DTPROC, ');
    lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGINI AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGINI, ');
    lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGFIM AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGFIM, ');
    lQue.SQL.Add('CASE PRCSTATUS ');
    lQue.SQL.Add('	WHEN 0 THEN ''PROCESSADO'' ');
    lQue.SQL.Add('	WHEN 1 THEN ''ENVIADO'' ');
    lQue.SQL.Add('	WHEN 2 THEN ''CONSOLIDADO'' ');
    lQue.SQL.Add('END PRCSTATUS ');
    lQue.SQL.Add('FROM LPDDBICE.PPSPROCC ');
    lQue.Open;

  finally
    Result := lQue;
  end;


end;




//{$REGION 'LISTAS'}
///////////
//{$ENDREGION}







end.
