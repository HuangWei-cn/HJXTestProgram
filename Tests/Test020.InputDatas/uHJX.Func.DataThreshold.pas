{ 本单元定义与观测限差、预警相关的类、集合与变量等内容 }
unit uHJX.Func.DataThreshold;

interface

uses
    System.classes, System.Sysutils, System.Generics.Collections;

type

    /// <summary>数据超限判断项。
    /// </summary>
    /// <remarks>本结构体保存了某个数据项的名称、值范围（最大最小值）、限差等。正常的数据应该在
    /// 值范围内，并且和上次数据的变化量不超过限差。
    /// </remarks>
    TDataThreshold = record
        DataName: string;
        Threshold: Double;
        VMax: Double;     // 最大值
        VMin: Double;     // 最小值
        MaxDelta: Double; // 最大增量，两次测值增量超过此值，提示或报警
        { todo: 考虑采用多级阈值，可分为关注、警示、报警、出错等4个等级 }
    end;

    TMeterDataThreshold = record
        MeterType: string;
        MDThr: TArray<TDataThreshold>;
        PDThr: TArray<TDataThreshold>;
        function OutRange(ADataName: string; AData: Double): Boolean;
        function HasData(ADataName: string): Boolean;
        /// <remarks>释放数组</remarks>
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
