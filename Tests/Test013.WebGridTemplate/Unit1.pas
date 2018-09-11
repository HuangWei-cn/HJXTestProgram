unit Unit1;

interface

uses
    System.Classes, System.Types, System.SysUtils, System.Variants, System.Generics.Collections,
    System.RegularExpressions;

type

    { ����нṹ����ͷ��������ʹ�ô˽ṹ }
    TGridTemplateRow = record
        Cols: TArray<String>;
    end;

    { ���ģ����󣬾��н��������Ĺ��� }
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
    {�����������ʽ���������� %DesignName% �� %PD1.Name% ���͵����TRegEx.Matches��ʽִ��ʱ��
    ���ؽ���ɷ��飬��%PD1.Name%Ϊ������Ϊ%PD1.Name%,PD1.Name,PD1,Name����}
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
    // �����#13#10���ַ�
    AStr := Trim(AStr);
    AStr := StringReplace(AStr, #13, '', [rfReplaceAll]);
    AStr := StringReplace(AStr, #10, '', [rfReplaceAll]);
    Rows := AStr.Split([';']);
    // ���ÿһ�У�����ð��ǰ�ı�ʶ���жϵ�ǰ��Ϊ��һ��
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
