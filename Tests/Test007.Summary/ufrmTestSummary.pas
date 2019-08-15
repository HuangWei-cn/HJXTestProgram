{ -----------------------------------------------------------------------------
 Unit Name: ufrmTestSummary
 Author:    黄伟
 Date:      07-六月-2018
 Purpose:   安全监测数据处理主界面
 History:
    2018-06-07 向接口化更进一步；部分Frame改为运行时创建；
----------------------------------------------------------------------------- }
unit ufrmTestSummary;

{ todo:完善“特性”功能，加载完参数表之后，显示当前参数设置的基本情况 }
{ DONE:整合参数表和仪器列表，用一个工程设置工作簿取代逐个打开各种设置文件 }
{ todo:完成显示仪器观测数据的功能 }
{ DONE:增加双击仪器显示过程线的功能 }
{ DONE:增加特征值提取功能 }
{ todo:增加一个命令终端窗口，敲命令可以显示相应的功能，like hack..mmm }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CategoryButtons, nExcel, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
    {----core system----}
  uHJX.Intf.AppServices, uHJX.IntfImp.AppServices,
  ufraSummaryMaker.Excel, uHJX.Intf.Datas,
    {---function frames---}
  ufraHJXDataGrid,
  ufraMeterListGrid, ufraDataLayout, ufraDataPresentation, ufraExcelMeterParamEditor,
    {ufraTrendLineShell,} ufraMeterList, ufraEigenvalueWeb, uHJX.ProjectGlobal, ufraRptDataHTMLGrid,
  ufraQuickViewer, ufraEigenvalueGrid,
    {--------}
  AdvPanel, Vcl.Menus {, acPathDialog};

type
  TfrmTestSummary = class(TForm)
    cbsFunctions: TCategoryButtons;
    dlgOpen: TOpenDialog;
    amMain: TActionManager;
    actLoadParams: TAction;
    actLoadDataFileList: TAction;
    actParamsEditor: TAction;
    actSummaryCreator: TAction;
    actSetupCustomStaticReport: TAction;
    pgcMain: TPageControl;
    tabBaseParams: TTabSheet;
    pnlLeftPanel: TPanel;
    Splitter1: TSplitter;
    actLoadSummaryDefine: TAction;
    tabSummary: TTabSheet;
    actConnectDatabase: TAction;
    tabDataViewer: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    lblDesignName: TLabel;
    Label2: TLabel;
    lblMeterType: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblStake: TLabel;
    Label7: TLabel;
    lblElevation: TLabel;
    lblPosition: TLabel;
    tabEigenValue: TTabSheet;
    fraMeterListGrid1: TfraMeterListGrid;
    tabDataLayout: TTabSheet;
    dlgOpenDataLayout: TOpenDialog;
    actShowDataLayout: TAction;
    tabParamsEditor: TTabSheet;
    lstTestMeters: TListBox;
    Panel2: TPanel;
    fraXLSParamEditor1: TfraXLSParamEditor;
    btnTest_LoadMeters: TButton;
    tabTools: TTabSheet;
    btnDataCounts: TButton;
    Button1: TButton;
    tabDataGraph: TTabSheet;
    scrTLList: TScrollBox;
    tabDataReport: TTabSheet;
    popSetDefaultTrendLineSize: TPopupMenu;
    piSetDefaultTLSize: TMenuItem;
    tabQuickView: TTabSheet;
    Button2: TButton;
    btnListSetupDate: TButton;
    Splitter2: TSplitter;
    Button3: TButton;
    Button4: TButton;
    procedure actLoadParamsExecute(Sender: TObject);
    procedure actLoadDataFileListExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actLoadSummaryDefineExecute(Sender: TObject);
    procedure actConnectDatabaseExecute(Sender: TObject);
    procedure actShowDataLayoutExecute(Sender: TObject);
    procedure btnTest_LoadMetersClick(Sender: TObject);
    procedure lstTestMetersDblClick(Sender: TObject);
    procedure btnDataCountsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure piSetDefaultTLSizeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure btnListSetupDateClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
        { Private declarations }
    FParamLoaded,
      FDataFileListLoaded: Boolean;
    FDefaultTLWidth,
      FDefaultTLHeight: integer; // 缺省过程线窗口宽和高
    FfraMeterList     : TfraMeterList;
    FEigenValue       : TfraEigenvalueWeb;
    FDataLayout       : TfraDataPresentation;
    FSummary          : TfraXLSSummaryMeker;
    FDataRpt          : TfraRptDataHTMLGrid;
    FQuickViewer      : TfraQuickViewer;
  public
        { Public declarations }
    procedure ShowMeterDatas(ADesignName: string);
    procedure ShowMeterTrendLine(ADesignName: string);
    procedure DblClickMeter(ADesignName: string);
        // 弹出一个过程线窗口
    procedure PopupTrendLineWindow(ADesignName: string);
  end;

