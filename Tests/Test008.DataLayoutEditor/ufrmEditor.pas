{ -----------------------------------------------------------------------------
 Unit Name: ufrmEditor
 Author:    黄伟
 Date:      26-四月-2017
 Purpose:   观测数据分布图编辑器
 History:
----------------------------------------------------------------------------- }
{ todo:增加模拟数据显示，以便于调整数据显示的位置 }
unit ufrmEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SimpleGraph, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ButtonGroup,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Clipbrd,
  Vcl.Imaging.jpeg, uhwSGEx, uhwSGEx.DataMapClasses, Vcl.Buttons, Vcl.Menus, Vcl.AppEvnts,
  LayoutUtils;

type
  TfrmEditor = class(TForm)
    Panel1: TPanel;
    sgLayout: TSimpleGraph;
    btngrpFuncs: TButtonGroup;
    tvwMeters: TTreeView;
    edtSeek: TEdit;
    ImageList: TImageList;
    ActionManager1: TActionManager;
    actLoadLayout: TAction;
    actSaveLayout: TAction;
    actSelectMode: TAction;
    actPanMode: TAction;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actActualSize: TAction;
    actWholeGraph: TAction;
    actInsBackgroud: TAction;
    actInsDataItem: TAction;
    actInsText: TAction;
    actInsLink: TAction;
    actCut: TAction;
    actDelete: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actProperty: TAction;
    actBringToFront: TAction;
    actSendToBack: TAction;
    dlgOpenLayout: TOpenDialog;
    dlgSaveLayout: TSaveDialog;
    actNewFile: TAction;
    actLinkDatabase: TAction;
    dlgOpenPrjConfig: TOpenDialog;
    ActionToolBar1: TActionToolBar;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    Panel2: TPanel;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edtText: TLabeledEdit;
    edtID: TLabeledEdit;
    edtDataName: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmbFonts: TComboBox;
    cmbFontSize: TComboBox;
    clbxFontColor: TColorBox;
    clbxBackColor: TColorBox;
    trcTransparency: TTrackBar;
    chkBorder: TCheckBox;
    btnSetAsDefault: TSpeedButton;
    clbxLineColor: TColorBox;
    Label6: TLabel;
    edtDataUnit: TLabeledEdit;
    popSG: TPopupMenu;
    piOriginBackgroundSize: TMenuItem;
    actRestoreOriginBackgroundSize: TAction;
    chkTextAutoSize: TCheckBox;
    chkUseGDIP: TCheckBox;
    actAlign: TAction;
    Label7: TLabel;
    cmbLineWidth: TComboBox;
    actInsDeformDirect: TAction;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    CategoryPanel4: TCategoryPanel;
    Splitter2: TSplitter;
    Label8: TLabel;
    edtFactor: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edtAngle: TEdit;
    Label11: TLabel;
    cmbDeformName: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    cmbXData: TComboBox;
    cmbYData: TComboBox;
    edtPointAngle: TEdit;
    Label14: TLabel;
    chkUseGlobalAngle: TCheckBox;
    ApplicationEvents1: TApplicationEvents;
    actInsElliptic: TAction;
    actInsTriangular: TAction;
    actInsRhomboidal: TAction;
    actInsPentagonal: TAction;
    actInsRectangular: TAction;
    chkDataAlighRight: TCheckBox;
    N1: TMenuItem;
    piDisableSelectMap: TMenuItem;
    actDisableSelectMap: TAction;
    btnSaveAsStyle: TSpeedButton;
    btnOpenStyleEditor: TSpeedButton;
    btnSaveStyles: TSpeedButton;
    cbxStyles: TComboBox;
    CategoryPanel5: TCategoryPanel;
    chkAutoMatchStyles: TCheckBox;
    Label15: TLabel;
    procedure actLoadLayoutExecute(Sender: TObject);
    procedure actSaveLayoutExecute(Sender: TObject);
    procedure actInsBackgroudExecute(Sender: TObject);
    procedure actInsBackgroudUpdate(Sender: TObject);
    procedure actInsDataItemExecute(Sender: TObject);
    procedure actInsDataItemUpdate(Sender: TObject);
    procedure actInsTextExecute(Sender: TObject);
    procedure actInsTextUpdate(Sender: TObject);
    procedure actInsLinkExecute(Sender: TObject);
    procedure actInsLinkUpdate(Sender: TObject);
    procedure actSelectModeExecute(Sender: TObject);
    procedure actSelectModeUpdate(Sender: TObject);
    procedure actPanModeExecute(Sender: TObject);
    procedure actPanModeUpdate(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomInUpdate(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actZoomOutUpdate(Sender: TObject);
    procedure actActualSizeExecute(Sender: TObject);
    procedure actActualSizeUpdate(Sender: TObject);
    procedure actWholeGraphExecute(Sender: TObject);
    procedure actWholeGraphUpdate(Sender: TObject);
    procedure sgLayoutObjectInsert(Graph: TSimpleGraph; GraphObject: TGraphObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actBringToFrontExecute(Sender: TObject);
    procedure actSendToBackExecute(Sender: TObject);
    procedure actBringToFrontUpdate(Sender: TObject);
    procedure actPropertyExecute(Sender: TObject);
    procedure sgLayoutObjectDblClick(Graph: TSimpleGraph; GraphObject: TGraphObject);
    procedure sgLayoutMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
      var Handled: Boolean);
    procedure sgLayoutMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
      var Handled: Boolean);
    procedure actNewFileExecute(Sender: TObject);
    procedure actSaveLayoutUpdate(Sender: TObject);
    procedure actLinkDatabaseExecute(Sender: TObject);
    procedure tvwMetersCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
    procedure sgLayoutDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure sgLayoutDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure tvwMetersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure tvwMetersEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure edtSeekChange(Sender: TObject);
    procedure sgLayoutObjectSelect(Graph: TSimpleGraph; GraphObject: TGraphObject);
    procedure sgLayoutObjectChange(Graph: TSimpleGraph; GraphObject: TGraphObject);
    procedure edtTextChange(Sender: TObject);
    procedure edtIDChange(Sender: TObject);
    procedure edtDataNameChange(Sender: TObject);
    procedure cmbFontsChange(Sender: TObject);
    procedure cmbFontSizeChange(Sender: TObject);
    procedure clbxFontColorChange(Sender: TObject);
    procedure clbxBackColorChange(Sender: TObject);
    procedure trcTransparencyChange(Sender: TObject);
    procedure chkBorderClick(Sender: TObject);
    procedure btnSetAsDefaultClick(Sender: TObject);
    procedure clbxLineColorChange(Sender: TObject);
    procedure edtDataUnitChange(Sender: TObject);
    procedure actRestoreOriginBackgroundSizeExecute(Sender: TObject);
    procedure actRestoreOriginBackgroundSizeUpdate(Sender: TObject);
    procedure chkTextAutoSizeClick(Sender: TObject);
    procedure chkUseGDIPClick(Sender: TObject);
    procedure sgLayoutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgLayoutKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actAlignExecute(Sender: TObject);
    procedure cmbLineWidthChange(Sender: TObject);
    procedure actInsDeformDirectExecute(Sender: TObject);
    procedure actInsDeformDirectUpdate(Sender: TObject);
    procedure edtAngleChange(Sender: TObject);
    procedure edtFactorChange(Sender: TObject);
    procedure cmbXDataChange(Sender: TObject);
    procedure cmbYDataChange(Sender: TObject);
    procedure edtPointAngleChange(Sender: TObject);
    procedure chkUseGlobalAngleClick(Sender: TObject);
    procedure cmbDeformNameChange(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure actInsEllipticExecute(Sender: TObject);
    procedure actInsEllipticUpdate(Sender: TObject);
    procedure actInsTriangularExecute(Sender: TObject);
    procedure actInsTriangularUpdate(Sender: TObject);
    procedure actInsRhomboidalExecute(Sender: TObject);
    procedure actInsRhomboidalUpdate(Sender: TObject);
    procedure actInsPentagonalExecute(Sender: TObject);
    procedure actInsPentagonalUpdate(Sender: TObject);
    procedure actInsRectangularExecute(Sender: TObject);
    procedure actInsRectangularUpdate(Sender: TObject);
    procedure chkDataAlighRightClick(Sender: TObject);
    procedure actDisableSelectMapExecute(Sender: TObject);
    procedure btnSaveAsStyleClick(Sender: TObject);
    procedure btnOpenStyleEditorClick(Sender: TObject);
    procedure btnSaveStylesClick(Sender: TObject);
    procedure cbxStylesChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
        { Private declarations }
    FLayoutfile       : string;
    FIsGraphSaved     : Boolean;
    FLoading          : Boolean;
    FLoadingProperties: Boolean;
    FSelectedGObj     : TGraphObject;
        { 缺省设置 }
    FdefFontName  : string;
    FdefFontSize  : Integer;
    FdefFontColor : TColor;
    FdefBackColor : TColor;
    FdefLineColor : TColor;
    FdefTrans     : Integer;
    FdefBorder    : Boolean;
    FdefLineWidth : Integer;
    FdefAlignRight: Boolean;

    { 当前样式 }
    FCurStyle: PElementDefine;

    // 下面两条是用于按住空格键平移图形的。
    FPreCmd      : TGraphCommandMode;
    FHoldSpaceKey: Boolean;

    // 上次访问的路径
    FLastPrjPath: string;
    FLastMapPath: string;
    function ForEachCallback(GraphObject: TGraphObject; Action: Integer): Boolean;
    /// <summary>
    /// 在这里，用这个方法实现拖放后自动对齐数据标签，加快版面整洁程度
    /// </summary>
    procedure GraphEndDragging(Graph: TSimpleGraph; GraphObject: TGraphObject; HT: DWORD;
      Cancelled: Boolean);

    procedure ShowMeters;
    procedure Modified;
    procedure StyleChanged; // 当FCurStyle发生变化时，用本方法更新界面组件的显示
    procedure SetStyle(AStyle: PElementDefine);
    /// <summary>
    /// 根据图元类型选择当前图元可匹配的样式。基本原则如下：
    /// 1、若勾选根据图元类型自动匹配，则从样式表中查找对应的图元类型、仪器类型返回样式；
    /// 2、否则，若当前样式FCurStyle<>nil，则返回FCurStyle的格式；
    /// 3、否则，若当前格式FdefFontName <> ''，则使用当前格式；
    /// 4、否则，随便了
    /// </summary>
    function RetCurrentStyle: TElementDefine;
    function GetMatchStyle(AGNode: TGraphObject; AMeterType: string): TElementDefine; overload;
    function GetMatchStyle(AGNType: TdefType; AMeterType: String): TElementDefine; overload;
  public
    { Public declarations }
    /// <summary>
    /// 将给定样式应用到当前图纸中所有同类型的图元上
    /// </summary>
    procedure ApplyStyleToGraphObject(AStyle: TElementDefine);
    // 加载样式到ComboBox列表中
    procedure LoadStylesInCombo;
    property CurentStyle: PElementDefine read FCurStyle write SetStyle;
  end;

var
  frmEditor: TfrmEditor;

implementation

uses
  NodeProp, LinkProp, ObjectProp, DesignProp, AlignDlg,
  uHJX.Intf.Datas, uHJX.Classes.Meters, uHJX.EnvironmentVariables,
  uHJX.Excel.Meters,
  uHJX.Excel.InitParams,
  ufrmStyles;
{$R *.dfm}


type
  TNodeType = (ntClass, ntMeter, ntDataItem);

  TmeterNode = class(TTreeNode)
  public
    NodeType: TNodeType;
    Valid   : Boolean;
    Meter   : TMeterDefine;
    DataName: string;
  end;

resourcestring
  SSaveChanges = 'Graph has been changed, would you like to save changes?';
  SViewOnly = 'View Only';
  SEditing = 'Editing';
  SPan = 'Pan Mode';
  SInsertingLink = 'Inserting Link/Line';
  SInsertingNode = 'Inserting Node';
  SModified = 'Modified';
  SUntitled = 'Untitled';
  SMultiSelect = '%d objects selected';
  SNumOfPoints = '%d point(s)';
  SStartPoint = 'startpoint';
  SEndPoint = 'endpoint';
  SNoName = 'NONAME';
  SCanDelete = 'Are you sure to delete ''%s''?';
  SCanHook = 'Are you sure to hook %s of ''%s'' link to ''%s'' object?';
  SCanLink = 'Are you sure to connect ''%s'' and ''%s'' objects using ''%s'' link?';
  SHooked = 'Hooked';
  SNodeInfo = '%s Node: %s' + #13#10 + 'Origin: %d, %d; Size: %d x %d' + #13#10 +
    'Input Links: %d; Output Links: %d';
  SLinkInfo = 'Link: %s' + #13#10 + 'Startpoint at: (%d, %d) %s' + #13#10 +
    'Endpoint at: (%d, %d) %s' + #13#10 + 'Breakpoints Count: %d';

const
  // ForEachObject Actions
  FEO_DELETE             = 00;
  FEO_SELECT             = 01;
  FEO_INVERTSELECTION    = 02;
  FEO_SENDTOBACK         = 03;
  FEO_BRINGTOFRONT       = 04;
  FEO_MAKESELECTABLE     = 05;
  FEO_SETFONTFACE        = 06;
  FEO_SETFONTSIZE        = 07;
  FEO_SETFONTBOLD        = 08;
  FEO_SETFONTITALIC      = 09;
  FEO_SETFONTUNDERLINE   = 10;
  FEO_RESETFONTBOLD      = 11;
  FEO_RESETFONTITALIC    = 12;
  FEO_RESETFONTUNDERLINE = 13;
  FEO_SETALIGNMENTLEFT   = 14;
  FEO_SETALIGNMENTCENTER = 15;
  FEO_SETALIGNMENTRIGHT  = 16;
  FEO_SETLAYOUTTOP       = 17;
  FEO_SETLAYOUTCENTER    = 18;
  FEO_SETLAYOUTBOTTOM    = 19;
  FEO_REVERSEDIRECTION   = 20;
  FEO_ROTATE90CW         = 21;
  FEO_ROTATE90CCW        = 22;
  FEO_GROW25             = 23;
  FEO_SHRINK25           = 24;
    /// ////
  FEO_SetBorder         = 25;
  FEO_SetTransparency   = 26;
  FEO_SetFontColor      = 27;
  FEO_SetBackColor      = 28;
  FEO_SetLineColor      = 29;
  FEO_SetGDIP           = 30;
  FEO_SetAutoSize       = 31;
  FEO_SetLineWidth      = 32;
  FEO_SetDataAlignRight = 33; // set TGPTextNode anchors right-top.
  FEO_DisableSelectMap  = 34; // disable select map, or not.
  // 下面是一次性设置多个变形方向图元的设置
  FEO_XDirectData    = 35;
  FEO_YDirectData    = 36;
  FEO_PointAngle     = 37;
  FEO_UseGlobalAngle = 38;

var
  ADragItem: TmeterNode; // 被用户拖放的TreeNode

function TfrmEditor.ForEachCallback(GraphObject: TGraphObject; Action: Integer): Boolean;
var
  RotateOrg: TPoint;
begin
  Result := True;
  case Action of
    FEO_DELETE:
      Result := GraphObject.Delete;
    FEO_SELECT:
      GraphObject.Selected := True;
    FEO_INVERTSELECTION:
      GraphObject.Selected := not GraphObject.Selected;
    FEO_SENDTOBACK:
      GraphObject.SendToBack;
    FEO_BRINGTOFRONT:
      GraphObject.BringToFront;
    FEO_MAKESELECTABLE:
      GraphObject.Options := GraphObject.Options + [goSelectable];
    FEO_SETFONTFACE:
      GraphObject.Font.Name := cmbFonts.Text;
    FEO_SETFONTSIZE:
      GraphObject.Font.Size := cmbFontSize.Tag; // cbxFontSize.Tag;
    FEO_SETFONTBOLD:
      GraphObject.Font.Style := GraphObject.Font.Style + [fsBold];
    FEO_SETFONTITALIC:
      GraphObject.Font.Style := GraphObject.Font.Style + [fsItalic];
    FEO_SETFONTUNDERLINE:
      GraphObject.Font.Style := GraphObject.Font.Style + [fsUnderline];
    FEO_RESETFONTBOLD:
      GraphObject.Font.Style := GraphObject.Font.Style - [fsBold];
    FEO_RESETFONTITALIC:
      GraphObject.Font.Style := GraphObject.Font.Style - [fsItalic];
    FEO_RESETFONTUNDERLINE:
      GraphObject.Font.Style := GraphObject.Font.Style - [fsUnderline];
    FEO_SETALIGNMENTLEFT:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Alignment := taLeftJustify;
    FEO_SETALIGNMENTCENTER:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Alignment := taCenter;
    FEO_SETALIGNMENTRIGHT:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Alignment := taRightJustify;
    FEO_SETLAYOUTTOP:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Layout := tlTop;
    FEO_SETLAYOUTCENTER:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Layout := tlCenter;
    FEO_SETLAYOUTBOTTOM:
      if GraphObject is TGraphNode then
          TGraphNode(GraphObject).Layout := tlBottom;
    FEO_REVERSEDIRECTION:
      if GraphObject is TGraphLink then
          TGraphLink(GraphObject).Reverse;
    FEO_ROTATE90CW:
      if GraphObject is TGraphLink then
        with TGraphLink(GraphObject) do
        begin
          RotateOrg := CenterOfPoints(Polyline);
          Rotate(+Pi / 2, RotateOrg);
        end;
    FEO_ROTATE90CCW:
      if GraphObject is TGraphLink then
        with TGraphLink(GraphObject) do
        begin
          RotateOrg := CenterOfPoints(Polyline);
          Rotate(-Pi / 2, RotateOrg);
        end;
    FEO_GROW25:
      if GraphObject is TGraphLink then
          TGraphLink(GraphObject).Scale(1.25);
    FEO_SHRINK25:
      if GraphObject is TGraphLink then
          TGraphLink(GraphObject).Scale(0.75);
    FEO_SetFontColor:
      GraphObject.Font.Color := clbxFontColor.Selected;
    FEO_SetBorder:
      if chkBorder.Checked then
          GraphObject.Pen.Style := psSolid
      else
          GraphObject.Pen.Style := psClear;
    FEO_SetLineColor:
      GraphObject.Pen.Color := clbxLineColor.Selected;
    FEO_SetBackColor:
      GraphObject.Brush.Color := clbxBackColor.Selected;
    FEO_SetAutoSize:
      if GraphObject is TGPTextNode then
          TGPTextNode(GraphObject).AutoSize := chkTextAutoSize.Checked;
    FEO_SetTransparency:
      if GraphObject is TGPGraphNode then
          TGPGraphNode(GraphObject).Transparency := trcTransparency.Tag
      else if GraphObject is TGPPolygonalNode then
          TGPPolygonalNode(GraphObject).Transparency := trcTransparency.Tag;
    FEO_SetGDIP:
      if GraphObject is TGPTextNode then
          TGPTextNode(GraphObject).UseGdipDrawText := chkUseGDIP.Checked;
    FEO_SetLineWidth:
      GraphObject.Pen.Width := cmbLineWidth.ItemIndex;
    FEO_SetDataAlignRight:
      if GraphObject is TGPTextNode then
        (GraphObject as TGPTextNode).DataAlignRight := chkDataAlighRight.Checked;
    FEO_DisableSelectMap:
      if GraphObject is TdmcMap then
        (GraphObject as TdmcMap).Selectable := not actDisableSelectMap.Checked;
    FEO_XDirectData:
      if GraphObject is TdmcDeformationDirection then
        (GraphObject as TdmcDeformationDirection).XDataName := cmbXData.Text;
    FEO_YDirectData:
      if GraphObject is TdmcDeformationDirection then
        (GraphObject as TdmcDeformationDirection).YDataName := cmbYData.Text;
    FEO_PointAngle:
      if GraphObject is TdmcDeformationDirection then
        (GraphObject as TdmcDeformationDirection).AngleFromNorth := StrToFloat(edtPointAngle.Text);
    FEO_UseGlobalAngle:
      if GraphObject is TdmcDeformationDirection then
        (GraphObject as TdmcDeformationDirection).UseGlobalAngle := chkUseGlobalAngle.Checked;
    else
        Result := False;
  end;
end;

procedure TfrmEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if sgLayout.Modified then
  begin
    case MessageBox(0, '正在编辑的图形已经改变，是否先保存？', '注意！', MB_ICONWARNING or MB_YESNOCANCEL) of
      mrYes:
        actSaveLayout.Execute;
      mrCancel:
        // do nothing, close form directly
        ;
    end;
  end;
end;

procedure TfrmEditor.FormCreate(Sender: TObject);
begin
  cmbFonts.Items := Screen.Fonts;
  sgLayout.OnObjectEndDrag := Self.GraphEndDragging;
  LoadPredefines;
  LoadStylesInCombo;
end;

procedure TfrmEditor.LoadStylesInCombo;
var
  i: Integer;
begin
  cbxStyles.Items.Clear;
  if PreDefines.Count = 0 then Exit;
  for i := 0 to PreDefines.Count - 1 do
      cbxStyles.Items.Add(PreDefines.Items[i].DefName);
end;

procedure TfrmEditor.actActualSizeExecute(Sender: TObject);
begin
  sgLayout.Zoom := 100;
end;

procedure TfrmEditor.actActualSizeUpdate(Sender: TObject);
begin
  actActualSize.Enabled := sgLayout.Zoom <> 100;
end;

procedure TfrmEditor.actAlignExecute(Sender: TObject);
var
  H: THAlignOption;
  V: TVAlignOption;
begin
  if TAlignDialog.Execute(H, V) then
      sgLayout.AlignSelection(H, V);
end;

procedure TfrmEditor.actBringToFrontExecute(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_BRINGTOFRONT, True);
end;

procedure TfrmEditor.actBringToFrontUpdate(Sender: TObject);
begin
  actBringToFront.Enabled := sgLayout.SelectedObjects.Count > 0;
end;

procedure TfrmEditor.actCopyExecute(Sender: TObject);
begin
  sgLayout.CopyToClipboard(True);
end;

procedure TfrmEditor.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := sgLayout.SelectedObjects.Count > 0;
end;

procedure TfrmEditor.actCutExecute(Sender: TObject);
begin
  actCopy.Execute;
  actDelete.Execute;
end;

procedure TfrmEditor.actCutUpdate(Sender: TObject);
begin
  actCut.Enabled := sgLayout.SelectedObjects.Count > 0;
end;

procedure TfrmEditor.actDeleteExecute(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_DELETE, True);
end;

procedure TfrmEditor.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := sgLayout.SelectedObjects.Count > 0;
end;

procedure TfrmEditor.actDisableSelectMapExecute(Sender: TObject);
begin
  actDisableSelectMap.Checked := not actDisableSelectMap.Checked;
  piDisableSelectMap.Checked := actDisableSelectMap.Checked;
  sgLayout.ForEachObject(ForEachCallback, FEO_DisableSelectMap);
end;

procedure TfrmEditor.actInsBackgroudExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TdmcMap;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsBackgroudUpdate(Sender: TObject);
begin
  actInsBackgroud.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TdmcMap);
end;

procedure TfrmEditor.actInsDataItemExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TdmcDataItem;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsDataItemUpdate(Sender: TObject);
begin
  actInsDataItem.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TdmcDataItem);
