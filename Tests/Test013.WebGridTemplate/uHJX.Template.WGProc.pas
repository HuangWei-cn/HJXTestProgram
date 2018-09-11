{ -----------------------------------------------------------------------------
 Unit Name: uHJX.Template.WGProc
 Author:    ��ΰ
 Date:      14-����-2018
 Purpose:   WebGridģ�崦��Ԫ
 ����Ԫ���������������õ�ָ��ģ���ϣ�����һ��WebGrid��HTML���롣����Ԫ��Ҫ����
 ģ�嵥Ԫ��Meters��Ԫ�����ݷ��ʶ���ȡ�

 ����Ԫ�Ĵ���ʽ������ֲ��Excel���ݱ�Ĵ�����Զ�̬�б�Ӧ���㹻�ˣ������ڣ�
 �����ñ�ģ���ʽ����ʾEhGrid�ı�ͷ��������ʾ��

 History:  2018-08-15 �����ɹ�������ʾê���������������ݲ�֧��������
            2018-08-16 ���Դ����������ˣ�ͬʱ��ģ��֧�ֵ��������ͽ��������ú�
            ��飬ģ��ֻ֧����ȷ���������͡�
----------------------------------------------------------------------------- }
{ done: ������ݸ�ʽ���Զ��ж������ǲ������ڻ�������ʱ�䣻���ݲ����Ҷ��� }
{ todo: ���������飬Ӧ֧�ֲ�ͬ�����ĸ�����������ǽ�����Meter1.DesignName }
{ todo: ֧������ʱ��� }
{ todo: GenGrid����ֵ�У�TitleӦ�ÿ�ѡ }
unit uHJX.Template.WGProc;

interface

uses
    System.Classes, System.SysUtils, System.DateUtils,
    uHJX.Template.WebGrid, uHJX.Classes.Meters, uHJX.Intf.AppServices, uHJX.Intf.Datas;

function GenGrid(grdTemp: TGridTemplate; AMeter: TMeterDefine): String;

implementation

uses
    System.RegularExpressions, uWebGridCross,
    Data.DB, Datasnap.DBClient;

const
    { �����������ʽ���������� %DesignName% �� %PD1.Name% ��%Meter1.PD1.Name%��%Meter1.DesignName% ���͵��
      ��TRegEx.Matches��ʽִ��ʱ�����ؽ���ɷ���:
            ====New match====================================
            Match #0: %DesignName%
            Group: 0
            Value 0: %DesignName%
            Value 1: DesignName
            ====New match====================================
            Match #1: %PD1.Name%
            Group: 1
            Value 0: %PD1.Name%
            Value 1: PD1.Name
            Value 2:
            Value 3:
            Value 4:
            Value 5: PD1.Name
            Value 6: PD
            Value 7: 1
            Value 8: Name
            ====New match====================================
            Match #2: %Meter1.PD1.Name%
            Group: 2
            Value 0: %Meter1.PD1.Name%
            Value 1: Meter1.PD1.Name
            Value 2: Meter1.
            Value 3: Meter
            Value 4: 1
            Value 5: PD1.Name
            Value 6: PD
            Value 7: 1
            Value 8: Name
            ====New match====================================
            Match #3: %Meter1.DesignName%
            Group: 3
            Value 0: %Meter1.DesignName%
            Value 1: Meter1.DesignName
            Value 2: Meter1.
            Value 3: Meter
            Value 4: 1
            Value 5: DesignName
 }
    RegExStr =
        '%([a-zA-Z]*|((Meter)([1-9][0-9]*)\.)?(DesignName|(PD|MD)([1-9][0-9]*)\.(Name|Alias|DataUnit)))%';

    { �����������ʽ���������е�ƥ�䣺%DTScale|Annotation%, %PD1%, %Meter1.PD1%�����������ƥ��
      �����Ϊ��
            ====New match====================================
            Match #0: %dtscale%
            Group: 0
            Value 0: %dtscale%
            Value 1: dtscale
            ====New match====================================
            Match #1: %pd1%
            Group: 1
            Value 0: %pd1%
            Value 1: pd1
            Value 2:
            Value 3:
            Value 4:
            Value 5: pd
            Value 6: 1
            ====New match====================================
            Match #2: %meter1.pd1%
            Group: 2
            Value 0: %meter1.pd1%
            Value 1: meter1.pd1
            Value 2: meter1.
            Value 3: meter
            Value 4: 1
            Value 5: pd
            Value 6: 1
 }
    DataRowRegStr = '%(DTScale|Annotation|((Meter)(n|[1-9][0-9]*)\.)?(PD|MD)([1-9][0-9]*))%';

