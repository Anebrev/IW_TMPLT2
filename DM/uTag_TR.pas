unit uTag_TR;

interface
uses
   System.Generics.Collections, System.SysUtils, uTag_TD;


Type
  TTag_TR = Class

  private
    //FIndexTag: Integer;
    FIDTag: String;
    FListaTD: TObjectList<Ttag_TD>;
  protected
    { protected declarations }
  public
    //property IndexTag: integer read FIndexTag write FIndexTag;
    property IDTag: string read FIDTag write FIDTag;
    property ListaTD: TObjectList<Ttag_TD> read FListaTD;

    constructor Create;
    destructor Destroy; override;
    procedure AddTadTD(IDTag, ClassTag, ValueTag: String);


 end;



implementation


constructor TTag_TR.Create;
begin
  inherited;
  //FIDVenda        := 0;
  //FData           := EncodeDate(1900,1,1);
  FListaTD := TObjectList<Ttag_TD>.Create;
end;



destructor TTag_TR.Destroy;
 begin
  FreeAndNil(FListaTD);
  inherited;
end;

procedure TTag_TR.AddTadTD(IDTag, ClassTag, ValueTag: String);
var
  I: Integer;
begin

  FListaTD.Add(Ttag_TD.Create);

  I := FListaTD.Count -1;
  FListaTD[I].IndexTag := I;
  FListaTD[I].IDTag    := IDTag;
  FListaTD[I].CalssTag := ClassTag;
  FListaTD[I].ValueTag := ValueTag;

end;


end.




// FIDVenda: Integer;
//04    FData: TDateTime;
//05    FListaVendaItem: TObjectList<TVendaItem>;
//06    { private declarations }
//07  protected
//08    { protected declarations }
//09  public
//10    { public declarations }
//11    property IDVenda: Integer read FIDVenda write FIDVenda;
//12    property Data   : TDateTime read FData write FData;
//13    property ListaVendaItem: TObjectList<TVendaItem> read FListaVendaItem
//14                                                  write FListaVendaItem;
//15    constructor Create;
//16    destructor Destroy; override;
//17    procedure AdicionarVendaItem(pProduto: String);

