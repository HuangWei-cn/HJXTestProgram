{ -----------------------------------------------------------------------------
 Unit Name: ufrmMain
 Author:    ��ΰ
 Date:      23-����-2018
 Purpose:   ����Ԫ���ڲ��Լ򵥸�ʽ�Ĺ����߶��壬�����ݶ��嶨�ƹ�����TeeChart.
            ��Ҫ��������⣺1�����ݶ�������Chart�������ʽ����������CustomAxis��
            ���Դ���������CustomAxis��2�����ݶ��崴��������LineSeries��ͬʱ
            ����CustomAxis��λ�á�

            ����ʽʹ��ʱ�����Դӱ���Ԫ�н���Ӧ�ķ�����ֲ����ʽ�Ĺ��ܵ�Ԫ�С�
 History:
----------------------------------------------------------------------------- }

unit ufrmMain;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Menus, Vcl.ExtCtrls,
    uHJX.Intf.AppServices, ufraMeterList, VclTee.TeeGDIPlus, Vcl.StdCtrls, VclTee.TeEngine,
    VclTee.TeeProcs, VclTee.Chart, VclTee.Series, VclTee.ArrowCha, VclTee.TeeTools;

type
    TfrmMain = class(TForm)
        MainMenu1: TMainMenu;
        pnlLeftFunc: TPanel;
        miSystem: TMenuItem;
        miSYS_Connect: TMenuItem;
        StatusBar1: TStatusBar;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        dlgOpen: TOpenDialog;
        Chart1: TChart;
        Splitter1: TSplitter;
        Panel1: TPanel;
        memCode: TMemo;
        Button1: TButton;
        Panel2: TPanel;
        Panel3: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        memDecode: TMemo;
        Series1: TFastLineSeries;
        Series2: TLineSeries;
        ChartTool1: TAxisScrollTool;
        ChartTool2: TAxisScrollTool;
        ChartTool3: TAxisScrollTool;
        Series3: TLineSeries;
        Series4: TLineSeries;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        Button2: TButton;
        procedure miSYS_ConnectClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Button1Click(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        { Private declarations }
        FMeterList: TfraMeterList;
        { �ص����ԣ����ڽ�CustomAxis�������ƶ�Ӧ��������LeftAxis[1]�ȵȡ� }
        FCustmAxes: TStrings;
        procedure PopupDataChart(ADesignName: string);
        procedure ShowDataChart(ADesignName: string);
        procedure DblClickMeter(ADesignName: string);
        { �ص㷽�������������߶��� }
        procedure DecodePredefine;
        { �ص㷽�����ͷ�Series��CustomAxis�� }
        procedure ReleaseSeries;
        { �ص㷽����DecodePredefine�������ñ���������Chart }
        procedure SetupChart(Entry: string; SParam: string);
        { �ص㷽��������CustomAxisλ�ã�����ChartRect��С }
        procedure PlaceAxes();
    public
        { Public declarations }
    end;

var
    frmMain: TfrmMain;

implementation

uses
    uHJX.IntfImp.AppServices, uHJX.IntfImp.FuncCompManager, uHJX.Intf.FunctionDispatcher,
    uHJX.Intf.Datas, uHJX.Excel.DataQuery, uHJX.Excel.InitParams, uHJX.Classes.Meters,
    uHJX.EnvironmentVariables,

    uTLDefineProc, // ����һ��Ԥ����Ľ������

    System.StrUtils, System.Types,
    VclTee.EditChar,
    Data.DB,
    Datasnap.DBClient;
// , uHJX.Excel.Meters;
{$R *.dfm}


var
    IFD      : IFunctionDispatcher;
    PreDefine: TTrendlinePreDefine;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin //
    HJXAppServices.SetApplication(Application);
    HJXAppServices.AppProcessMessages := Application.ProcessMessages;
    HJXAppServices.Host := Self;
    ENV_ExePath := ExtractFilePath(Application.ExeName);

    FuncCompManager.InitFuncComps;
    IFD := IAppServices.FuncDispatcher as IFunctionDispatcher;

    FMeterList := TfraMeterList.Create(Self);
    FMeterList.Parent := pnlLeftFunc;
    FMeterList.Align := alClient;
    FMeterList.OnShowMeterTrendLine := Self.ShowDataChart; // Self.PopupDataChart;
    FMeterList.OnDblClickMeter := Self.DblClickMeter;

    FCustmAxes := TStringList.Create;

    Chart1.Series[0].FillSampleValues(5000);
    Chart1.Series[1].FillSampleValues(5000);
    Chart1.MarginUnits := muPixels;
    Chart1.LeftAxis.PositionUnits := muPixels;
    Chart1.RightAxis.PositionUnits := muPixels;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    FCustmAxes.Free;
end;

procedure TfrmMain.miSYS_ConnectClick(Sender: TObject);
begin
    //
    if dlgOpen.Execute then
    begin
        FMeterList.tvwMeters.Items.Clear;
        LoadProjectConfig(dlgOpen.FileName);
        if ExcelMeters.Count > 0 then
            FMeterList.ShowMeters;
    end;
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
    EditChart(nil, Chart1);
end;

procedure TfrmMain.PopupDataChart(ADesignName: string);
begin
    IFD.PopupDataGraph(ADesignName);
end;

{ -----------------------------------------------------------------------------
  Procedure  : _SetupChart
  Description: �������ǿ�����ֲ�������߻��ƹ��ܵ�Ԫ�ģ���frmMain.SetChart��ͬ��
  ���������ڲ��Դ���
----------------------------------------------------------------------------- }
procedure _SetupChart(AChart: TChart; TLD: TTrendlinePreDefine);
var
    i    : integer;
    ax   : TTLAxis;
    chtAx: TChartAxis;
begin
    AChart.MarginUnits := muPixels;

    { ������Ҫ����һ��ChartTitle�а�����ռλ�� }
    AChart.Title.Caption := TLD.ChartTitle;

    // ���ú���
    AChart.BottomAxis.DateTimeFormat := TLD.HoriAxis.Format;
    AChart.BottomAxis.Automatic := True;
    AChart.BottomAxis.SubAxes[0].Visible := false;
    AChart.BottomAxis.SubAxes[1].Visible := false;
    if TLD.HoriAxis.SubAxis1.Visible then
    begin
        AChart.BottomAxis.SubAxes[0].Visible := True;
        AChart.BottomAxis.SubAxes[0].DateTimeFormat := TLD.HoriAxis.SubAxis1.Format;
    end;
    if TLD.HoriAxis.SubAxis2.Visible then
    begin
        AChart.BottomAxis.SubAxes[1].Visible := True;
        AChart.BottomAxis.SubAxes[1].DateTimeFormat := TLD.HoriAxis.SubAxis2.Format;
    end;
    // ���ú���title: sub[0]�������棬�м���sub��1������������bottomaxis
    if AChart.BottomAxis.SubAxes[0].Visible then
    begin
        AChart.BottomAxis.SubAxes[0].Title.Caption := TLD.HoriAxis.Title;
        AChart.BottomAxis.SubAxes[1].Title.Caption := '';
        AChart.BottomAxis.Title.Caption := '';
    end
    else if AChart.BottomAxis.SubAxes[1].Visible then
    begin
        AChart.BottomAxis.Title.Caption := '';
        AChart.BottomAxis.SubAxes[1].Title.Caption := TLD.HoriAxis.Title;
    end
    else
        AChart.BottomAxis.Title.Caption := TLD.HoriAxis.Title;

    // ��������
    for ax in TLD.VertAxis.Values do
    begin
        ax.ChartAxis := nil;
        // CustomAxis��Ҫ����
        if ax.AxisType = axCustom then
        begin
            chtAx := AChart.CustomAxes.Add;
            chtAx.Automatic := True;
            chtAx.Horizontal := false;
            chtAx.OtherSide := not ax.LeftSide;
            chtAx.AxisValuesFormat := ax.Format;
            chtAx.Title.Caption := ax.Title;
            ax.ChartAxis := chtAx;
        end
        else // �����ľ��������������
        begin
            if ax.LeftSide then
                chtAx := AChart.LeftAxis
            else
                chtAx := AChart.RightAxis;
            chtAx.Title.Caption := ax.Title;
            chtAx.AxisValuesFormat := ax.Format;
            chtAx.Automatic := True;
            ax.ChartAxis := chtAx;
        end;
    end;

    for i := 0 to AChart.Axes.Count - 1 do
        AChart.Axes.Items[i].PositionUnits := muPixels;
end;

// ��Ӳ����õ�LineSeries�����ڲ���Ԥ������
procedure _AddTestSeries(AChart: TChart; TLD: TTrendlinePreDefine);
var
    NewLine: TLineSeries;
    tlss   : TTLSeries;
begin
    for tlss in TLD.Series do
    begin
        NewLine := TLineSeries.Create(AChart);
        NewLine.HorizAxis := aBottomAxis;
        NewLine.XValues.DateTime := True;
        NewLine.Title := tlss.Title;
        NewLine.Color := AChart.GetFreeSeriesColor;

        if tlss.VertAxis.AxisType = axLeft then
            NewLine.VertAxis := aLeftAxis
        else if tlss.VertAxis.AxisType = axRight then
            NewLine.VertAxis := aRightAxis
        else
        begin
            NewLine.VertAxis := aCustomVertAxis;
            NewLine.CustomVertAxis := tlss.VertAxis.ChartAxis as TChartAxis;
            // if tlss.VerAxis.LeftSide then
            // NewLine.CustomVertAxis
        end;

        NewLine.FillSampleValues(500);
        AChart.AddSeries(NewLine);
        NewLine.Pointer.Visible := True;
        if AChart.SeriesCount = 1 then
            NewLine.Pointer.Size := 2
        else
            NewLine.Pointer.Size := 3;
        NewLine.Pointer.Style := TSeriesPointerStyle(AChart.SeriesCount - 1);
    end;
end;

{-----------------------------------------------------------------------------
  Procedure  : _AddMeterSeries
  Description: �����������ֲ����ʽ��ͼ��Ԫ�С����������Խ��Ͳ������ɹ�����
  ���嶨�ƵĹ����ߣ����۵�֧���ǳ���Կɡ������ϣ�ֻҪ�й����߶��������������
  �������������ͣ��ñ��������ܰ����û�Ҫ����Ƴ��������������ڿ����Ӹ�����淨��
  �������������ѡ��ͬ�Ķ��壬���Ʋ�ͬ��ͼ�Σ����������û�������ʱ��ʱ�޸Ķ�
  ���Թۿ�Ч��������ĳЩ���󣬵ȵȡ�Ŀǰֻ֧�ֹ����ߣ���������չΪ֧�ֻ�������
  ʸ��ͼ��ָ������������
-----------------------------------------------------------------------------}
procedure _AddMeterSeries(AChart: TChart; PreDef: TTrendlinePreDefine; AName: string);
var
    mt     : TMeterDefine;
    NewLine: TLineSeries;
    DS     : TClientDataSet;
    S      : string;
    iMT    : integer;
    Grp    : TMeterGroupItem;
    { �����µ�LineSeries�������ݶ����������ʽ������ }
    procedure AddNewLine(ATLSeries: TTLSeries);
    begin
        NewLine := TLineSeries.Create(AChart);
        NewLine.Title := ATLSeries.Title;
        // ���ú���
        NewLine.HorizAxis := aBottomAxis;
        NewLine.XValues.DateTime := True;
        NewLine.Color := AChart.GetFreeSeriesColor;
        NewLine.DrawStyle := dsCurve;
        // ��������
        if ATLSeries.VertAxis.AxisType = axLeft then
            NewLine.VertAxis := aLeftAxis
        else if ATLSeries.VertAxis.AxisType = axRight then
            NewLine.VertAxis := aRightAxis
        else
        begin
            NewLine.VertAxis := aCustomVertAxis;
            NewLine.CustomVertAxis := ATLSeries.VertAxis.ChartAxis as TChartAxis;
        end;
    end;
    { ������DsnName�����ݸ��ݶ�����ӹ����ߡ�IndexΪ���������е���ţ�����1����֧Ϊ1 }
    procedure SetMeterLines(DsnName: string; Index: integer = 1);
    var
        tls: TTLSeries;
        Fld: TField;
    begin
        if IAppServices.ClientDatas.GetAllPDDatas(DsnName, DS) then
            if DS.RecordCount > 0 then
                for tls in PreDef.Series do
                begin
                    if tls.SourceType = pdsEnv then
                        Continue;
                    // �����ָ����Ʊ�ţ��������ڵ�ǰ������ţ�����һ����������ʱ�����Ǵ�Ԥ������
                    // ����ָ����ŵļ������
                    if tls.SourceName <> '*' then
                        if tls.SourceName <> AName then
                            Continue;
                    // ���MeterIndex�Ȳ�������������������0��Ҳ���Ǳ����������Index�����ܻ�ͼ
                    if tls.MeterIndex <> 0 then
                        if tls.MeterIndex <> index then
                            Continue;

                    // ���ڿ���PDIndex���⡣
                    S := 'PD' + IntToStr(tls.PDIndex);
                    for Fld in DS.Fields do
                        if Fld.FieldName = S then
                        begin
                            // �����߶���
                            AddNewLine(tls);
                            // ����Series.Title
                            if Pos('%name%', NewLine.Title) > 0 then
                                NewLine.Title := NewLine.Title.Replace('%name%', Fld.DisplayLabel)
                            else if Pos('%MeterName%', NewLine.Title) > 0 then
                                NewLine.Title := NewLine.Title.Replace('%MeterName%',
                                    DsnName);
                            // ������д����
                            DS.First;
                            repeat
                                NewLine.AddXY(DS.Fields[0].AsDateTime, Fld.AsFloat);
                                DS.next;
                            until DS.Eof;

                            AChart.AddSeries(NewLine);
                            NewLine.Pointer.Visible := True;
                            NewLine.Pointer.Style := TSeriesPointerStyle(AChart.SeriesCount - 1);
                            if AChart.SeriesCount = 1 then
                                NewLine.Pointer.Size := 2
                            else
                                NewLine.Pointer.Size := 3;

                            Break;
                        end;

                end;
    end;

begin
    mt := ExcelMeters.Meter[AName];
    if mt = nil then
    begin
        Exit;
    end;

    _SetupChart(AChart, PreDef);
    // ���ڵ�֧������ֻҪ��������Meter���Ϳ�������
    // �ȴ���ChartTitle
    if Pos('%Name%', AChart.Title.Caption) > 0 then
        AChart.Title.Caption := StringReplace(AChart.Title.Caption, '%Name%', AName, [rfReplaceAll])
    else if Pos('%GroupName%', AChart.Title.Caption) > 0 then
        if mt.PrjParams.GroupID <> '' then
            AChart.Title.Caption := StringReplace(AChart.Title.Caption, '%GroupName%',
                mt.PrjParams.GroupID, [rfReplaceAll]);
    // ��ȡ�������ݵ�DataSet�У�Ȼ���ٸ���Ԥ������д���
    DS := TClientDataSet.Create(nil);
    try
        // �ж��Ƿ������飬���ǣ����жϸ�����Ԥ�����Ƿ�֧�������顣��ê��Ӧ�����������ã������������������
        // �ģ�������鴦������������Ե�֧�����ģ����������������
        if mt.PrjParams.GroupID = '' then
            SetMeterLines(AName, 1)
        else if PreDef.ApplyToGroup then
        begin
            Grp := MeterGroup.ItemByName[mt.PrjParams.GroupID];
            if Grp = nil then
                SetMeterLines(AName, 1)
            else
                for iMT := 0 to Grp.Count - 1 do
                    SetMeterLines(Grp.Items[iMT], iMT + 1);
        end
        else
            SetMeterLines(AName, 1);
    finally
        DS.Free;
    end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
    tlpd: TTrendlinePreDefine;
begin
    tlpd := TTrendlinePreDefine.Create;
    try
        tlpd.DecodeDefine(Self.memCode.Text);
        ReleaseSeries;

        _SetupChart(Self.Chart1, tlpd);
        _AddTestSeries(Chart1, tlpd);
        Chart1.Draw;
        PlaceAxes;

    finally
        tlpd.Free;
    end;
end;

var
    UserInput: string;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
    ReleaseSeries;
    PreDefine.DecodeDefine(memCode.Text);
    UserInput := UpperCase(InputBox('����������', '�������룬����ȥ��', UserInput));
    _AddMeterSeries(Chart1, PreDefine, UserInput);
    Chart1.Draw;
    PlaceAxes;
end;

procedure TfrmMain.ShowDataChart(ADesignName: string);
var
    mt: TMeterDefine;
begin
    ReleaseSeries;
    mt := ExcelMeters.Meter[ADesignName];
    if mt = nil then
        Exit;
    if mt.ChartPreDef = nil then
        Self.PopupDataChart(ADesignName)
    else
    begin
        _AddMeterSeries(Chart1, mt.ChartPreDef as TTrendlinePreDefine, ADesignName);
        Chart1.Draw;
        PlaceAxes;
    end;
end;

procedure TfrmMain.DblClickMeter(ADesignName: string);
begin
    IFD.PopupDataGraph(ADesignName);
end;

{ -----------------------------------------------------------------------------
  Procedure  : DecodePredefine
  Description: ����Ԥ����Ĺ����߶���
----------------------------------------------------------------------------- }
procedure TfrmMain.DecodePredefine;
var
    S : String;
    sa: TArray<string>;
    i : integer;

    procedure DecodeLine(sLine: String);
    var
        sEntry: string;
        SParam: String;
        Params: TArray<string>;
        ii    : integer;
    begin
        memDecode.Lines.Add('----');
        ii := Pos(':', sLine);
        if ii > 0 then
        begin
            sEntry := Copy(sLine, 0, ii - 1);
            SParam := Copy(sLine, ii + 1, Length(sLine) - ii);
            Params := SParam.Split(['|']);
            memDecode.Lines.Add('Entry:' + sEntry);
            memDecode.Lines.Add('Param String:' + SParam);
            for ii := Low(Params) to High(Params) do
                memDecode.Lines.Add('Param value: ' + Params[ii]);
            SetupChart(sEntry, SParam);
            SetLength(Params, 0);
        end
        else
            ShowMessage('����ȷ�����ã�' + sLine);
    end;

begin
    ReleaseSeries;
    memDecode.Text := '';
    { 1.���ݷֺŷֽ�Ϊ���У�2. ��ÿ�н��зֽ⣬ð��ǰ��Ϊ������Ŀ��3.�����߼����ֽ� }

    // ������лس����е��ַ�
    S := Trim(memCode.Text);
    S := StringReplace(S, #13, '', [rfReplaceAll]);
    S := StringReplace(S, #10, '', [rfReplaceAll]);
    // �ֽ�Ϊ�ַ�������
    sa := S.Split([';']);
    // sa := SplitString(s,';');

    try
        for i := Low(sa) to High(sa) do
        begin
            S := sa[i];
            if S = '' then
                Continue;
            memDecode.Lines.Add(S);
            DecodeLine(S);
            memDecode.Lines.Add('==============');
            memDecode.Lines.Add('');
        end;
    finally
        SetLength(sa, 0);
    end;
    // ����ˢ��Chart֮�������������������ȷ����ΪCustomAxis���뻭��֮����ߴ�֮��Ĳ�ȷ������
    Chart1.Draw;
    PlaceAxes;
end;

procedure TfrmMain.ReleaseSeries;
var
    i: integer;
begin
    Chart1.FreeAllSeries;

    // �����������
    for i := Chart1.LeftAxis.SubAxes.Count - 1 downto 0 do
        Chart1.LeftAxis.SubAxes[i].Free;
    Chart1.LeftAxis.SubAxes.Clear;

    for i := Chart1.RightAxis.SubAxes.Count - 1 downto 0 do
        Chart1.RightAxis.SubAxes[i].Free;
    Chart1.RightAxis.SubAxes.Clear;

    for i := Chart1.CustomAxes.Count - 1 downto 0 do
        Chart1.CustomAxes[i].Free;
    Chart1.CustomAxes.Clear;

    FCustmAxes.Clear;
end;

procedure TfrmMain.SetupChart(Entry: string; SParam: string);
var
    Params   : TArray<string>;
    Axis     : TChartAxis;
    CustmAxis: TChartAxis;
    NewLine  : TLineSeries;
    S        : string;
    i, j     : integer;
    procedure AddCustmAxis;
    begin
        CustmAxis := Chart1.CustomAxes.Add;
        CustmAxis.Horizontal := Axis.Horizontal;
        CustmAxis.OtherSide := Axis.OtherSide;
        CustmAxis.Automatic := True;
        CustmAxis.Axis.Color := Chart1.GetFreeSeriesColor;
        CustmAxis.PositionUnits := muPixels;
        CustmAxis.Title.Caption := Params[2];
        CustmAxis.AxisValuesFormat := Params[3];
        FCustmAxes.AddObject(UpperCase(Params[0]) + 'AXIS[' + Params[1] + ']', CustmAxis);
        // ShowMessage(UpperCase(Params[0])+'AXIS['+params[1]+']');
    end;

begin
    Params := SParam.Split(['|']);
    if SameText(Entry, 'ChartTitle') then
    begin
        { ��Ҫ�жϰ������滻�������ĸ���DesignName��Name, GroupName, EnvName���ֱ������Ʊ�š�
          ��Ʊ�š��������������� }
        SParam := StringReplace(SParam, '%Name%', 'R03,R04', [rfReplaceAll]);
        Chart1.Title.Caption := SParam;
    end
    else if SameText(Entry, 'Axis') then
    begin
        if SameText(Params[0], 'Left') then
        begin
            Axis := Chart1.LeftAxis;
            if Params[1] = '0' then
            begin
                Axis.Title.Caption := Params[2];
                Axis.AxisValuesFormat := Params[3];
                Axis.Automatic := True;
            end
            else
                AddCustmAxis;
        end
        else if SameText(Params[0], 'right') then
        begin
            Axis := Chart1.RightAxis;
            if Params[1] = '0' then
            begin
                Axis.Title.Caption := Params[2];
                Axis.AxisValuesFormat := Params[3];
                Axis.Automatic := True;
            end
            else
                AddCustmAxis;
        end
        else if SameText(Params[0], 'bottom') then
        begin
            Axis := Chart1.BottomAxis;
            if Params[1] = '0' then
            begin
                // Axis.Title.Caption := Params[2];
                Axis.AxisValuesFormat := Params[3];
                Axis.Automatic := True;
            end
            else
                AddCustmAxis;
        end;
    end
    else if Pos('PD', UpperCase(Entry)) > 0 then
    begin
        { ��ʽΪ��<�������>PD:num|��������|ָ������[num]��������������Ų���ֻ��������ų��֡�numָ��
          �������ĵڼ���PD���������������ֱ��ָ�����ݣ�Ҳ����ָ����PD�����ƻ����������ƣ���
          %name%��%MeterName%��������ָ�������ỹ�����ᣬ����������Ϊ���֣�0��ʾ���ᣬ1��ʾ��һ��CustomAxis��
          2��ʾ�ڶ���CustomAxis���ȵȡ�

          ��Ҫ�ж���PD����MD����PDǰ�������������ã���<Meter 1>, <Meter n>�ȣ��ֱ�����һ֧������
          ���������ȵȡ�����ָ���������飬��ʽ����Ϊ<Meter D12YBP>PD:1|....�ȣ�ָ��������ţ���ʱ��Ҫ
          ����ָ�������������ȡ���ݡ��������⣬�������ǻ�����������<Env WaterLevel>PD�������ǿ�ˮλ�� }
        NewLine := TLineSeries.Create(Chart1);
        // ������Ҫ�ж�Params[1]�Ƿ�Ϊ%name%��%MeterName%�����������ַ�������Ϊǰ���ߣ�����Ҫ�滻
        NewLine.Title := Params[1];
        NewLine.HorizAxis := aBottomAxis;
        NewLine.XValues.DateTime := True;
        NewLine.Pointer.Visible := True;
        // ������Ҫ�ж�Pointer.Style�Ƿ��������Σ����ǣ���Size=2
        NewLine.Pointer.Size := 3;

        { �ж�������---------- }
        // ȡ���������
        i := Pos('[', Params[2]);
        j := Pos(']', Params[2]);
        S := Copy(Params[2], i + 1, j - i - 1);
        i := StrToInt(S);
        // �ж��������ĸ�
        if Pos('LEFTAXIS', UpperCase(Params[2])) > 0 then
        begin
            if i = 0 then
                NewLine.VertAxis := aLeftAxis
            else
            begin
                NewLine.VertAxis := aCustomVertAxis;
                // �������ֻ��CustomAxis����
                j := FCustmAxes.IndexOf(UpperCase(Params[2]));
                if j <> -1 then
                    NewLine.CustomVertAxis := TChartAxis(FCustmAxes.Objects[j]);
                // ���Ӵ����жϣ���û���ҵ�������ָ����������ʱ������
            end;
        end
        else
        begin
            if i = 0 then
                NewLine.VertAxis := aRightAxis
            else
            begin
                j := FCustmAxes.IndexOf(UpperCase(Params[2]));
                if j <> -1 then
                    NewLine.CustomVertAxis := TChartAxis(FCustmAxes.Objects[j]);
                { todo:û���ҵ�ָ��������ʱ������ }
            end;
        end;
        // �������������ݣ�������ȥ
        NewLine.FillSampleValues(500);

        Chart1.AddSeries(NewLine);
        if NewLine.CustomVertAxis <> nil then
        begin
            NewLine.CustomVertAxis.Automatic := True;
            NewLine.CustomVertAxis.AutomaticMaximum := True;
            NewLine.CustomVertAxis.AutomaticMinimum := True;
        end;
    end;
end;

procedure TfrmMain.PlaceAxes();
const
    extraPos = 30; // �������֮��ļ��
const
    extraMargin = 80; // ÿ������ռ�ݵĿ�ȣ�ÿ����һ�����ᣬChartLeft��ChartRight��С���ֵ��
var
    CAList               : TList;
    i                    : integer;
    CA                   : TChartAxis;
    NextXLeft, NextXRight: integer;
    MargLeft, MargRight  : integer;
begin
    NextXLeft := 0;
    NextXRight := 0;
    MargLeft := 5;
    MargRight := 5;
    { todo:Ϊ����������������������һ��Chart�͸����������PositionUnit }
    CAList := TList.Create;
    try
        for i := 0 to Chart1.SeriesList.Count - 1 do
            if Chart1[i].Active then
                case Chart1[i].VertAxis of
                    aLeftAxis:
                        begin
                            if CAList.IndexOf(Chart1.LeftAxis) = -1 then
                            begin
                                CAList.Add(Chart1.LeftAxis);
                            // �����ѭ���У���������LeftAxis��Margin�������������޳������治���ж�
                                MargLeft := MargLeft - extraMargin;
                            end;
                        end;
                    aRightAxis:
                        begin
                            if CAList.IndexOf(Chart1.RightAxis) = -1 then
                            begin
                                CAList.Add(Chart1.RightAxis);
                                MargRight := MargRight - extraMargin;
                            end;
                        end;
                    aCustomVertAxis:
                        begin
                            if Chart1[i].CustomVertAxis <> nil then
                                if CAList.IndexOf(Chart1[i].CustomVertAxis) = -1 then
                                    CAList.Add(Chart1[i].CustomVertAxis);
                        end;
                end;

        for i := 0 to CAList.Count - 1 do
        begin
            CA := TChartAxis(CAList[i]);
            if CA.OtherSide then
            begin
                CA.PositionPercent := NextXRight;
                NextXRight := NextXRight - CA.MaxLabelsWidth - CA.TickLength - extraPos;
                MargRight := MargRight + extraMargin;
            end
            else
            begin
                CA.PositionPercent := NextXLeft;
                NextXLeft := NextXLeft - CA.MaxLabelsWidth - CA.TickLength - extraPos;
                MargLeft := MargLeft + extraMargin;
            end;
        end;

        Chart1.MarginLeft := MargLeft;
        Chart1.MarginRight := MargRight;
    finally
        CAList.Free;
    end;
end;

initialization

PreDefine := TTrendlinePreDefine.Create;

finalization

if Assigned(PreDefine) then
    PreDefine.Free;

end.