end;

procedure TfrmEditor.actInsDeformDirectExecute(Sender: TObject);
begin
  sgLayout.DefaultLinkClass := TdmcDeformationDirection;
  sgLayout.CommandMode := cmInsertLink;
end;

procedure TfrmEditor.actInsDeformDirectUpdate(Sender: TObject);
begin
  actInsDeformDirect.Checked := (sgLayout.CommandMode = cmInsertLink) and
    (sgLayout.DefaultLinkClass = TdmcDeformationDirection);
end;

procedure TfrmEditor.actInsEllipticExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPEllipticNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsEllipticUpdate(Sender: TObject);
begin
  actInsElliptic.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPEllipticNode);
end;

procedure TfrmEditor.actInsLinkExecute(Sender: TObject);
begin
  sgLayout.DefaultLinkClass := TGPGraphicLink;
  sgLayout.CommandMode := cmInsertLink;
end;

procedure TfrmEditor.actInsLinkUpdate(Sender: TObject);
begin
  actInsLink.Checked := (sgLayout.CommandMode = cmInsertLink) and
    (sgLayout.DefaultLinkClass = TGPGraphicLink);
end;

procedure TfrmEditor.actInsPentagonalExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPPentagonalNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsPentagonalUpdate(Sender: TObject);
begin
  actInsPentagonal.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPPentagonalNode);
