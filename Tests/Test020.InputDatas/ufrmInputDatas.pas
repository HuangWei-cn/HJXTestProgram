unit ufrmInputDatas;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, System.Actions,
    Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, sSkinProvider, sSkinManager;

type
    TfrmMain = class(TForm)
        Panel1: TPanel;
        ToolBar1: TToolBar;
        tbtnOpenConfig: TToolButton;
        dlgOpenExcel: TOpenDialog;
        ActionManager1: TActionManager;
        actOpenConfig: TAction;
        Panel2: TPanel;
        actDoInput: TAction;
        ToolButton1: TToolButton;
        sSkinManager1: TsSkinManager;
        sSkinProvider1: TsSkinProvider;
        ToolButton2: TToolButton;
        actSelectTestBook: TAction;
        ToolButton3: TToolButton;
        tbtnSaveConfig: TToolButton;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure actOpenConfigExecute(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure actDoInputExecute(Sender: TObject);
        procedure actSelectTestBookExecute(Sender: TObject);
        procedure tbtnSaveConfigClick(Sender: TObject);
    private
        { Private declarations }
        FTestBook  : string;
        FConfigFile: String;
        procedure OnPopupTrendLine(ADesignName: string);
        procedure OnPopupDataViewer(ADesignName: string);
        procedure ReadIniFile;
        procedure SaveIniFile;
        procedure LoadConfig(AConfigFile: string);
    public
        { Public declarations }
    end;

var
    frmMain: TfrmMain;

implementation

uses
    uHJX.Intf.AppServices, uHJX.IntfImp.AppServices, uHJX.IntfImp.FuncCompManager,
    uHJX.Intf.FunctionDispatcher, uHJX.Classes.Meters,
    uHJX.Excel.InitParams, System.IniFiles,
    ufraMeterList, ufraInputDatas;
{$R *.dfm}


var
    fraMeterList: TfraMeterList;
    fraInput    : TfraInputDatas;

procedure TfrmMain.actDoInputExecute(Sender: TObject);
begin
    if fraInput = nil then
    begin
        fraInput := TfraInputDatas.Create(self);
        fraInput.Parent := Panel2;
        fraInput.Align := alClient;
        if FTestBook <> '' then
            fraInput.TestBook := FTestBook;
    end;

    // if not actOpenConfig.Enabled then
    fraInput.AddMeters;
end;

procedure TfrmMain.actOpenConfigExecute(Sender: TObject);
begin
    dlgOpenExcel.Title := '选择工程配置文件';
    if dlgOpenExcel.Execute then
    begin
        if LoadProjectConfig(dlgOpenExcel.FileName) then
        begin
            FConfigFile := dlgOpenExcel.FileName;
            LoadConfig(dlgOpenExcel.FileName);
            actOpenConfig.Enabled := False;
        end;
    end;
end;

procedure TfrmMain.actSelectTestBookExecute(Sender: TObject);
begin
    dlgOpenExcel.Title := '选择用于测试的数据工作簿';
    if dlgOpenExcel.Execute then
    begin
        FTestBook := dlgOpenExcel.FileName;
        ShowMessage(FTestBook);
        if fraInput <> nil then
            fraInput.TestBook := FTestBook;
    end;
end;

procedure TfrmMain.LoadConfig(AConfigFile: string);
begin
    if LoadProjectConfig(AConfigFile) then
    begin
        FuncCompManager.InitFuncComps;
            // ShowMessage('done.');
        if fraMeterList = nil then
        begin
            fraMeterList := TfraMeterList.Create(self);
            fraMeterList.Parent := Panel1;
            fraMeterList.Align := alClient;
            fraMeterList.Visible := True;
            fraMeterList.ShowMeters;
            fraMeterList.OnShowMeterTrendLine := OnPopupTrendLine;
            fraMeterList.OnShowMeterDatas := OnPopupDataViewer;
        end
        else
            fraMeterList.ShowMeters;
    end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    HJXAppServices.Host := self;
    HJXAppServices.SetApplication(Application);
        (*
        fraInput := TfraInputDatas.create(self);
            fraInput.Parent := Panel2;
            fraInput.Align := alTop;
            fraInput.Visible := True;
 *)
    HJXAppServices.setmeters(ExcelMeters);
    HJXAppServices.SetMeterGroups(MeterGroup);
    HJXAppServices.setdsnames(DSNames);
    FTestBook := '';
    ReadIniFile;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    //
end;

procedure TfrmMain.OnPopupTrendLine(ADesignName: string);
begin
    (IAppServices.FuncDispatcher as IFunctionDispatcher).PopupDataGraph(ADesignName, nil);
end;

procedure TfrmMain.tbtnSaveConfigClick(Sender: TObject);
begin
    SaveIniFile;
end;

procedure TfrmMain.OnPopupDataViewer(ADesignName: string);
begin
    (IAppServices.FuncDispatcher as IFunctionDispatcher).PopupDataViewer(ADesignName, nil);
end;

procedure TfrmMain.ReadIniFile;
var
    IniFile: TIniFile;
begin
    if not FileExists(ExtractFilePath(Application.ExeName) + 'cf.ini') then
        Exit;

    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'cf.ini');
    try
        FConfigFile := IniFile.ReadString('Project', 'ConfigFile', '');
        FTestBook := IniFile.ReadString('Data', 'TestBook', '');
    finally
        IniFile.Free;
    end;
    LoadConfig(FConfigFile);
end;

procedure TfrmMain.SaveIniFile;
var
    IniFile: TIniFile;
begin
    IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'cf.ini');
    try
        IniFile.WriteString('Project', 'ConfigFile', FConfigFile);
        IniFile.WriteString('Data', 'TestBook', FTestBook);
    finally
        IniFile.Free;
    end;
end;

end.
