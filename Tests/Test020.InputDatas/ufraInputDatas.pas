{ -----------------------------------------------------------------------------
 Unit Name: ufraInputDatas
 Author:    ��ΰ
 Date:      06-����-2018
 Purpose:   �۲��������빦��ģ��
            ��ģ���ṩ�ڹ������۲����ݿ������빦�ܣ���ʱ��֧�ֶ��λ�Ƽơ�ê��
            �����ơ�ê��Ӧ������ȡ�
 History:
----------------------------------------------------------------------------- }
{ todo:���������� }
{ todo:��¼������ʷ }
{ todo:������������Լ���������������� }
{ todo:�������ã��������ļ��������޲�����볬�޺�ʾ }
unit ufraInputDatas;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
    Vcl.Menus, Vcl.ComCtrls,
    nexcel;

type
    TfraInputDatas = class(TFrame)
        cmbMeterList: TComboBox;
        Label1: TLabel;
        Memo1: TMemo;
        grdInput: TStringGrid;
        grdRecent: TStringGrid;
        popInput: TPopupMenu;
        piConfirmInput: TMenuItem;
        piReInput: TMenuItem;
        N1: TMenuItem;
        piShowHisData: TMenuItem;
        dtpDefault: TDateTimePicker;
        procedure cmbMeterListKeyPress(Sender: TObject; var Key: Char);
        procedure piConfirmInputClick(Sender: TObject);
        procedure piReInputClick(Sender: TObject);
        procedure piShowHisDataClick(Sender: TObject);
    private
        { Private declarations }
        FMeterBook : IXLSWorkBook;
        FMeterSheet: IXLSWorksheet;
        FIssueList : TStrings;
        procedure InitGridHead;
        procedure Prepare(AName: string);
        procedure PrepareGroup(AGroup: string);
        procedure PutDataInSheet;
        procedure PutGroupDataInSheet;
        procedure AddRecent(AName, ADate, AInput, ACalcRes: string; ARow: Integer);
        // �������
        function CheckInput: Boolean;
    public
        { Public declarations }
        TestBook: string;
        constructor Create(AOwner: TComponent);
        destructor Destroy; override;
        procedure AddMeters;
    end;

implementation

uses
    uHJX.Intf.AppServices, uHJX.Classes.Meters, uHJX.Excel.IO, System.Types;
{$R *.dfm}


type
    // ���С���������������������worksheet�е��ж�Ӧ��������������������
    TCellMap = record
        MeterName: string;
        DataName: string;
        ShtCol: Integer;
        GrdCol: Integer;
        LastRec: Double; // �ϴ����ݱ�������������ڼ���û�����
    end;

var
    curMeter: TMeterDefine;
    MDMap   : array of TCellMap; // �۲���
    PDMap   : array of TCellMap; // ����������������

procedure __CopyRow(ASheet: IXLSWorksheet; SRow, DRow: Integer);
var
    i: Integer;
begin
    for i := 1 to ASheet.UsedRange.LastCol + 1 do
        if ASheet.Cells[SRow, i].HasFormula then
            ASheet.Cells[SRow, i].Copy(ASheet.Cells[DRow, i])
        else
            ASheet.Cells[SRow, i].Copy(ASheet.Cells[DRow, i], xlPasteFormats);
end;

function __LastBlankRow(ASheet: IXLSWorksheet): Integer;
var
    i: Integer;
    S: string;
begin
    for i := ASheet.UsedRange.LastRow to 1 do
    begin
        S := Trim(VarToStr(ASheet.Cells[i, 1].Value));
        if S <> '' then
            Break;
    end;
    Result := i + 1;
end;

function __StrToVar(Str: string): Variant;
var
    d: Double;
begin
    // Result :=Null;
    if Trim(Str) = '' then
        Result := Null
    else if TryStrToFloat(Str, d) then
        Result := d
    else
        Result := Str;
end;

function __StrToDateVar(Str: String): Variant;
var
    d: TDateTime;
begin
    if Trim(Str) = '' then
        Result := Null
    else if TryStrToDateTime(Str, d) then
        Result := d
    else
        Result := Null;
end;

