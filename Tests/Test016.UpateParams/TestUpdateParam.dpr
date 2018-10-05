program TestUpdateParam;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufraMeterList in '..\..\Client\ClientCommon\FuncFrames\MeterList\ufraMeterList.pas' {fraMeterList: TFrame},
  uHJX.HostTemplates in '..\..\Client\ClientCommon\uHJX.HostTemplates.pas',
  ufraTerminal in 'ufraTerminal.pas' {fraTerminal: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
