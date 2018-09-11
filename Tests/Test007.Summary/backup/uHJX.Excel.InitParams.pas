{ -----------------------------------------------------------------------------
  Unit Name: uInitParams
  Author:    黄伟
  Date:      31-三月-2017
  Purpose:   本单元用于初始化仪器参数。
  仪器参数来源于“仪器参数表.xls”，程序从参数表中加载所需的各项参数
  History:
  ----------------------------------------------------------------------------- }

unit uHJX.Excel.InitParams;

interface

uses
    System.Classes, System.Generics.Collections, System.SysUtils, System.Variants, Vcl.Dialogs,
    nExcel, uHJX.Excel.Meters, uHJX.Excel.IO;

function LoadProjectConfig(prjBookName: String): Boolean;
function LoadParams(ParamBook: IXLSWorkBook): Boolean;
function LoadDataFileList(DFBook: IXLSWorkBook): Boolean;
function LoadFieldDispNames(ParamBook: IXLSWorkBook): Boolean;

implementation

uses
    uHJX.EnvironmentVariables;

type
    { 参数表列定义结构 }
    TParamColDefine = record
        ParamName: string;
        Col: Integer;
    end;

    PColDefine = ^TParamColDefine;

    TParamColsList = class
    private
        FList: TList<PColDefine>;
        function GetCount: Integer;
        function GetItem(Index: Integer): PColDefine;
        function GetCol(AName: string): Integer;
    public
        constructor Create;
        destructor Destroy; override;
        function AddNew: PColDefine;
        property Count: Integer read GetCount;
        property Item[Index: Integer]: PColDefine read GetItem;
        property Col[AName: string]: Integer read GetCol;
    end;

    TParamCols = class
    public
        PRJ: TParamColsList;
        PRM: TParamColsList;
        DAT: TParamColsList;
        constructor Create;
        destructor Destroy; override;
    end;

const
    MAXMETERNUMBER = 5000;

var
    // PARAMCOLS: TParamStruColDefine;
    theCols: TParamCols;

constructor TParamColsList.Create;
begin
    inherited;
    FList := TList<PColDefine>.Create;
end;

destructor TParamColsList.Destroy;
begin
    while FList.Count > 0 do
    begin
        Dispose(FList.Items[0]);
        FList.Delete(0);
    end;
    FList.Free;
    inherited;
end;

function TParamColsList.GetCount: Integer;
begin
    result := FList.Count;
end;

function TParamColsList.GetItem(Index: Integer): PColDefine;
begin
    result := FList.Items[Index];
end;

function TParamColsList.AddNew: PColDefine;
begin
    New(result);
    FList.Add(result);
end;

function TParamColsList.GetCol(AName: string): Integer;
var
    i: Integer;
begin
    result := 0;
    for i  := 0 to FList.Count - 1 do
        if FList.Items[i].ParamName = AName then
        begin
            result := FList.Items[i].Col;
            Break;
        end;
end;

constructor TParamCols.Create;
begin
    inherited;
    PRJ := TParamColsList.Create;
    PRM := TParamColsList.Create;
    DAT := TParamColsList.Create;
end;

destructor TParamCols.Destroy;
begin
    PRJ.Free;
    PRM.Free;
    DAT.Free;
    inherited;
end;

function GetParamSheetStructure(ParamBook: IXLSWorkBook): Boolean;
var
    Sht         : IXLSWorksheet;
    S, sNum     : string;
    iRow, ColNum: Integer;
    ColDef      : PColDefine;
begin
    result := False;
    Sht    := ExcelIO.GetSheet(ParamBook, 'ParamSheetStructure');
    if Sht = nil then
    begin
        ShowMessage('参数表中没有“ParamSheetStructure”工作表，你可能打开了'#13#10 + '假的参数表，请再检查一下。');
        exit;
    end;

    // 基本属性表结构定义
    for iRow := 3 to 50 do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
        if S = '' then
            Break;
        sNum   := VarToStr(Sht.Cells[iRow, 3].Value);
        ColNum := StrToInt(sNum);

        ColDef           := theCols.PRM.AddNew;
        ColDef.ParamName := S;
        ColDef.Col       := ColNum;
    end;

    // 工程属性表结构定义
    for iRow := 3 to 100 do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 6].Value));
        if S = '' then
            Break;
        sNum             := VarToStr(Sht.Cells[iRow, 7].Value);
        ColNum           := StrToInt(sNum);
        ColDef           := theCols.PRJ.AddNew;
        ColDef.ParamName := S;
        ColDef.Col       := ColNum;
    end;

    // 数据格式定义
    for iRow := 3 to 100 do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 10].Value));
        if S = '' then
            Break;
        sNum             := VarToStr(Sht.Cells[iRow, 11].Value);
        ColNum           := StrToInt(sNum);
        ColDef           := theCols.DAT.AddNew;
        ColDef.ParamName := S;
        ColDef.Col       := ColNum;
    end;

    result := true;
