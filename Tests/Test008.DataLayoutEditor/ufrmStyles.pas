unit ufrmStyles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LayoutUtils, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan;

type
  TfrmStyles = class(TForm)
    lstStyles: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtDefName: TEdit;
    cbxDefType: TComboBox;
    cbxMeterType: TComboBox;
    clrBKColor: TColorBox;
    edtLineWidth: TEdit;
    clrLineColor: TColorBox;
    edtFontSize: TEdit;
    clrFontColor: TColorBox;
    chkAutoFit: TCheckBox;
    chkUseGDIPlus: TCheckBox;
    chkShowBorder: TCheckBox;
    Label10: TLabel;
    tbrTrans: TTrackBar;
    Label11: TLabel;
    chkAlignRight: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label12: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnSetAsDefault: TButton;
    popStyleList: TPopupMenu;
    btnUpdate: TButton;
    piAddNew: TMenuItem;
    N1: TMenuItem;
    piSetCurrentUse: TMenuItem;
    N3: TMenuItem;
    piDelete: TMenuItem;
    ActionManager1: TActionManager;
    actChanged: TAction;
    cbxFonts: TComboBox;
    btnSaveStyles: TButton;
    btnApplyNow: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lstStylesClick(Sender: TObject);
    procedure actChangedExecute(Sender: TObject);
    procedure piAddNewClick(Sender: TObject);
    procedure piSetCurrentUseClick(Sender: TObject);
    procedure piDeleteClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSetAsDefaultClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnSaveStylesClick(Sender: TObject);
    procedure btnApplyNowClick(Sender: TObject);
  private
    { Private declarations }
    FCurEd  : PElementDefine;
    FCurIdx : Integer;
    FChanged: Boolean;
    procedure ShowDefine(AED: PElementDefine);
    procedure UpdateDefine(bAsk: Boolean);
    procedure ClearComps;
  public
    { Public declarations }
    procedure EditStyle(ADef: PElementDefine);
  end;

var
  frmStyles: TfrmStyles;

implementation

uses
  uHJX.ProjectGlobal, ufrmEditor;
{$R *.dfm}


function __GetDefTypeName(aType: TdefType): String;
begin
  case aType of
    dtLabel: Result := 'MeterLabel';
    dtDataItem: Result := 'DataItem';
    dtArrow: Result := 'DataArrow';
    dtLinkLine: Result := 'LinkLine';
    dtIcon: Result := 'Icon';
  end;
end;

function __GetDefTypeByName(AName: String): TdefType;
begin
  if AName = 'MeterLabel' then Result := dtLabel
  else if AName = 'DataItem' then Result := dtDataItem
  else if AName = 'DataArrow' then Result := dtArrow
  else if AName = 'LinkLine' then Result := dtLinkLine
  else if AName = 'Icon' then Result := dtIcon;
end;

procedure TfrmStyles.actChangedExecute(Sender: TObject);
begin
  if FCurEd <> nil then
  begin
    FChanged := True;
  end;
end;

procedure TfrmStyles.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // 加载所有的样式
  cbxMeterType.Items.AddStrings(PG_MeterTypes);
  cbxDefType.Items.Add('MeterLabel');
  cbxDefType.Items.Add('DataItem');
  cbxDefType.Items.Add('DataArrow');
  cbxDefType.Items.Add('LinkLine');
  cbxDefType.Items.Add('Icon');
  for i := 0 to PreDefines.Count - 1 do
      lstStyles.Items.Add(PreDefines.Items[i].DefName);

  cbxFonts.Items.AddStrings(Screen.Fonts);
  FCurEd := nil;
  FCurIdx := -1;
end;

procedure TfrmStyles.lstStylesClick(Sender: TObject);
begin
  if (lstStyles.Count = 0) or (lstStyles.ItemIndex < 0) then Exit;
  FCurEd := PreDefines.Items[lstStyles.ItemIndex];
  FCurIdx := lstStyles.ItemIndex;
  ShowDefine(FCurEd);
end;

procedure TfrmStyles.piAddNewClick(Sender: TObject);
begin
  if FCurEd <> nil then
    if FChanged then
        UpdateDefine(True);

  FCurEd := PreDefines.AddNew;
  FCurEd.DefName := '新样式';
  ShowDefine(FCurEd);
  lstStyles.Items.Add(FCurEd.DefName);
  FCurIdx := lstStyles.Count - 1;
  lstStyles.ItemIndex := lstStyles.Count - 1;
end;

procedure TfrmStyles.piDeleteClick(Sender: TObject);
var
  S: String;
begin
  if (lstStyles.Count = 0) or (lstStyles.ItemIndex = -1) then Exit;
  // 询问
  S := PreDefines.Items[lstStyles.ItemIndex].DefName;
  if MessageDlg('你确定要删除样式' + S + '吗？不可恢复哦~~', mtWarning, [mbYes, mbNo], 0) = mrNo then Exit;

  // 先删除Predeine，再删除List，再设置FCured为空
  if FCurEd = PreDefines.Items[lstStyles.ItemIndex] then
  begin
    FCurEd := nil;
    ClearComps;
    FCurIdx := -1;
  end;
  PreDefines.Delete(lstStyles.ItemIndex);
  lstStyles.Items.Delete(lstStyles.ItemIndex);
end;