end;

procedure TfrmEditor.actInsRectangularExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPRectangularNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsRectangularUpdate(Sender: TObject);
begin
  actInsRectangular.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPRectangularNode);
end;

procedure TfrmEditor.actInsRhomboidalExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPRhomboidalNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsRhomboidalUpdate(Sender: TObject);
begin
  actInsRhomboidal.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPRhomboidalNode);
end;

procedure TfrmEditor.actInsTextExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPTextNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsTextUpdate(Sender: TObject);
begin
  actInsText.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPTextNode);
end;

procedure TfrmEditor.actInsTriangularExecute(Sender: TObject);
begin
  sgLayout.DefaultNodeClass := TGPTriangularNode;
  sgLayout.CommandMode := cmInsertNode;
end;

procedure TfrmEditor.actInsTriangularUpdate(Sender: TObject);
begin
  actInsTriangular.Checked := (sgLayout.CommandMode = cmInsertNode) and
    (sgLayout.DefaultNodeClass = TGPTriangularNode);
end;

procedure TfrmEditor.actLinkDatabaseExecute(Sender: TObject);
begin
  if FLastPrjPath <> '' then
      dlgOpenPrjConfig.InitialDir := FLastPrjPath;

  if dlgOpenPrjConfig.Execute then
  begin
    FLastPrjPath := ExtractFileDir(dlgOpenPrjConfig.FileName);
    tvwMeters.Items.Clear;
    LoadProjectConfig(dlgOpenPrjConfig.FileName);
    if ExcelMeters.Count > 0 then
        ShowMeters;
  end;
end;

procedure TfrmEditor.actLoadLayoutExecute(Sender: TObject);
var
  i: Integer;
begin
  if sgLayout.Modified then
  begin
    case MessageBox(0, '正在编辑的图形已经改变，是否先保存？', '注意！', MB_ICONWARNING or MB_YESNOCANCEL) of
      mrYes:
        actSaveLayout.Execute;
      mrCancel:
        Exit;
    end;
  end;

  if ENV_SchemePath <> '' then
      dlgOpenLayout.InitialDir := ENV_SchemePath;

  if dlgOpenLayout.Execute then
  begin
    FLastMapPath := ExtractFileDir(dlgOpenLayout.FileName);
    FLoading := True;
    FLayoutfile := dlgOpenLayout.FileName;
    sgLayout.LoadFromFile(dlgOpenLayout.FileName);
    Caption := dlgOpenLayout.FileName + ' - ' + Application.Title;
    dlgSaveLayout.FileName := dlgOpenLayout.FileName;
    // 如果有底图，则设置底图的属性
    with sgLayout.Objects do
      for i := 0 to Count - 1 do
        if Items[i] is TdmcMap then
        begin
          edtAngle.Text := FloatToStr((Items[i] as TdmcMap).AngleFromNorth);
          edtFactor.Text := IntToStr((Items[i] as TdmcMap).OneMMLength);
        end;
    FLoading := False;
  end;
end;

procedure TfrmEditor.actNewFileExecute(Sender: TObject);
begin
  if sgLayout.Modified then
  begin
    case MessageBox(0, '正在编辑的图形已经改变，是否先保存？', '注意！', MB_ICONWARNING or MB_YESNOCANCEL) of
      mrYes:
        actSaveLayout.Execute;
      mrCancel:
        Exit;
    end;
  end;

  sgLayout.Clear;
  sgLayout.Zoom := 100;
  sgLayout.CommandMode := cmEdit;
  dlgSaveLayout.FileName := SUntitled;
  Caption := '新布置图 - ' + Application.Title;
end;

