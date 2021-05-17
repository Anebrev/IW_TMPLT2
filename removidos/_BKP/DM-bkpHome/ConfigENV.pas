unit ConfigENV;



interface
  uses
    //classes de componentes
    ADODB, DB, TypInfo, SysUtils, StrUtils, Windows,
    //IWSystem,
    vcl.forms,
    ActiveX,
    Registry,
    //classes complementares
    clsLog, clsAuxiliar;

type
  TResultArray = array of string;
  PRC_FUNCS = Class




PRIVATE
  //VARIABLES //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  logICEproc, srvLOGtrace, srvLOG0: Log; //logICE: Log
  agenteServico: array of string;
  //aux: Auxiliar;
  //CONN. AS400
  HSA0013, baseAS400: TADOConnection;
  //CONN. ORACLE
  //DBORACLE, baseORACLE: TADOConnection;
  //conORACLE, conDataSrcORACLE, conUserORACLE, conPassORACLE, conPersistSecORACLE, conProviderORACLE: string; //conBaseORACLE
  //ini_ownerCST_HML, ini_ownerCST_PRD, ownerCST_HML, ownerCST_PRD: string;

  //PATH / LOG'S
  erroLOG, processamentoLOG: string;
  pathPREVIA, pathDEFINITIVO, pathLOG, dirLOG: string;
  pathApp, exeApp: string;
  qtErros: integer; //qtInclusao errosSP


  //spPPS_PROC: TADOStoredProc;

  //dsOrdemDesbAS400, dsOrdemJDAS400, dsOrdemGLOAS400, dsOrdemDesb2AS400: TADODataSet;
  //dsOrdemCOMEX, dsOrdemCOMEX_GLO: TADODataSet;
  //spORDEM,spGLO, spPEDIDO_REPROC: TADOStoredProc;
  //qtOrdemItemAS400, qtORDEM_DESB, qtORDEM_DESB2, qtORDEMrpc, qtGLOrpc: Integer; //qtOrdemAS400
  //listaPEDIDO: array of array of string;//TResultArray;


  //CONSTRUCTOR METHODS
  function configINI(): Boolean;
  //function criaProcedure_PROCPPS(sobrescrever:Boolean): Boolean;
  //procedure configDS_Fixo();

  //Procedimentos PROCESSO <Process Name> //////////////////////////////////////////////////
  //procedure procICE_PROC1();


PUBLIC
  INT_NAME: string;
  aux: Auxiliar;
  auxENV: Auxiliar;
  conAS400, conDataSrcAS400, conUserAS400, conPassAS400, conBaseAS400, conPersistSecAS400, conProviderAS400: string;
  conDataSrcAS400_PY, conBaseAS400_PY, conPersistSecAS400_PY, conProviderAS400_PY: string;
  programaPronto: Boolean;
  recriaProcedure: boolean;
  logICE: Log;
  constructor Create();
  //function criaProcedures(sobrescrever:boolean): Boolean;



end;


var
  auxENV: Auxiliar;
implementation



{$REGION 'CONSTRUTOR'}
//////////////////////////////////////////////////////////////////////////////////////
// FUNÇÕES DO CONSTRUTOR                                                            //
//////////////////////////////////////////////////////////////////////////////////////
constructor PRC_FUNCS.Create();
var
  nomeLog:string;
  agentServico: array of string;
