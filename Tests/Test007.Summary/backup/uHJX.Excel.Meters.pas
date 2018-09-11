unit uHJX.Excel.Meters;

interface

uses
    System.Classes, System.SysUtils, System.Variants, System.Generics.Collections;

type
    TDataDefine = record
        Name: string;
        Alias: string;
        DataUnit: string;
        Column: Integer;
        HasEV: Boolean; // 有特征值否？
    end;

    PDataDefine = ^TDataDefine;
    // PDataDefines = array of PDataDefine;

    TDataDefines = class
    private
        FList: TList;
        function GetItem(Index: Integer): PDataDefine;
        // procedure SetItem(Index: Integer; DD: PDataDefine);
        function GetCount: Integer;
    public
        constructor Create;
        destructor Destroy; override;

        function AddNew: PDataDefine;
        function IndexOfDataName(AName: String) : Integer;
        property Items[Index: Integer]: PDataDefine read GetItem; // write SetItem;
        property Count: Integer read GetCount;
    end;

    TDataSheetStructure = record
        DTStartRow: Integer;
        DTStartCol: Integer;
        AnnoCol: Integer;
        BaseLine: Integer;
        MDs: TDataDefines;
        PDs: TDataDefines;
    end;

    TMeterParams = record
        MeterType: string;
        Model: string;
        SerialNo: string;
        WorkMode: string;
        MinValue: double;
        MaxValue: double;
        SensorCount: Integer;
        SetupDate: TDateTime;
        BaseDate: TDateTime;
        MDCount: Integer;
        PDCount: Integer;
        Annotation: string;
    end;

    TMeterProjectParams = record
        SubProject: string;
        Position: string;
        Elevation: double;
        Stake: string;
        Profile: string;
        Deep: double;
        Annotation: string;
    end;

    TMeterDefine = class
    private
        // function GetPDDefines: TDataDefines;
        function GetPDDefine(Index: Integer): TDataDefine;
    public
        DesignName   : string;
        DataSheet    : string;
        DataBook     : string;
        Params       : TMeterParams;
        PrjParams    : TMeterProjectParams;
        DataSheetStru: TDataSheetStructure;
        constructor Create;
        destructor Destroy; override;
        function ParamValue(AParamName: string): Variant;
        procedure SetParamValue(AParamName: string; Value: Variant);
        function PDName(Index: Integer): string;
        function PDColumn(Index: Integer): Integer;
        property PDDefines: TDataDefines read DataSheetStru.PDs;
        property PDDefine[Index: Integer]: TDataDefine read GetPDDefine;
    end;

    TMeterDefines = class
    private
        FList: TList;
        function GetCount: Integer;
        function GetItem(Index: Integer): TMeterDefine;
        function GetMeter(ADesignName: string): TMeterDefine;
    public
        constructor Create;
        destructor Destroy; override;
        function AddNew: TMeterDefine;
        function Add(AMeter: TMeterDefine): Integer;
        // 注意：Clear、Delete只移除对象，并不释放！！！
        procedure Clear;
        procedure ReleaseAllMeters;
        procedure Delete(Index: Integer); overload;
        procedure Delete(AName: string); overload;
        procedure SortByDesignName;
        procedure SortByPosition;
        procedure SortByMeterType;
        procedure SortByDataFile;
        property Count: Integer read GetCount;
        property Items[index: Integer]: TMeterDefine read GetItem;
        property Meter[ADesignName: string]: TMeterDefine read GetMeter;
    end;

type
    { 本程序数据字段名及对应的显示名，用来将DataSet中field名称换为中文名，供菜鸟看。
      这个结构体用于SetFieldDisplayName方法，该方法是接口同名方法的实现。 }
    ThjxDSName = record
        FieldName: string;
        DisplayName: string;
    end;

    PhjxDSName = ^ThjxDSName;

    ThjxDSNames = class
    private
        FList: TList<PhjxDSName>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure AddName(AFldName, ADispName: string);
        function DispName(AFldName: string): String;
    end;

var
    ExcelMeters: TMeterDefines;
    DSNames    : ThjxDSNames;

implementation

constructor TDataDefines.Create;
begin
    inherited;
    FList := TList.Create;
end;

destructor TDataDefines.Destroy;
begin
    while FList.Count > 0 do
    begin
        Dispose(FList.Items[0]);
        FList.Delete(0);
    end;
    FList.Clear;
    FList.Free;
    inherited;
end;

function TDataDefines.GetCount: Integer;
begin
    Result := FList.Count;
