unit clsAuxiliar;

interface
  uses
    //classes complementares
    clsLog,
    //classes de componentes
    ADODB, DB, TypInfo, Windows, SysUtils, StrUtils,
    IniFiles, Classes, vcl.forms;

    //IWCommonSystem;  //,IWSystem;
    //para email
    //IdSMTP, IdMessage, IdAttachmentFile;

    //classes de componentes
    //ADODB, DB, TypInfo, SysUtils, StrUtils, Windows, Classes;
    //ActiveX, Registry;






type
  TResultArray = array of string;
  //TResultArrayCustom = array of string;
  Auxiliar = Class

  private
    logICE: Log;
    INT_NAME: string;

  public
    procedure conectaBase(baseAS: TADOConnection);

    function conectaBase2(baseAS: TADOConnection): Boolean;

    function checaBase(base: TADOConnection): Boolean;

    procedure fechaCon(base: TADOConnection);

    function pegaQtdeRegistros(baseAS:TADOConnection; Tabela:string; Param1:string;
    vlParam1:string; Param2:string; vlParam2:string; Param3:string;vlParam3:string): Integer;

    function complCampo(campo:string; tamanho:Smallint; tipoCompl:Shortint; precisao:Shortint): String;

    function pegaStringAte(strValor:String; delimitador:string): string;

    function pegaCampoLine(line:String; delimitador:string; nrCampo:Integer): string;

    function pegaTotalCampoLine(line:String; delimitador:string): Integer;

    function truncaCampo(campo:string; tamanho:Integer): string;

    function truncaDecimal(campo:string; precisao:Shortint): String;

    function transfereTXT(nmInterface, fileTXT, pathINOUT, pathEnviados:string): Shortint;

    function moveTXT(nmInterface, fileTXT, pathDestino:string): Shortint;

    function listArquivos_Single(pathFILE, prefixoHeader:string; maxToList:Integer): TResultArray;

    function acessaDiretorio(diretorio:string): Boolean;

    //function doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; pFILE:TextFile; INT_NAME:string): Boolean;
    //function doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; INT_NAME:string): TextFile;//Boolean;
    //procedure doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; pFILE:TextFile; INT_NAME:string; fileCriado:bool);

    procedure limpaDataSet(ds: TADODataSet);

    function ElapsedTime(Start: DWORD): String;

    function doConnString(dataSrc, user, Pass, provider, persistSec: string): String;  //initialCatalog removida: nula dá erro em com Oracle);

    function getConfig(IniApplication, Sessao: String): TResultArray;

    function getProperty(IniApplication, Sessao: String): String;

    procedure criaParametroSP(SP:TADOStoredProc; nome:string; tipo:TDataType; tamanho,precisao:Integer);

    function dropProcedureAS400(baseAS400:TADOConnection; routine_name, routine_schema, routine_type: string; sobrescrever:Boolean): Integer;

    function loadDataSet(baseDB:TADOConnection; pDataset:TADODataSet): Integer;

    procedure criaParametroDS(DS:TADODataSet; nome:string; tipo:TDataType; tamanho,precisao:Integer);

    procedure criaParametroQRY(QRY:TADOQuery; nome:string; tipo:TDataType; tamanho,precisao:Integer);

    function configDS(dsPROC:TADODataSet; ds_name:string): TADODataSet;

    procedure TrimAppMemorySize;

    procedure updtSTATUS_ICE(
        baseAS400: TADOConnection; Tabela:string; campoStatus:string;Status:Byte;
        Key1, vlK1,  Key2, vlK2,  Key3, vlK3, Key4, vlK4 :string);




    //Contrutores públicos
    constructor Create(fileLog:string; agenteServico:array of string; pINT_NAME:string);



end;

implementation
//############################ IMPLEMENTAÇÃO DOS MÉTODOS ###########################

//Implementação cosntrutores
constructor Auxiliar.Create(fileLog:string; agenteServico:array of string; pINT_NAME:string);
begin

  //inicia Log de erro
  logICE:= Log.Create(fileLog, agenteServico, False, False, '');
  INT_NAME:= pINT_NAME;

