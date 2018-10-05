program DataLayoutEditor;

uses
  uHJX.CoreUnits in '..\..\Client\ClientCommon\uHJX.CoreUnits.pas',
  uHJX.Intf.Datas in '..\..\Client\ClientCommon\Interfaces\uHJX.Intf.Datas.pas',
  uHJX.Data.Types in '..\..\Client\ClientCommon\Core\uHJX.Data.Types.pas',
  uHJX.EnvironmentVariables in '..\..\Client\ClientCommon\Core\uHJX.EnvironmentVariables.pas',
  uHJX.Excel.DataQuery in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.DataQuery.pas',
  uHJX.Excel.InitParams in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.InitParams.pas',
  uHJX.Excel.IO in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.IO.pas',
  uHJX.Excel.Meters in '..\..\Client\ClientCommon\DataInfImp\uHJX.Excel.Meters.pas',
  Vcl.Forms,
  ufrmEditor in 'ufrmEditor.pas' {frmEditor},
  uhwSGEx.DataMapClasses in '..\..\Client\ClientCommon\Tools\uhwSGEx.DataMapClasses.pas',
  DesignProp in '..\..\Client\ClientCommon\Tools\SGEditor\DesignProp.pas' {DesignerProperties},
  LinkProp in '..\..\Client\ClientCommon\Tools\SGEditor\LinkProp.pas' {LinkProperties},
  MarginsProp in '..\..\Client\ClientCommon\Tools\SGEditor\MarginsProp.pas' {MarginDialog},
  NodeProp in '..\..\Client\ClientCommon\Tools\SGEditor\NodeProp.pas' {NodeProperties},
  ObjectProp in '..\..\Client\ClientCommon\Tools\SGEditor\ObjectProp.pas' {ObjectProperties},
  SizeDlg in '..\..\Client\ClientCommon\Tools\SGEditor\SizeDlg.pas' {SizeDialog},
  uhwSGEx in '..\..\Client\ClientCommon\Tools\uhwSGEx.pas',
  SimpleGraph in '..\..\Client\ClientCommon\Tools\SimpleGraph.pas',
  uHJX.HostTemplates in '..\..\Client\ClientCommon\uHJX.HostTemplates.pas',
  AlignDlg in '..\..\Client\ClientCommon\Tools\SGEditor\AlignDlg.pas' {AlignDialog};

{$R *.res}


begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := '观测数据分布图编辑器';
    Application.CreateForm(TfrmEditor, frmEditor);
  Application.Run;

end.
