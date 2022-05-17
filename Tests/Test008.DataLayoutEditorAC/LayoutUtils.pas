{ -----------------------------------------------------------------------------
 Unit Name: Unit1
 Author:    黄伟
 Date:      26-十一月-2021
 Purpose:   提供各种辅助功能。
            1、一些预定义设置，如预定义颜色等。
              预定义文件和可执行文件在同一个文件夹存放。
 History:
----------------------------------------------------------------------------- }

unit LayoutUtils;

interface

uses
  WinAPI.Windows, System.SysUtils, System.Classes, System.Variants,
  System.Generics.Collections, System.DateUtils, System.StrUtils, Vcl.Graphics, Vcl.Forms,
  vcl.Dialogs,
  Xml.XMLDoc, Xml.XMLIntf;

type
  { 预定义类型 }
  TdefType = (dtLabel { TdmcMeterLabel } ,
    dtDataItem { TdmcDataItem } ,
    dtArrow { TdmcDataArrow } ,
    dtLinkLine { TGPGraphicLink } ,
    dtDirection { TdmcDeformationDirection } ,
    dtIcon);

{ 预定义图元属性 }
  TElementDefine = record
    DefName: String;       // 定义的名称
    DefType: TdefType;     // 定义类型
    MeterType: string;     // 仪器类型
    bkColor: TColor;       // 背景颜色
    lnColor: TColor;       // 线颜色
    LineWidth: Integer;    // 线宽
    AutoFit: Boolean;      // 自动适应文字
    UseGDIPlus: Boolean;   // 是否使用GDI+
    Border: Boolean;       // 是否有边框
    fontName: String;      // 字体名称
    fontSize: Integer;     // 字体大小
    fontColor: TColor;     // 文字颜色
    Transparency: Integer; // 透明度
    AlignRight: Boolean;   // 是否右对齐
    procedure Init;
  end;

  PElementDefine = ^TElementDefine;

  { 预定义集合 }
  TEleDefines = class
  private
    FList: TList<PElementDefine>;
    function GetCount: Integer;
    function GetItem(Index: Integer): PElementDefine;
    function GetItemByName(AName: string): PElementDefine;
  public
    constructor Create;
    destructor Destroy; override;
    function AddNew: PElementDefine;
    function IndexOf(AED: PElementDefine): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: PElementDefine read GetItem;
    property ItemByName[AName: string]: PElementDefine read GetItemByName;
  end;

var
  PreDefines: TEleDefines;

procedure LoadPredefines;
procedure SavePreDefines;

implementation

procedure _InitNewElementDefine(NewEle: PElementDefine);
begin

end;

function __GetDefTypeName(aType: TdefType): String;
begin
  case aType of
    dtLabel: Result := 'MeterLabel';
    dtDataItem: Result := 'DataItem';
    dtArrow: Result := 'DataArrow';
    dtLinkLine: Result := 'LinkLine';
    dtDirection: Result := 'DeformationDirection';
    dtIcon: Result := 'Icon';
  end;
end;

function __GetDefTypeByName(AName: String): TdefType;
begin
  if AName = 'MeterLabel' then Result := dtLabel
  else if AName = 'DataItem' then Result := dtDataItem
  else if AName = 'DataArrow' then Result := dtArrow
  else if AName = 'LinkLine' then Result := dtLinkLine
  else if AName = 'DeformationDirection' then Result := dtDirection
  else if AName = 'Icon' then Result := dtIcon;
end;

procedure TElementDefine.Init;
begin
  DefName := '';
  bkColor := clNone;
  lnColor := clBlue;
  LineWidth := 1;
  AutoFit := True;
  UseGDIPlus := True;
  Border := True;
  fontName := 'Times New Roman';
  fontSize := 8;
  fontColor := clBlack;
  Transparency := 40; // 40%
  AlignRight := False;
end;

constructor TEleDefines.Create;
begin
  inherited;
  FList := TList<PElementDefine>.Create;
end;

destructor TEleDefines.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TEleDefines.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TEleDefines.AddNew: PElementDefine;
begin
  Result := New(PElementDefine);
  Result.Init;
  // _InitNewElementDefine(Result);
  FList.Add(Result);
end;

function TEleDefines.GetItem(Index: Integer): PElementDefine;
begin
  Result := FList.Items[index];
end;

function TEleDefines.GetItemByName(AName: string): PElementDefine;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
    if FList[i].DefName = AName then
    begin
      Result := FList[i];
      Break;
    end;
end;

procedure TEleDefines.Delete(Index: Integer);
var
  P: PElementDefine;
begin
  if FList.Count > 0 then
    if (index >= 0) and (Index < FList.Count) then
    begin
      P := FList[index];
      FList.Delete(index);
      Dispose(P);
    end;
end;

procedure TEleDefines.Clear;
var
  i: Integer;
begin
  for i := FList.Count - 1 downto 0 do
  begin
    Dispose(FList[i]);
    FList.Delete(i);
  end;
  FList.Clear;
end;

function TEleDefines.IndexOf(AED: PElementDefine): Integer;
begin
  Result := FList.IndexOf(AED);
end;

{ -----------------------------------------------------------------------------
  Procedure  : LoadPreDefines
  Description: 加载预定义的设置
----------------------------------------------------------------------------- }
procedure LoadPredefines;
var
  Xml              : IXMLDocument;
  Root, ClsNode    : IXMLNode;
  defNode, ItemNode: IXMLNode;
  iDef, iDefItem   : Integer;
  NewEd            : PElementDefine;
  S                : String;
  function FindItem(AItemName: String): Boolean;
  begin
    ItemNode := defNode.ChildNodes.FindNode(AItemName);
    Result := ItemNode <> nil;
  end;