procedure TfrmStyles.piSetCurrentUseClick(Sender: TObject);
begin
  if FCurEd <> nil then
      frmEditor.CurentStyle := FCurEd;
end;

procedure TfrmStyles.ShowDefine(AED: PElementDefine);
begin
  if FChanged then UpdateDefine(True);

  edtDefName.Text := AED.DefName;
  cbxDefType.Text := __GetDefTypeName(AED.DefType);
  cbxMeterType.Text := AED.MeterType;
  clrBKColor.Selected := AED.bkColor;
  clrLineColor.Selected := AED.lnColor;
  edtLineWidth.Text := IntToStr(AED.LineWidth);
  chkAutoFit.Checked := AED.AutoFit;
  chkUseGDIPlus.Checked := AED.UseGDIPlus;
  chkShowBorder.Checked := AED.Border;

  cbxFonts.Text := AED.fontName;
  clrFontColor.Selected := AED.fontColor;
  edtFontSize.Text := IntToStr(AED.fontSize);

  tbrTrans.Position := AED.Transparency;
  chkAlignRight.Checked := AED.AlignRight;
  FChanged := False;
end;

procedure TfrmStyles.UpdateDefine(bAsk: Boolean);
begin
  // 询问是否需要更新
  if bAsk then
    if MessageBox(0, '当前样式定义已经改变，是否更新？', '', MB_ICONQUESTION or MB_YESNO) = 7 then Exit;

  // 更新FCurEd的内容。FCurEd指向PreDefines中的某个成员
  FCurEd.DefName := edtDefName.Text;
  FCurEd.DefType := __GetDefTypeByName(cbxDefType.Text);
  FCurEd.MeterType := cbxMeterType.Text;
  FCurEd.bkColor := clrBKColor.Selected;
  FCurEd.lnColor := clrLineColor.Selected;
  FCurEd.LineWidth := StrToInt(edtLineWidth.Text);
  FCurEd.AutoFit := chkAutoFit.Checked;
  FCurEd.UseGDIPlus := chkUseGDIPlus.Checked;
  FCurEd.Border := chkShowBorder.Checked;
  FCurEd.fontName := cbxFonts.Text;
  FCurEd.fontSize := StrToInt(edtFontSize.Text);
  FCurEd.fontColor := clrFontColor.Selected;
  FCurEd.Transparency := tbrTrans.Position;
  FCurEd.AlignRight := chkAlignRight.Checked;

  lstStyles.Items[FCurIdx] := FCurEd.DefName;

  FChanged := False;
  frmEditor.LoadStylesInCombo;
end;

{ -----------------------------------------------------------------------------
  Procedure  : ClearComps
  Description: 清理样式组件的内容。当删除了当前样式之后，组件应该显示的空内容
----------------------------------------------------------------------------- }
procedure TfrmStyles.btnApplyNowClick(Sender: TObject);
var
  ed: TElementDefine;
begin
  ed.DefName := edtDefName.Text;
  ed.DefType := __GetDefTypeByName(cbxDefType.Text);
  ed.MeterType := cbxMeterType.Text;
  ed.bkColor := clrBKColor.Selected;
  ed.lnColor := clrLineColor.Selected;
  ed.fontName := cbxFonts.Text;
  ed.fontSize := StrToInt(edtFontSize.Text);
  ed.fontColor := clrFontColor.Selected;
  ed.LineWidth := StrToInt(edtLineWidth.Text);
  ed.AutoFit := chkAutoFit.Checked;
  ed.Border := chkShowBorder.Checked;
  ed.UseGDIPlus := chkUseGDIPlus.Checked;
  ed.Transparency := tbrTrans.Position;
  ed.AlignRight := chkAlignRight.Checked;
  frmEditor.ApplyStyleToGraphObject(ed);
end;

procedure TfrmStyles.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStyles.btnOKClick(Sender: TObject);
begin
  if FChanged then
    if MessageDlg('样式已修改，需要先保存再退出吗？', mtConfirmation, [mbYes, mbNo], 0) = mryes then
        UpdateDefine(False);
  Close;
end;

procedure TfrmStyles.btnSaveStylesClick(Sender: TObject);
begin
  SavePreDefines;
end;

procedure TfrmStyles.btnSetAsDefaultClick(Sender: TObject);
begin
  Self.piSetCurrentUseClick(Self);
end;

procedure TfrmStyles.btnUpdateClick(Sender: TObject);
begin
  UpdateDefine(False);
end;

procedure TfrmStyles.ClearComps;
begin
  edtDefName.Text := '';
  cbxDefType.Text := '';
  cbxMeterType.Text := '';
  edtLineWidth.Text := '';
  edtFontSize.Text := '';
  cbxFonts.ItemIndex := -1;
  clrBKColor.Selected := clnone;
  clrLineColor.Selected := clBlack;
  clrFontColor.Selected := clBlack;
  tbrTrans.Position := 100;
  chkAutoFit.Checked := True;
  chkUseGDIPlus.Checked := False;
  chkShowBorder.Checked := True;
  chkAlignRight.Checked := False;
  FChanged := False;
end;

procedure TfrmStyles.EditStyle(ADef: PElementDefine);
var
  i: Integer;
begin
  i := PreDefines.IndexOf(ADef);
  if i <> -1 then
  begin
    lstStyles.ItemIndex := i;
    FCurIdx := i;
    FCurEd := ADef;
    ShowDefine(FCurEd);
  end;
end;

end.
