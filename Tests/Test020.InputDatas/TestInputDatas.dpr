program TestInputDatas;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  uHJX.GraphDispatcherUnits in '..\..\Client\ClientCommon\uHJX.GraphDispatcherUnits.pas',
  uFuncDataGraph in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uFuncDataGraph.pas',
  uFuncDataViewer in '..\..\Client\ClientCommon\FuncFrames\DataViewer\uFuncDataViewer.pas',
  Vcl.Forms,
  ufrmInputDatas in 'ufrmInputDatas.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  ufraInputDatas in 'ufraInputDatas.pas' {TfraInputDatas: TFrame},
  uHJX.Template.ChartTemplate in '..\..\Client\ClientCommon\Templates\uHJX.Template.ChartTemplate.pas',
  uHJX.Template.WebGrid in '..\..\Client\ClientCommon\Templates\uHJX.Template.WebGrid.pas',
  uHJX.Template.XLGrid in '..\..\Client\ClientCommon\Templates\uHJX.Template.XLGrid.pas',
  uHJX.Template.ChartTemplateProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.ChartTemplateProc.pas',
  uHJX.Template.WebGridProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.WebGridProc.pas',
  uHJX.Template.XLGridHelper in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridHelper.pas',
  uHJX.Template.XLGridProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridProc.pas',
  uHJX.Template.ProcSpecifiers in '..\..\Client\ClientCommon\Templates\uHJX.Template.ProcSpecifiers.pas';

{$R *.res}


begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
