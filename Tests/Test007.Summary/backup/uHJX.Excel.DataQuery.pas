{ -----------------------------------------------------------------------------
  Unit Name: uHJX.Excel.DataQuery
  Author:    ��ΰ
  Date:      06-����-2017
  Purpose:   ���ݲ�ѯ��Ԫ-���Excel����Դ
  History:
  ----------------------------------------------------------------------------- }

unit uHJX.Excel.DataQuery;

interface

uses
    System.Classes, System.Types, System.SysUtils, System.Variants, System.StrUtils, Data.DB,
    Datasnap.DBClient, System.DateUtils, MidasLib,
    uHJX.Intf.Datas, uHJX.Excel.IO, uHJX.Data.Types;

type
    { �ƽ�Ͽ���ݲ�ѯ���� }
    ThjxDataQuery = class(TInterfacedObject, IClientFuncs)
    private
        FUseSession: Boolean;
    public
        destructor Destroy; override;
        { �����Ự }
        { todo:ʵ�������Ự�󴴽��򿪵Ĺ������أ�����Ҫ�򿪹�����ʱ�ȼ���Ƿ��Ѿ��򿪣�������
          û�У��Ŵ��������¹��������������ض��ھ�̬�����ͽ�Ϊ���ã����Դ����������ȡ���ݵ�ʱ�䡣 }
        procedure SessionBegin;
        procedure SessionEnd;
        { ȡ��ָ��������������һ�μ������ }
        function GetLastPDDatas(ADsnName: string; var Values: TDoubleDynArray): Boolean;
        { ȡ��ָ��ʱ���ڼ�����������һ������ }
        function GetLastPDDatasBeforeDate(ADsnName: string; DT: TDateTime;
            var Values: TDoubleDynArray): Boolean;
        { ȡ����ӽ�ָ�����ڵĹ۲����� }
        function GetNearestPDDatas(ADsnName: String; DT: TDateTime; var Values: TDoubleDynArray;
            DTDelta: Integer = 0): Boolean;
        { ȡ��ָ��ʱ���ڼ���������й۲����� }
        function GetPDDatasInPeriod(ADsnName: string; DT1, DT2: TDateTime; DS: TDataSet): Boolean;
        { ȡ��ȫ���۲����� }
        function GetAllPDDatas(ADsnName: string; DS: TDataSet): Boolean;
        { ȡ�ص�ǰ����ֵ�������������� }
        function GetEVData(ADsnName: String; EVData: PEVDataStru): Boolean; overload;
        function GetEVData(ADsnName: string; var EVDatas: TDoubleDynArray): Boolean; overload;
        { ȡ����������������������ֵ }
        function GetEVDatas(ADsnName: String; var EVDatas: PEVDataArray): Boolean;
        { ȡ��ָ��ʱ���ڵ�����ֵ }
        function GetEVDataInPeriod(ADsnName: string; DT1, DT2: TDateTime;
            var EVDatas: TDoubleDynArray): Boolean;
        { ����DataSet�ֶα���������Excel���������������Ӧ��洢��Excel�����ļ��У���ʼ������ʱ
          �Ѽ��ص�uHJX.Excel.Meters��Ԫ��DSNames������ }
        procedure SetFieldDisplayName(DS:TDataSet);
    end;

implementation

uses
    uHJX.Excel.Meters, nExcel;

