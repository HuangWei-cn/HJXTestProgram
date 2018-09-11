{ -----------------------------------------------------------------------------
  Unit Name: uHJX.Excel.DataQuery
  Author:    黄伟
  Date:      06-四月-2017
  Purpose:   数据查询单元-针对Excel数据源
  History:
  ----------------------------------------------------------------------------- }

unit uHJX.Excel.DataQuery;

interface

uses
    System.Classes, System.Types, System.SysUtils, System.Variants, System.StrUtils, Data.DB,
    Datasnap.DBClient, System.DateUtils, MidasLib,
    uHJX.Intf.Datas, uHJX.Excel.IO, uHJX.Data.Types;

type
    { 黄金峡数据查询对象： }
    ThjxDataQuery = class(TInterfacedObject, IClientFuncs)
    private
        FUseSession: Boolean;
    public
        destructor Destroy; override;
        { 启动会话 }
        { todo:实现启动会话后创建打开的工作簿池，当需要打开工作簿时先检查是否已经打开，若池中
          没有，才创建并打开新工作簿。工作簿池对于静态表类型较为有用，可以大幅度缩减提取数据的时间。 }
        procedure SessionBegin;
        procedure SessionEnd;
        { 取回指定监测仪器的最后一次监测数据 }
        function GetLastPDDatas(ADsnName: string; var Values: TDoubleDynArray): Boolean;
        { 取回指定时段内监测仪器的最后一次数据 }
        function GetLastPDDatasBeforeDate(ADsnName: string; DT: TDateTime;
            var Values: TDoubleDynArray): Boolean;
        { 取回最接近指定日期的观测数据 }
        function GetNearestPDDatas(ADsnName: String; DT: TDateTime; var Values: TDoubleDynArray;
            DTDelta: Integer = 0): Boolean;
        { 取回指定时段内监测仪器所有观测数据 }
        function GetPDDatasInPeriod(ADsnName: string; DT1, DT2: TDateTime; DS: TDataSet): Boolean;
        { 取回全部观测数据 }
        function GetAllPDDatas(ADsnName: string; DS: TDataSet): Boolean;
        { 取回当前特征值，这两个已弃用 }
        function GetEVData(ADsnName: String; EVData: PEVDataStru): Boolean; overload;
        function GetEVData(ADsnName: string; var EVDatas: TDoubleDynArray): Boolean; overload;
        { 取回仪器所有物理量的特征值 }
        function GetEVDatas(ADsnName: String; var EVDatas: PEVDataArray): Boolean;
        { 取回指定时段内的特征值 }
        function GetEVDataInPeriod(ADsnName: string; DT1, DT2: TDateTime;
            var EVDatas: TDoubleDynArray): Boolean;
        { 设置DataSet字段别名，对于Excel数据驱动，这个对应表存储在Excel参数文件中，初始化参数时
          已加载到uHJX.Excel.Meters单元的DSNames集合中 }
        procedure SetFieldDisplayName(DS:TDataSet);
    end;

implementation

uses
    uHJX.Excel.Meters, nExcel;

var
    SSWorkBook: IXLSWorkBook; // 会话期间使用的Workbook

    // 根据物理量定义创建字段表
procedure _CreateFieldsFromPDDefines(DS: TDataSet; APDDefines: TDataDefines);
var
    i : Integer;
    DF: TFieldDef;
begin
    TClientDataSet(DS).FieldDefs.Clear;
    TClientDataSet(DS).IndexDefs.Clear;

    DF             := DS.FieldDefs.AddFieldDef;
    DF.Name        := 'DTScale';
    DF.DataType    := ftDateTime;
    DF.DisplayName := '观测日期';
    for i          := 0 to APDDefines.Count - 1 do
    begin
        DF             := DS.FieldDefs.AddFieldDef;
        DF.Name        := 'PD' + IntToStr(i + 1);
        DF.DisplayName := APDDefines.Items[i].Name;
        DF.DataType    := ftFloat;
    end;
    TClientDataSet(DS).IndexDefs.Add('IndexDT', 'DTScale', []);
end;

procedure _SetFieldsDisplayName(DS: TDataSet; APDDefines: TDataDefines);
var
    i: Integer;
begin
    with DS as TClientDataSet do
    begin
        Fields[0].DisplayLabel := '观测日期';
        for i                  := 0 to APDDefines.Count - 1 do
        begin
            Fields[i + 1].DisplayLabel                     := APDDefines.Items[i].Name;
            (Fields[i + 1] as TNumericField).DisplayFormat := '0.00';
        end;
    end;
end;

destructor ThjxDataQuery.Destroy;
begin
    inherited;
end;

