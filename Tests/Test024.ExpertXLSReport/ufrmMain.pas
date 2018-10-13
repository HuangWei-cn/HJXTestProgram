unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bsSkinData, BusinessSkinForm, bsSkinCtrls, bsribbon,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, bsSkinExCtrls, Vcl.Mask, bsSkinBoxCtrls,
  uHJX.Intf.AppServices, uHJX.Intf.FunctionDispatcher, uHJX.Classes.Meters,
  uHJX.Classes.Templates,
  ufraMeterList;

type
  TfrmMain = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    bsribbon: TbsRibbon;
    bsAppMenu: TbsAppMenu;
    bsAppMenuPage1: TbsAppMenuPage;
    bsAppMenuPage2: TbsAppMenuPage;
    bsAppMenuPageListBox1: TbsAppMenuPageListBox;
    bsSkinStatusBar1: TbsSkinStatusBar;
    btnOpenConfig: TbsSkinButton;
    lbxRecentFile: TbsAppMenuPageListBox;
    bsRibbonPage1: TbsRibbonPage;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinSplitter1: TbsSkinSplitter;
    bsSkinPanel2: TbsSkinPanel;
    bsRibbonGroup1: TbsRibbonGroup;
    bsRibbonGroup2: TbsRibbonGroup;
    bsRibbonGroup3: TbsRibbonGroup;
    rbAllMeters: TbsSkinRadioButton;
    rbSelectedMeters: TbsSkinRadioButton;
    btnDoExpert: TbsSkinButtonEx;
    deStartDate: TbsSkinDateEdit;
    deEndDate: TbsSkinDateEdit;
    rbLifeDatas: TbsSkinRadioButton;
    rbDateRange: TbsSkinRadioButton;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinLabel2: TbsSkinLabel;
    dlgSave: TSaveDialog;
    ProgressBar1: TProgressBar;
    bsSkinButton1: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenConfigClick(Sender: TObject);
    procedure btnDoExpertClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
  private
    { Private declarations }
    FMeterList: TfraMeterList;
    procedure OnProjectLoaded(Sender: TObject);
    function CreateEmptyWorkBook(BkName: string; MeterList: TStrings): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  nExcel, uHJX.EnvironmentVariables, uHJX.Template.XlGridProc, uHJX.Template.XLGrid,
  uHJX.Excel.IO,
  ComObj;
{$R *.dfm}


procedure TfrmMain.bsSkinButton1Click(Sender: TObject);
var
  slMeters: TStrings;
  sExpFile: String;
begin
  if dlgSave.Execute then
      sExpFile := dlgSave.FileName
  else Exit;
  slMeters := TStringList.Create;
  try
    (IAppServices.FuncDispatcher as IFunctionDispatcher)
      .CallFunction('PopupMeterSelector', slMeters);
    if CreateEmptyWorkBook(sExpFile, slMeters) then
        ShowMessage('Create empty data file success!');
  finally
    slMeters.Free;
  end;
end;

procedure TfrmMain.btnDoExpertClick(Sender: TObject);
var
  slMeters    : TStrings; // selected meters
  mtGrps      : TStrings; // meter in group
  i, j        : Integer;
  sExpFile    : string;
  tBook, rBook: IXLSWorkBook; //tBook: Template workbook, rBook: Result workbook
  Meter       : TMeterDefine;
  xlTmpl      : TXLGridTemplate;
  grpItem     : TMeterGroupItem;
  bPreCreate  : Boolean; // �Ƿ�Ԥ�ȴ��������ݱ�
begin
    // �����ļ�
  if dlgSave.Execute then sExpFile := dlgSave.FileName
  else Exit;

    // ����ѡ��ִ�У�
  slMeters := TStringList.Create;
  mtGrps := TStringList.Create;
  try
    if rbSelectedMeters.Checked then
      (IAppServices.FuncDispatcher as IFunctionDispatcher)
        .CallFunction('PopupMeterSelector', slMeters)
    else
      for i := 0 to ExcelMeters.Count - 1 do slMeters.add(ExcelMeters.Items[i].DesignName);

    tBook := TXLSWorkbook.Create;
    rBook := TXLSWorkbook.Create;
    tBook.open(ENV_XLTemplBook);

    // Ϊÿֻ�������������ݱ����ѡ�ñ������Ͳ�Ҫʹ����һ��
    if CreateEmptyWorkBook(sExpFile, slMeters) then
    begin
      bPreCreate := True;
      rBook.open(sExpFile); // ��Ԥ���������ݱ�
    end
    else
    begin
      rBook.SaveAs(sExpFile); // ���չ���������Ϊָ�����ļ���
      bPreCreate := False;
    end;

    ProgressBar1.Min := 0;
    ProgressBar1.Max := slMeters.Count;
    ProgressBar1.Position := 0;
    ProgressBar1.Step := 1;
    ProgressBar1.Visible := True;

    for i := 0 to slMeters.Count - 1 do
    begin
      ProgressBar1.Position := i + 1;
      // ͬ��Ĳ�����
      if mtGrps.IndexOf(slMeters.Strings[i]) <> -1 then Continue;

      Meter := ExcelMeters.Meter[slMeters.Strings[i]];
      if Meter = nil then Continue;
      if (Meter.DataBook = '') or (Meter.DataSheet = '') then Continue;
      if Meter.DataSheetStru.XLTemplate = '' then Continue;

      if Meter.PrjParams.GroupID <> '' then
      begin
        grpItem := (IAppServices.MeterGroups as TMeterGroup)
          .ItemByName[Meter.PrjParams.GroupID];
        for j := 0 to grpItem.Count - 1 do mtGrps.add(grpItem.Items[j]);
      end;

      // ȡģ�����
      xlTmpl := (IAppServices.Templates as TTemplates).ItemByName
        [Meter.DataSheetStru.XLTemplate] as TXLGridTemplate;

      // ��ʼ��������
      if bPreCreate then
          GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, False) //���һ������False���÷���������ģ���
      else
          GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, True); //��Ҫ����ģ���
    end;
    rBook.save;
  finally
    slMeters.Free;
    mtGrps.Free;
  end;
    // if rbSelectedMeters.Checked then

  ShowMessage('���ݵ������');
  ProgressBar1.Visible := False;
end;

procedure TfrmMain.btnOpenConfigClick(Sender: TObject);
begin
  if Assigned(IAppServices) then IAppServices.OpenDatabaseManager;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    // bsAppMenu.Show;
  bsRibbonGroup1.Visible := False;
  bsRibbonGroup2.Visible := False;
  bsRibbonGroup3.Visible := False;
  deEndDate.Date := Now;
  if Assigned(IAppServices) then
      IAppServices.RegEventDemander('AfterConnectedEvent', OnProjectLoaded);

  FMeterList := TfraMeterList.Create(Self);
  FMeterList.Parent := Self.bsSkinPanel1;
  FMeterList.align := alclient;
  FMeterList.Visible := False;
end;

procedure TfrmMain.OnProjectLoaded(Sender: TObject);
begin
    // ShowMessage('Project loaded');
  bsAppMenu.hide;
  bsRibbonGroup2.Visible := True;
  bsRibbonGroup3.Visible := True;
  bsRibbonGroup1.Visible := True;
  FMeterList.Visible := True;
end;

function TfrmMain.CreateEmptyWorkBook(BkName: string; MeterList: TStrings): Boolean;
var
  ShtLsts: String;
  i, j   : Integer;
  Meter  : TMeterDefine;
  grpMts : TStrings; // ��������
  grpItem: TMeterGroupItem;
  tpl    : TXLGridTemplate;
  Tpls   : TTemplates;
  tplName: String;
  tagName: String;
begin
  Result := False;
  ShtLsts := '';
  grpMts := TStringList.Create;
  try
    Tpls := IAppServices.Templates as TTemplates;
    for i := 0 to MeterList.Count - 1 do
    begin
      if grpMts.IndexOf(MeterList.Strings[i]) <> -1 then Continue;
      Meter := ExcelMeters.Meter[MeterList.Strings[i]];

      if Meter = nil then Continue;
      if (Meter.DataBook = '') or (Meter.DataSheet = '') then Continue;
      if Meter.DataSheetStru.XLTemplate = '' then Continue;

      if Meter.PrjParams.GroupID <> '' then
      begin
        tagName := Meter.PrjParams.GroupID;
        grpItem := MeterGroup.ItemByName[Meter.PrjParams.GroupID];
        for j := 0 to grpItem.Count - 1 do grpMts.add(grpItem.Items[j]);
      end
      else tagName := Meter.DesignName;

      tpl := Tpls.ItemByName[Meter.DataSheetStru.XLTemplate] as TXLGridTemplate;
      tplName := tpl.TemplateSheet;

      ShtLsts := ShtLsts + tplName + ':' + tagName + #13#10;
    end;

    Result := TExcelIO.Excel_CopySheet(ENV_XLTemplBook, BkName, ShtLsts);
  finally
    grpMts.Free;
  end;
end;

end.