var
    SSWorkBook: IXLSWorkBook; // �Ự�ڼ�ʹ�õ�Workbook

    // �������������崴���ֶα�
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
    DF.DisplayName := '�۲�����';
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
        Fields[0].DisplayLabel := '�۲�����';
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
  Description: ȡ�����һ�ι۲����ݣ��������������ؽ������Ϊ�����ڡ�������
  ���飬����������˫���ȱ�ʾ
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

    iCount := Meter.PDDefines.Count + 1; // ������+�۲�����
    SetLength(Values, iCount);
    Values[0] := 0; // �۲���������Ϊ0����û�����ݣ������룬������ͨ���۲������Ƿ�Ϊ0�ж��Ƿ��й۲����ݡ�

    // ���濪ʼ�����������
    for iRow := sht.UsedRange.LastRow + 5 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;
        // �۲�����
        Values[0] := ExcelIO.GetDateTimeValue(sht, iRow, 1);
        // ����������
        for i             := 0 to Meter.PDDefines.Count - 1 do
            Values[i + 1] := ExcelIO.GetFloatValue(sht, iRow, Meter.PDColumn(i));
        Break;
    end;
    Result := True;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetLastPDDatasInPeriod
  Description: ȡ��ָ��ʱ�������һ�ι۲�����
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

    iCount := Meter.PDDefines.Count + 1; // ������+�۲�����
    SetLength(Values, iCount);
    Values[0] := 0; // �۲���������Ϊ0����û�����ݣ������룬������ͨ���۲������Ƿ�Ϊ0�ж��Ƿ��й۲����ݡ�
    for iRow  := sht.UsedRange.LastRow + 1 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;

        if TryStrToDateTime(S, DT1) = False then
            Continue; // ���ʱ���ַ�����Ч������������¼

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
  Description: ȡ����ӽ�ָ�����ڵĹ۲����ݣ�ʱ���ǰ�ɺ�
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

    iCount := Meter.PDDefines.Count + 1; // ������+�۲�����
    SetLength(Values, iCount);
    Values[0] := 0; // �۲���������Ϊ0����û�����ݣ������룬������ͨ���۲������Ƿ�Ϊ0�ж��Ƿ��й۲����ݡ�
    // �������
    dLast    := -1000;
    dThis    := 10000;
    iLRow    := 0;
    for iRow := sht.UsedRange.LastRow + 1 downto Meter.DataSheetStru.BaseLine do
    begin
        S := Trim(VarToStr(sht.Cells[iRow, 1].value));
        if S = '' then
            Continue;

        if TryStrToDateTime(S, DT1) = False then
            Continue; // ���ʱ���ַ�����Ч������������¼

        if DT1 = DT then
        begin
            SetData(iRow);
            Break;
        end
        else if DT1 > DT then
            dThis := DaysBetween(DT1, DT)
        else if DT1 < DT then
            dThis := DaysBetween(DT, DT1)
        else if iRow = Meter.DataSheetStru.BaseLine then // �������һ�У����������ݣ�֮��ͽ�����
        begin
            SetData(iRow);
            Break;
        end;

        // ��dLast>0��˵���Ѿ����һ����
        if dLast >= 0 then
            if dThis > dLast then // ˵���߹��ˣ��ϴ���С
            begin
                if DTDelta = 0 then // ���Գ���
                begin
                    SetData(iLRow);
                    Break;
                end
                else if dLast > DTDelta then // ���ޣ�����������
                begin
                    Break;
                end
                else // ���ڣ�����������
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
    // ���е�������Գ��Դ���DataSet����ȡ������
    // ���DSΪ�գ��򴴽�֮
    if DS = nil then
        DS := TClientDataSet.Create(nil)
    else
    begin
        if DS.Active then
            DS.Close;
        DS.FieldDefs.Clear;
    end;
    // ��DS������ֶ�
    _CreateFieldsFromPDDefines(DS, Meter.PDDefines);
    { ����Ҫע�⣬����ʹ��TClientDataset������ }
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
    // ���е�������Գ��Դ���DataSet����ȡ������
    // ���DSΪ�գ��򴴽�֮
    if DS = nil then
        DS := TClientDataSet.Create(nil)
    else
    begin
        if DS.Active then
            DS.Close;
        DS.FieldDefs.Clear;
    end;
    // ��DS������ֶ�
    _CreateFieldsFromPDDefines(DS, Meter.PDDefines);
    { ����Ҫע�⣬����ʹ��TClientDataset������ }
    TClientDataSet(DS).CreateDataSet;
    _SetFieldsDisplayName(DS, Meter.PDDefines);
    // ��ѯ���������
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
      Description: ���ҵ�ǰ����ֵ��ʱ��Ϊ���һ�ι۲�ʱ�䣬Ŀǰֻ�ܲ�ѯPD1������ֵ
      ���ڶ��λ�Ƽ�Ҳ����ˡ�
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

        { �ж��Ƿ�������CheckDate������������֮����ʱ�������һ����¼ }
        if chkDate.dtMon1 = 0 then
        begin
            SetDate(dtScale);
            { ��ǰֵ }
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
  Description: �����������������о�������ֵ��������������ֵ
  ��GetEVData��ͬ��GetEVData�����ص�һ��������������ֵ������������������ֵ��
  ������������ֵ����Щ�����ж����������������λ�Ƽƣ�ÿ����㶼��Ҫ������
  ��ֵ��������һ���Խ���Щ��������ֵȫ��ȡ�ء�
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
    // �ͷŵ������ṩ��evdatasռ�õ��ڴ棬��ͬ����������ֵ������ͬ
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
    // ��Ҫ�ļ��ͳ�ʼ��
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

    // ��EVDatas�����ʼ�����ͷŶ�����ڴ�
    ReleaseEVDatas;
    // ����Meter��������ֵ��������������ʼ��EVDatas����
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
        // ���û������ʱ�䣬���������ã��������һ����¼��ʱ����Ϊ������������ֵͳ��ʱ��
        if chkDate.theYear = 0 then
        begin
            SetDate(dtScale); //��ʼ��ʱ������
            //���õ�ǰֵ
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
  Description: ������������uHJX.Data.Types��Ԥ������ֶ����������Ӧ�����
  DataSet�е��ֶ�DisplayName���ڱ���Ԫ�У������Ӧ��ȡ��Excel�����Զ��幤����
  �е��ֶ������ñ��ڼ��ز���ʱ�����أ����洢��uhjx.excel.meters��Ԫ�е�
  DSNames�����У��ö�����һ��DispName�������ɸ����ֶ������ض�Ӧ��DisplayName
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