procedure TfrmEditor.actPanModeExecute(Sender: TObject);
begin
  sgLayout.CommandMode := cmPan;
end;

procedure TfrmEditor.actPanModeUpdate(Sender: TObject);
begin
  actPanMode.Checked := sgLayout.CommandMode = cmPan;
  actPanMode.Enabled := (sgLayout.HorzScrollBar.IsScrollBarVisible or
    sgLayout.VertScrollBar.IsScrollBarVisible);
end;

procedure TfrmEditor.actPasteExecute(Sender: TObject);
begin
  sgLayout.PasteFromClipboard;
end;

procedure TfrmEditor.actPasteUpdate(Sender: TObject);
begin
  actPaste.Enabled := Clipboard.HasFormat(CF_SIMPLEGRAPH);
end;

procedure TfrmEditor.actPropertyExecute(Sender: TObject);
var
  LinkCount: Integer;
begin
  if sgLayout.SelectedObjects.Count = 0 then
      TDesignerProperties.Execute(sgLayout)
  else
  begin
    LinkCount := sgLayout.SelectedObjectsCount(TGraphLink);
    if LinkCount = 0 then
        TNodeProperties.Execute(sgLayout.SelectedObjects)
    else if LinkCount = sgLayout.SelectedObjects.Count then
        TLinkProperties.Execute(sgLayout.SelectedObjects)
    else
        TObjectProperties.Execute(sgLayout.SelectedObjects);
  end;
end;

procedure TfrmEditor.actRestoreOriginBackgroundSizeExecute(Sender: TObject);
var
  i: Integer;
begin
  if sgLayout.SelectedObjects.Count = 0 then
      Exit;
  for i := 0 to sgLayout.SelectedObjects.Count - 1 do
    if sgLayout.SelectedObjects.Items[i] is TdmcMap then
        TdmcMap(sgLayout.SelectedObjects.Items[i]).SetBoundRectOriginal;
end;

procedure TfrmEditor.actRestoreOriginBackgroundSizeUpdate(Sender: TObject);
begin
  actRestoreOriginBackgroundSize.Enabled := sgLayout.SelectedObjectsCount(TdmcMap) > 0;
end;

procedure TfrmEditor.actSaveLayoutExecute(Sender: TObject);
begin
  if ENV_SchemePath <> '' then
      dlgSaveLayout.InitialDir := ENV_SchemePath;

  if dlgSaveLayout.Execute then
  begin
    FLayoutfile := dlgSaveLayout.FileName;
    sgLayout.SaveToFile(dlgSaveLayout.FileName);
    Self.Caption := dlgSaveLayout.FileName + ' - ' + Application.Title;
  end;
end;

procedure TfrmEditor.actSaveLayoutUpdate(Sender: TObject);
begin
  actSaveLayout.Enabled := sgLayout.Modified;
end;

procedure TfrmEditor.actSelectModeExecute(Sender: TObject);
begin
  sgLayout.CommandMode := cmEdit;
end;

procedure TfrmEditor.actSelectModeUpdate(Sender: TObject);
begin
  actSelectMode.Checked := sgLayout.CommandMode = cmEdit;
end;

procedure TfrmEditor.actSendToBackExecute(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SENDTOBACK, True);
end;

procedure TfrmEditor.actWholeGraphExecute(Sender: TObject);
begin
  sgLayout.ZoomGraph;
end;

procedure TfrmEditor.actWholeGraphUpdate(Sender: TObject);
begin
  actWholeGraph.Enabled := (sgLayout.Objects.Count > 0);
end;

procedure TfrmEditor.actZoomInExecute(Sender: TObject);
begin
  sgLayout.ChangeZoomBy(10, zoCursorCenter);
end;

procedure TfrmEditor.actZoomInUpdate(Sender: TObject);
begin
  actZoomIn.Enabled := sgLayout.Zoom < high(TZoom);
end;

procedure TfrmEditor.actZoomOutExecute(Sender: TObject);
begin
  sgLayout.ChangeZoomBy(-10, zoCursorCenter);
end;

procedure TfrmEditor.actZoomOutUpdate(Sender: TObject);
begin
  actZoomOut.Enabled := sgLayout.Zoom > low(TZoom);
end;

procedure TfrmEditor.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  if sgLayout.PZState = 1 then
  begin
    sgLayout.PZState := 0;
    sgLayout.Invalidate;
  end;
end;

procedure TfrmEditor.btnOpenStyleEditorClick(Sender: TObject);
var
  frm: TfrmStyles;
begin
  frm := TfrmStyles.Create(Self);
  frm.ShowModal;
  frm.Release;
end;

procedure TfrmEditor.btnSaveAsStyleClick(Sender: TObject);
var
  NewEd: PElementDefine;
  frm  : TfrmStyles;
begin
  NewEd := PreDefines.AddNew;
  NewEd.DefName := '新样式';
  NewEd.bkColor := clbxBackColor.Selected;
  NewEd.lnColor := clbxLineColor.Selected;
  NewEd.fontColor := clbxFontColor.Selected;
  NewEd.LineWidth := strtoint(cmbLineWidth.Text);
  NewEd.fontName := cmbFonts.Text;
  NewEd.fontSize := strtoint(cmbFontSize.Text);
  NewEd.AutoFit := chkTextAutoSize.Checked;
  NewEd.UseGDIPlus := chkUseGDIP.Checked;
  NewEd.Border := chkBorder.Checked;
  NewEd.AlignRight := chkDataAlighRight.Checked;
  NewEd.Transparency := Self.trcTransparency.Position;
  frm := TfrmStyles.Create(Self);
  frm.EditStyle(NewEd);
  frm.ShowModal;
  frm.Release;
  CurentStyle := NewEd;
  LoadStylesInCombo;
end;

procedure TfrmEditor.btnSaveStylesClick(Sender: TObject);
begin
  SavePreDefines;
  LoadStylesInCombo;
end;

procedure TfrmEditor.btnSetAsDefaultClick(Sender: TObject);
begin
  FdefFontName := cmbFonts.Text;
  FdefFontSize := strtoint(cmbFontSize.Text);
  FdefFontColor := clbxFontColor.Selected;
  FdefBackColor := clbxBackColor.Selected;
  FdefLineColor := clbxLineColor.Selected;
  FdefTrans := trcTransparency.Position; // round(trcTransparency.Position * 2.55);
  FdefBorder := chkBorder.Checked;
  FdefLineWidth := cmbLineWidth.ItemIndex;
  FdefAlignRight := chkDataAlighRight.Checked;
  FCurStyle := nil;
end;

procedure TfrmEditor.cbxStylesChange(Sender: TObject);
begin
  if cbxStyles.ItemIndex <> -1 then
      CurentStyle := PreDefines.Items[cbxStyles.ItemIndex];
end;

procedure TfrmEditor.chkBorderClick(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetBorder, True);
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// if FSelectedGObj is TGPTextNode then
// if chkBorder.Checked then
// TGPTextNode(FSelectedGObj).Pen.Style := psSolid
// else
// TGPTextNode(FSelectedGObj).Pen.Style := psClear;
end;

procedure TfrmEditor.chkDataAlighRightClick(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetDataAlignRight, True);
end;

procedure TfrmEditor.chkTextAutoSizeClick(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetAutoSize, True);
// if not FLoadingProperties then
// if (sgLayout.SelectedObjects.Count = 1) and
// (sgLayout.SelectedObjects.Items[0] = FSelectedGObj) then
// if FSelectedGObj is TGPTextNode then
// TGPTextNode(FSelectedGObj).AutoSize := chkTextAutoSize.Checked;
end;

procedure TfrmEditor.chkUseGDIPClick(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetGDIP, True);
// if not FLoadingProperties then
// if (sgLayout.SelectedObjects.Count = 1) and
// (sgLayout.SelectedObjects.Items[0] = FSelectedGObj) then
// if FSelectedGObj is TGPTextNode then
// TGPTextNode(FSelectedGObj).UseGdipDrawText := chkUseGDIP.Checked;
end;

procedure TfrmEditor.chkUseGlobalAngleClick(Sender: TObject);
begin
  if FLoadingProperties then Exit;
  (*
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDeformationDirection then
    begin
      TdmcDeformationDirection(FSelectedGObj).UseGlobalAngle := chkUseGlobalAngle.Checked;
      Modified;
    end;
 *)
  sgLayout.ForEachObject(ForEachCallback, FEO_UseGlobalAngle, True);
  Modified;
end;

procedure TfrmEditor.clbxBackColorChange(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetBackColor, True);
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// FSelectedGObj.Brush.Color := clbxBackColor.Selected;
end;

procedure TfrmEditor.clbxFontColorChange(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetFontColor, True);
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// FSelectedGObj.Font.Color := clbxFontColor.Selected;
end;

procedure TfrmEditor.clbxLineColorChange(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetLineColor, True);
//
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// FSelectedGObj.Pen.Color := clbxLineColor.Selected;
end;

procedure TfrmEditor.cmbDeformNameChange(Sender: TObject);
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDeformationDirection then
    begin
      TdmcDeformationDirection(FSelectedGObj).DesignName := cmbDeformName.Text;
      Modified;
    end;
end;

procedure TfrmEditor.cmbFontsChange(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SETFONTFACE, True);
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// FSelectedGObj.Font.Name := cmbFonts.Text;
end;

procedure TfrmEditor.cmbFontSizeChange(Sender: TObject);
var
  i: Integer;
