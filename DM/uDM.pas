unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,
  vcl.forms, Registry, //ActiveX,
  //classes complementares
  ConfigENV, clsLog, clsAuxiliar, clsAux
  ;

type
  TDM = class(TDataModule)
    QAliquotas: TADOQuery;
    QGAliquotas: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);

  private
    FIDUsuario: string;
    FUserName: string;
    FLastLogin: TDateTime;
    LOGGED: boolean;
    BASE_AS400: TADOConnection;
    conAS400: string;
    MY_ENV: string;
    strAux: string;
    lQue: TADOQuery;
    aux: Auxiliar2;

    //logSGX: Log;
    conDataSrcAS400, conBaseAS400, conPersistSecAS400, conProviderAS400: string;
    spPPS_PROC: TADOStoredProc;

    //function criaProcedures(sobrescrever:boolean): boolean;
    function criaProcedures2(sobrescrever: boolean): Boolean;
    function criaProcedure_PROCPPS(sobrescrever: boolean): Boolean;
    procedure conecta();
  public

    PROG_ENV: PRC_FUNCS;
    filtroConsolidacao: string;
    //programaPronto: boolean;
    CONN: TADOConnection;
    aux1: Auxiliar;
    erroLogin: string;

    property UserName: string read FUserName write FUserName;
    property IDUsuario: string read FIDUsuario write FIDUsuario;
    property LastLogin: TDateTime read FLastLogin write FLastLogin;




    //constructor Create(Sender: TObject);
    function LoginENV(USR, PASS, ENV:string): boolean;

    /////////////////////////////////////////////////////////////////////////
    //Listas ////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////
    //Processos
    function ListarProcessos(): TADOQuery;
    //Consolidação - por Aliquotas
    function ListTotColunasPorAliquota: TADOQuery;
    function ListColunasPorAliquota: TADOQuery;
    function GetTotalColunas2(): integer;
    function qtAltAliq(aliq:double): integer;
    function ListarAliquotas(): TADOQuery;
    function ListarAliquotas2(): TADOQuery;
    //Histórico
    function GetTotalColunasHist: integer;
    function ListTotColunasPorAliquotaHist: TADOQuery;
    function ListColunasPorAliquotaHist: TADOQuery;
    function ListarAliquotasHist(IDPROC, CDEMP, CDPROD: string): TADOQuery;

  end;

var
  DM: TDM;

implementation
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
uses
  ServerController;



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


procedure TDM.conecta();
begin

  //strAux:=  conAS400;

  if Not CONN.Connected then begin
    CONN.ConnectionString:= conAS400;
    //strAux:=  CONN.ConnectionString;  //BASE_AS400.ConnectionString;
    aux1.conectaBase2(CONN);
  end;

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


function TDM.LoginENV(USR, PASS, ENV:string): boolean;
begin


  self.MY_ENV:= ENV;

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


function TDM.ListarProcessos(): TADOQuery;
begin


  conecta();
  lQue:= TADOQuery.Create(nil);
  lQue.Connection:= CONN; //BASE_AS400;


  TRY
  Try

    if MY_ENV <> 'TST'  then begin
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

    if MY_ENV = 'TST'  then begin
      lQue.SQL.Add('SELECT ');
      lQue.SQL.Add('PPSID as IDPROC,  ');
      lQue.SQL.Add('PRCAUDUSR,  ');
      lQue.SQL.Add('PRCDT as DTPROC,  ');
      lQue.SQL.Add('PRCVIGINI as DTVIGINI, PRCVIGFIM as DTVIGFIM, ');
      lQue.SQL.Add('CASE PRCSTATUS ');
      lQue.SQL.Add('	WHEN 0 THEN ''PROCESSADO'' ');
      lQue.SQL.Add('	WHEN 1 THEN ''ENVIADO'' ');
      lQue.SQL.Add('	WHEN 2 THEN ''CONSOLIDADO'' ');
      lQue.SQL.Add('END PRCSTATUS ');
      lQue.SQL.Add('FROM LPDDBICE.PPSPROCC ');
    end;

    lQue.Open;

  Except
      On E:Exception do
      //on e : EDatabaseError do
      begin
        strAux:= E.Message;
      end;
  End;
  Finally
    //aux1.fechaCon(CONN);
    Result := lQue;
  END;