end;

function _GetStrValue(ASht: IXLSWorksheet; ARow: Integer; ColList: TParamColsList;
    AName: string): string;
var
    iCol: Integer;
begin
    result := '';
    iCol   := ColList.Col[AName];
    if iCol = 0 then
        exit;
    result := Trim(VarToStr(ASht.Cells[ARow, iCol].Value));
end;

function _GetFloatValue(ASht: IXLSWorksheet; ARow: Integer; ColList: TParamColsList;
    AName: string): double;
var
    sValue: string;
begin
    result := 0;
    sValue := _GetStrValue(ASht, ARow, ColList, AName);
    if sValue = '' then
        exit;
    try
        result := StrToFloat(sValue);
    finally
    end;
end;

function _GetDateTimeValue(ASht: IXLSWorksheet; ARow: Integer; ColList: TParamColsList;
    AName: string): TDateTime;
var
    sValue: String;
begin
    result := 0;
    sValue := _GetStrValue(ASht, ARow, ColList, AName);
    TryStrToDateTime(sValue, result);
end;

function LoadProjectParams(ParamBook: IXLSWorkBook): Boolean;
var
    iRow  : Integer;
    AMeter: TMeterDefine;
    Sht   : IXLSWorksheet;
    S     : string;
    function StrValue(ARow: Integer; AName: string): string;
    begin
        result := _GetStrValue(Sht, ARow, theCols.PRJ, AName);
    end;
    function FloatValue(ARow: Integer; AName: string): double;
    begin
        result := _GetFloatValue(Sht, ARow, theCols.PRJ, AName);
    end;

begin
    result := False;
    Sht    := ExcelIO.GetSheet(ParamBook, '仪器工程属性表');
    if Sht = nil then
        exit;
    for iRow := 4 to MAXMETERNUMBER do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
        if S = '' then
            Break;
        AMeter                      := ExcelMeters.AddNew;
        AMeter.DesignName           := S;
        AMeter.PrjParams.SubProject := StrValue(iRow, 'SubProject');
        AMeter.PrjParams.Position   := StrValue(iRow, 'Position');
        AMeter.PrjParams.Elevation  := FloatValue(iRow, 'Elevation');
        AMeter.PrjParams.Stake      := StrValue(iRow, 'Stake');
        AMeter.PrjParams.Profile    := StrValue(iRow, 'Profile');
        AMeter.PrjParams.Deep       := FloatValue(iRow, 'Deep');
        AMeter.PrjParams.Annotation := StrValue(iRow, 'Annotation');
    end;
    result := true;
end;

function LoadMeterParams(ParamBook: IXLSWorkBook): Boolean;
var
    iRow  : Integer;
    AMeter: TMeterDefine;
    Sht   : IXLSWorksheet;
    S     : string;
    function StrValue(AName: string): string;
    begin
        result := _GetStrValue(Sht, iRow, theCols.PRM, AName);
    end;
    function FloatValue(AName: string): double;
    begin
        result := _GetFloatValue(Sht, iRow, theCols.PRM, AName);
    end;
    function DateTimeValue(AName: String): TDateTime;
    begin
        result := _GetDateTimeValue(Sht, iRow, theCols.PRM, AName);
    end;

begin
    result := False;
    Sht    := ExcelIO.GetSheet(ParamBook, '仪器基本属性表');
    if Sht = nil then
        exit;
    for iRow := 4 to MAXMETERNUMBER do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
        if S = '' then
            Break;
        AMeter := ExcelMeters.Meter[S];
        if AMeter = nil then
            Continue;
        AMeter.Params.MeterType   := StrValue('MeterType');
        AMeter.Params.Model       := StrValue('Model');
        AMeter.Params.SerialNo    := StrValue('SerialNo');
        AMeter.Params.WorkMode    := StrValue('WorkMode');
        AMeter.Params.MinValue    := FloatValue('MinValue');
        AMeter.Params.MaxValue    := FloatValue('MaxValue');
        AMeter.Params.SensorCount := Trunc(FloatValue('SensorCount'));
        AMeter.Params.SetupDate   := DateTimeValue('SetupDate');
        AMeter.Params.BaseDate    := DateTimeValue('BaseDate');
        AMeter.Params.MDCount     := Trunc(FloatValue('MDCount'));
        AMeter.Params.PDCount     := Trunc(FloatValue('PDCount'));
        AMeter.Params.Annotation  := StrValue('Annotation');
    end;
    result := true;
