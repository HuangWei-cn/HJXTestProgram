{ ����Ԫ������۲��޲Ԥ����ص��ࡢ��������������� }
unit uHJX.Func.DataThreshold;

interface

uses
    System.classes, System.Sysutils, System.Generics.Collections;

type

    /// <summary>���ݳ����ж��
    /// </summary>
    /// <remarks>���ṹ�屣����ĳ������������ơ�ֵ��Χ�������Сֵ�����޲�ȡ�����������Ӧ����
    /// ֵ��Χ�ڣ����Һ��ϴ����ݵı仯���������޲
    /// </remarks>
    TDataThreshold = record
        DataName: string;
        Threshold: Double;
        VMax: Double;     // ���ֵ
        VMin: Double;     // ��Сֵ
        MaxDelta: Double; // ������������β�ֵ����������ֵ����ʾ�򱨾�
        { todo: ���ǲ��ö༶��ֵ���ɷ�Ϊ��ע����ʾ�������������4���ȼ� }
    end;

    TMeterDataThreshold = record
        MeterType: string;
        MDThr: TArray<TDataThreshold>;
        PDThr: TArray<TDataThreshold>;
        function OutRange(ADataName: string; AData: Double): Boolean;
        function HasData(ADataName: string): Boolean;
        /// <remarks>�ͷ�����</remarks>
        procedure Release;
    end;

    PMeterDataThreshold = ^TMeterDataThreshold;

    TDataThresholdList = class
    private
        FList: TList<PMeterDataThreshold>;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Clear;

        function Judge(AMeterType: string; ADataName: string; AValue: Double): Boolean;
    end;

implementation

function TMeterDataThreshold.OutRange(ADataName: string; AData: Double): Boolean;
var
    i: Integer;
begin
    Result := False;
    for i := low(MDThr) to high(MDThr) do
        if SameText(ADataName, MDThr[i].DataName) then
        begin
            Result := Abs(AData) > MDThr[i].Threshold;
            Exit;
        end;

    for i := low(PDThr) to high(PDThr) do
        if SameText(ADataName, PDThr[i].DataName) then
        begin
            Result := Abs(AData) > PDThr[i].Threshold;
            Exit;
        end;
end;

function TMeterDataThreshold.HasData(ADataName: string): Boolean;
var
    i: Integer;
begin
    Result := False;
    for i := low(MDThr) to high(MDThr) do
        if SameText(ADataName, MDThr[i].DataName) then
        begin
            Result := true;
            Exit;
        end;

    for i := low(PDThr) to high(PDThr) do
        if SameText(ADataName, PDThr[i].DataName) then
        begin
            Result := true;
            Exit;
        end;
end;

procedure TMeterDataThreshold.Release;
begin
    SetLength(MDThr, 0);
    SetLength(PDThr, 0);
end;

constructor TDataThresholdList.Create;
begin
    inherited;
    FList := TList<PMeterDataThreshold>.Create;
end;

destructor TDataThresholdList.Destroy;
begin
    Clear;
    FList.Free;
    inherited;
end;

procedure TDataThresholdList.Clear;
var
    i: Integer;
begin
    for i := 0 to FList.Count - 1 do
    begin
        FList[i].Release;
        Dispose(FList[i]);
    end;

    FList.Clear;
end;

function TDataThresholdList.Judge(AMeterType: string; ADataName: string; AValue: Double): Boolean;
var
    dt: TDataThreshold;
begin

end;

end.
