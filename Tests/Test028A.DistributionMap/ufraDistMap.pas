(* ufraDistMap �ֲ�ͼ��ʾFrame
  ����Ԫ������ʾһ���ֲ�ͼ
  2019-7-31 ����ʾһ����������һ����ʾһ���۲����ڵġ�
*)
unit ufraDistMap;

{ todo:��ѡ������ }
{ todo:������Ӷ����ߣ�ʹ�������ڶ����ᣬ�������6���ߣ��ҿ����ǲ�ͬ������������ê����+�����
+ƽ��λ���ߣ�����4���� }
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
    // procedure ShowMap(ADT: TDateTime); //��ʾָ�����ڵķֲ�ͼ
    procedure ShowMap; // ��ʾ�������ݵķֲ�ͼ
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// ����Distribution Map���壬�Զ����д���
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

{ �ֲ�ͼ������ʱ�����ı���ʽ�������ˣ����⡢�������͡����������ơ���������š������б�ÿһ��ռ��
  һ�У��ֺż��س����з���β�������б�֮���ö��ŷָ��� }
procedure TfraDistMap.SetDistMapDefine(ADefine: string);
var
  Strs1       : TStrings;
  i, iPos     : Integer;
  sItem, sCont: string;
begin
  // ������еĻس������з�
  ADefine := StringReplace(ADefine, #13, '', [rfReplaceAll]);
  ADefine := StringReplace(ADefine, #10, '', [rfReplaceAll]);
  Strs1 := TStringList.Create;
  try
  // �Էֺ�Ϊ�ָ�������ֳ���
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

    // �����궨��󣬳�ʼ��Chart���������������������ͱ���
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
