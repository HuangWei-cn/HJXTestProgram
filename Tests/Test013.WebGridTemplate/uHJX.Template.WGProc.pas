{ -----------------------------------------------------------------------------
 Unit Name: uHJX.Template.WGProc
 Author:    黄伟
 Date:      14-八月-2018
 Purpose:   WebGrid模板处理单元
 本单元将仪器、数据套用到指定模板上，返回一个WebGrid的HTML代码。本单元需要引用
 模板单元、Meters单元、数据访问对象等。

 本单元的处理方式可以移植到Excel数据表的处理，针对动态行表，应该足够了；甚至于，
 可以用本模板格式化显示EhGrid的表头和数据显示。

 History:  2018-08-15 初步成功，可显示锚索、多点等仪器，暂不支持仪器组
            2018-08-16 可以处理仪器组了，同时对模板支持的仪器类型进行了设置和
            检查，模板只支持正确的仪器类型。
----------------------------------------------------------------------------- }
{ done: 表格数据格式：自动判断日期是采用日期还是日期时间；数据部分右对齐 }
{ todo: 对于仪器组，应支持不同仪器的各项参数，而非仅仅是Meter1.DesignName }
{ todo: 支持数据时间段 }
{ todo: GenGrid返回值中，Title应该可选 }
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
    { 下面的正则表达式适用于类似 %DesignName% 、 %PD1.Name% 、%Meter1.PD1.Name%、%Meter1.DesignName% 类型的项。
      当TRegEx.Matches方式执行时，返回结果可分组:
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

    { 下面的正则表达式用于数据行的匹配：%DTScale|Annotation%, %PD1%, %Meter1.PD1%这三类情况，匹配
      后分组为：
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
        TempStr: string;   // 模板单元格内容
        Specifier: String; // 占位符
        Field: TField;     // 对应字段
        function GetValue: Variant;
    end;

var
    RegEx    : TRegEx;
    RegExData: TRegEx;
    MyColl   : TMatchCollection;
    MyGrps   : TGroupCollection;

function TDataCell.GetValue: Variant;
begin
    { todo:若Field是日期类型，则应判断是否需要显示时间。否则应仅显示日期。 }
    if Field = nil then
        Result := TempStr
    else if Field.DataType = ftDateTime then
    begin
        //如果只有日期部分，则格式为yyyy-mm-dd；若包含时间部分，则加上时间
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
  Description: 替换占位符，用仪器参数替换，本方法替换标题和表头占位符
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
    MyColl := RegEx.Matches(AStr); // 取回所有匹配项
    if MyColl.Count = 0 then       // 为零则原文输出
        Exit;

    // 通常只有一项，但也说不准什么时候就有的多了，比如：%MeterType%%DesignName%观测数据表
    for i := 0 to MyColl.Count - 1 do
    begin
        // MyColl.Item[i].Value; //这个是占位符的内容
        // MyGrps.Item[1]是去掉%%的项
        MyGrps := MyColl.item[i].Groups;
        // 根据组的元素数量判断是哪种类型，参见表达式说明和样例
        case MyGrps.Count of
            2: // 对应型式为%DesignName%，
                begin
                    { todo:需考虑%GroupName%的情况 }
                    if SameText(MyGrps.item[1].Value, 'GroupName') then
                        Result := StringReplace(Result, MyColl.item[i].Value,
                            AMeter.PrjParams.GroupID, [rfReplaceAll])
                    else
                    begin
                        sParam := AMeter.ParamValue(MyGrps.item[1].Value);
                        if sParam = '' then
                            sParam := ' ';
                    { if sParam = '' then
                        sParam := Format('参数%s不存在或无值', [MyGrps.item[1].Value]); }
                        Result := StringReplace(Result, MyColl.item[i].Value, sParam,
                            [rfReplaceAll, rfIgnoreCase]);
                    end;
                end;

            6: // 对应型式为%Meter1.DesignName%，这个形式针对仪器组，若非仪器组，则使用Ameter.DesignName
               // 实际可扩展到Meter的所有属性中，常用的除了DesignName，还有Deep，Stake，Elevation等几项
                begin
                    if AsGroup then // 如果进行组处理，则用组内仪器替换占位符
                    begin
                        j := StrToInt(MyGrps.item[4].Value); // 仪器序号
                        S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                        mt := ExcelMeters.Meter[S];
                        if mt <> nil then
                            Result := StringReplace(Result, MyColl.item[i].Value, mt.DesignName,
                                [rfReplaceAll]);
                    end
                    else // 否则用给定的仪器参数替换占位符
                        Result := StringReplace(Result, MyColl.item[i].Value, AMeter.DesignName,
                            [rfReplaceAll]);
                end;

            9: // 对应形式为%PD1.Name%和%Meter1.PD1.Name%
                begin
                    if MyGrps.item[2].Value <> '' then // %Meter1.PD1.Name%
                    begin
                        if AsGroup then
                        begin
                            j := StrToInt(MyGrps.item[4].Value); // 这个值是Meter后面的数字，即第几个Meter
                            S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                            mt := ExcelMeters.Meter[S]; // 这里暂不考虑仪器组问题，全部用AMeter替代
                        end
                        else
                            mt := AMeter;
                    end
                    else
                        mt := AMeter;

                    k := StrToInt(MyGrps.item[7].Value); // 这个值是PD或MD后面的数字，即第几个PD项
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
            MyGrps := MyColl.item[0].Groups; // 这里限制了每个数据单元格只能有一个占位符，更多占位符以后再说
            case MyGrps.Count of
                2:
                    begin
                        if SameText(MyGrps.item[1].Value, 'DTScale') then
                            DataRow[iCol].Field := DS.FindField('DTScale')
                        else if SameText(MyGrps.item[1].Value, 'Annotation') then
                            DataRow[iCol].Field := DS.FindField('Annotation');
                    end;

                7:
                    if MyGrps.item[3].Value = '' then // pd1的型式
                        DataRow[iCol].Field := DS.FindField(MyGrps.item[1].Value)
                    else // Meter1.PD1的形式
                    begin
                        // 如果bGroup=false，则DS中没有DesignName.PD1类型的字段名，只有PD1形式的
                        // 因为当bGroup=False时，查询数据集只查询单支仪器数据；只有为True时，才进行
                        // 组数据查询
                        if AsGroup then
                        begin
                            j := StrToInt(MyGrps.item[4].Value); // Meter的序号
                            S := MeterGroup.ItemByName[AMeter.PrjParams.GroupID].Items[j - 1];
                            // 设计编号
                        // S:DesignName.PD1的形式
                            S := S + '.' + MyGrps.item[5].Value + MyGrps.item[6].Value;
                            DataRow[iCol].Field := DS.FindField(S);
                        // 对于组仪器，字段的Name为DesignName.PDn格式，故需要先找到第j支仪器的设计编号，
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
  Description: 根据表格模板和监测仪器对象，生成该仪器的观测数据表
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
    bGroup    : Boolean; // 判断是否按组处理
    bGetData  : Boolean; // 判断是否成功取回数据

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
    // 检查仪器类型是否对应
    if grdTemp.MeterType <> '' then
        if grdTemp.MeterType <> AMeter.Params.MeterType then
            raise Exception.CreateFmt('"%s"不支持%s的仪器类型。模板仪器类型为%s，当前仪器类型为%s',
                [grdTemp.Name, AMeter.DesignName, grdTemp.MeterType,
                AMeter.Params.MeterType]);

    // 如果模板支持仪器组，且仪器归属于某个组，则进行组处理
    if grdTemp.ApplyToGroup and (AMeter.PrjParams.GroupID <> '') then
        bGroup := True;

    // 处理Title, 方法是将每行中的占位符替换为相应的仪器属性，若无占位符则原文输出
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
        // 处理表头: 解析模板表头单元格内容，用参数替换占位符，将行内容添加到WebCrossView中
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

        // 处理数据行:
        // 取回观测数据集
        DS := TClientDataSet.Create(nil);
        if bGroup then
            bGetData := IAppServices.ClientDatas.GetGroupAllPDDatas(AMeter.PrjParams.GroupID, DS)
        else
            bGetData := IAppServices.ClientDatas.GetAllPDDatas(AMeter.DesignName, DS);

        if bGetData then
        begin
            // 设置数据行数组
            SetLength(DR, grdTemp.ColCount);
            // 解析模板，设置数据行单元格
            ProcDataRow(grdTemp, AMeter, DR, DS, bGroup);
            // 根据DR中字段的数据类型设置列对齐
            SetColumnAlignment;
            // 添加数据
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
