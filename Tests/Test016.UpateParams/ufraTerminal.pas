{ -----------------------------------------------------------------------------
 Unit Name: ufraTerminal
 Author:    ��ΰ
 Date:      05-ʮ��-2018
 Purpose:   �����õ�α�նˣ���һ�����������봰�ںͽ����ʾ������ɡ�
            2018-10-05
            ���Բ����������� UpdateParm metername param = value
 History:
----------------------------------------------------------------------------- }

unit ufraTerminal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfraTerminal = class(TFrame)
    edtCmd: TEdit;
    mmResult: TMemo;
    procedure edtCmdKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FErrList: TStrings;
    procedure ProcCommand;
    procedure DoUpdate(CmdStr: String);
    procedure DoListParams;
    procedure ParseUpdateCommand(CmdStr: String; var MID: String; var PName: String;
      var Value: Variant);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  uHJX.Intf.AppServices, uHJX.Classes.Meters, uHJX.Excel.InitParams;
{$R *.dfm}


{ UpdateParam�����������ʽ, ����Value��Ϊ�ա������ʽ���£�
    UPDATEPARAM designname paramname=value }
const
  RE_UpdateCmd = '([a-zA-Z]*)[ ]+([a-zA-Z]*[a-zA-Z0-9]*)[ ]+(([a-zA-Z]+)[ ]*=(.+))';

type
  TCmdParam = record
    Command: String;
    MeterID: String;
    ParamName: String;
    ParamValue: Variant;
  end;

constructor TfraTerminal.Create(AOwner: TComponent);
begin
  inherited;
  FErrList := TStringList.Create;
end;

destructor TfraTerminal.Destroy;
begin
  FErrList.Free;
  inherited;
end;

procedure TfraTerminal.edtCmdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
      ProcCommand;
end;

procedure TfraTerminal.ProcCommand;
var
  Cmd   : String;
  CmdStr: String;
  function __GetCmd: String;
  var
    ii: Integer;
  begin
    ii := Pos(' ', CmdStr);
    if ii > 0 then
    begin
      Result := UpperCase(Copy(CmdStr, 1, ii - 1));
    end
    else
        Result := UpperCase(CmdStr);
  end;

begin
  CmdStr := Trim(edtCmd.Text);
  { 2018-10-05 Ŀǰֻ����update���� }
  Cmd := __GetCmd;
  if Cmd = 'UPDATEPARAM' then
      DoUpdate(CmdStr)
  else if Cmd = 'LISTPARAMS' then
      DoListParams
  else if Cmd = 'CLS' then
      mmResult.Text := ''
  else
  begin
    mmResult.Lines.Add('>>' + edtCmd.Text);
    mmResult.Lines.Add('* δ֪����');
  end;
end;

procedure TfraTerminal.DoUpdate(CmdStr: string);
var
  MeterID: string;
  PmName : string;
  pmValue: Variant;
begin
  FErrList.Clear;
  mmResult.Lines.Add('>>' + CmdStr);
  ParseUpdateCommand(CmdStr, MeterID, PmName, pmValue);
  if FErrList.Count > 0 then
  begin
    mmResult.Lines.Add(FErrList.Text);
    Exit;
  end;

  // ��������Ƿ����
  if ExcelMeters.Meter[MeterID] = nil then
  begin
    mmResult.Lines.Add(format('* ����%s������', [MeterID]));
    Exit;
  end;

  // �������Ƿ����
  if not THJXExcelParam.IsMeterParam(PmName) then
  begin
    mmResult.Lines.Add(format('* ����%s���ǺϷ�����', [PmName]));
    Exit;
  end;

  // ���²���
  if THJXExcelParam.UpdateParam(MeterID, PmName, pmValue) then
      mmResult.Lines.Add('* �������³ɹ�');
  // ��ʾ���
end;

{ -----------------------------------------------------------------------------
  Procedure  : ParseUpdateCommand
  Description: ����UpdateParam����ֽ��������š��������ƺͲ���ֵ
  UpdateParam�����ʽ��updateparam meterid paramname = value
----------------------------------------------------------------------------- }
procedure TfraTerminal.ParseUpdateCommand(CmdStr: string; var MID: string; var PName: string;
  var Value: Variant);
var
  S: string;
  i: Integer;
begin
  MID := '';
  PName := '';
  Value := '';

  i := Pos(' ', CmdStr);
  if i > 0 then
  begin
    S := Trim(Copy(CmdStr, i + 1, length(CmdStr) - i));
    i := Pos(' ', S);
    if i > 0 then
    begin
      MID := Trim(Copy(S, 1, i - 1));

      S := Trim(Copy(S, i + 1, length(S) - i));
      i := Pos('=', S);
      if i > 0 then
      begin
        PName := Trim(Copy(S, 1, i - 1));
        Value := Trim(Copy(S, i + 1, length(S) - i));
        if PName = '' then
            FErrList.Add('* �����ʽ����û��ָ��Ҫ���µĲ���');
        { if vartostr(Value) = '' then
            FErrList.Add('* �����ʽ����û����дҪ���µ�ֵ'); }
      end
      else
          FErrList.Add('* �����ʽ����û��ָ��Ҫ���µĲ���');
    end
    else
        FErrList.Add('* �����ʽ����û��ָ��Ҫ���µĲ�����ֵ');
  end
  else
      FErrList.Add('* �����ʽ����û���������');
end;

procedure TfraTerminal.DoListParams;
var
  S: String;
begin
  FErrList.Clear;
  mmResult.Lines.Add('>>ListParams');
  S := '* ParamName: ' + THJXExcelParam.ListMeterParamNames;
  S := StringReplace(S, #13#10, #13#10'* ParamName: ', [rfReplaceAll]);
  mmResult.Lines.Add(S);
end;

end.