begin
  // Xml := TXMLDocument.Create(nil);
  // Xml.Active := True;
  try
    S := ExtractFilePath(Application.ExeName) + 'DLEditorDefine.xml';
    if not FileExists(S) then
    begin
      ShowMessage('没有找到绘图样式表');
      Exit;
    end;

    Xml := LoadXMLDocument(S);
    Xml.Active := True;
    // Xml.LoadFromFile(ExtractFilePath(Application.ExeName) + 'DLEditorDefine.xml');
    if not Xml.IsEmptyDoc then
    begin

      ClsNode := Xml.DocumentElement.ChildNodes.FindNode('GraphElementsDefine');
      if ClsNode <> nil then
        if ClsNode.ChildNodes.Count <> 0 then
          for iDef := 0 to ClsNode.ChildNodes.Count - 1 do
          begin
            defNode := ClsNode.ChildNodes[iDef];
            S := defNode.NodeName;
            NewEd := PreDefines.AddNew; // New(PElementDefine);
            // NewEd.Init;
            NewEd.DefType := __GetDefTypeByName(S);
            // 加栽各个定义项
            if FindItem('DefName') then NewEd.DefName := ItemNode.Text;
            if FindItem('MeterType') then NewEd.MeterType := ItemNode.Text;
            if FindItem('BKColor') then NewEd.bkColor := StringToColor(ItemNode.Text);
            if FindItem('LineColor') then NewEd.lnColor := StringToColor(ItemNode.Text);
            if FindItem('LineWidth') then NewEd.LineWidth := StrToInt(ItemNode.Text);
            if FindItem('AutoFit') then NewEd.AutoFit := StrToBool(ItemNode.Text);
            if FindItem('UseGDIPlus') then NewEd.UseGDIPlus := StrToBool(ItemNode.Text);
            if FindItem('Border') then NewEd.Border := StrToBool(ItemNode.Text);
            if FindItem('FontName') then NewEd.fontName := ItemNode.Text;
            if FindItem('FontSize') then NewEd.fontSize := StrToInt(ItemNode.Text);
            if FindItem('FontColor') then NewEd.fontColor := StringToColor(ItemNode.Text);
            if FindItem('Transparency') then NewEd.Transparency := StrToInt(ItemNode.Text);
            if FindItem('AlignRight') then NewEd.AlignRight := StrToBool(ItemNode.Text);
          end;
    end;
  finally
    // Xml.Free;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : SavePreDefines
  Description: 保存预定义设置
----------------------------------------------------------------------------- }
procedure SavePreDefines;
var
  Xml: TXMLDocument;
  Root,
    ClsNode,
    defNode,
    XNode: IXMLNode;
  i      : Integer;
  ed     : PElementDefine;
  procedure AddXNode(AName, AText: String);
  begin
    XNode := defNode.AddChild(AName);
    XNode.Text := AText;
  end;

begin
  Xml := TXMLDocument.Create(nil);
  try
    // Xml.DOMDocument.createElement('');
    Xml.Active := True;
    Root := Xml.AddChild('DataLayoutDefine');
    ClsNode := Root.AddChild('GraphElementsDefine');
    if PreDefines.Count > 0 then
      for i := 0 to PreDefines.Count - 1 do
      begin
        ed := PreDefines.Items[i];
      /// 根据ElementDefine的类型，创建不同Tag的Node
        defNode := ClsNode.AddChild(__GetDefTypeName(ed.DefType));
        (*
        case ed.DefType of
          dtLabel: defNode := ClsNode.AddChild('MeterLabel');
          dtDataItem: defNode := ClsNode.AddChild('DataItem');
          dtArrow: defNode := ClsNode.AddChild('DataArrow');
          dtLinkLine: defNode := ClsNode.AddChild('LinkLine');
          dtDirection: defNode := ClsNode.AddChild('DeformationDirection');
          dtIcon: defNode := ClsNode.AddChild('Icon');
        end;
 *)
      /// 设置Node的预定义属性
        AddXNode('DefName', ed.DefName);
        AddXNode('MeterType', ed.MeterType);
        AddXNode('BKColor', ColorToString(ed.bkColor));
        AddXNode('LineColor', ColorToString(ed.lnColor));
        AddXNode('LineWidth', IntToStr(ed.LineWidth));
        AddXNode('AutoFit', BoolToStr(ed.AutoFit));
        AddXNode('UseGDIPLus', BoolToStr(ed.UseGDIPlus));
        AddXNode('Border', BoolToStr(ed.Border));
        AddXNode('FontName', ed.fontName);
        AddXNode('FontSize', IntToStr(ed.fontSize));
        AddXNode('FontColor', ColorToString(ed.fontColor));
        AddXNode('Transparency', IntToStr(ed.Transparency));
        AddXNode('AlignRight', BoolToStr(ed.AlignRight));
      end;
    /// Save define file
    Xml.SaveToFile(ExtractFilePath(Application.ExeName) + 'DLEditorDefine.xml');
  finally
    // Xml.Free; //这家伙自动Free
  end;
end;

initialization

PreDefines := TEleDefines.Create;

finalization

PreDefines.Free;

end.