begin
  if TryStrToInt(cmbFontSize.Text, i) then
  begin
    cmbFontSize.Tag := i;
    sgLayout.ForEachObject(ForEachCallback, FEO_SETFONTSIZE, True);
  end;
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// begin
// if TryStrToInt(cmbFontSize.Text, i) then
// FSelectedGObj.Font.Size := i;
// end;
end;

procedure TfrmEditor.cmbLineWidthChange(Sender: TObject);
begin
  sgLayout.ForEachObject(ForEachCallback, FEO_SetLineWidth, True);
end;

procedure TfrmEditor.cmbXDataChange(Sender: TObject);
begin
  if FLoadingProperties then Exit;
  (*
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDeformationDirection then
    begin
      TdmcDeformationDirection(FSelectedGObj).XDataName := cmbXData.Text;
      Modified;
    end;
 *)
  // 2020-06-12
  sgLayout.ForEachObject(ForEachCallback, FEO_XDirectData, True);
  Modified;
end;

procedure TfrmEditor.cmbYDataChange(Sender: TObject);
begin
  if FLoadingProperties then Exit;
  (*
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDeformationDirection then
    begin
      TdmcDeformationDirection(FSelectedGObj).YDataName := cmbYData.Text;
      Modified;
    end;
 *)
  sgLayout.ForEachObject(ForEachCallback, FEO_YDirectData, True);
  Modified;
end;

procedure TfrmEditor.edtAngleChange(Sender: TObject);
var
  i: Integer;
begin
  if FLoadingProperties then
      Exit;
  // 如果选中对象是底图，则设置之
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
  begin
    if FSelectedGObj is TdmcMap then
    begin
      TdmcMap(FSelectedGObj).AngleFromNorth := StrToFloat(edtAngle.Text);
      Modified;
    end;
  end
  else // 如果没有选中底图，则自动查找，对找到的第一个底图进行此项操作
  begin
    for i := 0 to sgLayout.Objects.Count - 1 do
      if sgLayout.Objects.Items[i] is TdmcMap then
      begin
        TdmcMap(sgLayout.Objects.Items[i]).AngleFromNorth := StrToFloat(edtAngle.Text);
        Modified;
        Break;
      end;
  end;
end;

procedure TfrmEditor.edtDataNameChange(Sender: TObject);
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDataItem then
        TdmcDataItem(FSelectedGObj).DataName := edtDataName.Text;
end;

procedure TfrmEditor.edtDataUnitChange(Sender: TObject);
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDataItem then
        TdmcDataItem(FSelectedGObj).DataUnit := edtDataUnit.Text;
end;

procedure TfrmEditor.edtFactorChange(Sender: TObject);
var
  i: Integer;
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
  begin
    if FSelectedGObj is TdmcMap then
        TdmcMap(FSelectedGObj).OneMMLength := strtoint(edtFactor.Text);
  end
  else
    for i := 0 to sgLayout.Objects.Count - 1 do
      if sgLayout.Objects.Items[i] is TdmcMap then
      begin
        TdmcMap(sgLayout.Objects.Items[i]).OneMMLength := strtoint(edtFactor.Text);
        Break;
      end;
  Modified;
end;

procedure TfrmEditor.edtIDChange(Sender: TObject);
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDataItem then
        TdmcDataItem(FSelectedGObj).DesignName := edtID.Text;
end;

procedure TfrmEditor.edtPointAngleChange(Sender: TObject);
begin
  if FLoadingProperties then Exit;
  (*
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
    if FSelectedGObj is TdmcDeformationDirection then
    begin
      TdmcDeformationDirection(FSelectedGObj).AngleFromNorth := StrToFloat(edtPointAngle.Text);
      Modified;
    end;
 *)
  sgLayout.ForEachObject(ForEachCallback, FEO_PointAngle, True);
  Modified;
end;

procedure TfrmEditor.edtSeekChange(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if edtSeek.Text = '' then
      Exit;
    // 查找：
  s := UpperCase(edtSeek.Text);
  for i := 0 to tvwMeters.Items.Count - 1 do
    if Pos(s, UpperCase(tvwMeters.Items[i].Text)) > 0 then
    begin
      tvwMeters.Items[i].Selected := True;
      tvwMeters.Items[i].MakeVisible;
      Exit;
    end;
  tvwMeters.Selected := nil;
end;

procedure TfrmEditor.edtTextChange(Sender: TObject);
begin
  if FLoadingProperties then
      Exit;
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
  then
      FSelectedGObj.Text := edtText.Text;
end;
{-----------------------------------------------------------------------------
  Procedure  : sgLayoutDragDrop
  Description: 本方法主要处理从仪器树拖拽仪器名或仪器数据项到图纸上，创建对应
  的图元、应用样式、自动对齐等工作。
-----------------------------------------------------------------------------}
procedure TfrmEditor.sgLayoutDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  go         : TGraphNode;
  tp         : TPoint;
  bNeedAlign : Boolean; // 需要设置对齐
  bSetDefault: Boolean; // 需要设置缺省值
  oo         : TGraphObject;
  tpooTL,
    tpooBR: TPoint; // 对象oo的左上角和右下角坐标;
  Style   : TElementDefine;
  dW, dH  : Integer; // 被覆盖图元宽、高的三分之一
  drpSide : Integer; // 10-Topleft; 11-Left; 12-BottemLeft; 20- TopRight; 21-Right; 22-BottomRight
begin
  tp := sgLayout.ClientToGraph(X, Y);
  oo := sgLayout.FindObjectAt(tp.X, tp.Y);

  if ADragItem.NodeType = ntMeter then
      Style := GetMatchStyle(dtLabel, ADragItem.Meter.Params.MeterType)
  else if ADragItem.NodeType = ntDataItem then
      Style := GetMatchStyle(dtDataItem, ADragItem.Meter.Params.MeterType)
  else
      Style := RetCurrentStyle;

  // 如果X，Y处有东西，且为TGPTEXTNODE对象，则需要对齐
  // 这里的MeterLabel和DataItem只和TextNode类型对齐，这种方法带来的问题是无法覆盖，可能减少了一些
  // 表现方法。
  { todo: 增加打开/关闭自动对齐的开关 }
  if (oo <> nil) and (oo is TGPTextNode) then
  begin
    { 自动判断对齐的方法：
           +-------------+
           |1     a     4|
           |2           5|
           |3     b     6|
           +-------------+
      判断tp的位置，1：TopLeft; 2:Right; 3:BottomLeft; a: 顶端+对齐设置; b:底端+对齐设置;
      4: TopRight; 5: Left; 6: BottomRight;
 }
    tpooTL := (oo as TGPTextNode).BoundsRect.TopLeft;
    tpooBR := (oo as TGPTextNode).BoundsRect.BottomRight;
    dW := (tpooBR.X - tpooTL.X) div 3; // 宽度的三分之一
    dH := (tpooBR.Y - tpooTL.Y) div 3; // 高度的三分之一
    // 判断tp的位置
    if (tp.X >= tpooTL.X) and (tp.X <= tpooTL.X + { 20 } dW) then
        drpSide := 10
    else if (tp.X >= tpooBR.X - { 20 } dW) and (tp.X <= tpooBR.X) then
        drpSide := 20;

    if (tp.Y >= tpooTL.Y) and (tp.Y <= tpooTL.Y + { 5 } dH) then
        drpSide := drpSide + 0
    else if (tp.Y >= tpooBR.Y - { 5 } dH) and (tp.Y <= tpooBR.Y) then
        drpSide := drpSide + 2
    else
        drpSide := drpSide + 1;

    bNeedAlign := True;
    (*
    if not Style.AlignRight then
    begin
      tp.X := (oo as TGPTextNode).Left;
      tp.Y := (oo as TGPTextNode).BoundsRect.Bottom + 2;
    end
    else
    begin
      tp.X := (oo as TGPTextNode).BoundsRect.Right - 10;
      tp.Y := (oo as TGPTextNode).BoundsRect.Bottom + 2;
    end;
    *)
  end
  else
      bNeedAlign := False;

  if ADragItem.NodeType = ntMeter then
  begin
    // if ADragItem.Meter.Params.MeterType = '平面变形测点' then
      // go := TdmcDeformationDirection.CreateNew(sgLayout,nil,[tp, Point(tp.X, tp.Y+10)],nil)
    // else
    // go := TGPTextNode.CreateNew(sgLayout, Rect(tp.X, tp.Y, 10, 10))
    go := TdmcMeterLabel.CreateNew(sgLayout, Rect(tp.X, tp.Y, tp.X + 10, tp.Y + 10));
    (*
    if FCurStyle <> nil then
      (go as TGPTextNode).DataAlignRight := FCurStyle.AlignRight
    else
      (go as TGPTextNode).DataAlignRight := FdefAlignRight;
 *)
  end
  else if ADragItem.NodeType = ntDataItem then
  begin
    go := TdmcDataItem.CreateNew(sgLayout, Rect(tp.X, tp.Y, tp.X + 10, tp.Y + 10));
    (*
    if FCurStyle <> nil then
      (go as TGPTextNode).DataAlignRight := FCurStyle.AlignRight
    else
      (go as TGPTextNode).DataAlignRight := FdefAlignRight;
 *)
  end
  else
      Exit;

  go.Text := ADragItem.Meter.DesignName;
  if go is TdmcDataItem then
    with go as TdmcDataItem do
    begin
      DesignName := ADragItem.Meter.DesignName;
      DataName := ADragItem.DataName;
      Text := DesignName + ':' + DataName;
      MeterType := ADragItem.Meter.Params.MeterType;
    end
  else if go is TdmcMeterLabel then
    with go as TdmcMeterLabel do
    begin
      DesignName := ADragItem.Meter.DesignName;
      MeterType := ADragItem.Meter.Params.MeterType;
    end;

  // 取回适当的图元样式
  // Style := GetMatchStyle(go, ADragItem.Meter.Params.MeterType);
  // 根据样式设置图元
  go.Font.Name := Style.fontName;
  go.Font.Size := Style.fontSize;
  go.Font.Color := Style.fontColor;
  go.Brush.Color := Style.bkColor;
  TGPTextNode(go).Transparency := Trunc(Style.Transparency * 2.55);
  if Style.Border then
      TGPTextNode(go).Pen.Style := psSolid
  else
      TGPTextNode(go).Pen.Style := psClear;

  TGPTextNode(go).DataAlignRight := Style.AlignRight;
  go.Pen.Width := Style.LineWidth;
  // 这里根据对齐方式调整新增图元的Left位置
  (*
  if bNeedAlign and Style.AlignRight then
      TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;
 *)
  // 新自动调整方法
  if bNeedAlign then
    case drpSide of
      10: // TopLeft
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Left;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top - TGPTextNode(go).Height - 2;
          TGPTextNode(go).DataAlignRight := False;
        end;
      11: // Left
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Left - TGPTextNode(go).Width - 2;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top;
          TGPTextNode(go).DataAlignRight := True;
        end;
      12: // BottomLeft
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Left;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top + TGPTextNode(go).Height + 2;
          TGPTextNode(go).DataAlignRight := False;
        end;
      20: // TopRight
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top - TGPTextNode(go).Height - 2;
          TGPTextNode(go).DataAlignRight := True;
        end;
      21: // Right
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right + 2;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top;
          TGPTextNode(go).DataAlignRight := False;
        end;
      22: // BottomRight
        begin
          TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;
          TGPTextNode(go).Top := (oo as TGPTextNode).BoundsRect.Top + TGPTextNode(go).Height + 2;
          TGPTextNode(go).DataAlignRight := True;
        end;
    else
      if Style.AlignRight then
      begin
        TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;
        TGPTextNode(go).DataAlignRight := Style.AlignRight;
      end;
    end;

(*
    { 如果FdefFontName<>''，说明已经设置过了缺省属性 }
  if bSetDefault then
  begin
    go.Font.Name := FdefFontName;
    go.Font.Size := FdefFontSize;
    go.Font.Color := FdefFontColor;
    go.Brush.Color := FdefBackColor;
    TGPTextNode(go).Transparency := FdefTrans;
    if FdefBorder then
        TGPTextNode(go).Pen.Style := psSolid
    else
        TGPTextNode(go).Pen.Style := psClear;
    TGPTextNode(go).DataAlignRight := FdefAlignRight;

    if FdefAlignRight then
        TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;

    go.Pen.Width := FdefLineWidth;
  end
  else if FCurStyle <> nil then
  begin
    go.Font.Name := FCurStyle.fontName;
    go.Font.Size := FCurStyle.fontSize;
    go.Font.Color := FCurStyle.fontColor;
    go.Brush.Color := FCurStyle.bkColor;
    TGPTextNode(go).Transparency := FCurStyle.Transparency;
    if FCurStyle.Border then
        TGPTextNode(go).Pen.Style := psSolid
    else
        TGPTextNode(go).Pen.Style := psClear;
    TGPTextNode(go).DataAlignRight := FCurStyle.AlignRight;

    if FCurStyle.AlignRight then
        TGPTextNode(go).Left := (oo as TGPTextNode).BoundsRect.Right - TGPTextNode(go).Width;

    go.Pen.Width := FCurStyle.LineWidth;
  end;
 *)
end;

procedure TfrmEditor.sgLayoutDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
    // ShowMessage('Drag over');
  Accept := (ADragItem <> nil) and (ADragItem.NodeType <> ntClass);
end;

procedure TfrmEditor.sgLayoutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  FHoldSpaceKey := Key = 32;
  if sgLayout.CommandMode <> cmPan then
    if FHoldSpaceKey then
    begin
      FPreCmd := sgLayout.CommandMode;
      sgLayout.CommandMode := cmPan;
    end;
end;

procedure TfrmEditor.sgLayoutKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 32 then
  begin
    if FHoldSpaceKey then
    begin
      FHoldSpaceKey := False;
      if sgLayout.CommandMode = cmPan then
      begin
        sgLayout.CommandMode := FPreCmd;
        if FPreCmd <> cmPan then
            sgLayout.Invalidate;
      end;
    end;
  end;
end;

procedure TfrmEditor.sgLayoutMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  MousePos := sgLayout.ScreenToClient(MousePos);
  if PtInRect(sgLayout.ClientRect, MousePos) then
  begin
    sgLayout.ChangeZoomBy(-2, zocursor);
// for I := 1 to 5 do
// begin
// sgLayout.ChangeZoomBy(-1, zoCursor);
// sgLayout.Update;
// end;
    Handled := True;
  end;
end;

procedure TfrmEditor.sgLayoutMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
  var Handled: Boolean);