end;

//Implementação métodos não-funcionais privados
procedure Auxiliar.conectaBase(baseAS: TADOConnection);
begin

  //Efetua a conexão com o banco
    try
      //baseAS:=TADOConnection.Create(nil);
      baseAS.LoginPrompt:=False;
      baseAS.Connected:=True; //open the connection
      baseAS.Open;
    except
      On E:EDatabaseError do
        logICE.saveLog(E.Message);
    end;

end;

function Auxiliar.conectaBase2(baseAS: TADOConnection): Boolean;
var
  connected: boolean;
begin


  //Efetua a conexão com o banco
  connected:= false;
  try
    //baseAS:=TADOConnection.Create(nil);
    baseAS.LoginPrompt:=False;
    baseAS.Connected:=True; //open the connection
    baseAS.Open;
    connected:= true;
  except
    On E:EDatabaseError do
      logICE.saveLog(E.Message);
  end;

  result:= connected;

end;

procedure Auxiliar.fechaCon(base: TADOConnection);
begin


   if base = nil then
   begin
      base.Free;
      exit;
   end;

   try

    try
      if base.Connected then
      begin
        base.Connected:= False;
        base.Close;
        //base.Free;
      end;
    except
      //On E:EDatabaseError do
      On E:Exception do
        logICE.saveLog(E.Message);
    end;

   finally
      //base.Free;
   end;

end;

function Auxiliar.checaBase(base: TADOConnection): Boolean;
begin
  if base.Connected then
    result := True
  else
    begin
      //logICE.saveLog('Base está offline');
      result := False; // ConectaBanco;
    end;

end;

function Auxiliar.pegaQtdeRegistros(baseAS:TADOConnection; Tabela:string; Param1:string;
  vlParam1:string; Param2:string; vlParam2:string; Param3:string;vlParam3:string): Integer;
var
  qryAux: TADOQuery;
