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
  ufraInputDatas in 'ufraInputDatas.pas' {TfraInputDatas: TFrame};

{$R *.res}


begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
