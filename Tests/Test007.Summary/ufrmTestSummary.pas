{ -----------------------------------------------------------------------------
 Unit Name: ufrmTestSummary
 Author:    ��ΰ
 Date:      07-����-2018
 Purpose:   ��ȫ������ݴ���������
 History:
    2018-06-07 ��ӿڻ�����һ��������Frame��Ϊ����ʱ������
----------------------------------------------------------------------------- }
unit ufrmTestSummary;

{ todo:���ơ����ԡ����ܣ������������֮����ʾ��ǰ�������õĻ������ }
{ DONE:���ϲ�����������б���һ���������ù�����ȡ������򿪸��������ļ� }
{ todo:�����ʾ�����۲����ݵĹ��� }
{ DONE:����˫��������ʾ�����ߵĹ��� }
{ DONE:��������ֵ��ȡ���� }
{ todo:����һ�������ն˴��ڣ������������ʾ��Ӧ�Ĺ��ܣ�like hack..mmm }

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
      FDefaultTLHeight: integer; // ȱʡ�����ߴ��ڿ�͸�
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
        // ����һ�������ߴ���
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

// ���������ļ��б�
procedure TfrmTestSummary.actConnectDatabaseExecute(Sender: TObject);
begin
    // ��������ʱ���룬����ʹ�����ݷ��ʶ�������������ݿ⡣
  IAppServices.OpenDatabaseManager;
    (*
    if dlgOpen.Execute then
    begin
        FfraMeterList.tvwMeters.Items.Clear;
        { todo:����������ؽ�����жϡ���ͨ���¼�������������������Ϻ�Ӧ�ý��еĶ��� }
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
  dlgOpen.Title := '�򿪼�����������ļ��б��幤����';
  if dlgOpen.Execute then
  begin
    try
      wbk := TXLSWorkbook.Create;
      wbk.Open(dlgOpen.FileName);
      if LoadDataFileList(wbk) then
      begin
        FDataFileListLoaded := True;
        ShowMessage('�����ļ��б�������');
      end;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
  if FParamLoaded and FDataFileListLoaded then
    FfraMeterList.ShowMeters;
end;
{ ���ز����� }

procedure TfrmTestSummary.actLoadParamsExecute(Sender: TObject);
var
  wbk: IXLSWorkBook;
begin
    // ѡ��Ҫ�򿪵��ļ�
  dlgOpen.Title := '�򿪼���������Թ�����';
  if dlgOpen.Execute then
  begin
    try
      wbk := TXLSWorkbook.Create;
      wbk.Open(dlgOpen.FileName);
            // ShowMessage(wbk.ActiveSheet.Name);
      if LoadParams(wbk) = True then
      begin
        FParamLoaded := True;
        ShowMessage('�����������ϣ�');
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
  Description: ��һ�����ܱ��壬�������ܱ�������
  ----------------------------------------------------------------------------- }
procedure TfrmTestSummary.actLoadSummaryDefineExecute(Sender: TObject);
var
  sFile: string;
begin
    //
  dlgOpen.Title := '�򿪻��ܱ�Ԥ���幤����';
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
  fraXLSParamEditor1.vleMeterParams.ItemProps['��������'].PickList := PG_MeterTypes;
  fraXLSParamEditor1.vlePrjParams.ItemProps['���̲�λ'].PickList := pg_locations;
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
  HJXAppServices.SetApplication(Application); // ����ȫ��Application����
  HJXAppServices.AppProcessMessages := Application.ProcessMessages;
    // ע����FormĿǰ��δ����IHost�ӿڣ�Ҳδ����IHost�ӿڽ��и��졣������ʱ������Ϊ����������Ԫ�ṩ
    // һ��Owner��Mainform��
  HJXAppServices.Host := Self;

  Self.pgcMain.ActivePage := tabBaseParams;
  FParamLoaded := False;
  FDataFileListLoaded := False;
  FfraMeterList := TfraMeterList.Create(Self);
  FfraMeterList.Parent := pnlLeftPanel;
  FfraMeterList.Align := alClient;
  ENV_ExePath := ExtractFilePath(Application.ExeName);

    // �������ݷ��ʽӿڵ�ʵ��
    { DONE:��FuncCompManagerע��ClientDataFunc }
    // IHJXClientFuncs := ThjxDataQuery.Create; //2018-06-07 ����uHJX.Excel.DataQuery��Ԫ�Լ�ע����

    // ָ�������¼���Ӧ������������ʱ�����������ù��ܵ��ȵ�Ԫʵ��
  FfraMeterList.OnShowMeterDatas := Self.ShowMeterDatas;
  FfraMeterList.OnShowMeterTrendLine := Self.ShowMeterTrendLine;
  FfraMeterList.OnDblClickMeter := Self.DblClickMeter;

    // ����ֵFrame
  FEigenValue := TfraEigenvalueWeb.Create(Self);
  FEigenValue.Parent := tabEigenValue;
  FEigenValue.Align := alClient;
    // �ֲ�ͼ
  FDataLayout := TfraDataPresentation.Create(Self);
  with FDataLayout do
  begin
    Parent := tabDataLayout;
    Align := alClient;
  end;
    // ���ܱ�
  FSummary := TfraXLSSummaryMeker.Create(Self);
  FSummary.Parent := tabSummary;
  FSummary.Align := alClient;
    // ���ݱ���
  FDataRpt := TfraRptDataHTMLGrid.Create(Self);
  FDataRpt.Parent := tabDataReport;
  FDataRpt.Align := alClient;
    // ��������
  FQuickViewer := TfraQuickViewer.Create(Self);
  FQuickViewer.Parent := tabQuickView;
  FQuickViewer.Align := alClient;

    // ����ȱʡ�Ĺ����߿�͸�
  FDefaultTLWidth := 800;
  FDefaultTLHeight := 350;

    // ��ʼ��ע��
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
  Description: ����ȱʡ�����ߴ��ڵĿ�Ⱥ͸߶�
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
  Description: ��ʾ��������
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
    pnl.Caption.Text := ADesignName + '��ʱ������';
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
  Description: ���ݵ�ǰ����ҳ����˫����������ʲô
----------------------------------------------------------------------------- }
procedure TfrmTestSummary.DblClickMeter(ADesignName: string);
begin
    { ���û��������б���˫������ʱ������ǰPage�ǹ۲����ݣ�����ʾ�����������ݣ����ǹ���������ʾ������ }
  if pgcMain.ActivePageIndex = 1 then
    ShowMeterDatas(ADesignName)
  else
  begin
    ShowMeterTrendLine(ADesignName);
    pgcMain.ActivePageIndex := 2;
  end;
    { todo: �����ӵ����������У���ʾ��������������ʾ�����������Լ�������Ϣ����ʾ�����������ݱ仯�����
      ��˫���������ͻ�λ����ʾ������������������ݱ� or �۲��������� or ȫ�������� or ����ֵ�ȵȡ�
      ����˫���¼��ṩ���ٷ��ʹ��ܣ�����û�Ч�ʣ������û����� }
end;

{ -----------------------------------------------------------------------------
  Procedure  : PopupTrendLineWindow
  Description: ����������һ�������ߴ���
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
