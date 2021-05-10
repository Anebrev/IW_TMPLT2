program prjTMPLT2;

{$DEFINE IW}

uses
  Forms,
  IWStart,
  UTF8ContentParser,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in 'UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase},
  uBase in 'Pages\uBase.pas' {IWBase: TIWAppForm},
  uConsolida_tst in 'Pages\uConsolida_tst.pas' {IWFRM_Consolida_tst: TIWAppForm},
  uIndex in 'Pages\uIndex.pas' {IWFRM_Index: TIWAppForm},
  uLogin in 'Pages\uLogin.pas' {IWFRM_Login: TIWAppForm},
  uProcessa in 'Pages\uProcessa.pas' {IWFRM_Processa: TIWAppForm},
  clsAux in 'clsAux.pas',
  uReport1 in 'Pages\uReport1.pas' {IWFRM_RPT1: TIWAppForm},
  uConsolida in 'Pages\uConsolida.pas' {IWFRM_Consolida: TIWAppForm};

{$R *.res}

begin
  TIWStart.Execute(True);
end.
