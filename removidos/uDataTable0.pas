unit uDataTable0;

interface

uses
  //Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  //Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uformbase, IWCompMemo, IWVCLBaseControl,
  //IWBaseControl, IWBaseHTMLControl, IWControl, IWCompText, IWVCLComponent,
  //IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  //IWTemplateProcessorHTML; ***ORIG

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWHTMLControls, IWCompMemo, IWCompText,
  uBASE1
  ;

type
  TIWFormDataTable = class(TIWFormBase)
    IWT_CONTENT: TIWText;
    IWMemo1: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure prc_Acao(EventParams : TStringList); override;
  end;

var
  IWFormDataTable: TIWFormDataTable;

implementation
{$R *.dfm}

procedure TIWFormDataTable.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  //--------------
end;


procedure TIWFormDataTable.prc_Acao(EventParams : TStringList);
begin
  inherited;

  if Acao = 'ProcDataTable' then begin
      IWT_CONTENT.RawText:= true;
      IWT_CONTENT.Text:= '<h1> JSON DataTable </h1>';
  end;


end;




end.
