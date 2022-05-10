program SummaryReport;

uses
  uHJX.Intf.AppServices in '..\..\Client\ClientCommon\Core\uHJX.Intf.AppServices.pas',
  uHJX.Intf.FuncCompManager in '..\..\Client\ClientCommon\Core\uHJX.Intf.FuncCompManager.pas',
  uHJX.Intf.FunctionDispatcher in '..\..\Client\ClientCommon\Core\uHJX.Intf.FunctionDispatcher.pas',
  uHJX.Intf.Datas in '..\..\Client\ClientCommon\Interfaces\uHJX.Intf.Datas.pas',
  uHJX.Intf.GraphDispatcher in '..\..\Client\ClientCommon\Dispatchers\uHJX.Intf.GraphDispatcher.pas',
  uHJX.Intf.ProjectGlobal in '..\..\Client\ClientCommon\Core\uHJX.Intf.ProjectGlobal.pas',
  uHJX.Data.Types in '..\..\Client\ClientCommon\Core\uHJX.Data.Types.pas',
  uHJX.Core.FuncCompTypes in '..\..\Client\ClientCommon\Core\uHJX.Core.FuncCompTypes.pas',
  uHJX.Classes.Meters in '..\..\Client\ClientCommon\Core\uHJX.Classes.Meters.pas',
  uHJX.Classes.Templates in '..\..\Client\ClientCommon\Core\uHJX.Classes.Templates.pas',
  uHJX.IntfImp.AppServices in '..\..\Client\ClientCommon\Core\uHJX.IntfImp.AppServices.pas',
  uHJX.IntfImp.FuncCompManager in '..\..\Client\ClientCommon\Core\uHJX.IntfImp.FuncCompManager.pas',
  uHJX.IntfImp.FunctionDispatcher in '..\..\Client\ClientCommon\Core\uHJX.IntfImp.FunctionDispatcher.pas',
  uHJX.IntfImp.GraphDispatcher in '..\..\Client\ClientCommon\Dispatchers\uHJX.IntfImp.GraphDispatcher.pas',
  uHJX.EnvironmentVariables in '..\..\Client\ClientCommon\Core\uHJX.EnvironmentVariables.pas',
  uHJX.ProjectGlobal in '..\..\Client\ClientCommon\Core\uHJX.ProjectGlobal.pas',
  uHJX.Excel.DataQuery in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.DataQuery.pas',
  uHJX.Excel.InitParams in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.InitParams.pas',
  uHJX.Excel.IO in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.IO.pas',
  uHJX.Excel.Meters in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.Meters.pas',
  uHJX.Template.ChartTemplate in '..\..\Client\ClientCommon\Templates\uHJX.Template.ChartTemplate.pas',
  uHJX.Template.ProcSpecifiers in '..\..\Client\ClientCommon\Templates\uHJX.Template.ProcSpecifiers.pas',
  uHJX.Template.TemplatesImp in '..\..\Client\ClientCommon\Templates\uHJX.Template.TemplatesImp.pas',
  uHJX.Template.WebGrid in '..\..\Client\ClientCommon\Templates\uHJX.Template.WebGrid.pas',
  uHJX.Template.XLGrid in '..\..\Client\ClientCommon\Templates\uHJX.Template.XLGrid.pas',
  uHJX.Template.ChartTemplateProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.ChartTemplateProc.pas',
  uHJX.Template.WebGridProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.WebGridProc.pas',
  uHJX.Template.XLGridHelper in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridHelper.pas',
  uHJX.Template.XLGridProc in '..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridProc.pas',
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  ufrmTestSummary in 'ufrmTestSummary.pas' {frmTestSummary},
  uWBLoadHTML in '..\..\Client\ClientCommon\Tools\uWBLoadHTML.pas',
  uWeb_DataSet2HTML in '..\..\Client\ClientCommon\Tools\uWeb_DataSet2HTML.pas',
  uWebGridCross in '..\..\Client\ClientCommon\Tools\uWebGridCross.pas',
  SynGdiPlus in '..\..\Client\ClientCommon\Tools\SynGdiPlus.pas',
  uhwSGEx in '..\..\Client\ClientCommon\Tools\uhwSGEx.pas',
  uhwSGEx.DataMapClasses in '..\..\Client\ClientCommon\Tools\uhwSGEx.DataMapClasses.pas',
  uMyUtils.CopyHTML2Clipbrd in '..\..\Client\ClientCommon\Tools\uMyUtils.CopyHTML2Clipbrd.pas',
  uFuncDataGraph in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uFuncDataGraph.pas',
  uFuncDataViewer in '..\..\Client\ClientCommon\FuncFrames\DataViewer\uFuncDataViewer.pas',
  uFuncDrawTLByStyle in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uFuncDrawTLByStyle.pas',
  uTLDefineProc in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uTLDefineProc.pas',
  ufraBasicTrendLine in '..\..\Client\ClientCommon\FuncFrames\DataGraph\ufraBasicTrendLine.pas' {fraBasicTrendLine: TFrame},
  ufraTrendLineShell in '..\..\Client\ClientCommon\FuncFrames\DataGraph\ufraTrendLineShell.pas' {fraTrendLineShell: TFrame},
  ufraDataLayout in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufraDataLayout.pas' {fraDataLayout: TFrame},
  ufraDataPresentation in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufraDataPresentation.pas' {fraDataPresentation: TFrame},
  ufraEigenvalueWeb in '..\..\Client\ClientCommon\FuncFrames\Eigenvalue\ufraEigenvalueWeb.pas' {fraEigenvalueWeb: TFrame},
  ufraExcelMeterParamEditor in '..\..\Client\ClientCommon\FuncFrames\ParamsEditor\ufraExcelMeterParamEditor.pas' {fraXLSParamEditor: TFrame},
  ufrmMeterDataSelector in '..\..\Client\ClientCommon\FuncFrames\ParamsEditor\ufrmMeterDataSelector.pas' {frmMeterDataFileSelection},
  ufraMeterList in '..\..\Client\ClientCommon\FuncFrames\MeterList\ufraMeterList.pas' {fraMeterList: TFrame},
  ufraMeterListGrid in '..\..\Client\ClientCommon\FuncFrames\MeterList\ufraMeterListGrid.pas' {fraMeterListGrid: TFrame},
  ufraRptDataHTMLGrid in '..\..\Client\ClientCommon\FuncFrames\ReportDataHTMLGrid\ufraRptDataHTMLGrid.pas' {fraRptDataHTMLGrid: TFrame},
  ufraSummaryMaker.Excel in '..\..\Client\ClientCommon\FuncFrames\SummaryReport\ufraSummaryMaker.Excel.pas' {fraXLSSummaryMeker: TFrame},
  ufrmSumRptGenOpts in '..\..\Client\ClientCommon\FuncFrames\SummaryReport\ufrmSumRptGenOpts.pas' {frmSumRptGenOpts},
  ufraHJXDataGrid in '..\..\Client\ClientCommon\FuncFrames\DataViewer\ufraHJXDataGrid.pas' {fraHJXDataGrid: TFrame},
  ufraHJXWebDataGrid in '..\..\Client\ClientCommon\FuncFrames\DataViewer\ufraHJXWebDataGrid.pas' {fraWebDataGrid: TFrame},
  ufraHJXUtilsA in '..\..\Client\ClientCommon\FuncFrames\Tools\ufraHJXUtilsA.pas' {fraHJXUtilsA: TFrame},
  ufrmDataCounts in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmDataCounts.pas' {frmDataCount},
  ufraQuickViewer in '..\..\Client\ClientCommon\FuncFrames\QuickView\ufraQuickViewer.pas' {fraQuickViewer: TFrame},
  Gopage in '..\..\Client\ClientCommon\FuncFrames\HVPrintPreview\Gopage.pas' {GoPageForm},
  PreviewForm in '..\..\Client\ClientCommon\FuncFrames\HVPrintPreview\PreviewForm.pas' {PreviewForm},
  PrintStatusForm in '..\..\Client\ClientCommon\FuncFrames\HVPrintPreview\PrintStatusForm.pas' {PrnStatusForm},
  ufraMeterSelector in '..\..\Client\ClientCommon\FuncFrames\MeterSelector\ufraMeterSelector.pas' {fraMeterSelector: TFrame},
  ufrmMeterSelector in '..\..\Client\ClientCommon\FuncFrames\MeterSelector\ufrmMeterSelector.pas' {frmMeterSelector},
  ufraBasePlaneDisplacementChart in '..\..\Client\ClientCommon\FuncFrames\DataGraph\ufraBasePlaneDisplacementChart.pas' {fraBasePlaneDisplacementChart: TFrame},
  ufraDisplacementChartShell in '..\..\Client\ClientCommon\FuncFrames\DataGraph\ufraDisplacementChartShell.pas' {fraDisplacementChartShell: TFrame},
  ufrmQuerySetupDate in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmQuerySetupDate.pas' {frmQuerySetupDate},
  ufraEigenvalueGrid in '..\..\Client\ClientCommon\FuncFrames\Eigenvalue\ufraEigenvalueGrid.pas' {fraEigenvalueGrid: TFrame},
  ufraDeformMap in '..\..\Client\ClientCommon\FuncFrames\Tools\ufraDeformMap.pas' {fraDeformMap: TFrame},
  ufrmShowDeformMap in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmShowDeformMap.pas' {frmShowDeformPoints},
  ufrmFindNewSheets in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmFindNewSheets.pas' {frmFindNewSheets},
  ufrmEVGraph in '..\..\Client\ClientCommon\FuncFrames\Eigenvalue\ufrmEVGraph.pas' {frmEVGraph},
  SimpleGraph in '..\..\Client\ClientCommon\Tools\SimpleGraph.pas',
  ufrmSetNewSheetParams in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmSetNewSheetParams.pas' {frmSetNewSheetParam},
  ufrmPeriodIncrement in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmPeriodIncrement.pas' {frmPeriodIncrement},
  ufraBaseIncrementGraph in '..\..\Client\ClientCommon\FuncFrames\DataGraph\ufraBaseIncrementGraph.pas' {fraIncGraph: TFrame},
  ufrmIncBarGraph in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmIncBarGraph.pas' {frmIncbar},
  ufrmTaskForm in '..\..\Client\ClientCommon\FuncFrames\TaskForm\ufrmTaskForm.pas' {TaskForm},
  ufrmCheckOmission in '..\..\Client\ClientCommon\FuncFrames\Tools\ufrmCheckOmission.pas' {frmCheckOmission},
  uMyTeeAxisScrollTool in '..\..\Client\ClientCommon\Tools\uMyTeeAxisScrollTool.pas',
  ufrmInputLayoutData in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufrmInputLayoutData.pas' {frmInputLayoutData},
  ufrmDataItemsList in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufrmDataItemsList.pas' {frmDataItemsList};

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '黄金峡观测数据处理辅助工具（功能测试程序）';
  Application.CreateForm(TfrmTestSummary, frmTestSummary);
  Application.CreateForm(TTaskForm, TaskForm);
  Application.CreateForm(TfrmCheckOmission, frmCheckOmission);
  Application.CreateForm(TfrmInputLayoutData, frmInputLayoutData);
  Application.CreateForm(TfrmDataItemsList, frmDataItemsList);
  // Application.CreateForm(TfrmMeterSelector, frmMeterSelector);
  Application.Run;

end.
