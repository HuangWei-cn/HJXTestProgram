program TestTemplates;

uses
  uHJX.CoreUnits in '..\..\..\HJXProject\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\..\HJXProject\uHJX.ExcelDataAccess.pas',
  uHJX.GraphDispatcherUnits in '..\..\..\HJXProject\uHJX.GraphDispatcherUnits.pas',
  uHJX.HostTemplates in '..\..\..\HJXProject\uHJX.HostTemplates.pas',
  Vcl.Forms,
  ufrmMian in 'ufrmMian.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
