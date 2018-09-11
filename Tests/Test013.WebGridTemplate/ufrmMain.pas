{ -----------------------------------------------------------------------------
 Unit Name: ufrmMain
 Author:    ��ΰ
 Date:      09-����-2018
 Purpose:   WebGrid���ģ�����
 ģ���﷨��ʽ�ص��������ģ�����ƣ��������̣�
 1���á�;���ֽ�ģ�嵽�м��ϣ�
 2���á�:���ֽ�������ͺ��ж��塣ð��ǰΪ�����ͣ�Ŀǰ�С�Title������Head������DataRow��
    �������ͣ��ֱ������⡢��ͷ�С������У�
 3���á�|���ֽ��ж��壬�����������У�����Title��Head�У������������滻�������
    ����������Head�У���Ҫ��ȡ����������
 4�����������У�Ŀǰ��֧�ֶ�̬�б�
 History:
----------------------------------------------------------------------------- }

unit ufrmMain;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, HTMLUn2, FramView, Vcl.ExtCtrls,
    System.RegularExpressions, Vcl.Menus, ufraMeterList, HtmlView;

type
    TForm2 = class(TForm)
        Panel1: TPanel;
        mmTemplate: TMemo;
        memo1: TMemo;
        Button1: TButton;
        Edit1: TEdit;
        Button2: TButton;
        Edit2: TEdit;
        Panel2: TPanel;
        Button3: TButton;
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        miConnect: TMenuItem;
        dlgOpen: TOpenDialog;
        HV: THtmlViewer;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure miConnectClick(Sender: TObject);
    private
        { Private declarations }
        FMeterList: TfraMeterList;
        FConnected: Boolean;
        procedure OnShowMeterData(AMeter: string);
    public
        { Public declarations }
    end;

var
    Form2 : TForm2;
    MyColl: TMatchCollection;
    MyEnum: TMatchCollectionEnumerator;

implementation

uses
    uHJX.Template.WebGrid, uHJX.ExcelDataAccess, uHJX.Template.WGProc, uHJX.Classes.Meters;
{$R *.dfm}


procedure TForm2.Button1Click(Sender: TObject);
const
    bigString    = 'Look for a the strings in this strang of strungs.';
    littlestring = '(str)([iau]ng)';
var
    regex : TRegEx;
    i, j  : integer;
    mygrps: TGroupCollection;
begin
    regex := TRegEx.Create(littlestring, [roIgnoreCase]);
    MyColl := regex.Matches(bigString);
    Edit1.Text := 'Count: ' + IntToStr(MyColl.Count);
    memo1.Clear;
    memo1.Lines.Add('First Collection: ');
    for i := 0 to MyColl.Count - 1 do
    begin
        memo1.Lines.Add('Match #' + IntToStr(i) + ': ' + MyColl.Item[i].Value);
        memo1.Lines.Add('Group: ' + IntToStr(i));
        mygrps := MyColl.Item[i].Groups;
        for j := 0 to mygrps.Count - 1 do
            memo1.Lines.Add('Value: ' + mygrps.Item[j].Value);
    end;

end;

procedure TForm2.Button2Click(Sender: TObject);
var
    regex : TRegEx;
    i, j  : integer;
    mygrps: TGroupCollection;
begin
    regex := TRegEx.Create(Edit2.Text, [roIgnoreCase]);
    MyColl := regex.Matches(mmTemplate.Text);
    Edit1.Text := 'count:' + IntToStr(MyColl.Count);
    memo1.Text := '';
    for i := 0 to MyColl.Count - 1 do
    begin
        memo1.Lines.Add('====New match====================================');
        memo1.Lines.Add('Match #' + IntToStr(i) + ': ' + MyColl.Item[i].Value);
        memo1.Lines.Add('Group: ' + IntToStr(i));
        mygrps := MyColl.Item[i].Groups;
        for j := 0 to mygrps.Count - 1 do
            memo1.Lines.Add('Value ' + IntToStr(j) + ': ' + mygrps.Item[j].Value);
    end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
    GT: TGridTemplate;
    i : integer;
    S : String;
begin
    memo1.Clear;
    GT := TGridTemplate.Create;
    try
        GT.TemplateStr := mmTemplate.Text;
        memo1.Lines.Add('Columns Count: ' + IntToStr(GT.ColCount));
        memo1.Lines.Add('Title rows: ' + IntToStr(GT.Titles.Count));
        memo1.Lines.Add('TableHead row count: ' + IntToStr(Length(GT.Heads)));
        memo1.Lines.Add('==================');
        S := '';
        for i := 0 to High(GT.Heads[0].Cols) do
            S := S + GT.Heads[0].Cols[i] + #9;
        memo1.Lines.Add(S);
    finally
        GT.Free;
    end;
end;

procedure TForm2.miConnectClick(Sender: TObject);
begin
    if dlgOpen.Execute then
    begin
        OpenConfig(dlgOpen.FileName);
        FMeterList := TfraMeterList.Create(Self);
        FMeterList.Parent := Panel2;
        FMeterList.Align := alBottom;
        FMeterList.Visible := True;
        FMeterList.ShowMeters;
        FMeterList.OnShowMeterDatas := OnShowMeterData;
        FConnected := True;
    end;

end;

procedure TForm2.OnShowMeterData(AMeter: string);
var
    mt: TMeterDefine;
    GT: TGridTemplate;
begin
    // ShowMessage('show data now');
    if FConnected then
    begin
        mt := ExcelMeters.Meter[AMeter];
        GT := TGridTemplate.Create;
        try
            GT.TemplateStr := mmTemplate.Text;
            HV.LoadFromString(GenGrid(GT, mt));
            // FV.LoadFromString(GenGrid(GT, mt));
        finally
            GT.Free;
        end;
    end;
end;

end.