var
  i: Integer;
begin
  MousePos := sgLayout.ScreenToClient(MousePos);
  if PtInRect(sgLayout.ClientRect, MousePos) then
  begin
    sgLayout.ChangeZoomBy(2, zocursor);
// for I := 1 to 5 do
// begin
// sgLayout.ChangeZoomBy(+1, zoCursor);
// sgLayout.Update;
// end;
    Handled := True;
  end;
end;

procedure TfrmEditor.sgLayoutObjectChange(Graph: TSimpleGraph; GraphObject: TGraphObject);
begin
  if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = GraphObject)
  then
  begin
    FLoadingProperties := True;
    FSelectedGObj := GraphObject;
    cmbFonts.Text := GraphObject.Font.Name;
    cmbFontSize.Text := IntToStr(GraphObject.Font.Size);
    clbxFontColor.Selected := GraphObject.Font.Color;
    clbxBackColor.Selected := GraphObject.Brush.Color;
    clbxLineColor.Selected := GraphObject.Pen.Color;
    edtText.Text := GraphObject.Text;

    edtID.Enabled := (GraphObject is TdmcDataItem) or (GraphObject is TdmcMeterLabel);
    edtDataName.Enabled := (GraphObject is TdmcDataItem);
    chkBorder.Enabled := GraphObject is TGPTextNode;

    if GraphObject is TGPTextNode then // 标签类
    begin
      CategoryPanel2.Collapsed := True;
      CategoryPanel3.Collapsed := True;
      trcTransparency.Enabled := True;
      trcTransparency.Position := round(TGPTextNode(GraphObject).Transparency / 255 * 100);
      chkBorder.Checked := GraphObject.Pen.Style <> psClear;
      chkTextAutoSize.Checked := TGPTextNode(GraphObject).AutoSize;
      chkUseGDIP.Checked := TGPTextNode(GraphObject).UseGdipDrawText;
      chkDataAlighRight.Checked := TGPTextNode(GraphObject).DataAlignRight;
      if GraphObject is TdmcDataItem then
      begin
        edtID.Text := TdmcDataItem(GraphObject).DesignName;
        edtDataName.Text := TdmcDataItem(GraphObject).DataName;
        edtDataUnit.Text := TdmcDataItem(GraphObject).DataUnit;
      end
      else if GraphObject is TdmcMeterLabel then
      begin
        edtID.Text := TdmcMeterLabel(GraphObject).DesignName;
        edtDataName.Text := '';
        edtDataUnit.Text := '';
      end;
    end
    else if GraphObject is TdmcMap then
    begin
      CategoryPanel2.Collapsed := False; // 展开
      CategoryPanel3.Collapsed := True;
      edtAngle.Text := FormatFloat('0.00', (GraphObject as TdmcMap).AngleFromNorth);
      edtFactor.Text := IntToStr((GraphObject as TdmcMap).OneMMLength);
    end
    else if GraphObject is TdmcDeformationDirection then
    begin
      CategoryPanel3.Collapsed := False;
      with GraphObject as TdmcDeformationDirection do
      begin
        cmbDeformName.ItemIndex := cmbDeformName.Items.IndexOf(DesignName);
        cmbXData.ItemIndex := cmbXData.Items.IndexOf(XDataName);
        cmbYData.ItemIndex := cmbYData.Items.IndexOf(YDataName);
      // cmbDeformName.Text := (GraphObject as TdmcDeformationDirection).DesignName;
        // cmbXData.Text := (GraphObject as TdmcDeformationDirection).XDataName;
        // cmbYData.Text := (GraphObject as TdmcDeformationDirection).YDataName;
        edtPointAngle.Text := FormatFloat('0.00', AngleFromNorth);
        chkUseGlobalAngle.Checked := UseGlobalAngle;
      end;
    end
    else if GraphObject is TGPGraphNode then
    begin
      CategoryPanel2.Collapsed := True;
      CategoryPanel3.Collapsed := True;
      trcTransparency.Enabled := True;
      trcTransparency.Position := round(TGPGraphNode(GraphObject).Transparency / 255 * 100);
    end
    else
        trcTransparency.Enabled := False;

    FLoadingProperties := False;
  end;
end;

procedure TfrmEditor.sgLayoutObjectDblClick(Graph: TSimpleGraph; GraphObject: TGraphObject);
begin
  actProperty.Execute;
end;

procedure TfrmEditor.sgLayoutObjectInsert(Graph: TSimpleGraph; GraphObject: TGraphObject);
var
  Style: TElementDefine;
