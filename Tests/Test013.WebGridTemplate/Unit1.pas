unit Unit1;

interface

uses
    System.Classes, System.Types, System.SysUtils, System.Variants, System.Generics.Collections,
    System.RegularExpressions;

type

    { 表格行结构，表头和数据行使用此结构 }
    TGridTemplateRow = record
        Cols: TArray<String>;
    end;

    { 表格模板对象，具有解析变量的功能 }
    TGridTemplate = class
    private
        FTemplateStr: String;
        FName       : string;
    protected
        procedure SetTemplateStr(AStr: string);
    public
        Titles  : TStrings;
        Heads   : TArray<TGridTemplateRow>;
        DataRows: TArray<TGridTemplateRow>;
        ColCount: Integer;
        constructor Create;
        destructor Destroy; override;
        property Name: string read FName write FName;
        property TemplateStr: string read FTemplateStr write SetTemplateStr;
    end;

implementation
const
    {下面的正则表达式适用于类似 %DesignName% 和 %PD1.Name% 类型的项。当TRegEx.Matches方式执行时，
    返回结果可分组，以%PD1.Name%为例，分为%PD1.Name%,PD1.Name,PD1,Name四项}
    RegExStr = '%(([a-zA-Z0-9]*)[\.]?([a-zA-Z0-9]*))%';

constructor TGridTemplate.Create;
begin
    inherited;
    Titles := TStringList.Create;
end;

destructor TGridTemplate.Destroy;
var
    i: Integer;
begin
    Titles.free;
    if Length(Heads) > 0 then
        for i := 0 to High(Heads) do
            SetLength(Heads[i].Cols, 0);
    SetLength(Heads, 0);

    if Length(DataRows) > 0 then
        for i := 0 to High(DataRows) do
            SetLength(DataRows[i].Cols, 0);
    SetLength(DataRows, 0);

    inherited;
end;

procedure TGridTemplate.SetTemplateStr(AStr: string);
var
    Rows       : TArray<string>;
    i, j, k    : Integer;
    id, content: string;
    Cols       : TArray<String>;
begin
    // 先清除#13#10等字符
    AStr := Trim(AStr);
    AStr := StringReplace(AStr, #13, '', [rfReplaceAll]);
    AStr := StringReplace(AStr, #10, '', [rfReplaceAll]);
    Rows := AStr.Split([';']);
    // 检查每一行，根据冒号前的标识符判断当前行为哪一类
    for i := 0 to high(Rows) do
    begin
        j := pos(':', Rows[i]);
        if j = 0 then
            continue;
        id := copy(Rows[i], 1, j - 1);
        content := copy(Rows[i], j + 1, Length(Rows[i]) - j);
        if SameText(id, 'Title') then
            Titles.add(content)
        else if SameText(id, 'Head') then
        begin
            Cols := content.Split(['|']);
            SetLength(Heads, Length(Heads) + 1);
            SetLength(Heads[High(Heads)].Cols, High(Cols));
            Heads[High(Heads)].Cols := Cols;
        end
        else if SameText(id, 'DataRow') then
        begin
            Cols := content.Split(['|']);
            SetLength(DataRows, Length(DataRows) + 1);
            DataRows[High(DataRows)].Cols := Cols;
            ColCount := High(Cols) - Low(Cols) + 1;
        end;
    end;
    SetLength(Rows, 0);
    SetLength(Cols, 0);
end;

end.
