program TestSimpleGraph;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  uHJX.HostTemplates in '..\..\Client\ClientCommon\uHJX.HostTemplates.pas',
  ufraDataLayout in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufraDataLayout.pas' {fraDataLayout: TFrame},
  ufraDataPresentation in '..\..\Client\ClientCommon\FuncFrames\DataLayout\ufraDataPresentation.pas' {fraDataPresentation: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