procedure ThjxDataQuery.SessionBegin;
begin
    FUseSession := True;
    SSWorkBook  := TmyWorkbook.Create;
end;

procedure ThjxDataQuery.SessionEnd;
begin
    SSWorkBook  := nil;
    FUseSession := False;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetLastPDDatas
  Description: 取回最后一次观测数据（物理量），返回结果数组为：日期、物理量
  数组，其中日期以双精度表示
  ----------------------------------------------------------------------------- }
function ThjxDataQuery.GetLastPDDatas(ADsnName: string; var Values: TDoubleDynArray): Boolean;
var
    Meter    : TMeterDefine;
    wbk      : IXLSWorkBook;
    sht      : IXLSWorkSheet;
    iCount, i: Integer;
    iRow     : Integer;
    S        : String;
begin
    Result := False;
    SetLength(Values, 0);
    Meter := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;

    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;

    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if TmyWorkbook(wbk).FullName <> Meter.DataBook then
        if not ExcelIO.OpenWorkbook(wbk, Meter.DataBook) then
            exit;

    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;

    iCount := Meter.PDDefines.Count + 1; // 物理量+观测日期
    SetLength(Values, iCount);
    Values[0] := 0; // 观测日期设置为0，若没有数据，则不填入，调用者通过观测日期是否为0判断是否有观测数据。

    // 下面开始倒序查找数据
    for iRow := sht.UsedRange.LastRow + 5 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        // 观测日期
        Values[0] := ExcelIO.GetDateTimeValue(sht, iRow, 1);
        // 各个物理量
        for i             := 0 to Meter.PDDefines.Count - 1 do
            Values[i + 1] := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(i));
        Break;
    end;
    Result := True;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetLastPDDatasInPeriod
  Description: 取回指定时段内最后一次观测数据
  ----------------------------------------------------------------------------- }
function ThjxDataQuery.GetLastPDDatasBeforeDate(ADsnName: string; DT: TDateTime;
    var Values: TDoubleDynArray): Boolean;
var
    Meter    : TMeterDefine;
    wbk      : IXLSWorkBook;
    sht      : IXLSWorkSheet;
    iCount, i: Integer;
    iRow     : Integer;
    S        : String;
    DT1      : TDateTime;
begin
    Result := False;
    SetLength(Values, 0);
    Meter := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;

    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;

    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if TmyWorkbook(wbk).FullName <> Meter.DataBook then
        if not ExcelIO.OpenWorkbook(wbk, Meter.DataBook) then
            exit;

    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;

    iCount := Meter.PDDefines.Count + 1; // 物理量+观测日期
    SetLength(Values, iCount);
    Values[0] := 0; // 观测日期设置为0，若没有数据，则不填入，调用者通过观测日期是否为0判断是否有观测数据。
    for iRow  := sht.UsedRange.LastRow + 1 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;

        if TryStrToDateTime(S, DT1) = False then
            Continue; // 如果时间字符串无效，跳过本条记录

        if DT1 > DT then
            Continue;

        Values[0]         := ExcelIO.GetDateTimeValue(sht, iRow, 1);
        for i             := 0 to Meter.PDDefines.Count - 1 do
            Values[i + 1] := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(i));
        Break;

    end;
    Result := True;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetNearestPDDatas
  Description: 取回最接近指定日期的观测数据，时间可前可后
  ----------------------------------------------------------------------------- }
function ThjxDataQuery.GetNearestPDDatas(ADsnName: string; DT: TDateTime;
    var Values: TDoubleDynArray;
    DTDelta: Integer = 0): Boolean;
var
    Meter       : TMeterDefine;
    wbk         : IXLSWorkBook;
    sht         : IXLSWorkSheet;
    iCount      : Integer;
    iRow, iLRow : Integer;
    S           : String;
    DT1         : TDateTime;
    dLast, dThis: double;

    procedure SetData(ARow: Integer);
    var
        ii: Integer;
    begin
        Values[0]          := ExcelIO.GetDateTimeValue(sht, ARow, 1);
        for ii             := 0 to Meter.PDDefines.Count - 1 do
            Values[ii + 1] := ExcelIO.GetFloatValue(sht, ARow, Meter.PDColumn(ii));
    end;