begin
  if FLoading then // 加载图形时，也会引起Insert事件，此时不做处理
      Exit;

  Style := GetMatchStyle(GraphObject, '');

  // 这时候应该是用户插入的新图形了
  if GraphObject is TdmcDataItem then
    with GraphObject as TdmcDataItem do
    begin
      if Text = '' then
        if DesignName = '' then
            Text := '观测数据(未指定仪器)'
        else if DataName = '' then
            Text := DesignName + ':未指定数据'
        else
            Text := DesignName + ':' + DataName;
    end
  else if GraphObject is TGPTextNode then
  begin
    if TGPTextNode(GraphObject).Text = '' then
        TGPTextNode(GraphObject).Text := 'Text';
  end
  else if GraphObject is TdmcDeformationDirection then { 2019-08-08 }
  begin
    GraphObject.Pen.Color := Style.lnColor;
    GraphObject.Pen.Width := Style.LineWidth;
    GraphObject.Font.Name := Style.fontName;
    GraphObject.Font.Size := Style.fontSize;
    GraphObject.Font.Color := Style.fontColor;
    GraphObject.Options := GraphObject.Options - [goLinkable]; // 不允许连接
  end
  else if GraphObject is TGraphLink then
  begin
    // 考虑自动将Caption设置为仪器编号？
    GraphObject.Pen.Color := Style.lnColor;
    GraphObject.Pen.Width := Style.LineWidth;
    GraphObject.Font.Name := Style.fontName;
    GraphObject.Font.Size := Style.fontSize;
    GraphObject.Font.Color := Style.fontColor;
    GraphObject.Options := GraphObject.Options - [goLinkable]; // 不允许连接
    if TGraphLink(GraphObject).Source is TdmcDataItem then
        TGraphLink(GraphObject).Text := TdmcDataItem(TGraphLink(GraphObject).Source).DesignName;
  end
  else
  begin
    GraphObject.Pen.Color := Style.lnColor;
    GraphObject.Pen.Width := Style.LineWidth;
    GraphObject.Font.Name := Style.fontName;
    GraphObject.Font.Size := Style.fontSize;
    GraphObject.Font.Color := Style.fontColor;
    GraphObject.Brush.Color := Style.bkColor;
    TGPPolygonalNode(GraphObject).Transparency := Style.Transparency;
    if Style.Border then
        TGPPolygonalNode(GraphObject).Pen.Style := psSolid
    else
        TGPPolygonalNode(GraphObject).Pen.Style := psClear;
    GraphObject.Pen.Width := Style.LineWidth;
  end;
end;

procedure TfrmEditor.sgLayoutObjectSelect(Graph: TSimpleGraph; GraphObject: TGraphObject);
begin
  if sgLayout.SelectedObjects.Count = 1 then
      sgLayoutObjectChange(sgLayout, sgLayout.SelectedObjects.Items[0]);
end;

procedure TfrmEditor.ShowMeters;
var
  i, k               : Integer;
  AMeter             : TMeterDefine;
  nPos, nType, nMeter: TTreeNode;
  nDataItem          : TTreeNode;
  sPos, sType        : string;
begin
  tvwMeters.Items.Clear;
  ExcelMeters.SortByPosition;
  sPos := '';
  sType := '';
  nPos := nil;
  nType := nil;
  cmbDeformName.Clear; // 清空平面变形测点列表
  cmbXData.Clear;
  cmbYData.Clear;
  for i := 0 to ExcelMeters.Count - 1 do
  begin
    AMeter := ExcelMeters.Items[i];
    // 增加一个工作部位
    if AMeter.PrjParams.Position <> sPos then
    begin
      sPos := AMeter.PrjParams.Position;
      sType := AMeter.Params.MeterType;
      nPos := tvwMeters.Items.Add(nil, sPos);
      nType := tvwMeters.Items.AddChild(nPos, sType);
      TmeterNode(nPos).NodeType := ntClass;
      TmeterNode(nType).NodeType := ntClass;
    end;
    // 增加一个仪器类型
    if AMeter.Params.MeterType <> sType then
    begin
      sType := AMeter.Params.MeterType;
      nType := tvwMeters.Items.AddChild(nPos, sType);
      TmeterNode(nType).NodeType := ntClass;
    end;
    // 增加仪器
    nMeter := tvwMeters.Items.AddChild(nType, AMeter.DesignName);
    if nMeter is TmeterNode then
    begin
      TmeterNode(nMeter).Meter := AMeter;
      TmeterNode(nMeter).NodeType := ntMeter;
      if AMeter.DataBook = '' then
          TmeterNode(nMeter).Valid := False
      else
          TmeterNode(nMeter).Valid := True;
      // 增加仪器的数据项
      for k := 0 to AMeter.PDDefines.Count - 1 do
      begin
        nDataItem := tvwMeters.Items.AddChild(nMeter, AMeter.PDDefine[k].Name);
        TmeterNode(nDataItem).Meter := AMeter;
        TmeterNode(nDataItem).NodeType := ntDataItem;
        TmeterNode(nDataItem).DataName := AMeter.PDDefine[k].Name;
      end;
    end;

    // 将平面变形测点添加到cmbDeformName中
    if AMeter.Params.MeterType = '平面位移测点' then
    begin
      cmbDeformName.Items.Add(AMeter.DesignName);
      if cmbXData.Items.Count = 0 then
        for k := 0 to AMeter.PDDefines.Count - 1 do
        begin
          cmbXData.Items.Add(AMeter.PDName(k));
          cmbYData.Items.Add(AMeter.PDName(k));
        end;
    end;
  end;
end;

procedure TfrmEditor.trcTransparencyChange(Sender: TObject);
var
  iTrans: Integer;
begin
  iTrans := Trunc(trcTransparency.Position * 2.55);
  trcTransparency.Tag := iTrans;
  sgLayout.ForEachObject(ForEachCallback, FEO_SetTransparency, True);
// if FLoadingProperties then
// exit;
// if (sgLayout.SelectedObjects.Count = 1) and (sgLayout.SelectedObjects.Items[0] = FSelectedGObj)
// then
// begin
// if FSelectedGObj is TGPGraphNode then
// TGPGraphNode(FSelectedGObj).Transparency := iTrans
// else if FSelectedGObj is TGPRectangularNode then
// TGPRectangularNode(FSelectedGObj).Transparency := iTrans;
// end;
end;

procedure TfrmEditor.tvwMetersCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TmeterNode;
end;

procedure TfrmEditor.tvwMetersEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  ADragItem := nil;
end;

procedure TfrmEditor.tvwMetersMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    // tvwMeters.GetHitTestInfoAt()
  if ssLeft in Shift then
  begin
    ADragItem := tvwMeters.GetNodeAt(X, Y) as TmeterNode;
    if ADragItem = nil then
        Exit;
    tvwMeters.BeginDrag(False, 5);
  end;
end;

procedure TfrmEditor.Modified;
begin
  sgLayout.Modified := True;
end;

/// <summary>
/// 2022-05-09 给本方法增加图元自动对齐的功能
/// </summary>
procedure TfrmEditor.GraphEndDragging(Graph: TSimpleGraph; GraphObject: TGraphObject; HT: Cardinal;
  Cancelled: Boolean);
var
  Obj    : TGraphObject;
  drpSide: Integer; // 值含义：10-顶左对齐；11-左侧右对齐；12-底左对齐；20-顶右对齐；21-右侧左对齐；
                    // 22-底右对齐
  coLT, coBR: TPoint; // Covered object top-left point & bottom-right point
  goLT      : TPoint; // graphobject top-left point
  dW, dH    : Integer;