var
  frmTestSummary: TfrmTestSummary;

implementation

uses uHJX.Excel.InitParams, {uHJX.Excel.Meters} uHJX.Classes.Meters, uHJX.EnvironmentVariables,
  uHJX.Excel.DataQuery, uHJX.IntfImp.FuncCompManager, uHJX.Intf.FunctionDispatcher,
  ufrmDataCounts, ufraMeterSelector, ufrmQuerySetupDate, ufrmShowDeformMap;
{$R *.dfm}


var
  IFD: IFunctionDispatcher;

// 加载数据文件列表
procedure TfrmTestSummary.actConnectDatabaseExecute(Sender: TObject);
begin
    // 下面是临时代码，将来使用数据访问对象替代连接数据库。
  IAppServices.OpenDatabaseManager;
    (*
    if dlgOpen.Execute then
    begin
        FfraMeterList.tvwMeters.Items.Clear;
        { todo:加入参数加载结果的判断。可通过事件进行驱动参数加载完毕后应该进行的动作 }
        LoadProjectConfig(dlgOpen.FileName);
        if ExcelMeters.Count > 0 then
        begin
            FfraMeterList.ShowMeters;
            fraMeterListGrid1.ListMeters;
        end;
    end;
 *)
end;

procedure TfrmTestSummary.actLoadDataFileListExecute(Sender: TObject);
var
  wbk: IXLSWorkBook;
begin
  dlgOpen.Title := '打开监测仪器数据文件列表定义工作簿';
  if dlgOpen.Execute then
  begin
    try
      wbk := TXLSWorkbook.Create;
      wbk.Open(dlgOpen.FileName);
      if LoadDataFileList(wbk) then
      begin
        FDataFileListLoaded := True;
        ShowMessage('数据文件列表加载完毕');
      end;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
  if FParamLoaded and FDataFileListLoaded then
    FfraMeterList.ShowMeters;
end;
{ 加载参数表 }

procedure TfrmTestSummary.actLoadParamsExecute(Sender: TObject);
var
  wbk: IXLSWorkBook;
begin
    // 选择要打开的文件
  dlgOpen.Title := '打开监测仪器属性工作簿';
  if dlgOpen.Execute then
  begin
    try
      wbk := TXLSWorkbook.Create;
      wbk.Open(dlgOpen.FileName);
            // ShowMessage(wbk.ActiveSheet.Name);
      if LoadParams(wbk) = True then
      begin
        FParamLoaded := True;
        ShowMessage('参数表加载完毕！');
      end;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
  if FParamLoaded and FDataFileListLoaded then
  begin
    FfraMeterList.ShowMeters;
    fraMeterListGrid1.ListMeters;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : actLoadSummaryDefineExecute
  Description: 打开一个汇总表定义，创建汇总表生成器
  ----------------------------------------------------------------------------- }
procedure TfrmTestSummary.actLoadSummaryDefineExecute(Sender: TObject);
var
  sFile: string;
begin
    //
  dlgOpen.Title := '打开汇总表预定义工作簿';
  if dlgOpen.Execute then
  begin
    sFile := dlgOpen.FileName;
    FSummary.SetSummaryDefine(sFile);
  end;
end;

procedure TfrmTestSummary.actShowDataLayoutExecute(Sender: TObject);
begin
  if dlgOpenDataLayout.Execute then
        // fraDataLayout.LoadDataLayout(dlgOpenDataLayout.FileName);
end;

procedure TfrmTestSummary.btnDataCountsClick(Sender: TObject);
var
  frm: TfrmDataCount;
begin
  frm := TfrmDataCount.Create(Self);
  try
    frm.ShowModal;
  finally
    frm.Release;
  end;
end;

procedure TfrmTestSummary.btnListSetupDateClick(Sender: TObject);
var
  frm: TfrmQuerySetupDate;
begin
  frm := TfrmQuerySetupDate.Create(Self);
  frm.ShowModal;
  frm.Release;
end;

procedure TfrmTestSummary.btnTest_LoadMetersClick(Sender: TObject);
var
  i: integer;
begin
  lstTestMeters.Clear;
  if ExcelMeters.Count > 0 then
    for i := 0 to ExcelMeters.Count - 1 do
      lstTestMeters.AddItem(ExcelMeters.Items[i].DesignName, ExcelMeters.Items[i]);
  fraXLSParamEditor1.vleMeterParams.ItemProps['仪器类型'].PickList := PG_MeterTypes;
  fraXLSParamEditor1.vlePrjParams.ItemProps['工程部位'].PickList := pg_locations;