begin
    Result := False;
    SetLength(Values, 0);
    Meter := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;

    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;

    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if TmyWorkbook(wbk).FullName <> Meter.DataBook then
        if not ExcelIO.OpenWorkbook(wbk, Meter.DataBook) then
            exit;

    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;

    iCount := Meter.PDDefines.Count + 1; // 物理量+观测日期
    SetLength(Values, iCount);
    Values[0] := 0; // 观测日期设置为0，若没有数据，则不填入，调用者通过观测日期是否为0判断是否有观测数据。
    // 倒序查找
    dLast    := -1000;
    dThis    := 10000;
    iLRow    := 0;
    for iRow := sht.UsedRange.LastRow + 1 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;

        if TryStrToDateTime(S, DT1) = False then
            Continue; // 如果时间字符串无效，跳过本条记录

        if DT1 = DT then
        begin
            SetData(iRow);
            Break;
        end
        else if DT1 > DT then
            dThis := DaysBetween(DT1, DT)
        else if DT1 < DT then
            dThis := DaysBetween(DT, DT1)
        else if iRow = Meter.DataSheetStru.BaseLine then // 如果到第一行，就设置数据，之后就结束了
        begin
            SetData(iRow);
            Break;
        end;

        // 当dLast>0，说明已经查过一次了
        if dLast >= 0 then
            if dThis > dLast then // 说明走过了，上次最小
            begin
                if DTDelta = 0 then // 忽略超限
                begin
                    SetData(iLRow);
                    Break;
                end
                else if dLast > DTDelta then // 超限，不返回数据
                begin
                    Break;
                end
                else // 限内，且满足条件
                begin
                    SetData(iLRow);
                    Break;
                end;
            end;
        dLast := dThis;
        iLRow := iRow;
    end;
    Result := True;
end;

function ThjxDataQuery.GetPDDatasInPeriod(ADsnName: string; DT1: TDateTime; DT2: TDateTime;
    DS: TDataSet): Boolean;
var
    wbk    : IXLSWorkBook;
    sht    : IXLSWorkSheet;
    Meter  : TMeterDefine;
    S      : string;
    iRow, i: Integer;
    DT     : TDateTime;
begin
    Result := False;
    Meter  := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;
    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;

    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if ExcelIO.OpenWorkbook(wbk, Meter.DataBook) = False then
        exit;
    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;
    // 运行到这里，可以尝试创建DataSet、读取数据了
    // 如果DS为空，则创建之
    if DS = nil then
        DS := TClientDataSet.Create(nil)
    else
    begin
        if DS.Active then
            DS.Close;
        DS.FieldDefs.Clear;
    end;
    // 给DS中添加字段
    _CreateFieldsFromPDDefines(DS, Meter.PDDefines);
    { 这里要注意，尽量使用TClientDataset！！！ }
    TClientDataSet(DS).CreateDataSet;
    _SetFieldsDisplayName(DS, Meter.PDDefines);

    for iRow := Meter.DataSheetStru.BaseLine to sht.UsedRange.LastRow + 1 do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        if TryStrToDateTime(S, DT) = False then
            Continue;

        if DT > DT2 then
            Break;

        if DT >= DT1 then
        begin
            // ---------------------
            DS.Append;
            DS.Fields[0].value         := StrToDateTime(S);
            for i                      := 0 to Meter.PDDefines.Count - 1 do
                DS.Fields[i + 1].value := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(i));
            DS.Post;
        end;
    end;
    Result := True;
end;

function ThjxDataQuery.GetAllPDDatas(ADsnName: string; DS: TDataSet): Boolean;
var
    wbk    : IXLSWorkBook;
    sht    : IXLSWorkSheet;
    Meter  : TMeterDefine;
    S      : string;
    iRow, i: Integer;
begin
    Result := False;
    Meter  := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;
    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;

    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if ExcelIO.OpenWorkbook(wbk, Meter.DataBook) = False then
        exit;
    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;
    // 运行到这里，可以尝试创建DataSet、读取数据了
    // 如果DS为空，则创建之
    if DS = nil then
        DS := TClientDataSet.Create(nil)
    else
    begin
        if DS.Active then
            DS.Close;
        DS.FieldDefs.Clear;
    end;
    // 给DS中添加字段
    _CreateFieldsFromPDDefines(DS, Meter.PDDefines);
    { 这里要注意，尽量使用TClientDataset！！！ }
    TClientDataSet(DS).CreateDataSet;
    _SetFieldsDisplayName(DS, Meter.PDDefines);
    // 查询、添加数据
    for iRow := Meter.DataSheetStru.BaseLine to sht.UsedRange.LastRow + 2 do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        // ---------------------
        DS.Append;
        DS.Fields[0].value         := StrToDateTime(S);
        for i                      := 0 to Meter.PDDefines.Count - 1 do
            DS.Fields[i + 1].value := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(i));
        DS.Post;
    end;
    Result := True;
end;

