program ExpertXLS;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  uHJX.HostTemplates in '..\..\Client\ClientCommon\uHJX.HostTemplates.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufraMeterSelector in '..\..\Client\ClientCommon\FuncFrames\MeterSelector\ufraMeterSelector.pas' {fraMeterSelector: TFrame},
  ufrmMeterSelector in '..\..\Client\ClientCommon\FuncFrames\MeterSelector\ufrmMeterSelector.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
