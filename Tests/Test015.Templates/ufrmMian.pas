{ 本程序用于测试模板单元的功能，以及测试编写的模板代码是否有效、按照所想的方式呈现效果。
    计划的主要功能如下：
    1、测试模板代码。可一边编写一边测试，使用真实仪器数据测试；
    2、测试已加入正是设置中的模板；
    3、测试模板新增功能等。
}
{ todo:为每种“创建新模板”编写助手，帮助用户按照既定规则创建模板 }
unit ufrmMian;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.WinXPanels, Vcl.ExtCtrls,
    Vcl.ButtonGroup, Vcl.ComCtrls, Vcl.Buttons, VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.TeeProcs,
    VclTee.Chart, sSkinProvider, sSkinManager, System.Actions, Vcl.ActnList, nExcel,
    Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Grids, Vcl.ToolWin, Vcl.CheckLst;

type
    TfrmMain = class(TForm)
        lblAnnotation: TLabel;
        Panel1: TPanel;
        Button1: TButton;
        Button2: TButton;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        TabSheet3: TTabSheet;
        Button3: TButton;
        dlgOpenWB: TOpenDialog;
        LabeledEdit1: TLabeledEdit;
        LabeledEdit2: TLabeledEdit;
        Label1: TLabel;
        mmWGTEditor: TMemo;
        Label2: TLabel;
        mmWGTResult: TMemo;
        btnNewWGT: TButton;
        btnParseWGT: TButton;
        btnTestWGT: TButton;
        btnTestWGT2Meter: TButton;
        Button4: TButton;
        Panel2: TPanel;
        mmCTEditor: TMemo;
        Label3: TLabel;
        Panel3: TPanel;
        Chart1: TChart;
        btnNewChartTemplate: TButton;
        Button6: TButton;
        Button7: TButton;
        Button8: TButton;
        CategoryPanelGroup1: TCategoryPanelGroup;
        CategoryPanel1: TCategoryPanel;
        CategoryPanel2: TCategoryPanel;
        tvwMeters: TTreeView;
        Panel4: TPanel;
        Panel5: TPanel;
        Panel6: TPanel;
        sSkinManager1: TsSkinManager;
        sSkinProvider1: TsSkinProvider;
        ActionManager1: TActionManager;
        actNewChartTemplate: TAction;
        actNewWebGridTemplate: TAction;
        Splitter1: TSplitter;
        tvwTemplates: TTreeView;
        grdXLTemplates: TStringGrid;
        ToolBar1: TToolBar;
        tbtnOpenXLTmpl: TToolButton;
        edtXLTmplName: TEdit;
        staTemplates: TStatusBar;
        TabSheet4: TTabSheet;
        chklstMeters: TCheckListBox;
        btnCreateXLSGrid: TButton;
        dlgSave: TSaveDialog;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure actNewChartTemplateExecute(Sender: TObject);
        procedure actNewWebGridTemplateExecute(Sender: TObject);
        procedure tvwMetersCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
        procedure FormCreate(Sender: TObject);
        procedure tbtnOpenXLTmplClick(Sender: TObject);
        procedure tvwMetersClick(Sender: TObject);
        procedure btnCreateXLSGridClick(Sender: TObject);
    private
        { Private declarations }
        procedure ListMeters;
        procedure ListTemplates;
        procedure Init;

        { 加载用户指定的Excel模板工作簿，列出其中的模板定义 }
        procedure LoadXLTmplDefines;
        { 从配置中加载模板列表 }
        procedure LoadTmplsFromConfig;
        { 根据模板创建Excel数据表 }
        procedure CreateExcelDataBook;
    public
        { Public declarations }
    end;

var
    frmMain: TfrmMain;

implementation

uses
    uhjx.intf.appservices, uhjx.Classes.Meters,
    uhjx.Classes.Templates, uhjx.Template.XLGridProc, uhjx.Template.WebGrid, uhjx.Template.XLGrid,
    uhjx.Excel.InitParams, uhjx.Excel.IO, uhjx.EnvironmentVariables,

    System.Win.ComObj;
{$R *.dfm}