//
//  try
//    lQue.SQL.Add('SELECT ');
//    lQue.SQL.Add('RIGHT(REPEAT(''0'', 6) || PPSID, 6) IDPROC, ');
//    lQue.SQL.Add('PRCAUDUSR,  ');
//    lQue.SQL.Add('TO_CHAR(TO_DATE(PRCDT, ''YYYYMMDD''), ''DD/MM/YYYY'') DTPROC, ');
//    lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGINI AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGINI, ');
//    lQue.SQL.Add('TO_CHAR(TO_DATE(CAST(PRCVIGFIM AS VARCHAR(8)),''YYYYMMDD''),''DD/MM/YYYY'') AS DTVIGFIM, ');
//    lQue.SQL.Add('CASE PRCSTATUS ');
//    lQue.SQL.Add('	WHEN 0 THEN ''PROCESSADO'' ');
//    lQue.SQL.Add('	WHEN 1 THEN ''ENVIADO'' ');
//    lQue.SQL.Add('	WHEN 2 THEN ''CONSOLIDADO'' ');
//    lQue.SQL.Add('END PRCSTATUS ');
//    lQue.SQL.Add('FROM LPDDBICE.PPSPROCC ');
//    lQue.Open;
//    Result := lQue;
//  finally
//  end;


end;



function TDM.GetTotalColunas2(): integer;
var
 totCol: integer; //idproc
 SQL: string;
begin

  totCol:= 0;
  //UserSession.GIDPROC:= '1';
  //idproc:= StrToInt(UserSession.GIDPROC);

  conecta();
  lQue:= TADOQuery.Create(nil);
  lQue.Connection := CONN;
  lQue.SQL.Clear;



  TRY
  Try


    SQL:=
    'SELECT                                                              '+SLineBreak+
    '  SUM(REG) as TOTAL                                                 '+SLineBreak+
    'FROM                                                                '+SLineBreak+
    '  (Select PPSICM, COUNT(DISTINCT PPSTP) REG from LPDDBICE.PPSCONSOL '+SLineBreak+
    '   where PPSID='+UserSession.GIDPROC+' and PPSICM > 0               '+SLineBreak+
    '   Group by PPSICM )X                                               ';
    lQue.SQL.Add(SQL);
    lQue.Open;
    totCol:= lQue.FieldByName('TOTAL').AsInteger;


//    lQue.SQL.Add('SELECT SUM(REG) TOTAL FROM (');
//    lQue.SQL.Add(' SELECT PPSICM, COUNT(DISTINCT PPSTP) REG ');
//    lQue.SQL.Add(' FROM (SELECT DISTINCT PPSTP, PPSICM FROM LPDDBICE.PPSPRICE WHERE PPSID = '+UserSession.GIDPROC+' and PPSICM > 0 ) X');
//    lQue.SQL.Add(' GROUP BY PPSICM ');
//    lQue.SQL.Add(')vw');
//    lQue.Open;
//    totCol:= lQue.FieldByName('TOTAL').AsInteger; //+ 1;
  Except
      On E:Exception do
      //on e : EDatabaseError do
      begin
        strAux:= E.Message;
      end;
  End;
  Finally
    lQue.Close;
    lQue.Free;
    aux1.fechaCon(CONN);
    Result := totCol;
  END;


 end;

function TDM.ListTotColunasPorAliquota: TADOQuery;
var
  lQue: TADOQuery;
  SQL: string;
begin


  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN; //ADOConn;
  lQue.SQL.Clear;

  try

    SQL:=
    'SELECT                                                                         '+SLineBreak+
    '  PPSICM, count(distinct PPSTP) TOTAL, sum(QTALT) as QTALT                     '+SLineBreak+
    'FROM                                                                           '+SLineBreak+
    '  (Select PPSICM, PPSTP, sum(QTALT) as QTALT                                   '+SLineBreak+
    '   from LPDDBICE.PPSCONSOL where PPSID='+UserSession.GIDPROC+' and PPSICM > 0  '+SLineBreak+
    '   group by PPSICM, PPSTP                                                      '+SLineBreak+
    '   order by PPSICM, PPSTP                                                      '+SLineBreak+
    '  )X                                                                           '+SLineBreak+
    'GROUP by PPSICM                                                                '+SLineBreak+
    'ORDER by PPSICM ';
    lQue.SQL.Add(SQL);
    lQue.Open;

    Result := lQue;
  finally

  end;