begin
  // 只有TdmcDataItem和TdmcMeterLabel才享受本过程的处理
  if not((GraphObject is TdmcDataItem) or (GraphObject is TdmcMeterLabel)) then
  begin
    Cancelled := True;
    Exit;
  end;

  // 只有当GraphObject盖在其他东西上面的时候才进行处理
  with GraphObject as TGraphNode do
  begin
    // 判断是否被拖动的图元覆盖了某个东西，
    Obj := Graph.FindObjectAt(GraphObject.BoundsRect.Left - 4, GraphObject.BoundsRect.Top - 4);
    if Obj is TGPTextNode then
    begin
{$IFDEF DEBUG}
      OutputDebugString(PChar('覆盖了这个东西：' + (Obj as TGPTextNode).Text + #13#10));
{$ENDIF}
      // 取坐标
      // coLT := Point((Obj as TGPTextNode).Left, (Obj as TGPTextNode).Top);
      coLT := Obj.BoundsRect.TopLeft;
      coBR := Obj.BoundsRect.BottomRight;
      goLT := GraphObject.BoundsRect.TopLeft;
      dW := (coBR.X - coLT.X) div 3; // 取判断的范围，基本上是三分之一吧
      dH := (coBR.Y - coLT.Y) div 3;
      drpSide := 0;
      // 下面将Snap到Obj的下方，并且根据拖放的位置自动设置对齐
      // 判断是放置到左侧还是右侧
      if (goLT.X >= coLT.X) and (goLT.X <= coLT.X + dW) then
          drpSide := 10
      else if (goLT.X >= coBR.X - dW) and (goLT.X <= coBR.X) then
          drpSide := 20;

      // 判断放置到顶还是底，抑或两侧
      if (goLT.Y >= coLT.Y) and (goLT.Y <= coLT.Y + dH) then
          drpSide := drpSide + 0
      else if (goLT.Y >= coBR.Y - dH) and (goLT.Y <= coBR.Y) then
          drpSide := drpSide + 2
      else
          drpSide := drpSide + 1;

      // auto align graph object
      case drpSide of
        10: // top and left align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := False;
            Left := Obj.BoundsRect.Left;
            Top := Obj.BoundsRect.Top - Height - 2;
          end;
        11: // left side and right align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := True;
            Left := Obj.BoundsRect.Left - Width - 2;
            Top := Obj.BoundsRect.Top;
          end;
        12: // bottom side and left align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := False;
            Left := Obj.BoundsRect.Left;
            Top := Obj.BoundsRect.Bottom + 2;
          end;
        20: // top side and right align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := True;
            Left := coBR.X - Width;
            Top := Obj.BoundsRect.Top - Height - 2;
          end;
        21: // right side and left align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := False;
            Left := coBR.X + 2;
            Top := Obj.BoundsRect.Top;
          end;
        22: // bottom side and right align
          with (GraphObject as TGPTextNode) do
          begin
            DataAlignRight := True;
            Left := coBR.X - Width;
            Top := Obj.BoundsRect.Bottom + 2;
          end;
      else
          // do nothing;
      end;
      (*
      if (GraphObject as TGPTextNode).DataAlignRight then
        with GraphObject as TGraphNode do
        begin
          Left := (Obj as TGraphNode).BoundsRect.Right - Width;
          Top := (Obj as TGraphNode).BoundsRect.Bottom + 2;
        end
      else // align left side
        with GraphObject as TGraphNode do
        begin
          Left := (Obj as TGraphNode).Left;
          Top := (Obj as TGraphNode).BoundsRect.Bottom + 2;
        end;
 *)
    end;
  end;
end;

procedure TfrmEditor.StyleChanged;
begin
  if FCurStyle = nil then Exit;
  // 下面改变界面组件的显示
  clbxFontColor.Selected := FCurStyle.fontColor;
  cmbFonts.Text := FCurStyle.fontName;
  cmbFontSize.Text := IntToStr(FCurStyle.fontSize);
  clbxBackColor.Selected := FCurStyle.bkColor;
  clbxLineColor.Selected := FCurStyle.lnColor;
  cmbLineWidth.Text := IntToStr(FCurStyle.LineWidth);
  chkTextAutoSize.Checked := FCurStyle.AutoFit;
  chkBorder.Checked := FCurStyle.Border;
  chkUseGDIP.Checked := FCurStyle.UseGDIPlus;
  chkDataAlighRight.Checked := FCurStyle.AlignRight;
  trcTransparency.Position := FCurStyle.Transparency;
end;

procedure TfrmEditor.SetStyle(AStyle: PElementDefine);
begin
  FCurStyle := AStyle;
  StyleChanged;
end;

function TfrmEditor.RetCurrentStyle: TElementDefine;
begin
  if FCurStyle <> nil then
      Result := FCurStyle^
  else if FdefFontName <> '' then
  begin
    Result.bkColor := FdefBackColor;
    Result.lnColor := FdefLineColor;
    Result.LineWidth := FdefLineWidth;
    Result.AutoFit := True;
    Result.UseGDIPlus := False;
    Result.Border := FdefBorder;
    Result.fontName := FdefFontName;
    Result.fontSize := FdefFontSize;
    Result.fontColor := FdefFontColor;
    Result.Transparency := FdefTrans;
    Result.AlignRight := FdefAlignRight;
  end
  else
  begin
    Result.bkColor := clbxBackColor.Selected;
    Result.lnColor := clbxLineColor.Selected;
    Result.LineWidth := strtoint(cmbLineWidth.Text);
    Result.AutoFit := chkTextAutoSize.Checked;
    Result.UseGDIPlus := chkUseGDIP.Checked;
    Result.Border := chkBorder.Checked;
    Result.fontName := cmbFonts.Text;
    Result.fontSize := strtoint(cmbFontSize.Text);
    Result.fontColor := clbxFontColor.Selected;
    Result.Transparency := trcTransparency.Position;
    Result.AlignRight := chkDataAlighRight.Checked;
  end;
end;

function TfrmEditor.GetMatchStyle(AGNode: TGraphObject; AMeterType: String): TElementDefine;
var
  GType : TdefType; // 图元类型
  MType : String;   // 仪器类型
  i     : Integer;
  iStyle: Integer;

begin
  //
  if AGNode = nil then
      Result := RetCurrentStyle
  else
  begin
    if chkAutoMatchStyles.Checked = False then
        Result := RetCurrentStyle
    else if (AGNode is TdmcMap) then
        Result := RetCurrentStyle
    else
    begin
      // 检查图元类型
      if AGNode is TdmcDataItem then GType := dtDataItem
      else if AGNode is TdmcMeterLabel then GType := dtLabel
      else if AGNode is TdmcDataArrow then GType := dtArrow
      else if AGNode is TdmcDeformationDirection then GType := dtArrow
      else if AGNode is TGPGraphicLink then GType := dtLinkLine
      else
      begin
        Result := RetCurrentStyle;
        Exit;
      end;

      Result := GetMatchStyle(GType, AMeterType);
    end;
  end;

end;

{ -----------------------------------------------------------------------------
  Procedure  : GetMatchStyle
  Description: 寻找指定类型的样式，本方法仅仅查找第一个……
----------------------------------------------------------------------------- }
function TfrmEditor.GetMatchStyle(AGNType: TdefType; AMeterType: string): TElementDefine;
var
  GType : TdefType; // 图元类型
  MType : String;   // 仪器类型
  i     : Integer;
  iStyle: Integer;
  bFound: Boolean;

begin
  // 如果没有自动匹配样式，则返回当前样式
  if chkAutoMatchStyles.Checked = False then Result := RetCurrentStyle
  else
  begin
    bFound := False;
      // 检查图元类型
      // 根据类型和仪器类型返回相应的样式
      // 对于没有仪器类型的，返回找到的一个匹配的图元类型定义
    case AGNType of
        /// <summary>
        /// 对于标签和数据，将检查是否有对应仪器类型的样式，若没有则使用当前样式
        /// </summary>
      dtLabel, dtDataItem:
        begin
          if AMeterType = '' then
              Result := RetCurrentStyle
          else
            for i := 0 to PreDefines.Count - 1 do
              if (PreDefines.Items[i].MeterType = AMeterType) and
                (PreDefines.Items[i].DefType = AGNType) then
              begin
                bFound := True;
                Result := PreDefines.Items[i]^;
                Break;
              end;
          if not bFound then Result := RetCurrentStyle;
        end;

      dtArrow, dtLinkLine, dtIcon:
        /// <summary>
        /// 对于箭头、连接线、图标等，找到一种就算是了。至于多种样式定义，下一步再说
        /// </summary>
        begin
          for i := 0 to PreDefines.Count - 1 do
            if PreDefines.Items[i].DefType = GType then
            begin
              bFound := True;
              Result := PreDefines.Items[i]^;
              Break;
            end;

          if not bFound then Result := RetCurrentStyle;
        end;
    end;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : ApplyStyleToGraphObject
  Description: 将给定样式应用到当前图纸的所有图元中
----------------------------------------------------------------------------- }
procedure TfrmEditor.ApplyStyleToGraphObject(AStyle: TElementDefine);
var
  i, n: Integer;
  c   : TGraphObjectClass;
  O   : TGraphObject;
  procedure SetNormalStyle;
  begin
    O.Brush.Color := AStyle.bkColor;
    O.Pen.Color := AStyle.lnColor;
    O.Pen.Width := AStyle.LineWidth;
    O.Font.Name := AStyle.fontName;
    O.Font.Size := AStyle.fontSize;
    O.Font.Color := AStyle.fontColor;
    if AStyle.Border then O.Pen.Style := psSolid
    else O.Pen.Style := psClear;
  end;

begin
  case AStyle.DefType of
    dtLabel:
      begin
        for i := 0 to sgLayout.ObjectsCount(TdmcMeterLabel) - 1 do
        begin
          O := sgLayout.Objects[i];
          with O as TdmcMeterLabel do
          begin
            if MeterType <> AStyle.MeterType then Continue;
            SetNormalStyle;
            Transparency := AStyle.Transparency;
            AutoSize := AStyle.AutoFit;
            UseGdipDrawText := AStyle.UseGDIPlus;
          end;
        end;
      end;
    dtDataItem:
      for i := 0 to sgLayout.ObjectsCount(TdmcDataItem) - 1 do
      begin
        O := sgLayout.Objects[i];
        with O as TdmcDataItem do
        begin
          if MeterType <> AStyle.MeterType then Continue;
          SetNormalStyle;
          Transparency := AStyle.Transparency;
          AutoSize := AStyle.AutoFit;
          UseGdipDrawText := AStyle.UseGDIPlus;
        end;
      end;
    dtArrow:
      for i := 0 to sgLayout.ObjectsCount(TdmcDataArrow) - 1 do
      begin
        O := sgLayout.Objects[i];
        SetNormalStyle;
        // (O as TGPGraphicLink).Pen.Width := astyle.LineWidth;
      end;
    dtLinkLine:
      for i := 0 to sgLayout.ObjectsCount(TGPGraphicLink) - 1 do
      begin
        O := sgLayout.Objects[i];
        SetNormalStyle;
        // (O as TGPGraphicLink).Pen.Width := astyle.LineWidth;
      end;
    dtdirection:
      for i := 0 to sgLayout.ObjectsCount(TdmcDeformationDirection) - 1 do
      begin
        O := sgLayout.Objects[i];
        SetNormalStyle;
        // (O as TGPGraphicLink).Pen.Width := astyle.LineWidth;
      end;
  else
    c := nil;
  end;
end;

end.
