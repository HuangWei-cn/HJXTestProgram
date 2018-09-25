program TestSimpleGraph;

uses
  uHJX.CoreUnits in '..\..\..\HJXProject\uHJX.CoreUnits.pas',
  uHJX.ExcelDataAccess in '..\..\..\HJXProject\uHJX.ExcelDataAccess.pas',
  uHJX.HostTemplates in '..\..\..\HJXProject\uHJX.HostTemplates.pas',
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  ufraDataLayout in '..\..\..\HJXProject\FuncFrames\DataLayout\ufraDataLayout.pas' {fraDataLayout: TFrame},
  ufraDataPresentation in '..\..\..\HJXProject\FuncFrames\DataLayout\ufraDataPresentation.pas' {fraDataPresentation: TFrame};


{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