const
    XLTGridHead = '序号|模板名称|仪器类型|仪器组|工作表|表类型|标题区|表头区|数据区|说明';

    NEWCT = 'ChartTitle:锚杆应力计%Name%测值过程线;'#13#10 + 'ChartType:过程线;'#13#10 + 'MeterType:锚杆应力计;'#13#10
        + 'Axis:Left|0|荷载(kN)|0.00;'#13#10 + 'Axis:Left|1|应力(MPa)|0.00;'#13#10 +
        'Axis:Right|0|温度(℃)|0.0;'#13#10 + 'Axis:Bottom|0|观测日期|yyyy-mm-dd;'#13#10 +
        'PD:1|荷载(kN)|LeftAxis[0];'#13#10 + 'PD:3|应力(MPa)|LeftAxis[1];'#13#10 +
        'PD:2|温度|RightAxis[0]'#13#10;

    NEWWG = 'Name:多点位移计观测数据表模板;'#13#10 + 'ApplyTo:Single;'#13#10 + 'MeterType:多点位移计;'#13#10 +
        'Title:多点位移计%DesignName%观测成果表;'#13#10 +
        'Head:设计编号|%DesignName%|%DesignName%|%DesignName%|%DesignName%|%DesignName%;'#13#10 +
        'Head:桩号|%Stake%|安装高程|%Elevation%|监测断面|%Profile%;'#13#10 +
        'Head:观测日期|区间位移(mm)|区间位移(mm)|区间位移(mm)|区间位移(mm)|备注;'#13#10 +
        'Head:观测日期|%PD1.Name%|%PD2.Name%|%PD3.Name%|%PD4.Name%|备注;'#13#10 +
        'DataRow:%DTScale%|%PD1%|%PD2%|%PD3%|%PD4%|%Annotation%;'#13#10;

type
    TmtNodeType = (ntCategory, ntMeter, ntPosition);

    TmtNode = class(TTreeNode)
    public
        NdType: TmtNodeType;
    end;

var
    Meters   : TMeterDefines;
    Templates: TTemplates;

function __IIF(V: Boolean; TrueStr, FalseStr: string): string;
begin
    if V then Result := TrueStr
    else Result := FalseStr;
end;

function __GridTypeStr(AType: TxlGridType): string;
begin
    case AType of
        xlgDynRow: Result := '动态行';
        xlgStatic: Result := '静态表';
        xlgDynCol: Result := '动态列';
    end;
end;

procedure TfrmMain.actNewChartTemplateExecute(Sender: TObject);
begin
    mmCTEditor.Clear;
    mmCTEditor.Lines.Text := NEWCT;
end;

procedure TfrmMain.actNewWebGridTemplateExecute(Sender: TObject);
begin
    mmWGTEditor.Clear;
    mmWGTEditor.Lines.Text := NEWWG;
end;

procedure TfrmMain.btnCreateXLSGridClick(Sender: TObject);
begin
    CreateExcelDataBook;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
    obj: Variant;
begin
    // obj :=CreateOleObject('Excel.Application');
    obj := CreateOleObject('ET.Application');
    obj.Visible := True;
    ShowMessage('Can you see Excel?');
    obj.Quit;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
    t : ThjxTemplate;
    ts: TTemplates;
    wg: TWebGridTemplate;
begin
// ts := IAppServices.Templates as TTemplates;
// t := ts.AddWGTemplate(TWebGridTemplate);
// ShowMessage(t.ClassName);
// t := ts.AddXLTemplate(txlgridtemplate);
// ShowMessage(t.ClassName);
// // t :=(iappservices.Templates as ttemplates).AddWGTemplate(twebgridtemplate);
// t := ts.AddWGTemplate(TWebGridTemplate);
// t.TemplateName := 'test';
// t.Category := tplwebgrid;
// t.MeterType := '渗压计';
//
// wg := (IAppServices.Templates as TTemplates).WebGridTemplate[1] as TWebGridTemplate;
// if wg = nil then ShowMessage('test faild')
// else
// begin
// ShowMessage(wg.TemplateName + ' ' + wg.MeterType);
// end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
    i : Integer;
    t : ThjxTemplate;
    ts: TTemplates;
