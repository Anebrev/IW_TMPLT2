program prjPPS;

{$DEFINE IW}

uses
  Forms,
  IWStart,
  UTF8ContentParser,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in 'UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase},
  uBase in 'Pages\uBase.pas' {IWBase: TIWAppForm},
  uIndex in 'Pages\uIndex.pas' {IWFRM_Index: TIWAppForm},
  uLogin in 'Pages\uLogin.pas' {IWFRM_Login: TIWAppForm},
  uProcessa in 'Pages\uProcessa.pas' {IWFRM_Processa: TIWAppForm},
  clsAux in 'clsAux.pas',
  uReport1 in 'Pages\uReport1.pas' {IWFRM_RPT1: TIWAppForm},
  uConsolida in 'Pages\uConsolida.pas' {IWFRM_Consolida: TIWAppForm},
  uPrevia in 'Pages\uPrevia.pas' {IWFRM_Previas: TIWAppForm},
  uTransmissao in 'Pages\uTransmissao.pas' {IWFRM_Transmissao: TIWAppForm},
  uDM in 'DM\uDM.pas' {DM: TDataModule},
  clsAuxiliar in 'DM\clsAuxiliar.pas',
  clsLog in 'DM\clsLog.pas',
  ConfigENV in 'DM\ConfigENV.pas',
  SweetAlerts in 'plugins\SweetAlerts.pas';

{$R *.res}

begin
  TIWStart.Execute(True);
end.
