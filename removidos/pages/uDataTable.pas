unit uDataTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWHTMLControls, IWCompMemo, IWCompText,
  uBASE1
  ;

type
  TIWFRM_Main = class(TIWFormBase)
    IWT_CONTENT: TIWText;
    IWMemo1: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
  private
    function getDataTable(filtro:string): string;
  public
    procedure prc_Acao(EventParams : TStringList); override;
  end;

var
  IWFRM_Main: TIWFRM_Main;

implementation
{$R *.dfm}



procedure TIWFRM_Main.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  //WebApplication.RegisterCallBack('prc_Acao', prc_Acao);


  IWMemo1.Text:= 'texto sem formatacao';
  IWT_CONTENT.Caption:= IWMemo1.Text;

end;

procedure TIWFRM_Main.prc_Acao(EventParams : TStringList);
begin

  inherited;




  if Acao = 'InjectContent' then begin

      IWT_CONTENT.RawText:= true;
      IWT_CONTENT.Text:= IWMemo1.Text;

  end;


  if Acao = 'ProcDataTable' then begin

      IWT_CONTENT.RawText:= true;
      IWT_CONTENT.Text:= getDataTable('---');

  end;




end;



function TIWFRM_Main.getDataTable(filtro:string): string;
begin


Result:=
'    <div class="container">                                                           '+
'    <table id="DTB1" class="table table-striped table-bordered" style="width:100%">   '+
'      <thead>                                                                         '+
'        <tr>                                                                          '+
'          <th> ID </th>                                                               '+
'          <th> Field1 </th>                                                           '+
'          <th> Field2 </th>                                                           '+
'          <th> Field3 </th>                                                           '+
'        </tr>                                                                         '+
'      </thead>                                                                        '+
//'      <tbody>
//
//        <tr> <td> 1 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 2 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 3 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 4 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 5 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 6 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 7 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 8 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 9 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td>  </tr>
//        <tr> <td> 10 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 11 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 12 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 13 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 14 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 15 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//        <tr> <td> 16 </td> <td> F1 </td> <td> F2 </td> <td> F3 </td> </tr>
//
//      </tbody>
'      <tfoot>                                                                         '+
'      </tfoot>                                                                        '+
'                                                                                      '+
'    </table>                                                                          '+
'  </div>                                                                              ';




end;

end.
