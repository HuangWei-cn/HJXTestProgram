unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bsSkinData, BusinessSkinForm, bsSkinCtrls, bsribbon,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, bsSkinExCtrls, Vcl.Mask, bsSkinBoxCtrls,
  uHJX.Intf.AppServices, uHJX.Intf.FunctionDispatcher, uHJX.Classes.Meters,
  uHJX.Classes.Templates,
  ufraMeterList {, ExcelXP, Vcl.OleServer};

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
    bsSkinButton2: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    bsRibbonGroup4: TbsRibbonGroup;
    chkNoExcel: TbsSkinCheckBox;
    rdgWriteOption: TbsSkinRadioGroup;
    bsSkinMemo1: TbsSkinMemo;
    lblExpMeter: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenConfigClick(Sender: TObject);
    procedure btnDoExpertClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure bsSkinButton3Click(Sender: TObject);
  private
    { Private declarations }
    FMeterList: TfraMeterList;
    procedure OnProjectLoaded(Sender: TObject);
    function CreateEmptyWorkBook(XLApp: OleVariant; BkName: string; MeterList: TStrings): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  nExcel, uHJX.EnvironmentVariables, uHJX.Template.XlGridProc, uHJX.Template.XLGrid,
  uHJX.Excel.IO,
  ComObj, ShellAPI;
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
    if CreateEmptyWorkBook(Null, sExpFile, slMeters) then
        ShowMessage('Create empty data file success!');
  finally
    slMeters.Free;
  end;
end;

{ test GetActiveOleObject function }
procedure TfrmMain.bsSkinButton2Click(Sender: TObject);
var
  XLApp: OleVariant;
begin
  XLApp := Unassigned;
  try
    XLApp := GetActiveOleObject('Excel.Application');
    if not VarIsNull(XLApp) then
        ShowMessage('Get excel application success!');
  except
    on EOleSysError do
    begin
      ShowMessage(VarTypeAsText(vartype(XLApp)));
      ShowMessage('Get excel application error');
    end
    else
      ShowMessage('Other error');
  end;
end;

procedure TfrmMain.bsSkinButton3Click(Sender: TObject);
var
  XLApp: OleVariant;
begin
  XLApp := Unassigned;
  try
    XLApp := GetActiveOleObject('Excel.Application');
  except
    try
      XLApp := CreateOleObject('Excel.Application')
    except
    end;
  end;

  if VarIsNull(XLApp) or VarIsEmpty(XLApp) then
  begin
    ShowMessage('Can not get Excel application');
    Exit;
  end;

  XLApp.Visible := True;
  ShowMessage('Get or Create Excel Application success');
  XLApp := Unassigned;
  ShowMessage('Excel application is free.');
end;

procedure TfrmMain.btnDoExpertClick(Sender: TObject);
type
  TXLWriteOption = (woNoExcel, woUseExcel, woOnlyCreateBook);