begin
    if dlgOpenWB.Execute then
    begin
        LoadProjectConfig(dlgOpenWB.FileName);
        ListMeters;
        ListTemplates;
        ShowMessage('Load project completed.');
        ts := IAppServices.Templates as TTemplates;
        Meters := IAppServices.Meters as TMeterDefines;
        Templates := IAppServices.Templates as TTemplates;
{

            Memo1.Clear;
            Memo1.lines.Add(format('记载模板总数：%d；Chart：%d；WG：%d；XL：%d', [ts.Count, ts.ChartTemplateCount,
                        ts.WebGridTemplateCount, ts.XLSGridTemplateCount]));
            Memo1.lines.Add('============');
            for i := 0 to ts.ChartTemplateCount - 1 do
                    Memo1.lines.Add(ts.ChartTemplate[i].TemplateName);
            Memo1.lines.Add('------------');
            for i := 0 to ts.WebGridTemplateCount - 1 do
                    Memo1.lines.Add(ts.WebGridTemplate[i].TemplateName);
            Memo1.lines.Add('------------');
            for i := 0 to ts.XLSGridTemplateCount - 1 do
                    Memo1.lines.Add(ts.XLSGridTemplate[i].TemplateName);

}
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    Init;
end;

procedure TfrmMain.ListMeters;
var
    i               : Integer;
    mt              : TMeterDefine;
    typNode, mtrNode: TmtNode;
    S               : string;
begin
    tvwMeters.Items.Clear;
    chklstMeters.Clear;
    Excelmeters.SortByMeterType;
    S := '';
    for i := 0 to Excelmeters.Count - 1 do
    begin
        mt := Excelmeters.Items[i];
        chklstMeters.Items.add(mt.DesignName);
        if S <> mt.params.MeterType then
        begin
            S := mt.params.MeterType;
            typNode := tvwMeters.Items.add(nil, S) as TmtNode;
            typNode.NdType := ntCategory;
        end;
        mtrNode := tvwMeters.Items.AddChild(typNode, mt.DesignName) as TmtNode;
        mtrNode.NdType := ntMeter;
    end;
end;

procedure TfrmMain.tbtnOpenXLTmplClick(Sender: TObject);
begin
    dlgOpenWB.Title := '选择Excel表格模板文件';
    if dlgOpenWB.Execute then edtXLTmplName.Text := dlgOpenWB.FileName;
end;

procedure TfrmMain.tvwMetersClick(Sender: TObject);
var
    nd: TmtNode;
    mt: TMeterDefine;
begin
    if tvwMeters.selected = nil then Exit;
    nd := tvwMeters.selected as TmtNode;
    if nd.NdType = ntMeter then
    begin
        mt := Meters.meter[nd.Text];
        if mt = nil then Exit;

        with staTemplates, mt.datasheetstru do
        begin
            Panels[0].Text := mt.DesignName;
            Panels[1].Text := 'CT: ' + ChartTemplate;
            Panels[2].Text := 'WGT: ' + WGTemplate;
            Panels[3].Text := 'XLT: ' + XLTemplate;
        end;
    end;
end;

procedure TfrmMain.tvwMetersCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
begin
    NodeClass := TmtNode;
end;

procedure TfrmMain.ListTemplates;
var
    i      : Integer;
    ts     : TTemplates;
    typNode: TTreeNode;
begin
    ts := IAppServices.Templates as TTemplates;
    tvwTemplates.Items.Clear;
    typNode := tvwTemplates.Items.add(nil, 'ChartTemplates');
    for i := 0 to ts.ChartTemplateCount - 1 do
            tvwTemplates.Items.AddChild(typNode, ts.ChartTemplate[i].TemplateName);

    typNode := tvwTemplates.Items.add(nil, 'WebGridTemplates');
    for i := 0 to ts.WebGridTemplateCount - 1 do
            tvwTemplates.Items.AddChild(typNode, ts.WebGridTemplate[i].TemplateName);

    typNode := tvwTemplates.Items.add(nil, 'XLGridTemplates');
    for i := 0 to ts.XLSGridTemplateCount - 1 do
            tvwTemplates.Items.AddChild(typNode, ts.xlsgridtemplate[i].TemplateName);

    LoadTmplsFromConfig;
end;

procedure TfrmMain.Init;
begin
    // setup grdXLTemplates head
    // grdxltemplates.cells[0,0] := '序号';
    grdXLTemplates.Rows[0].Delimiter := '|';
    grdXLTemplates.Rows[0].DelimitedText := XLTGridHead;
    grdXLTemplates.Rows[0].StrictDelimiter := True;
end;

procedure TfrmMain.LoadXLTmplDefines;
var
    sht       : IXLSWorkSheet;
    wbk       : IXLSWorkBook;
    iRow, iCol: Integer;
    S         : string;