end;

function TDataDefines.GetItem(Index: Integer): PDataDefine;
begin
    Result := nil;
    if FList.Items[Index] <> nil then
        Result := PDataDefine(FList.Items[index]);
end;

function TDataDefines.AddNew: PDataDefine;
begin
    New(Result);
    FList.Add(Result);
    Result.Name     := '';
    Result.Alias    := '';
    Result.DataUnit := '';
    Result.Column   := 0;
    Result.HasEV    := false;
end;

function TDataDefines.IndexOfDataName(AName: string):Integer;
var i: integer;
begin
    Result := -1;
    for i := 0 to FList.Count -1 do
        if CompareText(pdatadefine(flist.Items[i]).Name,AName)=0 then
        begin
            result := i;
            Break;
        end;
end;

constructor TMeterDefine.Create;
begin
    inherited;
    DataSheetStru.MDs := TDataDefines.Create;
    DataSheetStru.PDs := TDataDefines.Create;
end;

destructor TMeterDefine.Destroy;
begin
    Self.DataSheetStru.MDs.Free;
    Self.DataSheetStru.PDs.Free;
    inherited;
end;

function TMeterDefine.ParamValue(AParamName: string): Variant;
var
    S: string;
begin
    // Result := Empty;
    S := UpperCase(AParamName);
    if S = 'METERTYPE' then
        Result := Self.Params.MeterType
    else if S = 'MODEL' then
        Result := Params.Model
    else if S = 'SERIALNO' then
        Result := Params.SerialNo
    else if S = 'WORKMODE' then
        Result := Params.WorkMode
    else if S = 'SETUPDATE' then
        Result := FormatDateTime('yyyy-mm-dd hh:nn', Params.SetupDate)
    else if S = 'BASEDATE' then
        Result := FormatDateTime('yyyy-mm-dd hh:nn', Params.BaseDate)
    else if S = 'POSITION' then
        Result := PrjParams.Position
    else if S = 'ELEVATION' then
        Result := FormatFloat('0.00', PrjParams.Elevation)
    else if S = 'DEEP' then
        Result := FormatFloat('0.00', PrjParams.Deep)
    else if S = 'STAKE' then
        Result := PrjParams.Stake
    else if S = 'PROFILE' then
        Result := PrjParams.Profile
    else
        Result := 'Unknow parameter';
end;

procedure TMeterDefine.SetParamValue(AParamName: string; Value: Variant);
var
    S: String;
begin
    { todo:在SetParamValue方法中完善类型检查 }
    S := UpperCase(AParamName);
    if S = 'METERTYPE' then
        Params.MeterType := VarToStr(Value)
    else if S = 'MODEL' then
        Params.Model := Value
    else if S = 'SERIALNO' then
        Params.SerialNo := Value
    else if S = 'WORKMODE' then
        Params.WorkMode := Value
    else if S = 'SETUPDATE' then
        Params.SetupDate := VarToDateTime(Value)
    else if S = 'BASEDATE' then
        Params.BaseDate := VarToDateTime(Value)
    else if S = 'POSISTION' then
        PrjParams.Position := Value
    else if S = 'SUBPROJECT' then
        PrjParams.SubProject := Value
    else if S = 'ELEVATION' then
        PrjParams.Elevation := Value
    else if S = 'DEEP' then
        PrjParams.Deep := Value
    else if S = 'STAKE' then
        PrjParams.Stake := Value
    else if S = 'PROFILE' then
        PrjParams.Profile := Value;
end;

function TMeterDefine.PDName(Index: Integer): String;
begin
    Result := Self.DataSheetStru.PDs.Items[Index].Name;
end;

function TMeterDefine.PDColumn(Index: Integer): Integer;
begin
    Result := Self.DataSheetStru.PDs.Items[Index].Column;
end;

function TMeterDefine.GetPDDefine(Index: Integer): TDataDefine;
begin
    Result := PDataDefine(DataSheetStru.PDs.Items[Index])^;
end;

constructor TMeterDefines.Create;
begin
    inherited;
    FList := TList.Create;
end;

destructor TMeterDefines.Destroy;
begin
    while FList.Count > 0 do
    begin
        TMeterDefine(FList.Items[0]).Free;
        FList.Delete(0);
    end;

    FList.Free;
    inherited;
end;

function TMeterDefines.GetCount: Integer;
begin
    Result := FList.Count;
end;

function TMeterDefines.AddNew: TMeterDefine;
begin
    Result := TMeterDefine.Create;
    FList.Add(Result);
