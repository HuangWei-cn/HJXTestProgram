{ -----------------------------------------------------------------------------
 Unit Name: ufrmMain
 Author:    黄伟
 Date:      23-七月-2018
 Purpose:   本单元用于测试简单格式的过程线定义，及根据定义定制过程线TeeChart.
            主要解决的问题：1）根据定义设置Chart坐标轴格式，包括创建CustomAxis，
            可以创建任意多个CustomAxis；2）根据定义创建并设置LineSeries，同时
            调整CustomAxis的位置。

            在正式使用时，可以从本单元中将相应的方法移植到正式的功能单元中。
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
        { 重点属性，用于将CustomAxis与其名称对应起来，如LeftAxis[1]等等。 }
        FCustmAxes: TStrings;
        procedure PopupDataChart(ADesignName: string);
        procedure ShowDataChart(ADesignName: string);
        procedure DblClickMeter(ADesignName: string);
        { 重点方法，解析过程线定义 }
        procedure DecodePredefine;
        { 重点方法，释放Series，CustomAxis等 }
        procedure ReleaseSeries;
        { 重点方法，DecodePredefine方法调用本方法设置Chart }
        procedure SetupChart(Entry: string; SParam: string);
        { 重点方法，设置CustomAxis位置，调整ChartRect大小 }
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

    uTLDefineProc, // 测试一下预定义的解析情况

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
  Description: 本函数是可以移植到过程线绘制功能单元的，与frmMain.SetChart不同，
  后者是早期测试代码
----------------------------------------------------------------------------- }
procedure _SetupChart(AChart: TChart; TLD: TTrendlinePreDefine);
var
    i    : integer;
    ax   : TTLAxis;
    chtAx: TChartAxis;
begin
    AChart.MarginUnits := muPixels;

    { 这里需要处理一下ChartTitle中包含的占位符 }
    AChart.Title.Caption := TLD.ChartTitle;

    // 设置横轴
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
    // 设置横轴title: sub[0]在最下面，中间是sub【1】，最上面是bottomaxis
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

    // 设置竖轴
    for ax in TLD.VertAxis.Values do
    begin
        ax.ChartAxis := nil;
        // CustomAxis需要创建
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
        else // 其他的就是左轴和右轴了
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

// 添加测试用的LineSeries，用于测试预定义结果
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
  Description: 本代码可以移植到正式绘图单元中。本方法可以解释并绘制由过程线
  定义定制的过程线，无论单支还是成组皆可。基本上，只要有过程线定义的仪器，无需
  再区分仪器类型，用本方法就能按照用户要求绘制出过程线来。后期可增加更多的玩法，
  比如可以让仪器选择不同的定义，绘制不同的图形，可以允许用户在运行时临时修改定
  义以观看效果或满足某些需求，等等。目前只支持过程线，将来可扩展为支持环境量、
  矢量图、指定仪器过程线
-----------------------------------------------------------------------------}
procedure _AddMeterSeries(AChart: TChart; PreDef: TTrendlinePreDefine; AName: string);
var
    mt     : TMeterDefine;
    NewLine: TLineSeries;
    DS     : TClientDataSet;
    S      : string;
    iMT    : integer;
    Grp    : TMeterGroupItem;
    { 创建新的LineSeries，并根据定义设置其格式等属性 }
    procedure AddNewLine(ATLSeries: TTLSeries);
    begin
        NewLine := TLineSeries.Create(AChart);
        NewLine.Title := ATLSeries.Title;
        // 设置横轴
        NewLine.HorizAxis := aBottomAxis;
        NewLine.XValues.DateTime := True;
        NewLine.Color := AChart.GetFreeSeriesColor;
        NewLine.DrawStyle := dsCurve;
        // 设置纵轴
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
    { 将仪器DsnName的数据根据定义添加过程线。Index为仪器在组中的序号，基数1，单支为1 }
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
                    // 如果是指定设计编号，但不等于当前仪器编号，则下一个，这里暂时不考虑从预定义中
                    // 绘制指定编号的监测仪器
                    if tls.SourceName <> '*' then
                        if tls.SourceName <> AName then
                            Continue;
                    // 如果MeterIndex既不是适用于所有仪器的0，也不是本仪器的序号Index，则不能绘图
                    if tls.MeterIndex <> 0 then
                        if tls.MeterIndex <> index then
                            Continue;

                    // 现在考虑PDIndex问题。
                    S := 'PD' + IntToStr(tls.PDIndex);
                    for Fld in DS.Fields do
                        if Fld.FieldName = S then
                        begin
                            // 创建线对象
                            AddNewLine(tls);
                            // 处理Series.Title
                            if Pos('%name%', NewLine.Title) > 0 then
                                NewLine.Title := NewLine.Title.Replace('%name%', Fld.DisplayLabel)
                            else if Pos('%MeterName%', NewLine.Title) > 0 then
                                NewLine.Title := NewLine.Title.Replace('%MeterName%',
                                    DsnName);
                            // 下面填写数据
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
    // 对于单支仪器，只要定义中有Meter，就可以用了
    // 先处理ChartTitle
    if Pos('%Name%', AChart.Title.Caption) > 0 then
        AChart.Title.Caption := StringReplace(AChart.Title.Caption, '%Name%', AName, [rfReplaceAll])
    else if Pos('%GroupName%', AChart.Title.Caption) > 0 then
        if mt.PrjParams.GroupID <> '' then
            AChart.Title.Caption := StringReplace(AChart.Title.Caption, '%GroupName%',
                mt.PrjParams.GroupID, [rfReplaceAll]);
    // 提取仪器数据到DataSet中，然后再根据预定义进行处理
    DS := TClientDataSet.Create(nil);
    try
        // 判断是否仪器组，若是，则判断给定的预定义是否支持仪器组。如锚杆应力计有组设置，若定义是针对仪器组
        // 的，则进行组处理；若定义是针对单支仪器的，则仅处理本仪器即可
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
    UserInput := UpperCase(InputBox('输入监测仪器', '必须输入，否则去死', UserInput));
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
  Description: 解码预定义的过程线定义
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
            ShowMessage('不正确的设置：' + sLine);
    end;