end;

procedure TfrmTestSummary.Button1Click(Sender: TObject);
begin
  PopupTrendLineWindow('M03YBP');
end;

procedure TfrmTestSummary.Button2Click(Sender: TObject);
var
  strs: TStringList;
begin
  if IFD.HasProc('popupmeterselector') then
  begin
    strs := TStringList.Create;
    try
      IFD.CallFunction('PopupMeterSelector', strs);
      ShowMessage(strs.Text);
    finally
      strs.Free;
    end;
  end;
end;

procedure TfrmTestSummary.Button3Click(Sender: TObject);
var
  frm: TForm;
  fra: TfraEigenvalueGrid;
begin
  frm := TForm.Create(Self);
  frm.Position := poScreenCenter;
  frm.Width := Self.Width - 200;
  frm.Height := Self.Height - 200;
  fra := TfraEigenvalueGrid.Create(frm);
  fra.Parent := frm;
  fra.Align := alClient;
  fra.Visible := True;
  try
    frm.ShowModal;
  finally
    frm.Release;
  end;
end;

procedure TfrmTestSummary.Button4Click(Sender: TObject);
var frm: TfrmShowDeformPoints;
begin
  frm := TfrmShowDeformPoints.Create(Self);
  frm.OnClose := Self.FormClose;
  frm.Show;
end;

procedure TfrmTestSummary.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTestSummary.FormCreate(Sender: TObject);
begin
  HJXAppServices.SetApplication(Application); // 设置全局Application对象
  HJXAppServices.AppProcessMessages := Application.ProcessMessages;
    // 注：本Form目前还未增加IHost接口，也未按照IHost接口进行改造。这里暂时设置是为了向其他单元提供
    // 一个Owner、Mainform。
  HJXAppServices.Host := Self;

  Self.pgcMain.ActivePage := tabBaseParams;
  FParamLoaded := False;
  FDataFileListLoaded := False;
  FfraMeterList := TfraMeterList.Create(Self);
  FfraMeterList.Parent := pnlLeftPanel;
  FfraMeterList.Align := alClient;
  ENV_ExePath := ExtractFilePath(Application.ExeName);

    // 创建数据访问接口的实例
    { DONE:向FuncCompManager注册ClientDataFunc }
    // IHJXClientFuncs := ThjxDataQuery.Create; //2018-06-07 已在uHJX.Excel.DataQuery单元自己注册了

    // 指定功能事件响应方法，算是临时方法，将来用功能调度单元实现
  FfraMeterList.OnShowMeterDatas := Self.ShowMeterDatas;
  FfraMeterList.OnShowMeterTrendLine := Self.ShowMeterTrendLine;
  FfraMeterList.OnDblClickMeter := Self.DblClickMeter;

    // 特征值Frame
  FEigenValue := TfraEigenvalueWeb.Create(Self);
  FEigenValue.Parent := tabEigenValue;
  FEigenValue.Align := alClient;
    // 分布图
  FDataLayout := TfraDataPresentation.Create(Self);
  with FDataLayout do
  begin
    Parent := tabDataLayout;
    Align := alClient;
  end;
    // 汇总表
  FSummary := TfraXLSSummaryMeker.Create(Self);
  FSummary.Parent := tabSummary;
  FSummary.Align := alClient;
    // 数据报表
  FDataRpt := TfraRptDataHTMLGrid.Create(Self);
  FDataRpt.Parent := tabDataReport;
  FDataRpt.Align := alClient;
    // 数据速览
  FQuickViewer := TfraQuickViewer.Create(Self);
  FQuickViewer.Parent := tabQuickView;
  FQuickViewer.Align := alClient;

    // 设置缺省的过程线宽和高
  FDefaultTLWidth := 800;
  FDefaultTLHeight := 350;

    // 初始化注册
  FuncCompManager.InitFuncComps;
    //
  IFD := IAppServices.FuncDispatcher as IFunctionDispatcher;
  Self.Width := screen.Width - 350;
  Self.Height := screen.Height - 200;
end;

procedure TfrmTestSummary.lstTestMetersDblClick(Sender: TObject);
begin
  if lstTestMeters.Count = 0 then
    exit;
  fraXLSParamEditor1.EditMeter(lstTestMeters.Items.Objects[lstTestMeters.ItemIndex]
    as TMeterDefine);
end;

