{ -----------------------------------------------------------------------------
  Unit Name: uInitParams
  Author:    ��ΰ
  Date:      31-����-2017
  Purpose:   ����Ԫ���ڳ�ʼ������������
  ����������Դ�ڡ�����������.xls��������Ӳ������м�������ĸ������
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
    { �������ж���ṹ }
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
        ShowMessage('��������û�С�ParamSheetStructure������������ܴ���'#13#10 + '�ٵĲ��������ټ��һ�¡�');
        exit;
    end;

    // �������Ա�ṹ����
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

    // �������Ա�ṹ����
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

    // ���ݸ�ʽ����
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
    Sht    := ExcelIO.GetSheet(ParamBook, '�����������Ա�');
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
    Sht    := ExcelIO.GetSheet(ParamBook, '�����������Ա�');
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
        { TODO:��Ҫ��������������ͬ��������Լ���MDCount��PDCount��һ�µ���� }
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
    Sht    := ExcelIO.GetSheet(ParamBook, '�������ݸ�ʽ����');
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
            // ȡ�غ����ù۲�����������
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
  Description: ����������������
  ----------------------------------------------------------------------------- }
function LoadParams(ParamBook: IXLSWorkBook): Boolean;
begin
    result := False;
    // �ȼ��ز����ļ��ṹ�����
    if not GetParamSheetStructure(ParamBook) then
    begin
        ShowMessage('δ�ܼ��ز����ļ��ṹ���壬�޷���ɳ�ʼ���������ع��̡�');
        exit;
    end;
    // ���ع��̲�����
    LoadProjectParams(ParamBook);
    // ���ػ���������
    LoadMeterParams(ParamBook);
    // �������ݽṹ�����
    LoadDataSheetStru(ParamBook);
    // �����ֶ����б�
    LoadFieldDispNames(ParamBook);

    result := true;
end;

{ -----------------------------------------------------------------------------
  Procedure  : LoadDataFileList
  Description: �������������ļ��б����
  ----------------------------------------------------------------------------- }
function LoadDataFileList(DFBook: IXLSWorkBook): Boolean;
var
    Sht           : IXLSWorksheet;
    iRow          : Integer;
    S, sSht, sBook: string;
    AMeter        : TMeterDefine;
begin
    result := False;
    Sht    := ExcelIO.GetSheet(DFBook, '���������ļ��б�');
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
  Description: ���ع��������ļ�������ļ��ж����������������ļ������������ļ�
  �б��ļ��������̸��ݴ˱���һ����֮��
  ----------------------------------------------------------------------------- }
function LoadProjectConfig(prjBookName: string): Boolean;
var
    wbk, wbk1, wbk2: IXLSWorkBook;
    Sht            : IXLSWorksheet;
    S, sPF, sDLF   : string;
    iRow           : Integer;
begin
    result := False;
    // �����������ļ�����·�����Ժ�Ҫ�õ�
    ENV_ConfigPath := ExtractFilePath(prjBookName);
    // ���ȫ���Ѵ�����������Ҫ���¼�����~~
    ExcelMeters.ReleaseAllMeters;

    wbk := TXLSWorkbook.Create;

    { todo:��д����Ĵ��룬��OpenWorkbook���������ļ��򿪵���� }

    try
        // wbk.Open(prjBookName);
        if ExcelIO.OpenWorkbook(wbk, prjBookName) = False then
        begin
            ShowMessage('δ�ܴ򿪹��������ļ����޷�����...');
        end;

        Sht := ExcelIO.GetSheet(wbk, '���������ļ�');
        if Sht = nil then
        begin
            ShowMessage('������Ч�ġ����������ļ���');
            exit;
        end;
        { todo:��Ӹ�ʽ��� }
        sPF      := '';
        sDLF     := '';
        for iRow := 3 to Sht.UsedRange.LastRow + 1 do
        begin
            S := Trim(VarToStr(Sht.Cells[iRow, 2].Value));
            if S = '' then
                Break;

            if S = '��������������' then
                sPF := Trim(VarToStr(Sht.Cells[iRow, 3].Value))
            else if S = '���������ļ��б�����' then
                sDLF := Trim(VarToStr(Sht.Cells[iRow, 3].Value));
        end;

        // �����ļ�·��
        S := GetCurrentDir;
        SetCurrentDir(ENV_ConfigPath);
        // ������������������
        if sPF <> '' then
            try
                wbk1 := TXLSWorkbook.Create;
                wbk1.Open(sPF);
                LoadParams(wbk1);
            except
                on e: Exception do
                    ShowMessage('����������������' + e.Message);
            end;

        if sDLF <> '' then
            try
                wbk2 := TXLSWorkbook.Create;
                wbk2.Open(sDLF);
                LoadDataFileList(wbk2);
            except
                on e: Exception do
                    ShowMessage('�������������ļ��б����' + e.Message);
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
    Sht    := ExcelIO.GetSheet(ParamBook, '�ֶ�����');
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