end;

function TDM.ListColunasPorAliquota: TADOQuery;
var
  lQue: TADOQuery;
  SQL: string;
begin


  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN;//ADOConn;
  lQue.SQL.Clear;

  try


    SQL:=
    'SELECT                                                   '+SLineBreak+
    '  PPSICM CAMPO, PPSTP VALOR                              '+SLineBreak+
    'FROM                                                     '+SLineBreak+
    '  (Select distinct PPSICM, PPSTP from LPDDBICE.PPSCONSOL '+SLineBreak+
    '   where PPSID='+UserSession.GIDPROC+' and PPSICM > 0    '+SLineBreak+
    '  )X                                                     '+SLineBreak+
    'GROUP by PPSICM, PPSTP                                   '+SLineBreak+
    'ORDER by PPSICM, PPSTP';
    lQue.SQL.Add(SQL);
    lQue.Open;


//    lQue.SQL.Add('SELECT PPSICM CAMPO, PPSTP VALOR FROM (');
//    lQue.SQL.Add(' SELECT DISTINCT PPSTP, PPSICM ');
//    lQue.SQL.Add(' FROM LPDDBICE.PPSPRICE WHERE PPSID = '+UserSession.GIDPROC+' and PPSICM > 0');
//    lQue.SQL.Add(')X');
//    lQue.SQL.Add('GROUP BY PPSICM, PPSTP');
//    lQue.SQL.Add('ORDER BY PPSICM');
//    lQue.Open;


    Result := lQue;
  finally
  end;


end;

function TDM.qtAltAliq(aliq:double): integer;
var
  qtAlt: integer;
begin

  qtAlt:= 1;


  if aliq = 12 then
    qtAlt:= 42;
  if aliq= 17 then
    qtAlt:= 13;
  if aliq= 17.5 then
    qtAlt:= 11;
  if aliq= 18 then
    qtAlt:= 22;
  if aliq= 28 then
    qtAlt:= 1;



  Result:= qtAlt;
end;

function TDM.ListarAliquotas(): TADOQuery;
var
  lQue: TADOQuery;
  SQL, aliq, aliqt, tipo, leftjoin, campos: string;
  idproc: string;
  idField: string;
  aliqOLD: string;
begin

  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN;//ADOConn;
  lQue.SQL.Clear;

  IDPROC:= UserSession.GIDPROC;

  try

    SQL:=
    'SELECT                                                   '+SLineBreak+
    '  PPSICM ALIQ, PPSTP TIPO                                '+SLineBreak+
    'FROM                                                     '+SLineBreak+
    '  (Select distinct PPSICM, PPSTP from LPDDBICE.PPSCONSOL '+SLineBreak+
    '   where PPSID='+IDPROC+' and PPSICM > 0                 '+SLineBreak+
    '  )X                                                     '+SLineBreak+
    'ORDER BY PPSICM, PPSTP' ;
    lQue.SQL.Add(SQL);
    lQue.Open;




    While not lQue.Eof do begin
      aliq  := lQue.FieldByName('ALIQ').AsString;
      aliqt := aliq;
      aliq  := aliq.Replace(',','');
      aliqt := aliqt.Replace(',','.');
      tipo  := lQue.FieldByName('TIPO').AsString.trim;
      idField:= concat('a',aliq,tipo);
      //campo := campo + ',' + idField+'.PPSVLPRP'; //*** orig

      if ( (aliqOLD<>'') and (aliqOLD<>aliq) ) then begin
        campos := campos +SLineBreak;
      end;
      aliqOLD:= aliq;

      campos := campos + ', ' + idField+'.PPSPRECO as PRC_'+idField;

      leftjoin := leftjoin+
                  'LEFT join LPDDBICE.PPSCONSOL ' + idField + SLineBreak+
                  ' ON  ('+idField+'.PPSPRD    = a.PPSPRD)'+
                  ' and ('+idField+'.PPSVIGINI = a.PPSVIGINI) and ('+idField+'.PPSVIGFIM=a.PPSVIGFIM) '+
                  ' and ('+idField+'.PPSICM    = '+QuotedStr(aliqt)+') and ('+idField+'.PPSTP='+QuotedStr(tipo)+') '+
                  ' and ('+idField+'.PPSID     = a.PPSID) '+SLineBreak;
      lQue.Next;
    End;


    SQL :=
    'select * from ( '+SLineBreak+
    'SELECT DISTINCT a.PPSID, a.PPSEMP, a.PPSPRD, a.PPSVIGINI, a.PPSVIGFIM '+SLineBreak +
     campos +SLineBreak+ ', a.VIGINIANT, a.VIGFIMANT, a.PRECOANT, a.QTALT, a.CONFRMD '+SLineBreak+
    'FROM LPDDBICE.PPSCONSOL a '+SLineBreak+ leftjoin +SLineBreak+
    'WHERE a.PPSID = '+IDPROC+' )vw ';


    lQue.Close;
    lQue.SQL.Clear;
    lQue.SQL.Text := SQL;

    aux.saveTXT(SQL, 'sql_ListarAliquotas.sql');

    lQue.Open;

    Result := lQue;
  finally


  end;