type
    TDataCell = record
        TempStr: string;   // ģ�嵥Ԫ������
        Specifier: String; // ռλ��
        Field: TField;     // ��Ӧ�ֶ�
        function GetValue: Variant;
    end;

var
    RegEx    : TRegEx;
    RegExData: TRegEx;
    MyColl   : TMatchCollection;
    MyGrps   : TGroupCollection;

function TDataCell.GetValue: Variant;
begin
    { todo:��Field���������ͣ���Ӧ�ж��Ƿ���Ҫ��ʾʱ�䡣����Ӧ����ʾ���ڡ� }
    if Field = nil then
        Result := TempStr
    else if Field.DataType = ftDateTime then
    begin
        //���ֻ�����ڲ��֣����ʽΪyyyy-mm-dd��������ʱ�䲿�֣������ʱ��
        if DateOf(Field.AsDateTime) = Field.AsDateTime then
            Result := FormatDateTime('yyyy-mm-dd', Field.AsDateTime)
        else
            Result := FormatDateTime('yyyy-mm-dd hh:mm', Field.AsDateTime);
    end
    else
        Result := Field.Value;
end;

{ -----------------------------------------------------------------------------
  Procedure  : ReplaceSpecifiers
  Description: �滻ռλ���������������滻���������滻����ͱ�ͷռλ��
----------------------------------------------------------------------------- }
function ReplaceSpecifiers(AStr: String; AMeter: TMeterDefine; AsGroup: Boolean = False): String;
var
    i, j  : Integer;
    k     : Integer;
    sParam: String;
    S     : String;
    iPD   : Integer;
    DF    : TDataDefine;
    mt    : TMeterDefine;
begin
    Result := AStr;
    MyColl := RegEx.Matches(AStr); // ȡ������ƥ����
    if MyColl.Count = 0 then       // Ϊ����ԭ�����
        Exit;

    // ͨ��ֻ��һ���Ҳ˵��׼ʲôʱ����еĶ��ˣ����磺%MeterType%%DesignName%�۲����ݱ�
    for i := 0 to MyColl.Count - 1 do
    begin
        // MyColl.Item[i].Value; //�����ռλ��������
        // MyGrps.Item[1]��ȥ��%%����
        MyGrps := MyColl.item[i].Groups;
        // �������Ԫ�������ж����������ͣ��μ����ʽ˵��������
        case MyGrps.Count of
            2: // ��Ӧ��ʽΪ%DesignName%��
                begin
                    { todo:�迼��%GroupName%����� }
                    if SameText(MyGrps.item[1].Value, 'GroupName') then
                        Result := StringReplace(Result, MyColl.item[i].Value,
                            AMeter.PrjParams.GroupID, [rfReplaceAll])
                    else
                    begin
                        sParam := AMeter.ParamValue(MyGrps.item[1].Value);
                        if sParam = '' then
                            sParam := ' ';
                    { if sParam = '' then
                        sParam := Format('����%s�����ڻ���ֵ', [MyGrps.item[1].Value]); }
                        Result := StringReplace(Result, MyColl.item[i].Value, sParam,
                            [rfReplaceAll, rfIgnoreCase]);
                    end;
                end;

            6: // ��Ӧ��ʽΪ%Meter1.DesignName%�������ʽ��������飬���������飬��ʹ��Ameter.DesignName
               // ʵ�ʿ���չ��Meter�����������У����õĳ���DesignName������Deep��Stake��Elevation�ȼ���
                begin
                    if AsGroup then // ��������鴦���������������滻ռλ��
                    begin
                        j := StrToInt(MyGrps.item[4].Value); // �������
                        S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                        mt := ExcelMeters.Meter[S];
                        if mt <> nil then
                            Result := StringReplace(Result, MyColl.item[i].Value, mt.DesignName,
                                [rfReplaceAll]);
                    end
                    else // �����ø��������������滻ռλ��
                        Result := StringReplace(Result, MyColl.item[i].Value, AMeter.DesignName,
                            [rfReplaceAll]);
                end;

            9: // ��Ӧ��ʽΪ%PD1.Name%��%Meter1.PD1.Name%
                begin
                    if MyGrps.item[2].Value <> '' then // %Meter1.PD1.Name%
                    begin
                        if AsGroup then
                        begin
                            j := StrToInt(MyGrps.item[4].Value); // ���ֵ��Meter��������֣����ڼ���Meter
                            S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                            mt := ExcelMeters.Meter[S]; // �����ݲ��������������⣬ȫ����AMeter���
                        end
                        else
                            mt := AMeter;
                    end
                    else
                        mt := AMeter;

                    k := StrToInt(MyGrps.item[7].Value); // ���ֵ��PD��MD��������֣����ڼ���PD��
                    if UpperCase(MyGrps.item[6].Value) = 'PD' then
                        DF := mt.DataSheetStru.PDs.Items[k - 1]^
                    else
                        DF := mt.DataSheetStru.MDs.Items[k - 1]^;

                    S := UpperCase(MyGrps.item[8].Value);
                    if SameText(S, 'Name') then
                        sParam := DF.Name
                    else if SameText(S, 'Alias') then
                        sParam := DF.Alias
                    else if SameText(S, 'DataUnit') then
                        sParam := DF.DataUnit;

                    Result := StringReplace(Result, MyColl.item[i].Value, sParam, [rfReplaceAll]);
                end;
        end;

    end;
