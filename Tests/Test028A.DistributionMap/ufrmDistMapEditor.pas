{ -----------------------------------------------------------------------------
 Unit Name: ufrmDistMapEditor
 Author:    黄伟
 Date:      27-五月-2020
 Purpose:   监测数据分布图测试程序---分布图定义器

 History:   2020-05-27 修改
----------------------------------------------------------------------------- }

(* 分布图编辑器 ufrmDMEditor
    本界面用于定义、编辑分布图。
*)
{ TODO: 当用户选了一个部位时，自动从该部位所有监测仪器中挑选出预定的仪器类型，而不是
统统添加到列表中，否则各种不同类型的仪器都将其某个量添加到图里，不成体统。 }
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
// 这里存在一个问题，如果PDIndex由上面那句得出，有可能导致i= -1。所以，为防止出现这样的问题，
// 直接将PDIndex设置为cbbPD.ItemIndex。这个问题目前出现在多点位移计上，一般滴，多点位移计的
// 4个测点是0~5m，0~10m, 0~20m, 0~30m，但是有许多多点位移计的4个测点不是这样的，比如第1个测
// 点是0~10m。所以，还应该考虑，手工添加监测仪器监测量的功能，这个总是应该没有问题的。
/// </summary>
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
  /// <summary>
  // 这里存在一个问题，如果PDIndex由上面那句得出，有可能导致i= -1。所以，为防止出现这样的问题，
  // 直接将PDIndex设置为cbbPD.ItemIndex。这个问题目前出现在多点位移计上，一般滴，多点位移计的
  // 4个测点是0~5m，0~10m, 0~20m, 0~30m，但是有许多多点位移计的4个测点不是这样的，比如第1个测
  // 点是0~10m。所以，还应该考虑，手工添加监测仪器监测量的功能，这个总是应该没有问题的。
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

  // 填入仪器类型
  for i := 0 to DSDefines.Count - 1 do
    if cbbMeterType.Items.indexof(DSDefines.item[i].datadefine.MeterType) = -1 then
        cbbMeterType.Items.Add(DSDefines.item[i].datadefine.MeterType);
end;

procedure TfrmDMEditor.OnMapFormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