end;

function LoadDataSheetStru(ParamBook: IXLSWorkBook): Boolean;
var
    iRow     : Integer;
    AMeter   : TMeterDefine;
    Sht      : IXLSWorksheet;
    S, S1, S2: string;
    SS1, SS2 : TStrings;
    function StrValue(AName: string): string;
    begin
        result := _GetStrValue(Sht, iRow, theCols.DAT, AName);
    end;
    function FloatValue(AName: string): double;
    begin
        result := _GetFloatValue(Sht, iRow, theCols.DAT, AName);
    end;
    procedure ExtractDataDefine(datNames, datCols: string; DDs: TDataDefines);
    var
        i  : Integer;
        pdd: PDataDefine;
    begin
        SS1.Clear;
        SS2.Clear;
        SS1.DelimitedText := datNames;
        SS2.DelimitedText := datCols;
        { TODO:需要考虑两者数量不同的情况，以及和MDCount、PDCount不一致的情况 }
        if (SS1.Count > 0) and (SS2.Count > 0) then
            for i := 0 to SS1.Count - 1 do
            begin
                pdd        := DDs.AddNew;
                pdd.Name   := SS1.Strings[i];
                pdd.Column := StrToInt(SS2.Strings[i]);
            end;
    end;
    procedure ProcEVItems(EVDefine: string);
    var
        i, k: Integer;
    begin
        SS1.Clear;
        SS1.DelimitedText := EVDefine;
        if SS1.Count > 0 then
            for i := 0 to SS1.Count - 1 do
            begin
                k                               := StrToInt(SS1.Strings[i]) - 1;
                AMeter.PDDefines.Items[k].HasEV := true;
            end;
    end;

begin
    result := False;
    Sht    := ExcelIO.GetSheet(ParamBook, '仪器数据格式定义');
    if Sht = nil then
        exit;
    try
        SS1           := tstringlist.Create;
        SS2           := tstringlist.Create;
        SS1.Delimiter := '|';
        SS2.Delimiter := '|';
        for iRow      := 4 to MAXMETERNUMBER do
        begin
            S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
            if S = '' then
                Break;
            AMeter := ExcelMeters.Meter[S];
            if AMeter = nil then
                Continue;
            AMeter.DataSheetStru.DTStartRow := Trunc(FloatValue('DTStartRow'));
            AMeter.DataSheetStru.DTStartCol := Trunc(FloatValue('DTStartCol'));
            AMeter.DataSheetStru.AnnoCol    := Trunc(FloatValue('Annotation'));
            AMeter.DataSheetStru.BaseLine   := Trunc(FloatValue('BaseLine'));
            // 取回和设置观测量和物理量
            S1 := StrValue('MDDefine');
            S2 := StrValue('MDCols');
            ExtractDataDefine(S1, S2, AMeter.DataSheetStru.MDs);
            S1 := StrValue('PDDefine');
            S2 := StrValue('PDCols');
            ExtractDataDefine(S1, S2, AMeter.DataSheetStru.PDs);
            S1 := StrValue('EVItems');
            ProcEVItems(S1);
        end;
    finally
        SS1.Free;
        SS2.Free;
    end;
    result := true;
end;

{ -----------------------------------------------------------------------------
  Procedure  : LoadParams
  Description: 加载仪器参数过程
  ----------------------------------------------------------------------------- }
function LoadParams(ParamBook: IXLSWorkBook): Boolean;
begin
    result := False;
    // 先加载参数文件结构定义表
    if not GetParamSheetStructure(ParamBook) then
    begin
        ShowMessage('未能加载参数文件结构定义，无法完成初始化参数加载过程。');
        exit;
    end;
    // 加载工程参数表
    LoadProjectParams(ParamBook);
    // 加载基本参数表
    LoadMeterParams(ParamBook);
    // 加载数据结构定义表
    LoadDataSheetStru(ParamBook);
    // 加载字段名列表
    LoadFieldDispNames(ParamBook);

    result := true;