function __FindLastRecRow(Sht: IXLSWorksheet): Integer;
var
    iRow: Integer;
    S   : string;
begin
    Result := 0;
    for iRow := Sht.UsedRange.LastRow downto 1 do
    begin
        S := Trim(VarToStr(Sht.Cells[iRow, 1].Value));
        { todo:Ӧ�и���ļ������ж��Ƿ������һ����Ч��¼ }
        if S <> '' then
        begin
            Result := iRow;
            Break;
        end;
    end;
end;

function __FindLastDate(Sht: IXLSWorksheet): TDateTime;
var
    iRow: Integer;
    i   : Integer;
    S   : string;
    d   : TDateTime;
begin
    Result := 0;
    for i := Sht.UsedRange.LastRow downto 1 do
    begin
        S := Trim(VarToStr(Sht.Cells[i, 1].Value));
        if S <> '' then
            if TryStrToDateTime(S, d) then
            begin
                Result := d;
                Break;
            end;
    end;
end;

// ��ȡ�ϴι۲�����
function __GetLastDataRecord(Sht: IXLSWorksheet): Boolean;
var
    iRow: Integer;
    i   : Integer;
    S   : string;
    function ___CellValue(S: String): Double;
    begin
        Result := 0;
        TryStrToFloat(S, Result);
    end;

begin
    Result := false;
    if curMeter = nil then
        Exit;

    if (Length(MDMap) = 0) or (Length(PDMap) = 0) then
        Exit;

    iRow := __FindLastRecRow(Sht); // iRowδ������Ч��¼������Ҫ����ļ��
    if iRow <= 1 then              // ��nExcel�У�1�ǹ�����ĵ�һ�С���Ч�Ĺ۲����ݱ�������һ�ѱ�ͷ�����ԡ���
        Exit;

    for i := 0 to High(MDMap) do
        MDMap[i].LastRec := ___CellValue(VarToStr(Sht.Cells[iRow, MDMap[i].ShtCol].Value));

    for i := 0 to High(PDMap) do
        PDMap[i].LastRec := ___CellValue(VarToStr(Sht.Cells[iRow, PDMap[i].ShtCol].Value));
end;

constructor TfraInputDatas.Create(AOwner: TComponent);
begin
    inherited;
    InitGridHead;
    dtpDefault.Date := Now;
    FIssueList := TStringList.Create;
end;

destructor TfraInputDatas.Destroy;
begin
    FIssueList.Free;
    inherited;
end;

procedure TfraInputDatas.InitGridHead;
var
    i: Integer;
begin
    grdInput.Cells[0, 0] := '�۲�����';

    grdRecent.Cells[0, 0] := '��Ʊ��';
    grdRecent.Cells[1, 0] := '�۲�����';
    grdRecent.Cells[2, 0] := '��������';
    grdRecent.Cells[3, 0] := '������';
    grdRecent.Cells[4, 0] := '�������к�';
    grdRecent.ColWidths[2] := 250;
    grdRecent.ColWidths[3] := 250;
end;

procedure TfraInputDatas.piConfirmInputClick(Sender: TObject);
begin
    if curMeter.prjparams.groupid <> '' then
        PutGroupDataInSheet
    else
        PutDataInSheet;
end;

procedure TfraInputDatas.piReInputClick(Sender: TObject);
var
    i: Integer;
begin
    for i := 0 to grdInput.ColCount - 1 do
        grdInput.Cells[i, 1] := '';
    grdInput.Cells[0, 1] := formatdatetime('yyyy-mm-dd', dtpDefault.Date);
end;

procedure TfraInputDatas.piShowHisDataClick(Sender: TObject);
begin
//
end;

procedure TfraInputDatas.AddMeters;
var
    Meters: TMeterDefines;
    i     : Integer;
begin
    cmbMeterList.Clear;
    Meters := IAppServices.Meters as TMeterDefines;
    for i := 0 to Meters.Count - 1 do
        cmbMeterList.AddItem(Meters.items[i].DesignName, Meters.items[i]);
end;

procedure TfraInputDatas.cmbMeterListKeyPress(Sender: TObject; var Key: Char);
var
    mt: TMeterDefine;