begin


  if Not (checaBase(baseAS)) then
  begin
    conectaBase(baseAS);
  end;


  qryAux := TADOQuery.Create(nil);
  qryAux.Connection := baseAS;
  qryaux.SQL.Text := 'SELECT count(*) AS qtRegistro FROM '+ Tabela;
  if Length(Param1) > 0 then
    qryaux.SQL.Add(' WHERE '+Param1+'='''+vlParam1+'''');
  if Length(Param2) > 0 then
    qryaux.SQL.Add(' AND '+Param2+'='''+vlParam2+'''');
  if Length(Param3) > 0 then
    qryaux.SQL.Add(' AND '+Param3+'='''+vlParam3+'''');

  qryAux.Open;
  Result := qryAux.FieldByName('qtRegistro').AsInteger;

end;

function Auxiliar.complCampo(campo:string; tamanho:Smallint; tipoCompl:Shortint; precisao:Shortint): String;
var
  strCampo:string;
  splitDec, splitInt: string;
  posDecimal: Shortint;
begin

     // tipoCompl:
     // 0 - string
     // 1 - Inteiro
     // 2 - Decimal
     // 3 - Data

    strCampo:= campo;
    while Length(strCampo) < tamanho do
    begin

      //sempre que vier em branco(nulo) ou zero(mas não for string), manda somente espaços
      if (Length(strCampo) = 0) then
         tipoCompl:=0;
      if (strCampo='0') and  Not (tipoCompl=0) then
      begin
         tipoCompl:=0;
         strCampo:=' ';
      end;

      //STRING E INTEIRO
      case tipoCompl of
        0: strCampo:= strCampo + ' ';  //0:completa com espaço ' ' à direita
        1: strCampo:= '0' + strCampo;  //0:completa com zero '0' à esquerda
      end;


      //DECIMAL
      if tipoCompl = 2 then
      begin

        //i) Separa partes inteira e decimal
        strCampo:= StringReplace(strCampo, ',', '.',[rfReplaceAll, rfIgnoreCase]);
        posDecimal:= Pos('.', strCampo);
        //..se não tiver posicao inicial de decimal assumir tamanho do campo + 1
        if (posDecimal= 0) then
           posDecimal:=Length(strCampo)+1;

        splitDec:= AnsiMidStr(strCampo, posDecimal+1, precisao);
        splitInt:= AnsiMidStr(strCampo,1, posDecimal-1);

        //ii) Se não tiver inteiro, assumir '0'
        if (Length(splitInt) < 1) then
          splitInt:= '0';
        //Se não tiver decimal, assumir '0'
        if (Length(splitDec) < 1) then
          splitDec:= '0';

        //iii) Completa tamanho da precisão
        while Length(splitDec) < precisao do
        begin
          splitDec:= splitDec+'0';
        end;

        //iv) mescla partes inteira e decimal
        strCampo:= splitInt + '.' + splitDec;

        //v) Completa o tamanho do campo com zeros à esquerda
        while (Length(strCampo) < tamanho) do
        begin
          strCampo:= '0' + strCampo;
        end;


      end;


      //DATA [YYYYMMDDHHMMSS]
      if tipoCompl = 3 then
      begin
        // completa com '0' à direita
        while (Length(strCampo) < tamanho) do
        begin
          strCampo:= strCampo + '0';
        end;
      end;


    end;

    Result:= strCampo;

end;

function Auxiliar.pegaStringAte(strValor:String; delimitador:string): string;
var
  posDelimitador: Integer;
  strValorCampo: string;
begin


    posDelimitador:= Pos(delimitador, strValor);
    strValorCampo:= AnsiMidStr(strValor, 1, posDelimitador-1);


   Result:= strValorCampo;
end;

function Auxiliar.pegaCampoLine(line:String; delimitador:string; nrCampo:Integer): string;
var
  //strVar:string;
  //splitDec, splitInt: string;
  posDelimitador0, posDelimitador1, tamCampo: Integer;
  strValorCampo: string;
  i:Integer;
begin

  //Inicializa variavevis
  //posDelimitador0:= 0;
  //posDelimitador1:= 0;
  //tamCampo:= 0;
  strValorCampo:= '';


  //teste
  //line:= '|campo1|campo02|campo003|campoN|';

  //Para achar um campo n,
  //i) percorrer line até encontrar n delimitadores
  for i := 1 to nrCampo do
  begin
     posDelimitador0:= Pos(delimitador, line);
     line:= AnsiMidStr(line, posDelimitador0+1, Length(line));
  end;

  //define o ponto final do campo
  posDelimitador1:= Pos(delimitador, line);
  //como os campos antes da ocorrencia=nrCampo da line já foram descatardos, o valor do campo vai da posição 1 até a proxima ocorrencia do delimitador:
  tamCampo:= posDelimitador1-1;//posição 1 até a posição antes do delimitador
  //pega string do intervalo definido
  strValorCampo:= AnsiMidStr(line, 1, tamCampo);





   Result:= strValorCampo;

  //Para achar um campo n,
  //i) pega a posição da n-esima ocorrencia do delimitador
  //posDelimitador0:= StrUtils.PosEx(separador,line,nrCampo);**** função delphi não está funcionando
  //ii) pega a posição da n-esima+1 ocorrencia do delimitador p/ calcular o tamanho do campo
  //posDelimitador1:= StrUtils.PosEx(delimitador, line, nrCampo+1);**** função delphi não está funcionando
  //tamCampo:= posDelimitador1 - posDelimitador0;

end;

function Auxiliar.pegaTotalCampoLine(line:string; delimitador:string): Integer;
var
   P: Byte;
   S: string;
begin

  Result := -1; //decrementa 1 delimitador
  S:= line;

  P := Pos (delimitador, S);
  while P > 0 do
  begin
    Inc (Result);
    S := Copy (S, P + Length(delimitador), Length(S));
    P := Pos (delimitador, S);
  end;


end;

function Auxiliar.truncaCampo(campo:string; tamanho:Integer): string;
var
  strCampo:string;
begin

  strCampo:= campo;

  if (Length(campo) > tamanho) then
  begin
     strCampo:= AnsiMidStr(campo, 1, tamanho);
  end;


  Result:=strCampo;

end;

function Auxiliar.truncaDecimal(campo:string; precisao:Shortint): String;  //@@Difers from EMBARQUE_OLD
var
  strCampo:string;
  splitDec, splitInt: string;
  posDecimal: Shortint;
begin

    strCampo:= campo;
    strCampo:= StringReplace(strCampo, '.', ',',[rfReplaceAll, rfIgnoreCase]);
    posDecimal:= Pos(',', strCampo);


    //se tiver posição decimal, truncar
    if posDecimal>0 then
    begin

      splitDec:= AnsiMidStr(strCampo, posDecimal+1, precisao);
      //splitDec:= AnsiMidStr(splitDec,1, precisao);

      splitInt:= AnsiMidStr(strCampo,1, posDecimal-1);
      if ( length(splitInt) < 1 ) then
        splitInt:= '0';

      strCampo:= splitInt + ',' + splitDec;

    end;


    Result:= strCampo;

end;

function Auxiliar.transfereTXT(nmInterface, fileTXT, pathINOUT, pathEnviados:string): Shortint;
var
  resultProc: Shortint;
  //IMP:Impersoner;
  //usr, strMsg:string;
Begin

  resultProc:= 0;

  try

    CopyFile(PChar(fileTXT), PChar(pathINOUT), true);
    MoveFile(PChar(fileTXT), PChar(pathEnviados));
    resultProc:= 1;

  except
    On E:Exception do
      logICE.saveLog('ICE: '+nmInterface+' [TXT '+fileTXT+ ' NÃO TRANSFERIDO!. Erro ['+E.Message+']');
  end;

  //Volta para usuario original
  //RevertToSelf;
  //usr:= IMP.GetCurrUserName;

  Result:= resultProc;

end;

function Auxiliar.moveTXT(nmInterface, fileTXT, pathDestino:string): Shortint;
var
  resultProc: Shortint;
Begin

  resultProc:= 0;


  try

    //CopyFile(PChar(fileTXT), PChar(pathINOUT), true);
    MoveFile(PChar(fileTXT), PChar(pathDestino));
    resultProc:= 1;

  except
    On E:Exception do
      logICE.saveLog('ICE: '+nmInterface+' [TXT '+fileTXT+ ' NÃO TRANSFERIDO para o diretório '+pathDestino+'. Erro ['+E.Message+']');
  end;


  Result:= resultProc;



end;

function Auxiliar.listArquivos_Single(pathFILE, prefixoHeader:string; maxToList:Integer): TResultArray;
var
  listados: Integer;
  SR: TSearchRec;
  IsFound : Integer;
  arquivos: TResultArray;
begin

  //LISTA ARQUIVOS HEADER
  IsFound := FindFirst(pathFILE+'\'+prefixoHeader+'*.txt*', faAnyFile, SR);
  listados:= 0;
  while (IsFound = 0) and (listados < MAXtoList) do
  begin

    SetLength(arquivos, Length(arquivos)+1);
    arquivos[listados]:= SR.Name;

    IsFound := FindNext(SR);
    listados:= listados + 1;
  end;
  SysUtils.FindClose(SR); //SysUtils added

  Result:= arquivos;

end;

function Auxiliar.acessaDiretorio(diretorio:string): Boolean;
var
  temAcesso:Boolean;
  f: TextFile;
  fileTXT: string;
begin

  temAcesso:= false;

  TRY
    try
      fileTXT:= diretorio+'\acesso.txt';
      AssignFile(f,fileTXT);
      Rewrite(f);
      writeln(f,DateTimeToStr(Now)+' --> Teste de acesso');
      CloseFile(f);
      DeleteFile(pChar(fileTXT));  //use pChar or SysUtils.DeleteFile(fileTXT)
      temAcesso:= True;
    except
      On E:Exception do
        logICE.saveLog(INT_NAME+' --> Erro durante configuração do diretório '+ diretorio +'. Erro ['+E.Message+']');
    end;
  FINALLY
    Result:= temAcesso;
  END;

end;




//function Auxiliar.doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; INT_NAME:string): TextFile;//Boolean;
//function Auxiliar.doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; pFILE:TextFile; INT_NAME:string): Boolean;
//procedure Auxiliar.doTXT(pathFILE, fileTXT, fileName, prefixoTXT:string; pFILE:TextFile; INT_NAME:string; fileCriado:bool);
//var
//  //fileTXTPAD, filePADName: string;
//  dataAtual: string;
//  txtCriado: bool;
//  //pFILE:TextFile;
//begin
//
//  TRY
//  try
//    txtCriado:= false;
//    dataAtual:= FormatDateTime('YYYYMMDDHHMMSS',Now);
//    //filePADName:= prefixoTXT +dataAtual+ '.TXT';   //'INS_' +dataAtual+ '.TXT';
//    fileName:= prefixoTXT +dataAtual+ '.TXT';   //'INS_' +dataAtual+ '.TXT';
//    //fileTXTPAD:= pathFILE+'\'+filePADName;//pathICE_TMP+'\'+filePADName;
//    fileTXT:= pathFILE+'\'+fileName;//pathICE_TMP+'\'+filePADName;
//    //AssignFile(pFILE, fileTXTPAD); //AssignFile(fPAD,fileTXTPAD);
//    AssignFile(pFILE, fileTXT); //AssignFile(fPAD,fileTXTPAD);
//    Rewrite(pFILE); //Rewrite(fPAD);
//  except
//    On E:Exception do
//    begin
//        logICE.saveLog(INT_NAME+ ': Erro ao criar TXT. Erro ['+E.Message+']');
//    end;
//  end;
//  FINALLY
//    Result:= pFILE;//txtCriado;
//  END;
//
//end;


//Implementação métodos auxiliares
procedure Auxiliar.limpaDataSet(ds: TADODataSet);
var
  statusDS: string;
begin

  statusDS:= GetEnumName(TypeInfo(TDataSetState), Ord(ds.State));
  if (statusDS='dsActive') then
  begin
    ds.DeleteRecords();
    ds.Active:= False;
    ds.Close;
  end;


  if (statusDS='dsBrowse') then
  begin
    //ds.DeleteRecords();
    //ds.Active:= False;
    ds.Close;
  end;

   statusDS:= GetEnumName(TypeInfo(TDataSetState), Ord(ds.State));

end;

function Auxiliar.ElapsedTime(Start: DWORD): String;
var Hor,Min,Sec,MSec,TimeDif: DWORD;
begin
  TimeDif := GetTickCount - Start; //Pega a diferença do Fim e Início

  Hor := ((TimeDif div 3600000) mod 24); //Divide o TimeDif por 36*10^5 e pega o resto do resultado dividido por 24
  Min := ((TimeDif div 60000) mod 60); //Faz a mesma coisa só muda os dados
  Sec := ((TimeDif div 1000) mod 60); //Faz a mesma coisa só muda os dados²
  MSec := (TimeDif mod 1000); //Pega o resto de TimeDif dividido por 1000

  Result := Format('%.2d:%.2d:%.2d.%.3d',[Hor,Min,Sec,MSec]); //Formata em HH:MM:SS.sss
end;

procedure Auxiliar.TrimAppMemorySize;
var
  MainHandle : THandle;
begin

  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
    CloseHandle(MainHandle) ;
  except
  end;
  //Application.ProcessMessages; //** não funciona para serviços

end;

function Auxiliar.doConnString(dataSrc, user, pass, provider, persistSec: string): String;  //initialCatalog removida: nula dá erro em com Oracle);
var
  conString: string;
begin

  //if tpDB = 'ORACLE' then
  //  provider:= 'MSDAORA.1'
  //else
  //  provider:= 'MSDASQL.1';

  conString:=
    'Provider=' + provider +';' +
    'Password=' + pass +';' +
    'User ID=' + user +';' +
    'Data Source=' + dataSrc +';' +
    'Persist Security Info='+ persistSec;
    //'Initial Catalog='+ initialCatalog;

  Result:= conString;
  //Provider=MSDAORA.1;Password=Cetjna14;User ID=sb037635;Data Source=sfwhml;Persist Security Info=True

end;

function Auxiliar.getConfig(IniApplication, Sessao: String): TResultArray;
var
  //path:string;
  arquivo:String;
  i:Integer;
  MyIniFile:TIniFile;
  Valores:TStringList;
  arrValores: TResultArray;
  //IniOrigem:String;
  //Criptografa:TCryptFile;
begin

  //Criptografa := TCryptFile.Create(nil);
  { Obtém o comprimento da variável }
  //path := '';
  //i := GetEnvironmentVariable('TEMP', nil, 0);
  //if I > 0 then begin
  //  SetLength(Path, I);
  //  GetEnvironmentVariable('TEMP', PChar(path), I);
  //end;
  // O arquivo será o NOME do EXECUTAVEL + .INI
  //IniOrigem := Copy( IniApplication, 1, Length( IniApplication ) - 3 ) + 'ini';
  arquivo:= Copy( IniApplication, 1, Length( IniApplication ) - 3 ) + 'ini';
  //arquivo:= IniApplication + '.ini';
  //path := Copy( path, 1, Length( path ) - 1 );
  //arquivo := path + '\temp.ini';
  //Criptografa.Infile := IniOrigem;
  //Criptografa.Outfile := Arquivo;
  //if FileExists( Arquivo ) then
  //   DeleteFile( Arquivo );
  //Criptografa.Decrypt;
  MyIniFile := TIniFile.Create(Arquivo);
  Valores := TStringList.Create;
  MyIniFile.ReadSectionValues( Sessao , Valores );
  MyIniFile.Free;
  //DeleteFile( Arquivo ); ****
  //Criptografa.Free;


  SetLength(arrValores, Valores.Count);
  for i := 0 to Pred(Valores.Count) do
  begin
     //somente valores
     arrValores[i]:= Valores.ValueFromIndex[i];
     //campo e valores
     arrValores[i]:= Valores.Strings[i];
  end;

  Result:= arrValores;


end;

function Auxiliar.getProperty(IniApplication, Sessao: String): String;
var
  arquivo:String;
  MyIniFile:TIniFile;
  Retorno:String;
  Valores:TStringList;
begin

  arquivo := Copy( IniApplication, 1, Length( IniApplication ) - 3 ) + 'ini';
  MyIniFile := TIniFile.Create(Arquivo);
  Valores := TStringList.Create;
  MyIniFile.ReadSectionValues( Sessao , Valores );
  MyIniFile.Free;
  Retorno := Valores.ValueFromIndex[0];
  Result := Retorno;

end;

procedure Auxiliar.criaParametroSP(SP:TADOStoredProc; nome:string; tipo:TDataType; tamanho,precisao:Integer);
begin

    try
    with SP do
    begin
      with Parameters.AddParameter do
      begin
        Name      := nome;
        DataType  := tipo;
        Direction := pdInput;
        Precision := precisao;
        Size      := tamanho;
      end;
    end;
    finally

    end;

end;

function Auxiliar.dropProcedureAS400(baseAS400:TADOConnection; routine_name, routine_schema, routine_type: string; sobrescrever:Boolean): Integer;
var
  qryAux: TADOQuery;
  qtProcedure:Integer;
begin


  //DELETA PROCEDURE "routine_name"
  qtProcedure:= 0;
  TRY
  try
    qryAux:= TADOQuery.Create(nil);
    qryAux.Connection:= baseAS400;
    qryAux.SQL.Text :='Select count(*) as qt from qsys2.SYSROUTINES ';
    qryAux.SQL.Add('   Where  routine_name   = :pNAME and');
    qryAux.SQL.Add('          routine_schema = :pSCHEMA and');
    qryAux.SQL.Add('          routine_type   = :pTYPE');
    qryAux.Parameters.ParamByName('pNAME').Value:= routine_name;
    qryAux.Parameters.ParamByName('pSCHEMA').Value:= routine_schema;
    qryAux.Parameters.ParamByName('pTYPE').Value:= routine_type;
    qryAux.Open;
    qtProcedure:= qryAux.FieldByName('qt').AsInteger;
    if ( (qtProcedure>0) and (sobrescrever)) then
    begin
      qryAux.SQL.Clear;
      qryAux.SQL.Text :='DROP PROCEDURE '+routine_schema+'.'+routine_name;//LPDPGICE.prcICE_INSCET019';
      qryAux.ExecSQL;
      qtProcedure:= 0;
    end;
  except
    On E:Exception do
    begin
        logICE.saveLog(INT_NAME+ ': Erro ao excluir procedure '+routine_name+ '. Erro ['+E.Message+']');
    end;
  end;
  FINALLY
    Result:= qtProcedure;
  END;


  //qryAux.SQL.Add('where routine_name='+''''+'PRCICE_INSCET019'+'''');
  //qryAux.SQL.Add(' AND routine_schema = '+''''+'LPDPGICE'+''''+' AND routine_type = '+''''+'PROCEDURE'+'''');

end;

function Auxiliar.loadDataSet(baseDB:TADOConnection; pDataset:TADODataSet): Integer;
var
  qtREG: Integer;
begin

  qtREG:= 0;

  try
  pDataset.CommandTimeout:= 90;

    fechaCon(baseDB);
    conectaBase(baseDB);
    limpaDataSet(pDataset);
    pDataset.Connection:= baseDB;
    pDataset.Active:= True;
    qtREG:= pDataset.RecordCount;
  except
    On E:Exception do
    begin
      logICE.saveLog(INT_NAME+': Erro ao carregar dataset (' +pDataset.Name+') . Erro ['+E.Message+']');
    end;
    On E:EDatabaseError do
      logICE.saveLog(INT_NAME+': Erro ao carregar dataset (' +pDataset.Name+') . Erro ['+E.Message+']');
  end;

  Result:= qtREG;

end;


function Auxiliar.configDS(dsPROC:TADODataSet; ds_name:string): TADODataSet;
var
  //dsCarregado: Boolean;
  fName, dsFile, strCMDSQL: string;
  f:TextFile;
  linha:String;
  pathApp: string; //exeApp
begin

  dsPROC:= TADODataSet.Create(nil);
  dsPROC.Name:= ds_name;


  //pathApp:= ExtractFilePath(Application.ExeName);
  //pathApp:= gsAppPath;
  pathApp:= ExtractFilePath(Application.ExeName);

  fName:= dsPROC.Name+'.ini';
  dsFile:= pathApp+'\'+fName;
  if Not (FileExists(dsFile)) then
  begin
    //dsCarregado:= False;
    Result:= dsPROC;//dsCarregado;
    logICE.saveLog(INT_NAME+' --> Erro durante configuração de DataSet.'+' Erro [Arquivo ' + fName + ' não encontrado.]');
    exit;
  end;


  AssignFile(f, dsFile);
  Reset(f);
  While not Eof(f) do
  begin
    Readln(f, linha);
    //strCMDSQL:= strCMDSQL + #13#10 + linha;
    strCMDSQL:= strCMDSQL + sLineBreak + linha;
  end;
  CloseFile(f);


  dsPROC.Fields.Clear();
  dsPROC.CommandText:= strCMDSQL;
  //dsCarregado:= true;


  Result:= dsPROC;//dsCarregado;

end;


procedure Auxiliar.criaParametroQRY(QRY:TADOQuery; nome:string; tipo:TDataType; tamanho,precisao:Integer);
begin

    try
    with QRY do
    begin
      with Parameters.AddParameter do
      begin
        Name      := nome;
        DataType  := tipo;
        Direction := pdInput;
        Precision := precisao;
        Size      := tamanho;
      end;
    end;
    finally

    end;

end;



procedure Auxiliar.criaParametroDS(DS:TADODataSet; nome:string; tipo:TDataType; tamanho,precisao:Integer);
begin

    try
    with DS do
    begin
      with Parameters.AddParameter do
      begin
        Name      := nome;
        DataType  := tipo;
        Direction := pdInput;
        Precision := precisao;
        Size      := tamanho;
      end;
    end;
    finally

    end;

end;



procedure Auxiliar.updtSTATUS_ICE(
  baseAS400: TADOConnection; Tabela:string;
  campoStatus:string; Status:Byte;
  Key1, vlK1,  Key2, vlK2,  Key3, vlK3, Key4, vlK4 :string);
var
  qryAux: TADOQuery;
begin

  if Length(Key1) = 0 then
  begin
    logICE.saveLog(INT_NAME+ ': Erro na atualização de status ('+Tabela+'). Erro [chave 1 obrigatória.]');
  end;

  conectaBase(baseAS400);
  qryAux:= TADOQuery.Create(nil);
  qryAux.Connection := baseAS400;
  qryAux.SQL.Text:= 'UPDATE ' +Tabela+ ' SET '+campoStatus+'= :pStatus';
  qryaux.SQL.Add('   WHERE  '+Key1+' = :pVLK1  ');
  if Length(Key2) > 0 then
    qryaux.SQL.Add(' AND '+Key2+' = :pVLK2 ');
  if Length(Key3) > 0 then
    qryaux.SQL.Add(' AND '+Key3+' = :pVLK3 ');
  if Length(Key4) > 0 then
    qryaux.SQL.Add(' AND '+Key4+' = :pVLK4 ');


  qryAux.Parameters.ParamByName('pSTATUS').Value := Status;
  qryAux.Parameters.ParamByName('pVLK1').Value := vlK1;
  if Length(Key2) > 0 then
    qryAux.Parameters.ParamByName('pVLK2').Value := vlK2;
  if Length(Key3) > 0 then
    qryAux.Parameters.ParamByName('pVLK3').Value := vlK3;
  if Length(Key4) > 0 then
    qryAux.Parameters.ParamByName('pVLK4').Value := vlK4;
  qryAux.ExecSQL;



  //if Length(Key1) > 0 then
  //  qryaux.SQL.Add(' WHERE '+Key1+' = :pVLK1');
  //if Length(Key2) > 0 then
  //  qryaux.SQL.Add(' AND ( '+Key2+' = :pVLK2 or 1>0 )');
  //if Length(Key3) > 0 then
  //  qryaux.SQL.Add(' AND ( '+Key3+' = :pVLK3 or 1>0 )');
  //qryAux.Parameters.ParamByName('pSTATUS').Value := Status;
  //qryAux.Parameters.ParamByName('pVLK1').Value := vlK1;
  //qryAux.Parameters.ParamByName('pVLK2').Value := vlK2;
  //qryAux.Parameters.ParamByName('pVLK3').Value := vlK3;
  //qryAux.ExecSQL;




  //OLD:
  //qryAux := TADOQuery.Create(nil);
  //qryAux.Connection := baseAS;
  //qryaux.SQL.Text := 'UPDATE ' +Tabela+ ' SET '+campoStatus+'='+IntToStr(Status);
  //if Length(Key1) > 0 then
  //  qryaux.SQL.Add(' WHERE '+Key1+'='''+vlK1+'''');
  //if Length(Key2) > 0 then
  //  qryaux.SQL.Add(' AND '+Key2+'='''+vlK2+'''');
  //if Length(Key3) > 0 then
  //  qryaux.SQL.Add(' AND '+Key3+'='''+vlK3+'''');
  //qryAux.ExecSQL;

end;






end.