end;

function TMeterDefines.Add(AMeter: TMeterDefine): Integer;
begin
    Result := FList.Add(AMeter);
end;

function TMeterDefines.GetItem(Index: Integer): TMeterDefine;
begin
    Result := FList.Items[index];
end;

function TMeterDefines.GetMeter(ADesignName: string): TMeterDefine;
var
    i: Integer;
begin
    for i := 0 to FList.Count - 1 do
    begin
        Result := Items[i];
        if Result.DesignName = ADesignName then
            exit;
    end;
    Result := nil;
end;

procedure TMeterDefines.Clear;
begin
    FList.Clear;
end;

procedure TMeterDefines.ReleaseAllMeters;
begin
    while FList.Count > 0 do
    begin
        TMeterDefine(FList.Items[0]).Free;
        FList.Delete(0);
    end;
    FList.Clear;
end;

procedure TMeterDefines.Delete(Index: Integer);
begin
    FList.Delete(index);
end;

procedure TMeterDefines.Delete(AName: string);
var
    i: Integer;
begin
    for i := 0 to FList.Count - 1 do
        if Items[i].DesignName = AName then
        begin
            FList.Delete(i);
            Break;
        end;
end;

function CompareDesignName(N1, N2: Pointer): Integer;
begin
    Result := CompareText(TMeterDefine(N1).DesignName, TMeterDefine(N2).DesignName);
end;

function ComparePosition(N1, N2: Pointer): Integer;
var
    M1, M2: TMeterDefine;
begin
    M1     := TMeterDefine(N1);
    M2     := TMeterDefine(N2);
    Result := CompareText(M1.PrjParams.Position, M2.PrjParams.Position);
    if Result = 0 then
    begin
        Result := CompareText(M1.Params.MeterType, M2.Params.MeterType);
        if Result = 0 then
            Result := CompareText(M1.DesignName, M2.DesignName);
    end;
end;

function CompareMeterType(N1, N2: Pointer): Integer;
var
    M1, M2: TMeterDefine;
begin
    M1     := TMeterDefine(N1);
    M2     := TMeterDefine(N2);
    Result := CompareText(M1.Params.MeterType, M2.Params.MeterType);
    if Result = 0 then
    begin
        Result := CompareText(M1.PrjParams.Position, M2.PrjParams.Position);
        if Result = 0 then
            Result := CompareText(M1.DesignName, M2.DesignName);
    end;
end;

function CompareDataBook(N1, N2: Pointer): Integer;
var
    M1, M2: TMeterDefine;
begin
    M1     := TMeterDefine(N1);
    M2     := TMeterDefine(N2);
    Result := CompareText(M1.DataBook, M2.DataBook);
    if Result = 0 then
        Result := CompareText(M1.DesignName, M2.DesignName);
end;

procedure TMeterDefines.SortByDesignName;
begin
    FList.Sort(@CompareDesignName);
end;

procedure TMeterDefines.SortByPosition;
begin
    FList.Sort(@ComparePosition);
end;

procedure TMeterDefines.SortByMeterType;
begin
    FList.Sort(@CompareMeterType);
end;

procedure TMeterDefines.SortByDataFile;
begin
    FList.Sort(@CompareDataBook);
end;

constructor ThjxDSNames.Create;
begin
    inherited Create;
    FList := TList<PhjxDSName>.Create;
end;

destructor ThjxDSNames.Destroy;
begin
    while FList.Count > 0 do
    begin
        Dispose(FList.Items[0]);
        FList.Delete(0);
    end;
    FList.Clear;
    FreeAndNil(FList);
    inherited;
end;

procedure ThjxDSNames.AddName(AFldName: string; ADispName: string);
var
    NewDs: PhjxDSName;
begin
    New(NewDs);
    NewDs.FieldName   := AFldName;
    NewDs.DisplayName := ADispName;
    FList.Add(NewDs);
end;

function ThjxDSNames.DispName(AFldName: string): string;
var
    i: Integer;
begin
    Result := '';
    for i  := 0 to FList.Count - 1 do
        if CompareText(AFldName, FList.Items[i].FieldName) = 0 then
        begin
            Result := FList.Items[i].DisplayName;
            Break;
        end;
end;

initialization

ExcelMeters := TMeterDefines.Create;
DSNames     := ThjxDSNames.Create;

finalization

try
    FreeAndNil(ExcelMeters);
    FreeAndNil(DSNames);
finally
end;

end.