var
  slMeters    : TStrings; // selected meters
  mtGrps      : TStrings; // meter in group
  i, j        : Integer;
  sExpFile    : string;
  tBook, rBook: IXLSWorkBook; // tBook: Template workbook, rBook: Result workbook
  Meter       : TMeterDefine;
  xlTmpl      : TXLGridTemplate;
  grpItem     : TMeterGroupItem;
  bPreCreate  : Boolean; // �Ƿ�Ԥ�ȴ��������ݱ�
  bUseExcel   : Boolean; // �Ƿ���Excel���д�����
  WriteOption : TXLWriteOption;
  XLApp       : OleVariant;
  TagBk       : OleVariant;
  TagSht      : OleVariant;
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

    case rdgWriteOption.ItemIndex of
      0: WriteOption := woNoExcel;
      1: WriteOption := woOnlyCreateBook;
      2: WriteOption := woUseExcel;
    end;
    // ��ʹ��Excel����
    bPreCreate := False;
    bUseExcel := False;
    // if not chkNoExcel.Checked then
    if WriteOption <> woNoExcel then
    begin
      XLApp := TExcelIO.GetExcelApp(False); // ȡ�Ѿ����ڵ�Excel Application
      if VarIsNull(XLApp) or VarIsEmpty(XLApp) then
          XLApp := TExcelIO.GetExcelApp(True); // ������Excelʵ��
      // ����޷�ȡ��ExcelApplication����
      if VarIsNull(XLApp) or VarIsEmpty(XLApp) then
      begin
        bPreCreate := False; // û��Ԥ�ȴ����������ļ�����ζ��ֻ����nExcel��
        WriteOption := woNoExcel;
      end
      else
      begin
        if CreateEmptyWorkBook(XLApp, sExpFile, slMeters) = False then
        begin
          bPreCreate := False;
          WriteOption := woNoExcel;
        end
        else
        begin
          bPreCreate := True;
          if WriteOption = woOnlyCreateBook then
          begin
            ShellExecute(0, PChar('open'), PChar(sExpFile), nil, nil, SW_SHOWNORMAL);
            ShowMessage('����Excel(����WPS���ӱ��)�򿪸ղ����ɵĿչ��������ٱ���һ�£����֮����ȷ����');
            XLApp.Quit;
          end
          else
          begin
            TagBk := XLApp.workbooks.Open(sExpFile);
            XLApp.Visible := False;
            Sleep(1000);
          end;
        end;
      end;
    end;

    if WriteOption <> woUseExcel then
    begin
      tBook := TXLSWorkbook.Create;
      tBook.Open(ENV_XLTemplBook);

      rBook := TXLSWorkbook.Create;
      if WriteOption = woNoExcel then
          rBook.SaveAs(sExpFile)
      else
          rBook.Open(sExpFile);
    end;

    ProgressBar1.Min := 0;
    ProgressBar1.Max := slMeters.Count;
    ProgressBar1.Position := 0;
    ProgressBar1.Step := 1;
    ProgressBar1.Visible := True;
    lblExpMeter.Visible := True;
    Screen.Cursor := crHourGlass;
    if WriteOption = woUseExcel then
    begin
      XLApp.ScreenUpdating := False;
      XLApp.EnableEvents := False;
    end;

    for i := 0 to slMeters.Count - 1 do
    begin
      ProgressBar1.Position := i + 1;
      lblExpMeter.Caption := slMeters.Strings[i];
      ProgressBar1.Refresh;
      lblExpMeter.Refresh;
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
{
        if bPreCreate then
            // GenXLGrid(xlTmpl, Meter, TagBk) // ���һ������False���÷���������ģ���
            GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, False)
        else
            GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, True); // ��Ҫ����ģ���

}
      case WriteOption of
        woNoExcel: { ��ȫ��ʹ��Excel����졢��򵥣������ս��û��Chart }
          GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, True);
        woUseExcel: { ��ȫʹ��Excel������Ҫ������ԭ֭ԭζ���Ҽ� }
          GenXLGrid(xlTmpl, Meter, TagBk);
        woOnlyCreateBook: { ʹ��Excel��������������nExcelд�룬�鷳���Ͽ졢��Chart }
          GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, False);
      end;
    end;

  finally
    slMeters.Free;
    mtGrps.Free;

    if WriteOption = woUseExcel then
    begin
      TagBk.Save;
      XLApp.workbooks.Close;
      XLApp.ScreenUpdating := True;
      XLApp.EnableEvents := True;
      XLApp.Quit;
    end
    else
    begin
      rBook.Save;
        { todo: ����ĬĬ����Excel�򿪡���棬�ٹر�Excel }
    end;

    Screen.Cursor := crDefault;
  end;
    // if rbSelectedMeters.Checked then
  if WriteOption = woOnlyCreateBook then
      ShowMessage('���ݵ�����ϣ�����Excel�򿪵������ļ������Ϊxlsx��ʽ������WPS���ӱ��ET��'#13#10
      + '�򱣴�һ�¼��ɡ��������ļ�����һ���ĸ�ʽ���⣬��Ҫ���±��淽�ܽ����')
  else
      ShowMessage('���ݵ�����ϣ������á�');
  ProgressBar1.Visible := False;
  lblExpMeter.Visible := False;
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
  bsRibbonGroup4.Visible := False;
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
  bsRibbonGroup4.Visible := True;
  bsRibbonGroup2.Visible := True;
  bsRibbonGroup3.Visible := True;
  bsRibbonGroup1.Visible := True;
  FMeterList.Visible := True;
end;

{ -----------------------------------------------------------------------------
  Procedure  : CreateEmptyWorkBook
  Description: ��Excel���ģ�幤�����Ƶ�Ҫ�������ݵĹ������У������������
  ���Ƹ�Ϊ������Ż������ơ�������������Excel.IO��Ԫ��Exdel_CopySheet����,
  �ø÷���һ���Ը���������Ҫ�������ݵĹ�����ģ�塣
  ʹ��Excel��ɹ�����ĸ��ƣ����Խ�ģ���ʽ��ͼ��100%�ظ��ƹ�ȥ����nExcel��
  ��ʧһЩ��ʽ��ͼ�Ρ�Chart�����ݡ�
----------------------------------------------------------------------------- }
function TfrmMain.CreateEmptyWorkBook(XLApp: OleVariant; BkName: string;
  MeterList: TStrings): Boolean;
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
  Screen.Cursor := crHourGlass;
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
        { TODO -ohw -c�˴���Ӷ�grpItem�Ƿ�Ϊnil���жϣ��û����ÿ������� : ActionItem }
        if grpItem <> nil then
          for j := 0 to grpItem.Count - 1 do grpMts.add(grpItem.Items[j]);
      end
      else tagName := Meter.DesignName;

      tpl := Tpls.ItemByName[Meter.DataSheetStru.XLTemplate] as TXLGridTemplate;
      tplName := tpl.TemplateSheet;

      ShtLsts := ShtLsts + tplName + ':' + tagName + #13#10;
    end;

    Result := TExcelIO.Excel_CopySheet(XLApp, ENV_XLTemplBook, BkName, ShtLsts);
  finally
    grpMts.Free;
    Screen.Cursor := crDefault;
  end;
end;

end.
