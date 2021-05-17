object IWServerController: TIWServerController
  OldCreateOrder = False
  AppName = 'TMPLT1'
  CacheDir = 'C:\Users\bingo\AppData\Local\Temp'
  Compression.Level = 6
  Description = 'Template 1'
  DisplayName = 'TMPLT1'
  Log = loFile
  MasterTemplate = 'IWMaster.html'
  Port = 8888
  ServerResizeTimeout = 0
  ShowLoadingAnimation = True
  SessionTimeout = 10
  SSLOptions.NonSSLRequest = nsAccept
  SSLOptions.Port = 0
  SSLOptions.SSLVersion = SSLv3
  SSLOptions.SSLVersions = []
  Version = '14.2.13'
  AllowMultipleSessionsPerUser = False
  IECompatibilityMode = 'IE=8'
  RestartExpiredSession = True
  BackButtonOptions.Mode = bmEnable
  BackButtonOptions.ShowMessage = True
  BackButtonOptions.WarningMessage = 'Aten'#231#227'o, erro ao acionar hist'#243'rico!'
  OnNewSession = IWServerControllerBaseNewSession
  Height = 380
  Width = 319
end
