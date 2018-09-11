program pTestTLDefine;
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}


uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.GraphDispatcherUnits in '..\..\Client\ClientCommon\uHJX.GraphDispatcherUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  uFuncDataGraph in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uFuncDataGraph.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufraMeterList in '..\..\Client\ClientCommon\FuncFrames\MeterList\ufraMeterList.pas' {fraMeterList: TFrame},
  uTLDefineProc in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uTLDefineProc.pas',
  uFuncDrawTLByStyle in '..\..\Client\ClientCommon\FuncFrames\DataGraph\uFuncDrawTLByStyle.pas';

{$R *.res}


begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
