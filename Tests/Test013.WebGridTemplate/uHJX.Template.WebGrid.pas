{ -----------------------------------------------------------------------------
 Unit Name: uHJX.Template.WebGrid
 Author:    ��ΰ
 Date:      10-����-2018
 Purpose:   ����WebGrid����壬�ֽ�Ϊ���⡢��ͷ�������������֡���ĳ�����۲�
            ������Ҫ���ñ��ģ��ʱ��������һ����Ԫ����ƥ�����á�

            Ŀǰ���ģ�岻֧�ֱ����۶��壬���ܴ������ݡ���۶�����ҪTWebCrossView
            ����֧�ֺ����֧�֣����ö���Ŀǰ������Ƕ����ģ��޷��ı䡣
 History:
----------------------------------------------------------------------------- }

unit uHJX.Template.WebGrid;

interface

uses
    System.Classes, System.Types, System.SysUtils, System.Variants,
    System.Generics.Collections {, System.RegularExpressions};

type
    { 2018-08-14�ݲ����ã���������ת�Ƶ�����Ԫ�н��У�ʹ����Ԫ��Ӧ�����
      ���ڴ˶Ե�Ԫ�����ݽ���ģʽƥ�䴦��������ģ�嶨��ĸ�ʽ����ֻ��ӵ��һ��ռλ�������ż���ֻ��
      �������ȡ������漰��ģ�����ݵĴ�����ģ����Ӧ�Կ���󻯡�
      ��Ԫ�����ݶ���, Ŀǰÿ����Ԫ���֧��һ��ռλ����ʾ�Ĵ��滻���ݣ���֧�ֶ�� }
    TCellRec = record
        Text: string;  // ԭ�������ݣ����п��ܰ�����ռλ��%xxx%����������ʱ��ʵ�������滻��
        Code: string;  // ��%xxx%�����ݣ��������������Ϊ��
        Param: string; // ��%xxx%�аٷֺ������xxx�Ĳ���(%xxx.yyy%��xxx.yyy����)��
        Item1: string; // ��xxx.yyy��xxx���֣��Ǵ˸�ʽ�����Param
        Item2: string; // xxx.yyy�е�yyy���֣��������
    end;

    { ����нṹ����ͷ��������ʹ�ô˽ṹ������Cols��ÿ���нṹ������Ԫ�����ݣ���ʵ����Cells }
    TGridTemplateRow = record
        Cols: TArray<String>;
        // Cells: TArray<TCellRec>;
    end;

    { ���ģ����󣬾��н��������Ĺ��� }
    TGridTemplate = class
    private
        FTemplateStr : String;
        FName        : string;
        FApplyToGroup: Boolean;
        FMeterType   : String; // Ŀǰֻ�����һ�����ͣ���������Ч��Ӧ������Ӧ��������
    protected
        procedure SetTemplateStr(AStr: string);
        function GetHeadCell(ARow, ACol: Integer): String;
        function GetDataCell(ACol: Integer): String;
        function GetHeadRowCount: Integer;
    public
        Titles  : TStrings;
        Heads   : TArray<TGridTemplateRow>;
        DataRows: TArray<TGridTemplateRow>;
        ColCount: Integer;
        constructor Create;
        destructor Destroy; override;
        property Name: string read FName write FName;
        property TemplateStr: string read FTemplateStr write SetTemplateStr;
        property HeadCell[ARow, ACol: Integer]: string read GetHeadCell;
        property DataCell[ACol: Integer]: string read GetDataCell;
        property HeadRowCount: Integer read GetHeadRowCount;
        property MeterType: string read FMeterType;
        property ApplyToGroup: Boolean read FApplyToGroup;
    end;

implementation

const
    { �����������ʽû�ã���������ģ��ƥ��Ĳμ�uHJX.Template.WGProc��Ԫ�е�������ʽ }
    RegExStr = '%(([a-zA-Z0-9]*)[\.]?([a-zA-Z0-9]*))%';

{ var
    RegEx: TRegEx; }

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
    { todo: ��Ҫ�����㹻�Ĵ����飬�����������Ϊ��Ϣ���ݳ�ȥ }
    for i := 0 to high(Rows) do
    begin
        j := pos(':', Rows[i]);
        if j = 0 then
            continue;
        id := Trim(copy(Rows[i], 1, j - 1));
        content := Trim(copy(Rows[i], j + 1, Length(Rows[i]) - j));
        if SameText(id, 'Name') then
            FName := content
        else if SameText(id, 'MeterType') then
            FMeterType := content
        else if SameText(id, 'ApplyTo') then
        begin
            if SameText(content, 'single') then
                FApplyToGroup := False
            else if SameText(content, 'Group') then
                FApplyToGroup := True;
        end
        else if SameText(id, 'Title') then
            Titles.add(content)
        else if SameText(id, 'Head') then
        begin
            Cols := content.Split(['|']);
            { todo: ���Cols�Ƿ�Ϊ�ա������Ƿ���ǰ��ı���һ�� }
            // ȥ��ǰ��ո�
            if Length(Cols) > 0 then
                for k := 0 to High(Cols) do
                    Cols[k] := Trim(Cols[k]);
            SetLength(Heads, Length(Heads) + 1);
            SetLength(Heads[High(Heads)].Cols, High(Cols));
            Heads[High(Heads)].Cols := Cols;
        end
        else if SameText(id, 'DataRow') then
        begin
            Cols := content.Split(['|']);
            // ȥ��ǰ��ո�
            if Length(Cols) > 0 then
                for k := 0 to High(Cols) do
                    Cols[k] := Trim(Cols[k]);
            SetLength(DataRows, Length(DataRows) + 1);
            DataRows[High(DataRows)].Cols := Cols;
            ColCount := High(Cols) - Low(Cols) + 1;
        end;
    end;
    SetLength(Rows, 0);
    SetLength(Cols, 0);
end;

function TGridTemplate.GetHeadRowCount: Integer;
begin
    if Length(Heads) = 0 then
        Result := 0
    else
        Result := High(Self.Heads) + 1;
end;

function TGridTemplate.GetDataCell(ACol: Integer): String;
begin
    Result := '';

    if Length(DataRows) > 0 then
        if Length(DataRows[0].Cols) > 0 then
            if (ACol >= 0) and (ACol <= High(DataRows[0].Cols)) then
                Result := DataRows[0].Cols[ACol];
end;

function TGridTemplate.GetHeadCell(ARow: Integer; ACol: Integer): String;
begin
    Result := '';
    // ǰ����if�ж�����Ч��������if�ж�����Ч
    if Length(Heads) > 0 then
        if (ARow >= 0) and (ARow <= High(Heads)) then
            if Length(Heads[ARow].Cols) > 0 then
                if (ACol >= 0) and (ACol <= High(Heads[ARow].Cols)) then
                    Result := Heads[ARow].Cols[ACol];
end;

end.
