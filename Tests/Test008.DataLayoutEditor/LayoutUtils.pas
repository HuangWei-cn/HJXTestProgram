{ -----------------------------------------------------------------------------
 Unit Name: Unit1
 Author:    ��ΰ
 Date:      26-ʮһ��-2021
 Purpose:   �ṩ���ָ������ܡ�
            1��һЩԤ�������ã���Ԥ������ɫ�ȡ�
              Ԥ�����ļ��Ϳ�ִ���ļ���ͬһ���ļ��д�š�
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
  { Ԥ�������� }
  TdefType = (dtLabel { TdmcMeterLabel } ,
    dtDataItem { TdmcDataItem } ,
    dtArrow { TdmcDataArrow } ,
    dtLinkLine { TGPGraphicLink } ,
    dtDirection { TdmcDeformationDirection } ,
    dtIcon);

{ Ԥ����ͼԪ���� }
  TElementDefine = record
    DefName: String;       // ���������
    DefType: TdefType;     // ��������
    MeterType: string;     // ��������
    bkColor: TColor;       // ������ɫ
    lnColor: TColor;       // ����ɫ
    LineWidth: Integer;    // �߿�
    AutoFit: Boolean;      // �Զ���Ӧ����
    UseGDIPlus: Boolean;   // �Ƿ�ʹ��GDI+
    Border: Boolean;       // �Ƿ��б߿�
    fontName: String;      // ��������
    fontSize: Integer;     // �����С
    fontColor: TColor;     // ������ɫ
    Transparency: Integer; // ͸����
    AlignRight: Boolean;   // �Ƿ��Ҷ���
    procedure Init;
  end;

  PElementDefine = ^TElementDefine;

  { Ԥ���弯�� }
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
  Description: ����Ԥ���������
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
      ShowMessage('û���ҵ���ͼ��ʽ��');
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
            // ���Ը���������
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
  Description: ����Ԥ��������
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
      /// ����ElementDefine�����ͣ�������ͬTag��Node
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
      /// ����Node��Ԥ��������
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
    // Xml.Free; //��һ��Զ�Free
  end;
end;

initialization

PreDefines := TEleDefines.Create;

finalization

PreDefines.Free;

end.
