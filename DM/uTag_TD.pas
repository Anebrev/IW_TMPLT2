unit uTag_TD;


interface
  //uses
    //TypInfo, Windows, SysUtils, StrUtils,

type
  TTag_TD = Class

  private
    FIndexTag: Integer;
    FIDTag: string;
    FCalssTag: String;
    FValueTag: String;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property IndexTag: Integer read FIndexTag write FIndexTag;
    property IDTag: String read FIDTag write FIDTag;
    property CalssTag: string read FCalssTag write FCalssTag;
    property ValueTag: string read FValueTag write FValueTag;
  //published
    { published declarations }
 end;



 implementation


 end.