type
    TevCheckDate = record
        theYear, theMon: Integer;
        dtYear1, dtYear2: TDateTime;
        dtMon1, dtMon2: TDateTime;
    end;

    { -----------------------------------------------------------------------------
      Procedure  : GetEVData
      Description: 查找当前特征值，时间为最后一次观测时间，目前只能查询PD1的特征值
      对于多点位移计也是如此。
      ----------------------------------------------------------------------------- }
function ThjxDataQuery.GetEVData(ADsnName: string; EVData: PEVDataStru): Boolean;
var
    Meter  : TMeterDefine;
    wbk    : IXLSWorkBook;
    sht    : IXLSWorkSheet;
    chkDate: TevCheckDate;
    iRow   : Integer;
    S      : String;
    PD1    : double;
    dtScale: TDateTime;

    procedure SetDate(DT: TDateTime);
    begin
        chkDate.theYear := YearOf(DT);
        chkDate.theMon  := MonthOf(DT);
        chkDate.dtYear1 := EncodeDate(chkDate.theYear, 1, 1);
        chkDate.dtYear2 := EndOfAYear(chkDate.theYear);
        chkDate.dtMon1  := EncodeDate(chkDate.theYear, chkDate.theMon, 1);
        chkDate.dtMon2  := EndOfAMonth(chkDate.theYear, chkDate.theMon);
    end;

begin
    Result := False;
    EVData.Init;
    chkDate.dtYear1 := 0;
    chkDate.dtMon1  := 0;
    Meter           := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;
    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;
    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if TmyWorkbook(wbk).FullName <> Meter.DataBook then
        if not ExcelIO.OpenWorkbook(wbk, Meter.DataBook) then
            exit;
    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;

    { set date for check }
    EVData.ID := Meter.DesignName;
    for iRow  := sht.UsedRange.LastRow + 2 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        if TryStrToDateTime(S, dtScale) = False then
            Continue;

        PD1 := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(0));

        { 判断是否设置了CheckDate，若无则设置之：此时遇到最后一条记录 }
        if chkDate.dtMon1 = 0 then
        begin
            SetDate(dtScale);
            { 当前值 }
            EVData.CurValue := PD1;
            EVData.CurDate  := dtScale;
        end;

        { LeftEV }
        EVData.LifeEV.CompareData(dtScale, PD1);

        { YearEV }
        if YearOf(dtScale) = chkDate.theYear then
        begin
            EVData.YearEV.CompareData(dtScale, PD1);
            { MonthEV }
            if MonthOf(dtScale) = chkDate.theMon then
                EVData.MonthEV.CompareData(dtScale, PD1);
        end;
    end;

    Result := True;
end;

function ThjxDataQuery.GetEVData(ADsnName: string; var EVDatas: TDoubleDynArray): Boolean;
var
    EVData: PEVDataStru;
begin
    Result := False;
    SetLength(EVDatas, 0);
    New(EVData);
    try
        Result := GetEVData(ADsnName, EVData);
        if Result then
        begin
            SetLength(EVDatas, 14);
            with EVData.LifeEV do
            begin
                EVDatas[0] := MaxValue;
                EVDatas[1] := MaxDate;
                EVDatas[2] := MinValue;
                EVDatas[3] := MinDate;
            end;
            with EVData.YearEV do
            begin
                EVDatas[4] := MaxValue;
                EVDatas[5] := MaxDate;
                EVDatas[6] := MinValue;
                EVDatas[7] := MinDate;
            end;
            with EVData.MonthEV do
            begin
                EVDatas[8]  := MaxValue;
                EVDatas[9]  := MaxDate;
                EVDatas[10] := MinValue;
                EVDatas[11] := MinDate;
            end;
            EVDatas[12] := EVData.CurValue;
            EVDatas[13] := EVData.CurDate;
        end;
    finally
        Dispose(EVData);
    end;
    Result := True;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetEVDatas
  Description: 本方法返回仪器所有具有特征值的物理量的特征值
  与GetEVData不同，GetEVData仅返回第一个物理量的特征值，本函数返回有特征值的
  物理量的特征值。有些仪器有多个物理量，比如多点位移计，每个测点都需要返回特
  征值，本方法一次性将这些测点的特征值全部取回。
  ----------------------------------------------------------------------------- }