begin
    ReleaseSeries;
    memDecode.Text := '';
    { 1.根据分号分解为各行；2. 对每行进行分解，冒号前的为定义项目；3.用竖线继续分解 }

    // 清除所有回车换行等字符
    S := Trim(memCode.Text);
    S := StringReplace(S, #13, '', [rfReplaceAll]);
    S := StringReplace(S, #10, '', [rfReplaceAll]);
    // 分解为字符串数组
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
    // 必须刷新Chart之后再设置坐标轴才能正确，因为CustomAxis必须画完之后其尺寸之类的才确定下来
    Chart1.Draw;
    PlaceAxes;
end;

procedure TfrmMain.ReleaseSeries;
var
    i: integer;
begin
    Chart1.FreeAllSeries;

    // 清除子坐标轴
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
        { 需要判断包含的替换代码是哪个：DesignName或Name, GroupName, EnvName，分别代表设计编号、
          设计编号、组名、环境量名 }
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
        { 格式为“<仪器序号>PD:num|数据名称|指定竖轴[num]”，其中仪器序号部分只对仪器组才出现。num指明
          是仪器的第几个PD。数据名称项可以直接指定内容，也可以指明是PD的名称或仪器的名称，如
          %name%或%MeterName%。竖轴项指明是左轴还是右轴，方括号内容为数字，0表示主轴，1表示第一个CustomAxis，
          2表示第二个CustomAxis，等等。

          需要判断是PD还是MD，且PD前还可能有组设置，如<Meter 1>, <Meter n>等，分别代表第一支仪器、
          所有仪器等等。对于指定仪器的组，形式可能为<Meter D12YBP>PD:1|....等，指明仪器编号，此时需要
          根据指定的仪器编号提取数据。除仪器外，还可以是环境量，比如<Env WaterLevel>PD，表明是库水位。 }
        NewLine := TLineSeries.Create(Chart1);
        // 这里需要判断Params[1]是否为%name%或%MeterName%，还是其他字符串，若为前两者，则需要替换
        NewLine.Title := Params[1];
        NewLine.HorizAxis := aBottomAxis;
        NewLine.XValues.DateTime := True;
        NewLine.Pointer.Visible := True;
        // 这里需要判断Pointer.Style是否是正方形，若是，则Size=2
        NewLine.Pointer.Size := 3;

        { 判断坐标轴---------- }
        // 取坐标轴序号
        i := Pos('[', Params[2]);
        j := Pos(']', Params[2]);
        S := Copy(Params[2], i + 1, j - i - 1);
        i := StrToInt(S);
        // 判断竖轴是哪个
        if Pos('LEFTAXIS', UpperCase(Params[2])) > 0 then
        begin
            if i = 0 then
                NewLine.VertAxis := aLeftAxis
            else
            begin
                NewLine.VertAxis := aCustomVertAxis;
                // 根据名字获得CustomAxis对象
                j := FCustmAxes.IndexOf(UpperCase(Params[2]));
                if j <> -1 then
                    NewLine.CustomVertAxis := TChartAxis(FCustmAxes.Objects[j]);
                // 增加错误判断，当没有找到过程线指定的坐标轴时，报错
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
                { todo:没有找到指定坐标轴时，报错 }
            end;
        end;
        // 在这里请求数据，并填充进去
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
    extraPos = 30; // 多个竖轴之间的间距
const
    extraMargin = 80; // 每个竖轴占据的宽度，每增加一个竖轴，ChartLeft或ChartRight减小这个值。
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
    { todo:为保险起见，这里最好再设置一遍Chart和各个坐标轴的PositionUnit }
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
                            // 下面的循环中，计入了主LeftAxis的Margin，故这里先行剔除，后面不再判断
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
