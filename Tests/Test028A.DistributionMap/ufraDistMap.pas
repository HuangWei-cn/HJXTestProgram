(* ufraDistMap �ֲ�ͼ��ʾFrame
  ����Ԫ������ʾһ���ֲ�ͼ
  2019-7-31 ����ʾһ����������һ����ʾһ���۲����ڵġ�
*)
unit ufraDistMap;

{ done:��ѡ������ }
{ todo:������Ӷ����ߣ�ʹ�������ڶ����ᣬ�������6���ߣ��ҿ����ǲ�ͬ������������ê����+�����
+ƽ��λ���ߣ�����4���� }
{ todo:���������ڣ�ÿ������һ���ߣ������û����ػ�ɾ��ĳЩ�� }
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.types,
  System.Classes, System.StrUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, VCLTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeChineseSimp,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.ExtCtrls, Vcl.StdCtrls,
  uHJX.Intf.AppServices, uHJX.Intf.Datas, Vcl.ComCtrls, Vcl.Menus, Vcl.Buttons;

type
  TfraDistMap = class(TFrame)
    pnlFunc: TPanel;
    chtDistMap: TChart;
    srsFirst: TLineSeries;
    TeeGDIPlus1: TTeeGDIPlus;
    btnLastData: TButton;
    pgbLoadDatas: TProgressBar;
    PopupMenu1: TPopupMenu;
    piSetup: TMenuItem;
    N1: TMenuItem;
    piCopyChartAsBitmap: TMenuItem;
    btnSpecialDate: TButton;
    dtpData: TDateTimePicker;
    pnlCustom: TPanel;
    btnShowCustomPanel: TSpeedButton;
    edtChartTitle: TLabeledEdit;
    edtAxisTitle: TLabeledEdit;
    btnAddNewLine: TButton;
    dtpNewLineDate: TDateTimePicker;
    procedure btnLastDataClick(Sender: TObject);
    procedure piCopyChartAsBitmapClick(Sender: TObject);
    procedure piSetupClick(Sender: TObject);
    procedure btnSpecialDateClick(Sender: TObject);
    procedure btnShowCustomPanelClick(Sender: TObject);
    procedure edtChartTitleKeyPress(Sender: TObject; var Key: Char);
    procedure edtAxisTitleKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddNewLineClick(Sender: TObject);
  private
    { Private declarations }
    FMeterList: TStrings;
    FTitle    : string;
    FMeterType: string;
    FPDIndex  : Integer;
    FPDName   : string;
    FMapName  : string;
    FLastDate : Boolean;
    // procedure ShowMap(ADT: TDateTime); //��ʾָ�����ڵķֲ�ͼ
    procedure ShowMap(LS: TLineSeries; dt: TDateTime); // ��ʾ�������ݵķֲ�ͼ
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// ����Distribution Map���壬�Զ����д���
    procedure SetDistMapDefine(ADefine: string);
  end;

implementation

uses
  VCLTee.EditChar;
{$R *.dfm}


procedure TfraDistMap.btnAddNewLineClick(Sender: TObject);
var
  srs: TLineSeries;
  i  : Integer;
begin
  srs := TLineSeries.Create(chtDistMap);
  srs.Title := FormatDateTime('yyyy-mm-dd', dtpNewLineDate.Date);
  srs.Pointer.Visible := True;
  srs.Pointer.Size := 3;
  chtDistMap.AddSeries(srs);
  FLastDate := False;
  for i := 0 to FMeterList.Count - 1 do srs.Add(0, FMeterList[i]);
  ShowMap(srs,dtpNewLineDate.Date);
end;

procedure TfraDistMap.btnLastDataClick(Sender: TObject);
begin
  FLastDate := True;
  ShowMap(srsFirst,now); //���ڷǱ��룬�����һ������
end;

procedure TfraDistMap.btnShowCustomPanelClick(Sender: TObject);
begin
  IF btnShowCustomPanel.Caption = '��' then
  begin
    btnShowCustomPanel.Caption := '��';
    pnlCustom.Visible := True;
  end
  else
  begin
    btnShowCustomPanel.Caption := '��';
    pnlCustom.Visible := False;
  end;
end;

procedure TfraDistMap.btnSpecialDateClick(Sender: TObject);
begin
  FLastDate := False;
  ShowMap(srsFirst,dtpData.Date);
end;

constructor TfraDistMap.Create(AOwner: TComponent);
begin
  inherited;
  FMeterList := TStringList.Create;
  TeeSetChineseSimp;
  dtpData.Date := Now;
  dtpNewLineDate.Date := Now;
end;

destructor TfraDistMap.Destroy;
begin
  FreeAndNil(FMeterList);
  inherited;
end;

procedure TfraDistMap.edtAxisTitleKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
      chtDistMap.Axes.Left.Title.Caption := edtAxisTitle.Text;
end;

procedure TfraDistMap.edtChartTitleKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
      chtDistMap.Title.Caption := edtChartTitle.Text;
end;

procedure TfraDistMap.piCopyChartAsBitmapClick(Sender: TObject);
begin
  chtDistMap.CopyToClipboardBitmap;
end;

procedure TfraDistMap.piSetupClick(Sender: TObject);
begin
  EditChart(nil, chtDistMap);
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
    // ShowMessage(IntToStr(Strs1.Count));
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
    srsFirst.Clear;
    // add meters
    for i := 0 to FMeterList.Count - 1 do srsFirst.Add(0, FMeterList[i]);
    chtDistMap.Axes.Left.Title.Caption := FPDName;
    chtDistMap.Axes.bottom.Title.Caption := FMeterType;
    //
    edtChartTitle.Text := chtDistMap.Title.Caption;
    edtAxisTitle.Text := chtDistMap.Axes.Left.Title.Caption;
  finally
    FreeAndNil(Strs1);
  end;
end;

procedure TfraDistMap.ShowMap(LS: TLineSeries; dt: TDateTime);
var
  i: Integer;
  V: TDoubleDynArray;
begin
  pgbLoadDatas.Position := 0;
  pgbLoadDatas.Max := FMeterList.Count;
  pgbLoadDatas.Visible := True;
  for i := 0 to FMeterList.Count - 1 do
  begin
    if FLastDate then
    begin
      if IAppServices.ClientDatas.GetLastPDDatas(FMeterList[i], V) then
      begin
        LS.YValue[i] := V[FPDIndex + 1];
      end
      else
          LS.YValue[i] := Null;
    end
    else
      if IAppServices.ClientDatas.GetNearestPDDatas(FMeterList[i], dt, V) then
        LS.YValue[i] := V[FPDIndex + 1]
    else
        LS.YValue[i] := Null;

    pgbLoadDatas.Position := i + 1;
  end;
  LS.Title := FormatDateTime('yyyy-mm-dd', V[0]);
  ShowMessage('�����Ѽ���.');
  pgbLoadDatas.Visible := False;
end;

end.
