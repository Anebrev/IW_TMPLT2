unit clsLog;

interface

uses
  Windows, Messages, SysUtils, Classes, DB;
  //Graphics, Controls, SvcMgr, Dialogs

type
  TResultArray = array of string;
  Log = Class
  private
    FfileLog: string;
    agenteSrv: array of string;
    Foverride: Boolean;
    sendEmail: Boolean;
    FemailLog: string;
    //logLista:TStringList;

    //Construtores privados
    procedure setFileLog(fileLog:string);
    function getFileLog: string;
    procedure setEmailLog(emailLog:string);
    function getEmailLog: string;

    //outros metodos
    procedure enviaEmail(msg:string);


  public
   //Contrutores p�blicos
   //constructor Create(path:string);
   constructor Create(
       fileLog:string; agenteServico:array of string;
       sobrescrever, enviarEmail: Boolean; strEmailLog:string);

   //Propriedades p�blicas
   property fileLog: string read getFileLog write setFileLog;
   property emailLog: string read getEmailLog write setEmailLog;

   //para n�o utilizar nomenclatura get/set na manipula��o do objeto (add set/get em private):
//    A Borland adotou uma medida alternativa e interessante de promover a seguran�a de
//    seus atributos: o uso de propriedades. Esta medida se trata, na verdade,
//    de encapsular os atributos sob m�todos gets e sets. Isto dar� ao desenvolvedor-usu�rio
//    desta classe a �sensa��o� de que ele est� manipulando os atributos internos do objeto
//    diretamente, sem que de fato esteja:
//    property Atributo: Integer read GetAtributo write SetAtributo;


      //Outros m�todos
      //procedure saveLog1(msg: string);

      //log padr�o em RelAutomaticoServer
      procedure saveLog(msg: String);

      procedure saveLogOver(msg:string);


  end;


implementation
//uses
  //clsEMail;

//  Implementa��o construtores
constructor Log.Create(
    fileLog:string; agenteServico:array of string;
    sobrescrever, enviarEmail: Boolean; strEmailLog:string);
begin

  setFileLog(fileLog);
  Foverride:= sobrescrever;
  //logLista:= TStringList.Create;
  if sobrescrever then
  begin
    if FileExists(fileLog) then
      SysUtils.DeleteFile(fileLog);
  end;


  sendEmail:= enviarEmail;

  setEmailLog(strEmailLog);

  //agenteSrv:= agenteServico;
  if enviarEmail then
  begin
    if Length(agenteServico) > 0 then
    begin
      SetLength(agenteSrv, 3);
      agenteSrv[0]:= agenteServico[0];
      agenteSrv[1]:= agenteServico[1];
      agenteSrv[2]:= agenteServico[2];
    end;

  end;


end;

procedure Log.setFileLog(fileLog: string);
begin
      FfileLog:= fileLog;
end;

function Log.getFileLog;
begin
      Result:= FfileLog;
end;

procedure Log.setEmailLog(emailLog: string);
begin
      FemailLog:= emailLog;
end;

function Log.getEmailLog;
begin
      Result:= FemailLog;
end;

//Implementa��o m�todos funcionais
procedure Log.enviaEmail(msg: string);
//var
  //email: EmailDTI;
  //anexos : TStringList;
  //dominio, porta, emailAgent: string;
begin

//  anexos:= TStringList.Create;
//  anexos.Add(fileLog);
//  email:= EmailDTI.Create;
//  msg:= msg + Chr(13)+Chr(13);
//  msg:= msg + 'Esta mensagem � gerada automaticamente pelo servi�o de processamento de interface do Sistema Comex - ICE. Esta mensagem n�o deve ser respondida.';
//
//  dominio:= agenteSrv[0];
//  porta:= agenteSrv[1];
//  emailAgent:= agenteSrv[2];
//
//  email.EnviarEmail(dominio,porta,'matricula','pass', False,
//  'Agente Servi�o - ICE', emailAgent, emailLog,
//  'ICE - Erro de Processamento da Interface', msg, 1, 0, False, anexos);

end;

procedure Log.saveLog(msg: string);
var
  F: TextFile;
begin

  AssignFile(f,fileLog);
  if FileExists(fileLog) then
    Append(f)
  else
    Rewrite(f);

  writeln(f,DateTimeToStr(Now)+' --> ' +msg);
  CloseFile(f);


  if sendEmail then
  begin
    enviaEmail(msg);
  end;


end;

procedure Log.saveLogOver(msg:string);
var
  F: TextFile;
begin

  AssignFile(f,fileLog);

  Rewrite(f); //sempre sobrescreve arquivo

  writeln(f,DateTimeToStr(Now)+' --> ' +msg);
  CloseFile(f);

  if sendEmail then
  begin
    enviaEmail(msg);
  end;


end;













end.