begin

  qtErros:= 0;

  INT_NAME:= 'SGX - Geração de Obrigação Fiscal';
  pathApp:= ExtractFilePath(Application.ExeName);
  exeApp:= ExtractFileName(Application.ExeName);
  exeApp:= StringReplace(exeApp,'.exe','',[rfReplaceAll, rfIgnoreCase]);

  srvLOG0:= Log.Create(pathApp+'\'+exeApp+'_0.log', agenteServico, False, False,'');
  srvLOGtrace:= Log.Create(pathApp+'\'+'TraceSRV_'+exeApp+'.log',agenteServico, False, False,'');
  aux:= Auxiliar.Create(pathApp+'\'+exeApp+'_aux.log', agenteServico, INT_NAME);
  auxENV:= Auxiliar.Create(pathApp+'\'+exeApp+'_aux.log', agenteServico, INT_NAME);

  if not configINI() then
  begin
    exit;
  end;



  //INICIALIZA SISTEMA DE LOGS /////////////////////////////////////////////////////////////////////
  nomeLog:= AnsiMidStr(erroLOG, 1, length(erroLOG)-4); //pega nomeLog sem extensão (.log)

  //i) log de erro diário - logErro + data -> histórico de log passa a ser diário
  //   não sobrescreve, acumula logs do dia e não é enviado por email
  erroLOG:= dirLOG+'\'+ nomeLog +'_'+ FormatDateTime('YYYYMMDD',Now) + '.log';
  logICE:= Log.Create(erroLOG, agentServico, False, False, '');

  //ii) Log de status de processo
  processamentoLOG:= dirLOG+'\'+processamentoLOG;
  logICEproc:= Log.Create(processamentoLOG, agentServico, True, False, '');



  //INICIALIZA FUNCOES AUXILIARES ///////////////////////////////////////////////////////////////////
  aux:= Auxiliar.Create(erroLOG, agentServico, INT_NAME);



  //INICIALIZA CONEXÕES DB ///////////////////////////////////////////////////////////////////////////
  baseAS400:=  HSA0013;
  //baseAS400.CommandTimeout:= 120; //default 30
  //baseORACLE:= DBORACLE;



  //CRIA DATASETS ////////////////////////////////////////////////////////////////////////////////////
  //Carrega DataSet's [ds...]
  //dsOrdemDesbAS400:= aux.configDS(dsOrdemDesbAS400, 'dsORDEMDESB_AS400');



  //PROCEDURES DB /////////////////////////////////////////////////////////////////////////////////////
  //spPPS_PROC:= TADOStoredProc.Create(nil);
  //ownerCST_HML:= ini_ownerCST_HML;
  //ownerCST_PRD:= ini_ownerCST_PRD;

  //CRIA PROCEDURES  **movido após login - quando identifica o ambiente
  //If not criaProcedures(recriaProcedure) then
  //begin
  //  programaPronto:= False;
  //end;


end;

function PRC_FUNCS.configINI(): Boolean;
var
  i, errosINI: Integer;
  str: string;
  posEQ: Shortint;
  strAtributo, strValor: string;
  trace: Boolean;
  iniValores: clsAuxiliar.TResultArray; //clsLog.TResultArray
  //baseConectada: Boolean;
  fileINI: string;
begin


  programaPronto:= False;
  errosINI:= 0;
  //baseConectada:= false;


  // VALIDA EXISTÊNCIA DO ARQUIVO .INI
  fileINI:= pathApp+'\'+exeApp+'.ini';
  if Not (FileExists(fileINI)) then
  begin
    programaPronto:= False;
    Result:= programaPronto;
    srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração do arquivo INI.'+' Erro [Arquivo de inicialização (*.INI) não encontrado.]');
    exit;
  end;


  {$REGION 'CONN'}
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  STRING DE CONEXAO [Recupera nome da conexão (Data Source) ODBC]  ///////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //CON. AS400 - PY
  try
    SetLength(iniValores,6);
    iniValores:= aux.getConfig(pathApp+exeApp+'.exe', 'CONAS400_PD' );
    for i := 0 to Length(iniValores)-1 do
    begin
       str:= iniValores[i];
       //separa atributo e valor
       posEQ:= Pos('=', str);
       strAtributo:= AnsiMidStr(str,1, posEQ-1);
       strValor:= AnsiMidStr(str, posEQ+1, 100);
       //atribui valores
       if strAtributo='Provider' then
         conProviderAS400:= strValor
       //else if strAtributo='User ID' then
       //  conUserAS400:= strValor
       //else if strAtributo='Password' then
       //  conPassAS400:= strValor
       else if strAtributo='Data Source' then
         conDataSrcAS400:= strValor
       else if strAtributo='Initial Catalog' then
         conBaseAS400:= strValor
       else if strAtributo='Persist Security Info' then
         conPersistSecAS400:= strValor
    end;
  except
    On E:Exception do
    begin
      programaPronto:= False;
      //errosINI:=  errosINI + 1;
      Result:= programaPronto;
      str:= E.Message;
      srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração de conexão AS400.'+' Erro ['+E.Message+']');
      exit;
    end;
  end;


  //CON. AS400 - PD
  try
    SetLength(iniValores,6);
    iniValores:= aux.getConfig(pathApp+exeApp+'.exe', 'CONAS400_PY' );
    for i := 0 to Length(iniValores)-1 do
    begin
       str:= iniValores[i];
       //separa atributo e valor
       posEQ:= Pos('=', str);
       strAtributo:= AnsiMidStr(str,1, posEQ-1);
       strValor:= AnsiMidStr(str, posEQ+1, 100);
       //atribui valores
       if strAtributo='Provider' then
         conProviderAS400_PY:= strValor
       //else if strAtributo='User ID' then
       //  conUserAS400:= strValor
       //else if strAtributo='Password' then
       //  conPassAS400:= strValor
       else if strAtributo='Data Source' then
         conDataSrcAS400_PY:= strValor
       else if strAtributo='Initial Catalog' then
         conBaseAS400_PY:= strValor
       else if strAtributo='Persist Security Info' then
         conPersistSecAS400_PY:= strValor
    end;
  except
    On E:Exception do
    begin
      programaPronto:= False;
      //errosINI:= errosINI + 1;
      Result:= programaPronto;
      str:= E.Message;
      srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração de conexão AS400.'+' Erro ['+E.Message+']');
      exit;
    end;
  end;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  STRING DE CONEXAO [Valida Conexão]  ////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////Valida Conn. AS400
  //TRY
  //  Try
  //    baseConectada:= false;
  //    conAS400:= aux.doConnString(
  //      conDataSrcAS400, conUserAS400, conPassAS400, conProviderAS400, conPersistSecAS400); //conBaseAS400);//initialCatalog removida: nula dá erro em com Oracle);
  //    CoInitialize(nil);
  //    HSA0013:= TADOConnection.Create(nil);
  //    HSA0013.ConnectionString:= conAS400;
  //    aux.fechaCon(HSA0013);
  //    baseConectada:= aux.conectaBase2(HSA0013);
  //    aux.fechaCon(HSA0013);
  //  Except
  //    On E:Exception do
  //    begin
  //      programaPronto:= False;
  //      //errosINI:= errosINI + 1;
  //      Result:= programaPronto;
  //      str:= E.Message;
  //      srvLOG0.saveLog(INT_NAME+' --> Data Source ['+conDataSrcAS400+']: Erro durante configuração de conexão com o BD.'+' Erro ['+E.Message+']');
  //      exit;
  //    end;
  //  End;
  //FINALLY
  //  begin
  //    if not baseConectada then
  //    begin
  //      errosINI:= errosINI + 1;
  //      srvLOG0.saveLog(INT_NAME+' --> Data Source ['+conDataSrcAS400+']: Ocorreram erros durante configuração de conexão com o BD.');
  //    end;
  //  end;
  //END;



  {$ENDREGION}


  {$REGION 'LOGS'}
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  LOGS, DORETÓRIOS E OUTROS  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //NOME DOS LOGS
  try
    SetLength(iniValores,2);
    iniValores:= aux.getConfig(pathApp+exeApp+'.exe', 'LOGS' );
    for i := 0 to Length(iniValores)-1 do
    begin
       str:= iniValores[i];
       //separa atributo e valor
       posEQ:= Pos('=', str);
       strAtributo:= AnsiMidStr(str,1, posEQ-1);
       strValor:= AnsiMidStr(str, posEQ+1, 100);
       //atribui valores
     if strAtributo='erro' then
       erroLog:= strValor
     else if strAtributo='proc' then
       processamentoLog:= strValor
     else if strAtributo='path' then
       pathLOG:= strValor
    end;
    dirLOG:= pathLOG;
  except
    On E:Exception do
    begin
      errosINI:= errosINI + 1;
      srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração de diretórios.'+' Erro ['+E.Message+']');
    end;
  end;

  {$ENDREGION}


  {$REGION 'DIRETORIOS'}
  //DIRETÓRIOS
  try
    SetLength(iniValores,4);
    iniValores:= aux.getConfig(pathApp+exeApp+'.exe', 'DIRETORIOS' );
    for i := 0 to Length(iniValores)-1 do
    begin
       str:= iniValores[i];
       //separa atributo e valor
       posEQ:= Pos('=', str);
       strAtributo:= AnsiMidStr(str,1, posEQ-1);
       strValor:= AnsiMidStr(str, posEQ+1, 100); //50->100
       //atribui valores
       if strAtributo='XML_PREVIA' then
         pathPREVIA:= strValor
       else if strAtributo='XML_DEFINITIVO' then
         pathDEFINITIVO:= strValor
    end;
  except
    On E:Exception do
    begin
      programaPronto:= False;
      //errosINI:= errosINI + 1;
      Result:= programaPronto;
      //str:= E.Message;
      srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração de diretórios.'+' Erro ['+E.Message+']');
      exit;
    end;
  end;

  //Testa acesso a diretórios
  if Not aux.acessaDiretorio(pathPREVIA) then
    errosINI:= errosINI + 1;
  if Not aux.acessaDiretorio(pathDEFINITIVO) then
    errosINI:= errosINI + 1;
  if Not aux.acessaDiretorio(pathLOG) then
    errosINI:= errosINI + 1;

  {$ENDREGION}


  {$REGION 'OUTROS'}
  //OUTROS - Recriação de procedure, owner, etc
  try
    SetLength(iniValores,2);
    iniValores:= aux.getConfig(pathApp+exeApp+'.exe', 'OUTROS' );
    for i := 0 to Length(iniValores)-1 do
    begin
       str:= iniValores[i];
       //separa atributo e valor
       posEQ:= Pos('=', str);
       strAtributo:= AnsiMidStr(str,1, posEQ-1);
       strValor:= AnsiMidStr(str, posEQ+1, 100);
       //atribui valores
     if strAtributo='recriaProcedures' then
       recriaProcedure:=  StrToBool(strValor)
     //else if strAtributo='ownerCST_HML' then
     //  ini_ownerCST_HML:= strValor
     //else if strAtributo='ownerCST_PRD' then
     //  ini_ownerCST_PRD:= strValor
    end;
  except
    On E:Exception do
    begin
      errosINI:= errosINI + 1;
      srvLOG0.saveLog(INT_NAME+' --> Erro durante configuração de OUTROS.'+' Erro ['+E.Message+']');
    end;
  end;
  {$ENDREGION}



  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //  TRACE  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  trace:= StrToBool( aux.getProperty(pathApp+exeApp+'.exe', 'TRACE') );
  if trace then
  begin
    srvLOGtrace.saveLogOver('Begin Tracing:');
    srvLOGtrace.saveLog('LOGS: erro['+erroLog+']; proc['+processamentoLog+']');
    srvLOGtrace.saveLog('DIRETORIOS: PREVIA['+pathPREVIA+']; DEFINITIVO['+pathDEFINITIVO+']; LOG['+pathLOG+']');
    srvLOGtrace.saveLog('CONAS400: ODBC Data Source['+conDataSrcAS400+']; Base['+conBaseAS400+']; User['+conUserAS400+']');
    srvLOGtrace.saveLog('End Tracing.');
  end;



  if errosINI> 0 then
    programaPronto:= false
  else
    programaPronto:= true;


  Result:=programaPronto;

end;





{$REGION 'OFF'}

//procedure PRC_FUNCS.configDS_Fixo();
////var
//  //strCMDSQL: string;
//begin
//
//
//  //LISTA DE INSUMOS PADRÃO
////  strCMDSQL:= '           select * from LPDDBICE.CET021 ';
////  strCMDSQL:= strCMDSQL+ 'where PADStatusI in (0, 2, 3)';
////  dsINSUMOS_PAD:= TADODataSet.Create(nil);
////  dsINSUMOS_PAD.Name:= 'dsINSUMOS_PAD';
////  dsINSUMOS_PAD.CommandText:= strCMDSQL;
////  dsINSUMOS_PAD.Fields.Clear();
////
////
////  //LISTA DE INSUMOS PEXPAM
////  strCMDSQL:= '           select * from LPDDBICE.CET022 ';
////  strCMDSQL:= strCMDSQL+ 'where PEXStatusI in (0, 2, 3)';
////  dsINSUMOS_PEX:= TADODataSet.Create(nil);
////  dsINSUMOS_PEX.Name:= 'dsINSUMOS_PEX';
////  dsINSUMOS_PEX.CommandText:= strCMDSQL;
////  dsINSUMOS_PEX.Fields.Clear();
//
//end;
{$ENDREGION}

{$ENDREGION}



end.

