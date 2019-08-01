program DistrubitionMapTest;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  uHJX.Func.ChartTemplateClasses in '..\..\Client\ClientCommon\uHJX.Func.ChartTemplateClasses.pas',
  uHJX.GraphDispatcherUnits in '..\..\Client\ClientCommon\uHJX.GraphDispatcherUnits.pas',
  uHJX.HostTemplates in '..\..\Client\ClientCommon\uHJX.HostTemplates.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  ufrmDistMapEditor in 'ufrmDistMapEditor.pas' {frmDMEditor},
  ufraDistMap in 'ufraDistMap.pas' {fraDistMap: TFrame},
  ufrmDistMap in 'ufrmDistMap.pas' {frmDistMap};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '观测数据分布图测试程序';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