begin
    if not ExcelIO.OpenWorkbook(wbk, edtXLTmplName.Text) then
    begin
        ShowMessage('打开模板工作簿出错。');
        Exit;
    end;

    grdXLTemplates.RowCount := 2;
    grdXLTemplates.Rows[1].Text := '';

    sht := ExcelIO.GetSheet(wbk, '基本数据表模板');
    for iRow := 3 to sht.UsedRange.LastRow do
    begin
        // 名称
        S := Trim(VarToStr(sht.Cells[iRow, 2].Value));
        if S = '' then break;

        if (iRow - 1) > grdXLTemplates.RowCount then grdXLTemplates.RowCount := iRow - 1;

        grdXLTemplates.Cells[1, iRow - 2] := S;

        // meter type
        S := Trim(VarToStr(sht.Cells[iRow, 3].Value));
        grdXLTemplates.Cells[2, iRow - 2] := S;

        // group
        S := Trim(VarToStr(sht.Cells[iRow, 4].Value));
        grdXLTemplates.Cells[3, iRow - 2] := S;

        // template worksheet name
        S := Trim(VarToStr(sht.Cells[iRow, 5].Value));
        grdXLTemplates.Cells[4, iRow - 2] := S;

        // grid type
        S := Trim(VarToStr(sht.Cells[iRow, 6].Value));
        grdXLTemplates.Cells[5, iRow - 2] := S;

        // title range
        S := Trim(VarToStr(sht.Cells[iRow, 7].Value));
        grdXLTemplates.Cells[6, iRow - 2] := S;

        // head range
        S := Trim(VarToStr(sht.Cells[iRow, 8].Value));
        grdXLTemplates.Cells[7, iRow - 2] := S;

        // data range
        S := Trim(VarToStr(sht.Cells[iRow, 9].Value));
        grdXLTemplates.Cells[8, iRow - 2] := S;

        // annotation
        S := Trim(VarToStr(sht.Cells[iRow, 10].Value));
        grdXLTemplates.Cells[9, iRow - 2] := S;
    end;
end;

procedure TfrmMain.LoadTmplsFromConfig;
var
    ts: TTemplates;
    tp: TXLGridTemplate;
    i : Integer;
begin
    ts := IAppServices.Templates as TTemplates;
    grdXLTemplates.RowCount := ts.XLSGridTemplateCount + 1;
    for i := 0 to ts.XLSGridTemplateCount - 1 do
    begin
        tp := ts.xlsgridtemplate[i] as TXLGridTemplate;
        with grdXLTemplates do
        begin
            Rows[i + 1].Text := '';
            Cells[0, i + 1] := IntToStr(i + 1);
            Cells[1, i + 1] := tp.TemplateName;
            Cells[2, i + 1] := tp.MeterType;
            Cells[3, i + 1] := __IIF(tp.ApplyToGroup, '是', '否');
            Cells[4, i + 1] := tp.TemplateSheet;
            Cells[5, i + 1] := __GridTypeStr(tp.GridType);
            Cells[6, i + 1] := tp.TitleRangeRef;
            Cells[7, i + 1] := tp.HeadRangeRef;
            Cells[8, i + 1] := tp.DataRangeRef;
            Cells[9, i + 1] := tp.Annotation;
        end;
    end;
end;

procedure TfrmMain.CreateExcelDataBook;
var
    i, n: Integer;
    Strs: TStrings;
    mt  : TMeterDefine;
    tp  : TXLGridTemplate;
begin
    if ENV_XLTemplBook = '' then
    begin
        ShowMessage('没有提供模板文件，无法生成数据表');
        Exit;
    end;

    n := 0;
    for i := 0 to chklstMeters.Count - 1 do
        if chklstMeters.Checked[i] then inc(n);
    if n = 0 then
    begin
        ShowMessage('没有选择仪器。');
        Exit;
    end;

// 请用户先选择输出的报表文件
    if dlgSave.Execute then
    begin
        for i := 0 to chklstMeters.Count - 1 do
            if chklstMeters.Checked[i] then
            begin
                mt := Meters.meter[chklstMeters.Items[i]];
                if mt = nil then Continue;

                if mt.datasheetstru.XLTemplate = '' then Continue;
                tp := Templates.ItemByName[mt.datasheetstru.XLTemplate] as TXLGridTemplate;
                if tp = nil then Continue;

                GenXLGrid(tp, mt.DesignName, ENV_XLTemplBook, dlgSave.FileName);
                application.ProcessMessages;
            end;

        ShowMessage('I''m done.');
    end;
end;

end.
