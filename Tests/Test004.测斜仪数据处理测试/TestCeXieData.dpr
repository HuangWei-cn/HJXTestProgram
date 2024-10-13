program TestCeXieData;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  uhwDataType.DSM.Inclinometer in 'uhwDataType.DSM.Inclinometer.pas',
  ufraInclineCharts in 'ufraInclineCharts.pas' {fraInclineCharts: TFrame},
  uhwDataOp.Excel.InclinoMeter in 'uhwDataOp.Excel.InclinoMeter.pas',
  ufrmOriDataWind in 'ufrmOriDataWind.pas' {frmOriDataWindow},
  ufrmMultDates in 'ufrmMultDates.pas' {frmMultDates},
  ufrmDeepTrendLine in 'ufrmDeepTrendLine.pas' {frmDeepTrendLine};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '测斜孔数据显示程序';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