end;

function TDM.ListarAliquotas2(): TADOQuery;
var
  lQue: TADOQuery;
  SQL: string;
  filtro: string;
begin

  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN;
  lQue.SQL.Clear;
  filtro:= '';


  TRY
  try


    if filtroConsolidacao='todos' then
      filtro:= '';
    if filtroConsolidacao='alterados' then
      filtro:= 'and QTALT > 0';




    SQL:=
    'Select                                           '+SLineBreak+
    '  PPSID, PPSEMP, PPSPRD, PPSVIGINI, PPSVIGFIM,   '+SLineBreak+
    '  trim(PPSPRD)||PPSVIGINI||PPSVIGFIM KEY_LINE,   '+SLineBreak+
    '  PPSICM ALIQ, PPSTP TP, PPSPRECO PRC,           '+SLineBreak+
    '  PPSICM||trim(PPSTP) ID_COL,                    '+SLineBreak+
    '  VIGINIANT, VIGFIMANT, PRECOANT, QTALT, CONFRMD '+SLineBreak+
    'From                                             '+SLineBreak+
    '  LPDDBICE.PPSCONSOL                             '+SLineBreak+
    'Where                                            '+SLineBreak+
    '  PPSID='+UserSession.GIDPROC+' and PPSICM > 0   '+SLineBreak+
    '  '+filtro+'                                     '+SLineBreak+
    '  and PPSPRD in('+QuotedStr('JFT')+','+QuotedStr('JGQ')+')'+SLineBreak;

    if MY_ENV ='TST' then begin
      SQL:= SQL.Replace(
        'trim(PPSPRD)||PPSVIGINI||PPSVIGFIM KEY_LINE',
        'concat(trim(PPSPRD), PPSVIGINI, PPSVIGFIM) as KEY_LINE'
      );
    end;



    lQue.SQL.Add(SQL);
    lQue.Open;

  except
    On E:Exception do begin
      PROG_ENV.logICE.saveLog(PROG_ENV.INT_NAME+': Erro ao listar alíquotas (ListarAliquotas2). Erro ['+E.Message+']');
    end;

  end;

  FINALLY
    aux.saveTXT(SQL, 'sql_ListarAliquotas.sql');
    Result := lQue;
  END;


end;



function TDM.GetTotalColunasHist: integer;
var
  FQue: TADOQuery;
  total: integer;
begin

  conecta();
  FQue:= TADOQuery.Create(nil);
  FQue.Connection := CONN;//ADOConn;
  total:= 0;

  try
    FQue.SQL.Add('SELECT ');
    FQue.SQL.Add('  SUM(REG) TOTAL ');
    FQue.SQL.Add('FROM ');
    FQue.SQL.Add('  (Select PPSICM, count(distinct PPSTP) REG ');
    FQue.SQL.Add('   From (select distinct PPSTP, PPSICM From LPDDBICE.PPSHIST ');
    FQue.SQL.Add('         where  PPSID='+UserSession.GIDPROC+' and PPSPRD='+QuotedStr(UserSession.GPPSPRD)+' and PPSICM > 0) X' );
    FQue.SQL.Add('   Group by PPSICM ');
    FQue.SQL.Add('  )vw ');
    FQue.Open;
    total:= FQue.FieldByName('TOTAL').AsInteger; //+ 1 id adicional action column
  finally
    FQue.Close;
    FQue.Free;
    Result:= total;
  end;

end;

function TDM.ListTotColunasPorAliquotaHist: TADOQuery;
var
  lQue: TADOQuery;
