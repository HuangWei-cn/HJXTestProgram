{ -----------------------------------------------------------------------------
 Unit Name: ufrmDistMapEditor
 Author:    ��ΰ
 Date:      27-����-2020
 Purpose:   ������ݷֲ�ͼ���Գ���---�ֲ�ͼ������

 History:   2020-05-27 �޸�
----------------------------------------------------------------------------- }

(* �ֲ�ͼ�༭�� ufrmDMEditor
    ���������ڶ��塢�༭�ֲ�ͼ��
*)
{ TODO: ���û�ѡ��һ����λʱ���Զ��Ӹò�λ���м����������ѡ��Ԥ�����������ͣ�������
ͳͳ��ӵ��б��У�������ֲ�ͬ���͵�����������ĳ������ӵ�ͼ�������ͳ�� }
unit ufrmDistMapEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uHJX.Intf.AppServices, uHJX.Classes.Meters, Vcl.StdCtrls;

type
  TfrmDMEditor = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    edtDMName: TEdit;
    edtTitle: TEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    cbbMeterType: TComboBox;
    cbbPD: TComboBox;
    lstSelectedMeters: TListBox;
    btnSelecMeters: TButton;
    btnSaveDefine: TButton;
    btnTest: TButton;
    procedure cbbMeterTypeClick(Sender: TObject);
    procedure btnSelecMetersClick(Sender: TObject);
    procedure btnSaveDefineClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnMapFormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
    procedure Init;
  end;

var
  frmDMEditor: TfrmDMEditor;

implementation

uses
  ufrmMeterSelector, ufrmDistMap;
{$R *.dfm}


procedure TfrmDMEditor.btnSaveDefineClick(Sender: TObject);
begin
  ShowMessage('Not yet');
end;

procedure TfrmDMEditor.btnSelecMetersClick(Sender: TObject);
var
  frm: TfrmMeterSelector;
begin
  frm := TfrmMeterSelector.create(Self);
  frm.ShowModal;
  frm.GetSelected(lstSelectedMeters.Items);
  frm.release;
end;

/// <summary>
// �������һ�����⣬���PDIndex�������Ǿ�ó����п��ܵ���i= -1�����ԣ�Ϊ��ֹ�������������⣬
// ֱ�ӽ�PDIndex����ΪcbbPD.ItemIndex���������Ŀǰ�����ڶ��λ�Ƽ��ϣ�һ��Σ����λ�ƼƵ�
// 4�������0~5m��0~10m, 0~20m, 0~30m�������������λ�ƼƵ�4����㲻�������ģ������1����
// ����0~10m�����ԣ���Ӧ�ÿ��ǣ��ֹ���Ӽ������������Ĺ��ܣ��������Ӧ��û������ġ�
/// </summary>
procedure TfrmDMEditor.btnTestClick(Sender: TObject);
var
  frm: TfrmDistMap;
  str: string;
  i  : Integer;
begin
  // create define string:
  // ��Ч���ж�
  if cbbMeterType.Text = '' then exit;
  if cbbPD.Text = '' then exit;
  if lstSelectedMeters.Count = 0 then exit;

  str := 'Title:' + edtTitle.Text + ';'#13#10;
  str := str + 'MeterType:' + cbbMeterType.Text + ';'#13#10;
  str := str + 'PDName:' + cbbPD.Text + ';'#13#10;
  i := ExcelMeters.Meter[lstSelectedMeters.Items[0]].PDDefines.IndexOfDataName(cbbPD.Text);
  /// <summary>
  // �������һ�����⣬���PDIndex�������Ǿ�ó����п��ܵ���i= -1�����ԣ�Ϊ��ֹ�������������⣬
  // ֱ�ӽ�PDIndex����ΪcbbPD.ItemIndex���������Ŀǰ�����ڶ��λ�Ƽ��ϣ�һ��Σ����λ�ƼƵ�
  // 4�������0~5m��0~10m, 0~20m, 0~30m�������������λ�ƼƵ�4����㲻�������ģ������1����
  // ����0~10m�����ԣ���Ӧ�ÿ��ǣ��ֹ���Ӽ������������Ĺ��ܣ��������Ӧ��û������ġ�
  /// </summary>
  str := str + 'PDIndex:' + IntToStr(cbbPD.ItemIndex) + ';'#13#10;
  // str := str + 'PDIndex:' + IntToStr(i) + ';'#13#10;
  lstSelectedMeters.Items.Delimiter := ',';
  str := str + 'Meters:' + lstSelectedMeters.Items.DelimitedText;

// create distribution map form, and deal with it.
  frm := TfrmDistMap.create(Self);
  frm.OnClose := Self.OnMapFormClose;
  frm.SetDistMap(str);
  frm.Show;
  // frm.ShowModal;
  // frm.release;
end;

procedure TfrmDMEditor.cbbMeterTypeClick(Sender: TObject);
var
  i, k: Integer;
begin
  if cbbMeterType.Text <> '' then
  begin
    cbbPD.clear;
    // �г���ѡ�����������������������û�ѡ��
    for i := 0 to DSDefines.Count - 1 do
      if DSDefines.item[i].datadefine.MeterType = cbbMeterType.Text then
      begin
        with DSDefines.item[i] do
          for k := 0 to datadefine.pds.Count - 1 do
          begin
            cbbPD.Items.Add(datadefine.pds.Items[k].Name);
          end;
        break;
      end;
    if cbbPD.Items.Count > 0 then cbbPD.ItemIndex := 0;
  end;
end;

procedure TfrmDMEditor.Init;
var
  i: Integer;
begin
  edtDMName.Text := '';
  edtTitle.Text := '';

  if ExcelMeters.Count = 0 then exit;

  cbbPD.clear;
  cbbMeterType.clear;

  // ������������
  for i := 0 to DSDefines.Count - 1 do
    if cbbMeterType.Items.indexof(DSDefines.item[i].datadefine.MeterType) = -1 then
        cbbMeterType.Items.Add(DSDefines.item[i].datadefine.MeterType);
end;

procedure TfrmDMEditor.OnMapFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