begin
    if Key = #13 then
    begin
        if cmbMeterList.ItemIndex = -1 then
            ShowMessage('No such meter')
        else
        begin
            { Memo1.clear; }
            mt := TMeterDefine(cmbMeterList.items.Objects[cmbMeterList.ItemIndex]);
            { Memo1.lines.add(mt.DesignName);
            Memo1.lines.add('=================');
            Memo1.lines.add('Databook��' + mt.databook);
            Memo1.lines.add('DataSheet: ' + mt.DataSheet); }
            Prepare(mt.DesignName);
        end;
    end;
end;

procedure TfraInputDatas.Prepare(AName: string);
var
    mt  : TMeterDefine;
    i, n: Integer;
begin
    mt := (IAppServices.Meters as TMeterDefines).Meter[AName];
    curMeter := mt;
    { todo:do something if mt=nil }
    SetLength(MDMap, curMeter.DataSheetStru.MDs.Count);
    SetLength(PDMap, curMeter.DataSheetStru.PDs.Count);

    if curMeter.prjparams.groupid <> '' then
        PrepareGroup(curMeter.prjparams.groupid)
    else
    begin
        n := mt.DataSheetStru.MDs.Count + mt.PDDefines.Count + 1;
        grdInput.ColCount := n;

        for i := 0 to grdInput.ColCount - 1 do
            grdInput.Cells[i, 1] := '';

        for i := 0 to mt.DataSheetStru.MDs.Count - 1 do
        begin
            grdInput.Cells[i + 1, 0] := mt.DataSheetStru.MDs.items[i].Name;
            MDMap[i].DataName := mt.DataSheetStru.MDs.items[i].Name;
            MDMap[i].GrdCol := i + 1;
            MDMap[i].ShtCol := mt.DataSheetStru.MDs.items[i].Column;
        end;

        n := mt.DataSheetStru.MDs.Count + 1;
        for i := 0 to mt.PDDefines.Count - 1 do
        begin
            grdInput.Cells[i + n, 0] := mt.PDDefines.items[i].Name;
            PDMap[i].DataName := mt.DataSheetStru.PDs.items[i].Name;
            PDMap[i].GrdCol := i + n;
            PDMap[i].ShtCol := mt.DataSheetStru.PDs.items[i].Column;
        end;
    end;

    grdInput.Cells[0, 1] := formatdatetime('yyyy-mm-dd', dtpDefault.Date);

    // prepare workbook and worksheet
    if FMeterBook = nil then
        ExcelIO.OpenWorkbook(FMeterBook, TestBook)
    else if not ExcelIO.BookOpened(FMeterBook, TestBook) then
        ExcelIO.OpenWorkbook(FMeterBook, TestBook);
    { todo: do something if FMeterSheet is nil }
    if not ExcelIO.HasSheet(FMeterBook, mt.DataSheet) then
    begin
        ShowMessage('û���ڹ��������ҵ�����' + mt.DesignName + '�����ݱ�');
        grdInput.ColCount := 2;
        grdInput.Cells[1, 0] := '';
        FMeterSheet := nil;
    end
    else
        FMeterSheet := ExcelIO.GetSheet(FMeterBook, mt.DataSheet);
    { todo: load last record }
    if FMeterSheet <> nil then
        __GetLastDataRecord(FMeterSheet);
end;

procedure TfraInputDatas.PrepareGroup(AGroup: string);
var
    gi  : TMeterGroupItem;
    mt  : TMeterDefine;
    i, j: Integer;
    k, n: Integer;
