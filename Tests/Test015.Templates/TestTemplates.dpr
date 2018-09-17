program TestTemplates;

uses
  uHJX.CoreUnits in '..\..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.Classes.Templates in '..\..\..\Client\ClientCommon\Core\uHJX.Classes.Templates.pas',
  uHJX.Template.ChartTemplate in '..\..\..\Client\ClientCommon\Templates\uHJX.Template.ChartTemplate.pas',
  uHJX.Template.TemplatesImp in '..\..\..\Client\ClientCommon\Templates\uHJX.Template.TemplatesImp.pas',
  uHJX.ExcelDataAccess in '..\..\..\Client\ClientCommon\uHJX.ExcelDataAccess.pas',
  Vcl.Forms,
  ufrmMian in 'ufrmMian.pas' {frmMain},
  uHJX.Template.ProcSpecifiers in '..\..\..\Client\ClientCommon\Templates\uHJX.Template.ProcSpecifiers.pas',
  uHJX.Template.WebGridProc in '..\..\..\Client\ClientCommon\Functions\Template\uHJX.Template.WebGridProc.pas',
  uHJX.Template.WebGrid in '..\..\..\Client\ClientCommon\Templates\uHJX.Template.WebGrid.pas',
  uHJX.Template.XLGrid in '..\..\..\Client\ClientCommon\Templates\uHJX.Template.XLGrid.pas',
  uHJX.Template.XLGridHelper in '..\..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridHelper.pas',
  uHJX.Template.XLGridProc in '..\..\..\Client\ClientCommon\Functions\Template\uHJX.Template.XLGridProc.pas',
  Vcl.Themes,
  Vcl.Styles,
  uHJX.Template.ChartTemplateProc in '..\..\..\Client\ClientCommon\Functions\Template\uHJX.Template.ChartTemplateProc.pas';

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
