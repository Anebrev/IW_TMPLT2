unit clsAux;

interface
  uses
    ADODB, DB, TypInfo, Windows, SysUtils, StrUtils,
    IniFiles, Classes;



type
  TResultArray = array of string;
  Auxiliar2 = Class

public
  procedure saveTXT(text, title: string);


End;

implementation


procedure Auxiliar2.saveTXT(text, title: string);
var
  Arquivo: TStringList;
begin

  Arquivo := TStringList.Create;
  try
    Arquivo.Add(text);
    //Arquivo.SaveToFile(title+'.txt');
    Arquivo.SaveToFile(title);
  finally
    Arquivo.Free;
  end;

end;

end.