end;

procedure ProcDataRow(grdTemp: TGridTemplate; AMeter: TMeterDefine; var DataRow: TArray<TDataCell>;
    DS: TClientDataSet; AsGroup: Boolean = False);
var
    iCol: Integer;
    i, j: Integer;
    S   : String;
begin
    for iCol := 0 to grdTemp.ColCount - 1 do
    begin
        DataRow[iCol].TempStr := S;
        DataRow[iCol].Field := nil;
        DataRow[iCol].Specifier := '';

        S := grdTemp.DataCell[iCol];
        MyColl := RegExData.Matches(S);
        if MyColl.Count > 0 then
        begin
            MyGrps := MyColl.item[0].Groups; // ����������ÿ�����ݵ�Ԫ��ֻ����һ��ռλ��������ռλ���Ժ���˵
            case MyGrps.Count of
                2:
                    begin
                        if SameText(MyGrps.item[1].Value, 'DTScale') then
                            DataRow[iCol].Field := DS.FindField('DTScale')
                        else if SameText(MyGrps.item[1].Value, 'Annotation') then
                            DataRow[iCol].Field := DS.FindField('Annotation');
                    end;

                7:
                    if MyGrps.item[3].Value = '' then // pd1����ʽ
                        DataRow[iCol].Field := DS.FindField(MyGrps.item[1].Value)
                    else // Meter1.PD1����ʽ
                    begin
                        // ���bGroup=false����DS��û��DesignName.PD1���͵��ֶ�����ֻ��PD1��ʽ��
                        // ��Ϊ��bGroup=Falseʱ����ѯ���ݼ�ֻ��ѯ��֧�������ݣ�ֻ��ΪTrueʱ���Ž���
                        // �����ݲ�ѯ
                        if AsGroup then
                        begin
                            j := StrToInt(MyGrps.item[4].Value); // Meter�����
                            S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                            // ��Ʊ��
                        // S:DesignName.PD1����ʽ
                            S := S + '.' + MyGrps.item[5].Value + MyGrps.item[6].Value;
                            DataRow[iCol].Field := DS.FindField(S);
                        // �������������ֶε�NameΪDesignName.PDn��ʽ������Ҫ���ҵ���j֧��������Ʊ�ţ�
                        end
                        else
                        begin
                            S := MyGrps.item[5].Value + MyGrps.item[6].Value;
                            DataRow[iCol].Field := DS.FindField(S);
                        end;
                    end;
            end;
        end;
    end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GenGrid
  Description: ���ݱ��ģ��ͼ�������������ɸ������Ĺ۲����ݱ�
----------------------------------------------------------------------------- }
function GenGrid(grdTemp: TGridTemplate; AMeter: TMeterDefine): String;
var
    i         : Integer;
    iRow, iCol: Integer;
    S         : String;
    wcv       : TWebCrossView;
    v         : array of Variant;
    DR        : TArray<TDataCell>;
    DS        : TClientDataSet;
    bGroup    : Boolean; // �ж��Ƿ��鴦��
    bGetData  : Boolean; // �ж��Ƿ�ɹ�ȡ������

    procedure SetColumnAlignment;
    var
        ii: Integer;
    begin
        for ii := 0 to grdTemp.ColCount - 1 do
            if DR[ii].Field <> nil then
                case DR[ii].Field.DataType of
                    ftFloat:
                        wcv.ColHeader[ii].Align := taRightJustify;
                end;
    end;

begin
    Result := '';
    bGroup := False;
    // ������������Ƿ��Ӧ
    if grdTemp.MeterType <> '' then
        if grdTemp.MeterType <> AMeter.Params.MeterType then
            raise Exception.CreateFmt('"%s"��֧��%s���������͡�ģ����������Ϊ%s����ǰ��������Ϊ%s',
                [grdTemp.Name, AMeter.DesignName, grdTemp.MeterType,
                AMeter.Params.MeterType]);

    // ���ģ��֧�������飬������������ĳ���飬������鴦��
    if grdTemp.ApplyToGroup and (AMeter.PrjParams.GroupID <> '') then
        bGroup := True;

    // ����Title, �����ǽ�ÿ���е�ռλ���滻Ϊ��Ӧ���������ԣ�����ռλ����ԭ�����
    for i := 0 to grdTemp.Titles.Count - 1 do
    begin
        S := ReplaceSpecifiers(grdTemp.Titles[i], AMeter, bGroup);
        Result := Result + S + #13#10;
    end;

    wcv := TWebCrossView.Create;
    try
        wcv.TitleRows := grdTemp.HeadRowCount;
        wcv.TitleCols := grdTemp.ColCount;
        wcv.ColCount := grdTemp.ColCount;
        SetLength(v, grdTemp.ColCount);
        // �����ͷ: ����ģ���ͷ��Ԫ�����ݣ��ò����滻ռλ��������������ӵ�WebCrossView��
        for iRow := 0 to High(grdTemp.Heads) do
        begin
            for iCol := 0 to High(grdTemp.Heads[iRow].Cols) do
            begin
                S := ReplaceSpecifiers(grdTemp.Heads[iRow].Cols[iCol], AMeter, bGroup);
                // Result := Result + S + #9;
                v[iCol] := S;
            end;
            // Result := Result + #13#10;
            wcv.AddRow(v);
        end;

        // ����������:
        // ȡ�ع۲����ݼ�
        DS := TClientDataSet.Create(nil);
        if bGroup then
            bGetData := IAppServices.ClientDatas.GetGroupAllPDDatas(AMeter.PrjParams.GroupID, DS)
        else
            bGetData := IAppServices.ClientDatas.GetAllPDDatas(AMeter.DesignName, DS);

        if bGetData then
        begin
            // ��������������
            SetLength(DR, grdTemp.ColCount);
            // ����ģ�壬���������е�Ԫ��
            ProcDataRow(grdTemp, AMeter, DR, DS, bGroup);
            // ����DR���ֶε��������������ж���
            SetColumnAlignment;
            // �������
            DS.First;
            repeat
                for iCol := 0 to grdTemp.ColCount - 1 do
                    v[iCol] := DR[iCol].GetValue;
                wcv.AddRow(v);
                DS.Next;
            until DS.Eof;
        end;
        Result := wcv.CrossPage;
    finally
        wcv.Free;
        SetLength(v, 0);
        SetLength(DR, 0);
        DS.Free;
    end;
end;

initialization

RegEx := TRegEx.Create(RegExStr, [roIgnoreCase]);
RegExData := TRegEx.Create(DataRowRegStr, [roIgnoreCase]);

end.