{ -----------------------------------------------------------------------------
  Procedure  : piSetDefaultTLSizeClick
  Description: 设置缺省过程线窗口的宽度和高度
----------------------------------------------------------------------------- }
procedure TfrmTestSummary.piSetDefaultTLSizeClick(Sender: TObject);
begin
  with (popSetDefaultTrendLineSize.PopupComponent as TWinControl) do
  begin
    FDefaultTLWidth := Width;
    FDefaultTLHeight := Height;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : ShowMeterDatas
  Description: 显示仪器数据
----------------------------------------------------------------------------- }
procedure TfrmTestSummary.ShowMeterDatas(ADesignName: string);
var
  Meter: TMeterDefine;
begin
  Meter := ExcelMeters.Meter[ADesignName];
  if Meter <> nil then
  begin
    lblDesignName.Caption := ADesignName;
    lblMeterType.Caption := Meter.Params.MeterType;
    lblPosition.Caption := Meter.PrjParams.Position;
    lblStake.Caption := Meter.PrjParams.Stake;
    lblElevation.Caption := FloatToStr(Meter.PrjParams.Elevation);
  end;

  try
    screen.Cursor := crHourGlass;
        // fraHJXDataGrid1.ShowMeterDatas(ADesignName);
    IFD.ShowData(ADesignName, tabDataViewer);
        // IFD.ShowData(ADesignName, nil);
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TfrmTestSummary.ShowMeterTrendLine(ADesignName: string);
var
  Meter: TMeterDefine;
  frm  : TForm;
  pnl  : TAdvPanel;
    // fra  : TfraTrendLineShell;
begin
  Meter := ExcelMeters.Meter[ADesignName];
  if Meter <> nil then
  begin
// frm := TForm.Create(self);
// frm.BorderStyle := bsSizeToolWin;
// frm.Parent := scrTLList;
// frm.Align := alTop;
// frm.Width := 800;
// frm.Height := 350;

    pnl := TAdvPanel.Create(Self);
    pnl.Parent := scrTLList;
    pnl.Caption.CloseButton := True;
    pnl.Caption.Visible := True;
    pnl.Caption.Text := ADesignName + '历时过程线';
    pnl.CanSize := True;
    pnl.Align := alTop;
    pnl.Width := FDefaultTLWidth;
    pnl.Height := FDefaultTLHeight;
    pnl.FreeOnClose := True;
    pnl.Caption.MinMaxButton := True;
    pnl.PopupMenu := popSetDefaultTrendLineSize;

    IFD.ShowDataGraph(ADesignName, pnl);
// fra := TfraTrendLineShell.Create(pnl);
// fra.Parent := pnl;
// fra.Align := alClient;
// try
// Screen.Cursor := crHourGlass;
// fra.DrawLine(ADesignName);
// finally
// Screen.Cursor := crDefault;
// end;
        // frm.Show;
        // fraTrendLineShell1.DrawLine(ADesignName);
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : DblClickMeter
  Description: 根据当前功能页决定双击仪器后做什么
----------------------------------------------------------------------------- }
procedure TfrmTestSummary.DblClickMeter(ADesignName: string);
begin
    { 当用户在仪器列表中双击仪器时，若当前Page是观测数据，则显示被击仪器数据，若是过程线则显示过程线 }
  if pgcMain.ActivePageIndex = 1 then
    ShowMeterDatas(ADesignName)
  else
  begin
    ShowMeterTrendLine(ADesignName);
    pgcMain.ActivePageIndex := 2;
  end;
    { todo: 可增加的其他功能有：显示仪器档案卡；显示仪器各类属性及运行信息；显示仪器近期数据变化情况；
      若双击的是类型或部位则：显示该类别中所有仪器数据表 or 观测数据速览 or 全部过程线 or 特征值等等。
      利用双击事件提供快速访问功能，提高用户效率，改善用户体验 }
end;

{ -----------------------------------------------------------------------------
  Procedure  : PopupTrendLineWindow
  Description: 本方法弹出一个过程线窗口
----------------------------------------------------------------------------- }
procedure TfrmTestSummary.PopupTrendLineWindow(ADesignName: string);
var
  Meter: TMeterDefine;
  frm  : TForm;
    // fra  : TfraTrendLineShell;
begin
  IFD.PopupDataGraph(ADesignName);
// Meter := ExcelMeters.Meter[ADesignName];
// if Meter = nil then
// exit;
// frm := TForm.Create(Self);
// frm.BorderStyle := bsSizeToolWin;
// // frm.Parent := scrTLList;
// // frm.Align := altop;
// frm.Width := 800;
// frm.Height := 400;
// fra := TfraTrendLineShell.Create(frm);
// fra.Parent := frm;
// fra.Align := alClient;
// fra.DrawLine(ADesignName);
// frm.Show;
// frm.OnClose := Self.OnClose;
end;

end.
