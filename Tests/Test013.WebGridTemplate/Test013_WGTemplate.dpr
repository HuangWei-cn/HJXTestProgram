program Test013_WGTemplate;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form2},
  uHJX.Template.WebGrid in 'uHJX.Template.WebGrid.pas',
  uHJX.Template.WGProc in 'uHJX.Template.WGProc.pas',
  ufraMeterList in '..\..\Client\ClientCommon\FuncFrames\MeterList\ufraMeterList.pas' {fraMeterList: TFrame},
  uWebGridCross in '..\..\Client\ClientCommon\Functions\WebGrid\uWebGridCross.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