function ThjxDataQuery.GetEVDatas(ADsnName: string; var EVDatas: PEVDataArray): Boolean;
var
    Meter  : TMeterDefine;
    i, n   : Integer;
    wbk    : IXLSWorkBook;
    sht    : IXLSWorkSheet;
    chkDate: TevCheckDate;
    iRow   : Integer;
    S      : String;
    dtScale: TDateTime;
    // 释放调用者提供的evdatas占用的内存，不同的仪器特征值数量不同
    procedure ReleaseEVDatas;
    var
        ii: Integer;
    begin
        if Length(EVDatas) > 0 then
            for ii := Low(EVDatas) to High(EVDatas) do
                try
                    Dispose(EVDatas[ii]);
                except
                end;
        SetLength(EVDatas, 0);
    end;
    procedure SetDate(DT: TDateTime);
    begin
        chkDate.theYear := YearOf(DT);
        chkDate.theMon  := MonthOf(DT);
        chkDate.dtYear1 := EncodeDate(chkDate.theYear, 1, 1);
        chkDate.dtYear2 := EndOfAYear(chkDate.theYear);
        chkDate.dtMon1  := EncodeDate(chkDate.theYear, chkDate.theMon, 1);
        chkDate.dtMon2  := EndOfAMonth(chkDate.theYear, chkDate.theMon);
    end;
    procedure FindEVData(iev: Integer);
    var
        D   : double;
        iCol: Integer;
    begin
        iCol := Meter.PDColumn(EVDatas[iev].PDIndex);
        D    := ExcelIO.GetFloatValue(sht, iRow, iCol);
        EVDatas[iev].LifeEV.CompareData(dtScale, D);
        if YearOf(dtScale) = chkDate.theYear then
        begin
            EVDatas[iev].YearEV.CompareData(dtScale, D);
            if MonthOf(dtScale) = chkDate.theMon then
                EVDatas[iev].MonthEV.CompareData(dtScale, D);
        end;
    end;

begin
    Result          := False;
    chkDate.theYear := 0;
    chkDate.theMon  := 0;
    // 必要的检查和初始化
    Meter := ExcelMeters.Meter[ADsnName];
    if Meter = nil then
        exit;

    if (Meter.DataBook = '') or (Meter.DataSheet = '') then
        exit;
    if FUseSession then
        wbk := SSWorkBook
    else
        wbk := TmyWorkbook.Create;

    if TmyWorkbook(wbk).FullName <> Meter.DataBook then
        if not ExcelIO.OpenWorkbook(wbk, Meter.DataBook) then
            exit;
    sht := ExcelIO.GetSheet(wbk, Meter.DataSheet);
    if sht = nil then
        exit;

    // 对EVDatas数组初始化，释放多余的内存
    ReleaseEVDatas;
    // 根据Meter具有特征值的物理量数量初始化EVDatas数组
    n     := 0;
    for i := 0 to Meter.PDDefines.Count - 1 do
        if Meter.PDDefine[i].HasEV then
        begin
            Inc(n);
            SetLength(EVDatas, n);
            New(EVDatas[n - 1]);
            EVDatas[n - 1].Init;
            EVDatas[n - 1].PDIndex := i;
            EVDatas[n - 1].ID      := ADsnName;
        end;

    for iRow := sht.UsedRange.LastRow + 1 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        if TryStrToDateTime(S, dtScale) = False then
            Continue;
        // 如果没有设置时间，则现在设置：即以最后一条记录的时间作为该仪器的特征值统计时间
        if chkDate.theYear = 0 then
        begin
            SetDate(dtScale); //初始化时间设置
            //设置当前值
            for i := 0 to High(EVDatas) do
            begin
                EVDatas[i].CurDate  := dtScale;
                EVDatas[i].CurValue := ExcelIO.GetFloatValue(sht, iRow,
                    Meter.PDColumn(EVDatas[i].PDIndex));
            end;
        end;
        //
        for i := 0 to High(EVDatas) do
            FindEVData(i);
    end;

    Result := True;
end;

function ThjxDataQuery.GetEVDataInPeriod(ADsnName: string; DT1: TDateTime; DT2: TDateTime;
    var EVDatas: TDoubleDynArray): Boolean;
begin
    Result := False;
end;
{-----------------------------------------------------------------------------
  Procedure  : SetFieldDisplayName
  Description: 本方法根据在uHJX.Data.Types中预定义的字段名与别名对应表更换
  DataSet中的字段DisplayName。在本单元中，这个对应表取自Excel的属性定义工作簿
  中的字段名表，该表在加载参数时被加载，并存储到uhjx.excel.meters单元中的
  DSNames对象中，该对象有一个DispName方法，可根据字段名返回对应的DisplayName
-----------------------------------------------------------------------------}
procedure ThjxDataQuery.SetFieldDisplayName(DS: TDataSet);
var i:integer;
    s:string;
begin
    for i := 0 to ds.Fields.Count -1 do
    begin
        s:=DSNames.DispName(ds.Fields[i].FieldName);
        if s <>'' then
            ds.Fields[i].DisplayLabel := s;
    end;
end;

end.