end;

{ -----------------------------------------------------------------------------
  Procedure  : LoadDataFileList
  Description: 加载仪器数据文件列表过程
  ----------------------------------------------------------------------------- }
function LoadDataFileList(DFBook: IXLSWorkBook): Boolean;
var
    Sht           : IXLSWorksheet;
    iRow          : Integer;
    S, sSht, sBook: string;
    AMeter        : TMeterDefine;
begin
    result := False;
    Sht    := ExcelIO.GetSheet(DFBook, '仪器数据文件列表');
    if Sht = nil then
        exit;
    for iRow := 3 to 10000 do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
        if S = '' then
            Break;
        AMeter := ExcelMeters.Meter[S];
        if AMeter = nil then
            Continue;
        sSht             := VarToStr(Sht.Cells[iRow, 3].Value);
        sBook            := VarToStr(Sht.Cells[iRow, 4].Value);
        AMeter.DataSheet := sSht;
        AMeter.DataBook  := sBook;
    end;
    result := true;
end;

{ -----------------------------------------------------------------------------
  Procedure  : LoadProjectConfig
  Description: 加载工程配置文件，这个文件中定义了仪器参数表文件和仪器数据文件
  列表文件，本过程根据此表逐一加载之。
  ----------------------------------------------------------------------------- }
function LoadProjectConfig(prjBookName: string): Boolean;
var
    wbk, wbk1, wbk2: IXLSWorkBook;
    Sht            : IXLSWorksheet;
    S, sPF, sDLF   : string;
    iRow           : Integer;
begin
    result := False;
    // 解析出配置文件所在路径，以后要用到
    ENV_ConfigPath := ExtractFilePath(prjBookName);
    // 清空全部已创建的仪器，要重新加载了~~
    ExcelMeters.ReleaseAllMeters;

    wbk := TXLSWorkbook.Create;

    { todo:重写下面的代码，用OpenWorkbook函数处理文件打开的情况 }

    try
        // wbk.Open(prjBookName);
        if ExcelIO.OpenWorkbook(wbk, prjBookName) = False then
        begin
            ShowMessage('未能打开工程配置文件，无法继续...');
        end;

        Sht := ExcelIO.GetSheet(wbk, '工程配置文件');
        if Sht = nil then
        begin
            ShowMessage('不是有效的“工程配置文件”');
            exit;
        end;
        { todo:添加格式检查 }
        sPF      := '';
        sDLF     := '';
        for iRow := 3 to Sht.UsedRange.LastRow + 1 do
        begin
            S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
            if S = '' then
                Break;

            if S = '仪器参数表工作簿' then
                sPF := Trim(VarToStr(Sht.Cells[iRow, 3].Value))
            else if S = '仪器数据文件列表工作簿' then
                sDLF := Trim(VarToStr(Sht.Cells[iRow, 3].Value));
        end;

        // 设置文件路径
        S := GetCurrentDir;
        SetCurrentDir(ENV_ConfigPath);
        // 加载仪器参数表工作簿
        if sPF <> '' then
            try
                wbk1 := TXLSWorkbook.Create;
                wbk1.Open(sPF);
                LoadParams(wbk1);
            except
                on e: Exception do
                    ShowMessage('加载仪器参数出错：' + e.Message);
            end;

        if sDLF <> '' then
            try
                wbk2 := TXLSWorkbook.Create;
                wbk2.Open(sDLF);
                LoadDataFileList(wbk2);
            except
                on e: Exception do
                    ShowMessage('加载仪器数据文件列表出错：' + e.Message);
            end;

        result := true;
    except
        on e: Exception do
            ShowMessage(e.Message);
    end;
    SetCurrentDir(S);
end;

function LoadFieldDispNames(ParamBook: IXLSWorkBook): Boolean;
var
    Sht   : IXLSWorksheet;
    iRow  : Integer;
    S1, S2: String;
begin
    result := False;
    Sht    := ExcelIO.GetSheet(ParamBook, '字段名表');
    if Sht = nil then
        exit;

    for iRow := 2 to Sht.UsedRange.LastRow + 1 do
    begin
        S1 := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
        if S1 = '' then
            Continue;
        S2 := Trim(VarToStr(Sht.Cells[iRow, 3].Value));
        if S2 <> '' then
            dsnames.AddName(S1, S2);
    end;

    result := true;
end;

initialization

theCols := TParamCols.Create;

finalization

theCols.Free;

end.