begin
    gi := (IAppServices.MeterGroups as TMeterGroup).ItemByName[AGroup];
    { todo:do something if gi=nil }
    // count columns
    n := 0;
    j := 0;
    k := 0;
    SetLength(MDMap, 100);
    SetLength(PDMap, 100);
    grdInput.ColCount := 100;

    for i := 0 to gi.Count - 1 do
    begin
        mt := (IAppServices.Meters as TMeterDefines).Meter[gi.items[i]];
        with mt.DataSheetStru do
        begin
            n := n + MDs.Count + PDs.Count;
            j := j + MDs.Count;
            k := k + PDs.Count;
        end;
    end;
    inc(n); // add dtscale col
    grdInput.ColCount := n;
    SetLength(MDMap, j);
    SetLength(PDMap, k);

    for i := 0 to grdInput.ColCount - 1 do
        grdInput.Cells[i, 1] := '';

    n := 1;
    for i := 0 to gi.Count - 1 do
    begin
        mt := (IAppServices.Meters as TMeterDefines).Meter[gi.items[i]];
        with mt.DataSheetStru do
            for j := 0 to MDs.Count - 1 do
            begin
                grdInput.Cells[n, 0] := mt.DesignName + ':' + MDs.items[j].Name;
                MDMap[n - 1].MeterName := mt.DesignName;
                MDMap[n - 1].DataName := MDs.items[j].Name;
                MDMap[n - 1].ShtCol := MDs.items[j].Column;
                MDMap[n - 1].GrdCol := n;
                inc(n);
            end;
    end;

    k := 0;
    for i := 0 to gi.Count - 1 do
    begin
        mt := (IAppServices.Meters as TMeterDefines).Meter[gi.items[i]];
        with mt.DataSheetStru do
            for j := 0 to PDs.Count - 1 do
            begin
                grdInput.Cells[n, 0] := mt.DesignName + ':' + PDs.items[j].Name;
                PDMap[k].MeterName := mt.DesignName;
                PDMap[k].DataName := PDs.items[j].Name;
                PDMap[k].ShtCol := PDs.items[j].Column;
                PDMap[k].GrdCol := n;
                inc(k);
                inc(n);
            end;
    end;
end;

procedure TfraInputDatas.PutDataInSheet;
var
    i, iRow: Integer;
    n, j   : Integer;
    S      : string;
    sInput : string;
    sPD    : string;
begin
    { todo:����Ӧ���кϷ��Լ�飬ȷ������������ǺϷ���ֵ }
    if CheckInput = false then
    begin
        ShowMessage(FIssueList.text);
        Exit;
    end;
    { todo:����ڱ���֮ǰӦ�ý���ģ�����޼�� }
    { todo:��Ҫ�������������ݵ����� }
    // ����������һ��
    iRow := __LastBlankRow(FMeterSheet);

    // copy format and formula
    // copy fomula
    n := curMeter.DataSheetStru.MDs.Count + 1;
    if iRow > curMeter.DataSheetStru.DTStartRow + 1 then
        j := curMeter.DataSheetStru.DTStartRow + 1 // ѡ���ֵ�ĵڶ��У���ʽ������
    else
        j := curMeter.DataSheetStru.DTStartRow; // ʵ�ڲ��У�ѡ���ֵ��

    __CopyRow(FMeterSheet, j, iRow);

    // dtscale
    FMeterSheet.Cells[iRow, 1].Value := StrToDateTime(grdInput.Cells[0, 1]);

    // fill datas
    { todo: use MDMap array to do this }
    sInput := '';
    with curMeter.DataSheetStru.MDs do
        for i := 0 to Count - 1 do
        begin
            FMeterSheet.Cells[iRow, items[i].Column].Value := StrToFloat(grdInput.Cells[i + 1, 1]);
            sInput := sInput + grdInput.Cells[i + 1, 1] + '; ';
        end;

    // read calculate result: pd datas
    { todo: use PDMap array todo this }
    sPD := '';
    with curMeter.PDDefines do
        for i := 0 to Count - 1 do
        begin
            { todo:��Ҫ���ǵ�Worksheet��Ԫ���в�����ֵ�����⣬����ִ��󣬸�������ʾ�û�����������
            ʾ }
            { todo:����������֮��Ӧ����������飬�ж��Ƿ���Ҫ��ʾ�û��˲�򸴲� }
            grdInput.Cells[i + n, 1] :=
                FormatFloat('0.00', FMeterSheet.Cells[iRow, items[i].Column].Value);
            { �����Ѿ����ص�PAMap.LastRec�У���ʱ���Խ���Ԥ���ж� }

            sPD := sPD + grdInput.Cells[i + n, 1] + '; ';
        end;

    FMeterBook.Save;
    AddRecent(curMeter.DesignName, grdInput.Cells[0, 1], sInput, sPD, iRow);
