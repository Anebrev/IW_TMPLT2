unit uclientes;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWHTMLControls, IWCompButton,
  IWCompEdit, IWCompGrids, IWDBGrids, Data.DB, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWCompExtCtrls, Vcl.Forms,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion,
  IWDBStdCtrls, IWHTMLTag,
  uBASE1
  ;

type
  TIWFormClientes = class(TIWFormBase)
    IWEdtIDCliente: TIWEdit;
    IWEdtRazaoSocial: TIWEdit;
    IWBtnPesquisar: TIWButton;
    IWGridClientes: TIWDBGrid;
    ds: TDataSource;
    IWBtnNovo: TIWButton;
    IWDBEditIDCliente: TIWDBEdit;
    IWDBEditRazao: TIWDBEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnPesquisarClick(Sender: TObject);
    procedure IWGridClientesRenderCell(ACell: TIWGridCell; const ARow,
      AColumn: Integer);
    procedure IWAppFormRender(Sender: TObject);
  public
    function GetCellControl(ARow, ACol: Integer): TIWCustomControl;
    procedure DoEditClient(EventParams: TStringList);

  end;

implementation

uses ServerController;

{$R *.dfm}

procedure TIWFormClientes.DoEditClient(EventParams: TStringList);
begin
//  UserSession.BsClientes.DataSet.Locate('ID_CLIENTE',EventParams.Values['option'],[]);
end;

function TIWFormClientes.GetCellControl(ARow, ACol: Integer): TIWCustomControl;
var
  aName: string;
begin
  inherited;
  aName := Self.Name + 'BtnEdit' + IntToStr(ARow);
  // try to find an already existing IWBtnEdit. The parent of all BtnEdit is the IWForm
  Result := Self.FindComponent(aName) as TIWCustomControl;
  // If not found, create one
  if Result = nil then begin
    Result := TIWButton.Create(Self);
    // set all the properties
    with TIWButton(Result) do
    begin
      Name := aName;
      Caption := 'Editar';
      Css := 'btn btn-warning';
//      ScriptEvents.Add('onClick','doEditClient('+UserSession.BsClientes.idCliente.ToString+');');
      Tag := ARow;
    end;
  end;
end;

procedure TIWFormClientes.IWAppFormCreate(Sender: TObject);
begin
  inherited;
//  ds.DataSet:=UserSession.BsClientes.DataSet;
//  UserSession.BsClientes.Select(-1,'','S');

end;

procedure TIWFormClientes.IWAppFormRender(Sender: TObject);
const
  jsTag = '<script language="javascript" type="text/javascript">%s</script>';
var
  AjaxFunc: string;
begin
  inherited;
  // this is the JavaScript function that I want to call.
  // This function, in turn, will call IWFormClientes.DoEditClient()
  AjaxFunc := 'function doEditClient(pClientCode) {' + #13 +
      'executeAjaxEvent("&option="+pClientCode, null,"' + UpperCase(Self.Name) + '.DoEditClient", false, null, false);' + #13 +
      '$("#EditaDados").modal("show"); '+#13+
      'return true;}';

  PageContext.ExtraHeader.Add(Format(jsTag, [AjaxFunc]));
  // If we want to call IWForm2.DoMyAjaxFunc, then we have to register it as a Callback
  WebApplication.RegisterCallBack(UpperCase(Self.Name) + '.DoEditClient', DoEditClient);

end;

procedure TIWFormClientes.IWBtnPesquisarClick(Sender: TObject);
begin
  inherited;
//  UserSession.BsClientes.Select(StrToIntDef(IWEdtIDCliente.Text,0),
//    UpperCase(IWEdtRazaoSocial.Text),'');
end;

procedure TIWFormClientes.IWGridClientesRenderCell(ACell: TIWGridCell;
  const ARow, AColumn: Integer);
begin
  inherited;
  if ARow > 0 then
  begin
    if AColumn = 4 then
    begin
      if not Assigned(ACell.Control) then
      begin
        ACell.Control := GetCellControl(ARow, AColumn);
      end;
    end;
  end;
end;

end.
