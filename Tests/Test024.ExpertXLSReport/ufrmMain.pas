unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, bsSkinData, BusinessSkinForm, bsSkinCtrls, bsribbon,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, bsSkinExCtrls, Vcl.Mask, bsSkinBoxCtrls,
  uHJX.Intf.AppServices, uHJX.Intf.FunctionDispatcher, uHJX.Classes.Meters,
  uHJX.Classes.Templates,
  ufraMeterList, ExcelXP, Vcl.OleServer;

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
    ExcelApplication1: TExcelApplication;
    ExcelChart1: TExcelChart;
    ExcelWorkbook1: TExcelWorkbook;
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
var
  slMeters    : TStrings; // selected meters
  mtGrps      : TStrings; // meter in group
  i, j        : Integer;
  sExpFile    : string;
  tBook, rBook: IXLSWorkBook; // tBook: Template workbook, rBook: Result workbook
  Meter       : TMeterDefine;
  xlTmpl      : TXLGridTemplate;
  grpItem     : TMeterGroupItem;
  bPreCreate  : Boolean; // 是否预先创建了数据表
  XLApp       : OleVariant;
  TagBk       : OleVariant;
  TagSht      : OleVariant;
begin
    // 导出文件
  if dlgSave.Execute then sExpFile := dlgSave.FileName
  else Exit;

    // 根据选项执行：
  slMeters := TStringList.Create;
  mtGrps := TStringList.Create;
  try
    if rbSelectedMeters.Checked then
      (IAppServices.FuncDispatcher as IFunctionDispatcher)
        .CallFunction('PopupMeterSelector', slMeters)
    else
      for i := 0 to ExcelMeters.Count - 1 do slMeters.add(ExcelMeters.Items[i].DesignName);

    // 若使用Excel，则
    bPreCreate := False;
    if not chkNoExcel.Checked then
    begin
      XLApp := TExcelIO.GetExcelApp(False); // 取已经存在的Excel Application
      if VarIsNull(XLApp) or VarIsEmpty(XLApp) then
          XLApp := TExcelIO.GetExcelApp(True); // 创建新Excel实例
      // 如果无法取得ExcelApplication，则
      if VarIsNull(XLApp) or VarIsEmpty(XLApp) then
          bPreCreate := False // 没有预先创建空数据文件，意味着只能用nExcel了
      else
      begin
        if CreateEmptyWorkBook(XLApp, sExpFile, slMeters) = False then
            bPreCreate := False
        else
        begin
          TagBk := XLApp.WorkBooks.Open(sExpFile);
          bPreCreate := True;
          XLApp.Visible := True;
        end;
      end;
    end;

    if not bPreCreate then
    begin
      tBook := TXLSWorkbook.Create;
      rBook := TXLSWorkbook.Create;
      tBook.Open(ENV_XLTemplBook);
      rBook.SaveAs(sExpFile)
    end;

{
      // 为每只仪器创建空数据表，如果选用本方法就不要使用下一句
      if (not chkNoExcel.Checked) and CreateEmptyWorkBook(sExpFile, slMeters) then
      begin
        bPreCreate := True;
        rBook.Open(sExpFile); // 打开预创建的数据表
      end
      else
      begin
        rBook.SaveAs(sExpFile); // 将空工作簿保存为指定的文件名
        bPreCreate := False;
      end;

}
    ProgressBar1.Min := 0;
    ProgressBar1.Max := slMeters.Count;
    ProgressBar1.Position := 0;
    ProgressBar1.Step := 1;
    ProgressBar1.Visible := True;

    for i := 0 to slMeters.Count - 1 do
    begin
      ProgressBar1.Position := i + 1;
      ProgressBar1.Invalidate;
      // 同组的不处理
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

      // 取模板对象
      xlTmpl := (IAppServices.Templates as TTemplates).ItemByName
        [Meter.DataSheetStru.XLTemplate] as TXLGridTemplate;

      // 开始处理数据
      if bPreCreate then
          GenXLGrid(xlTmpl, Meter, TagBk) // 最后一个参数False，该方法不复制模板表
          //GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, False)
      else
          GenXLGrid(xlTmpl, slMeters.Strings[i], tBook, rBook, True); // 需要复制模板表
    end;

  finally
    slMeters.Free;
    mtGrps.Free;

    if bPreCreate then
    begin
      TagBk.Save;
      XLApp.WorkBooks.Close;
      XLApp.Quit;
    end
    else
        rBook.Save;
  end;
    // if rbSelectedMeters.Checked then

  ShowMessage('数据导出完毕');
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
  Description: 用Excel完成模板工作表复制到要导出数据的工作簿中，并将工作表的
  名称改为仪器编号或组名称。本方法调用了Excel.IO单元的Exdel_CopySheet方法,
  用该方法一次性复制所有需要导出数据的工作表模板。
  使用Excel完成工作表的复制，可以将模板格式、图表100%地复制过去。用nExcel将
  丢失一些格式、图形、Chart等内容。
----------------------------------------------------------------------------- }
function TfrmMain.CreateEmptyWorkBook(XLApp: OleVariant; BkName: string;
  MeterList: TStrings): Boolean;
var
  ShtLsts: String;
  i, j   : Integer;
  Meter  : TMeterDefine;
  grpMts : TStrings; // 组内仪器
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
