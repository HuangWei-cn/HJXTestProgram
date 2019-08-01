(* ufraDistMap 分布图显示Frame
  本单元用于显示一个分布图
  2019-7-31 先显示一个物理量，一次显示一个观测日期的。
*)
unit ufraDistMap;

{ todo:可选择日期 }
{ todo:允许添加多条线，使用右轴或第二左轴，最多允许6条线，且可以是不同类型仪器。如锚杆线+多点线
+平面位移线；或多点4条线 }
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.types,
  System.Classes, System.StrUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, VCLTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.ExtCtrls, Vcl.StdCtrls,
  uHJX.Intf.AppServices, uHJX.Intf.Datas;

type
  TfraDistMap = class(TFrame)
    pnlFunc: TPanel;
    chtDistMap: TChart;
    Series1: TLineSeries;
    TeeGDIPlus1: TTeeGDIPlus;
    btnLastData: TButton;
    procedure btnLastDataClick(Sender: TObject);
  private
    { Private declarations }
    FMeterList: TStrings;
    FTitle    : string;
    FMeterType: string;
    FPDIndex  : Integer;
    FPDName   : string;
    FMapName  : string;
    // procedure ShowMap(ADT: TDateTime); //显示指定日期的分布图
    procedure ShowMap; // 显示最新数据的分布图
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// 设置Distribution Map定义，自动进行处理
    procedure SetDistMapDefine(ADefine: string);
  end;

implementation

{$R *.dfm}

procedure TfraDistMap.btnLastDataClick(Sender: TObject);
begin
  ShowMap;
end;

constructor TfraDistMap.Create(AOwner: TComponent);
begin
  inherited;
  FMeterList := TStringList.Create;
end;

destructor TfraDistMap.Destroy;
begin
  FreeAndNil(FMeterList);
  inherited;
end;

{ 分布图定义暂时采用文本方式，包含了：标题、仪器类型、物理量名称、物理量序号、仪器列表。每一项占用
  一行，分号及回车换行符结尾。仪器列表之间用逗号分隔。 }
procedure TfraDistMap.SetDistMapDefine(ADefine: string);
var
  Strs1       : TStrings;
  i, iPos     : Integer;
  sItem, sCont: string;
begin
  // 清除所有的回车及换行符
  ADefine := StringReplace(ADefine, #13, '', [rfReplaceAll]);
  ADefine := StringReplace(ADefine, #10, '', [rfReplaceAll]);
  Strs1 := TStringList.Create;
  try
  // 以分号为分隔符，拆分出行
    Strs1.Delimiter := ';';
    Strs1.DelimitedText := ADefine;
    ShowMessage(IntToStr(Strs1.Count));
    for i := 0 to Strs1.Count - 1 do
    begin
      iPos := Pos(':', Strs1[i]);
      sItem := Copy(Strs1[i], 1, iPos - 1);
      sCont := Copy(Strs1[i], iPos + 1, Length(Strs1[i]) - iPos);
      if SameText(sItem, 'Title') then FTitle := sCont
      else if SameText(sItem, 'MeterType') then FMeterType := sCont
      else if SameText(sItem, 'PDName') then FPDName := sCont
      else if SameText(sItem, 'PDIndex') then FPDIndex := StrToInt(sCont)
      else if SameText(sItem, 'Meters') then
      begin
        FMeterList.Delimiter := ',';
        FMeterList.DelimitedText := sCont;
      end;
    end;

    // 处理完定义后，初始化Chart，添加仪器、设置坐标轴和标题
    Series1.Clear;
    // add meters
    for i := 0 to FMeterList.Count - 1 do Series1.Add(0, FMeterList[i]);
    chtDistMap.Axes.Left.Title.Caption := FPDName;
    chtDistMap.Axes.bottom.Title.Caption := FMeterType;
  finally
    FreeAndNil(Strs1);
  end;
end;

procedure TfraDistMap.ShowMap;
var
  i: Integer;
  V: TDoubleDynArray;
begin
  for i := 0 to FMeterList.Count - 1 do
  begin
    if IAppServices.ClientDatas.GetLastPDDatas(FMeterList[i], V) then
    begin
      Series1.YValue[i] := V[FPDIndex + 1];
    end;
  end;
  Series1.Title := FormatDateTime('yyyy-mm-dd', V[0]);
end;

end.
