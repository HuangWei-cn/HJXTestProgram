(* 分布图编辑器 ufrmDMEditor
    本界面用于定义、编辑分布图。
*)
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

procedure TfrmDMEditor.btnTestClick(Sender: TObject);
var
  frm: TfrmDistMap;
  str: string;
  i  : Integer;
begin
  // create define string:
  // 有效性判断
  if cbbMeterType.Text = '' then exit;
  if cbbPD.Text = '' then exit;
  if lstSelectedMeters.Count = 0 then exit;

  str := 'Title:' + edtTitle.Text + ';'#13#10;
  str := str + 'MeterType:' + cbbMeterType.Text + ';'#13#10;
  str := str + 'PDName:' + cbbPD.Text + ';'#13#10;
  i := ExcelMeters.Meter[lstSelectedMeters.Items[0]].PDDefines.IndexOfDataName(cbbPD.Text);
  str := str + 'PDIndex:' + IntToStr(i) + ';'#13#10;
  lstSelectedMeters.Items.Delimiter := ',';
  str := str + 'Meters:' + lstSelectedMeters.Items.DelimitedText;

// create distribution map form, and deal with it.
  frm := TfrmDistMap.create(Self);
  frm.SetDistMap(str);
  frm.ShowModal;
  frm.release;
end;

procedure TfrmDMEditor.cbbMeterTypeClick(Sender: TObject);
var
  i, k: Integer;
begin
  if cbbMeterType.Text <> '' then
  begin
    cbbPD.clear;
    // 列出所选仪器类型所有物理量，供用户选择
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
    if cbbPD.Items.Count > 0 then cbbPD.itemindex := 0;
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

  // 填入仪器类型
  for i := 0 to DSDefines.Count - 1 do
    if cbbMeterType.Items.indexof(DSDefines.item[i].datadefine.MeterType) = -1 then
        cbbMeterType.Items.Add(DSDefines.item[i].datadefine.MeterType);
end;

end.