end;

procedure TfraInputDatas.PutGroupDataInSheet;
var
    i, iRow: Integer;
    j      : Integer;
    sInput : string;
    sResult: string;
    S      : string;
begin
    { todo:����������� }
    // ������ҿ���
    iRow := __LastBlankRow(FMeterSheet);

    // copy format and formula
    if iRow > curMeter.DataSheetStru.DTStartRow + 1 then
        j := curMeter.DataSheetStru.DTStartRow + 1
    else
        j := curMeter.DataSheetStru.DTStartRow;

    __CopyRow(FMeterSheet, j, iRow);

    // dtscale
    FMeterSheet.Cells[iRow, 1].Value := StrToDateTime(grdInput.Cells[0, 1]);

    // fill datas
    sInput := '';
    for i := Low(MDMap) to High(MDMap) do
    begin
        FMeterSheet.Cells[iRow, MDMap[i].ShtCol].Value :=
            StrToFloat(grdInput.Cells[MDMap[i].GrdCol, 1]);
        sInput := sInput + grdInput.Cells[MDMap[i].GrdCol, 1] + '; ';
    end;
    sResult := '';
    for i := Low(PDMap) to High(PDMap) do
    begin
        grdInput.Cells[PDMap[i].GrdCol, 1] :=
            FormatFloat('0.00', FMeterSheet.Cells[iRow, PDMap[i].ShtCol].Value);
        { Ԥ���ж� }

        sResult := sResult + grdInput.Cells[PDMap[i].GrdCol, 1] + '; ';
    end;
    FMeterBook.Save;
    AddRecent(curMeter.DesignName, grdInput.Cells[0, 1], sInput, sResult, iRow);
end;

procedure TfraInputDatas.AddRecent(AName: string; ADate: string; AInput: string;
    ACalcRes: string; ARow: Integer);
var
    i: Integer;
    procedure AddData(iRow: Integer);
    begin
        grdRecent.Cells[0, iRow] := AName;
        grdRecent.Cells[1, iRow] := ADate;
        grdRecent.Cells[2, iRow] := AInput;
        grdRecent.Cells[3, iRow] := ACalcRes;
        grdRecent.Cells[4, iRow] := IntToStr(ARow);
    end;

begin
    for i := 1 to grdRecent.RowCount - 1 do
    begin
        if grdRecent.Cells[0, i] = '' then
        begin
            AddData(i);
            Exit;
        end;
    end;
    grdRecent.RowCount := grdRecent.RowCount + 1;
    AddData(grdRecent.RowCount - 1);
end;

function TfraInputDatas.CheckInput: Boolean;
var
    i : Integer;
    S : string;
    d : Double;
    dt: TDateTime;
begin
    Result := false;
    FIssueList.Clear;

    // load last data record
    // __getlastdatarecord(fmeterworksheet);

    // Check DTScale
    S := grdInput.Cells[0, 1];
    if Trim(S) = '' then
        FIssueList.Add('û����������')
    else
    begin
        if TryStrToDateTime(S, dt) = false then
            FIssueList.Add('��������ڸ�ʽ')
        else // ��������Ƿ�������һ�����ݣ����������������Ӧ�����£��ݲ�֧�ֲ�������
            if dt < __FindLastDate(FMeterSheet) then
                FIssueList.Add('��������ڲ����������ڡ���������ʱ��֧�ֲ����ȥ�����ݡ�');
    end;

    // Check input data
    for i := 0 to High(MDMap) do
    begin
        // check every md item
        S := Trim(grdInput.Cells[MDMap[i].GrdCol, 1]);
        if S = '' then { todo:����һ�����أ�������ֹ������ }
            FIssueList.Add(MDMap[i].DataName + ': û����������')
        else if TryStrToFloat(S, d) then
            // check data range
        else
            FIssueList.Add(MDMap[i].DataName + ':' + S + '������Ч����');
    end;

    // True or False? this is a question.
    Result := FIssueList.Count = 0;
end;

initialization

SetLength(MDMap, 0);
SetLength(PDMap, 0);

finalization

SetLength(MDMap, 0);
SetLength(PDMap, 0);

end.
