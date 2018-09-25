program TestSmoothPan;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  SimpleGraph in 'SimpleGraph.pas',
  uhwSGEx.DataMapClasses in '..\..\..\HJXProject\Tools\uhwSGEx.DataMapClasses.pas',
  uhwSGEx in '..\..\..\HJXProject\Tools\uhwSGEx.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