begin

  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN; //ADOConn;
  lQue.SQL.Clear;

  try
    lQue.SQL.Add('SELECT PPSICM, COUNT(DISTINCT PPSTP) TOTAL');
    lQue.SQL.Add('FROM (Select DISTINCT PPSTP, PPSICM From LPDDBICE.PPSHIST ');
    lQue.SQL.Add('      Where  PPSID='+UserSession.GIDPROC+' and PPSPRD='+QuotedStr(UserSession.GPPSPRD)+' and PPSICM > 0) X');
    lQue.SQL.Add('GROUP BY PPSICM');
    lQue.SQL.Add('ORDER BY PPSICM');
    lQue.Open;
    Result := lQue;
  finally
  end;

end;

function TDM.ListColunasPorAliquotaHist: TADOQuery;
var
  lQue: TADOQuery;
begin

  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN; //ADOConn;
  lQue.SQL.Clear;

  try
    lQue.SQL.Add('SELECT PPSICM CAMPO, PPSTP VALOR FROM ');
    lQue.SQL.Add('(SELECT DISTINCT PPSTP, PPSICM FROM LPDDBICE.PPSHIST ');
    lQue.SQL.Add(' WHERE PPSID='+UserSession.GIDPROC+' and PPSPRD='+QuotedStr(UserSession.GPPSPRD)+' and PPSICM > 0) X');
    lQue.SQL.Add('GROUP BY PPSICM, PPSTP');
    lQue.SQL.Add('ORDER BY PPSICM');
    lQue.Open;
    Result := lQue;
  finally
  end;

end;

function TDM.ListarAliquotasHist(IDPROC, CDEMP, CDPROD: string): TADOQuery;
var
  lQue: TADOQuery;
  sql, aliq, aliqt, tipo, leftjoin, campo, idField: string;
begin

  conecta();
  lQue := TADOQuery.Create(nil);
  lQue.Connection := CONN;//ADOConn;
  lQue.SQL.Clear;

  try
    lQue.SQL.Add('SELECT PPSICM ALIQ, PPSTP TIPO ');
    lQue.SQL.Add('FROM (Select DISTINCT PPSTP, PPSICM FROM LPDDBICE.PPSHIST ');
    lQue.SQL.Add('      Where PPSID='+UserSession.GIDPROC+' and PPSPRD='+QuotedStr(UserSession.GPPSPRD)+' and PPSICM > 0) X');
    lQue.SQL.Add('GROUP BY PPSICM, PPSTP');
    lQue.SQL.Add('ORDER BY PPSICM, PPSTP');
    lQue.Open;

    sql := 'SELECT DISTINCT a.PPSID, a.PPSEMP, a.PPSPRD, a.PPSVIGINI, a.PPSVIGFIM ';

    while not lQue.Eof do
    begin
      aliq  := lQue.FieldByName('ALIQ').AsString;
      aliqt := aliq;
      aliq  := aliq.Replace(',','');
      aliqt := aliqt.Replace(',','.');
      tipo  := lQue.FieldByName('TIPO').AsString.trim;
      idField:= concat('a',aliq,tipo);
      campo := campo + ',' + idField+'.PPSVLPRP';

      leftjoin := leftjoin+
                  ' LEFT JOIN LPDDBICE.PPSHIST ' + idField +
                  ' ON  ('+idField+'.PPSPRD   = a.PPSPRD )'+
                  ' AND ('+idField+'.PPSVIGINI= a.PPSVIGINI) AND ('+ idField+'.PPSVIGFIM=a.PPSVIGFIM) '+
                  ' AND ('+idField+'.PPSICM   = '+QuotedStr(aliqt)+') AND ('+idField+'.PPSTP='+QuotedStr(tipo)+') '+
                  ' and ('+idField+'.PPSID    = '+idproc+') '+SLineBreak;
      lQue.Next;
    end;

    sql := sql + campo + ' FROM LPDDBICE.PPSHIST a '+ leftjoin + ' WHERE a.PPSID='+IDPROC+' AND a.PPSEMP= '+QuotedStr(CDEMP)+' AND a.PPSPRD='+QuotedStr(CDPROD);
    lQue.Close;
    lQue.SQL.Clear;
    lQue.SQL.Text := SQL;
    lQue.Open;

    Result := lQue;
  finally
  end;

end;




end.
