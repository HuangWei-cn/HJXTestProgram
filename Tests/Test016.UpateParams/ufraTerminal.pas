{ -----------------------------------------------------------------------------
 Unit Name: ufraTerminal
 Author:    黄伟
 Date:      05-十月-2018
 Purpose:   测试用的伪终端，由一个命令行输入窗口和结果显示窗口组成。
            2018-10-05
            测试参数更新命令 UpdateParm metername param = value
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


{ UpdateParam命令的正则表达式, 允许Value项为空。命令格式如下：
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
  { 2018-10-05 目前只考虑update命令 }
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
    mmResult.Lines.Add('* 未知命令');
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

  // 检查仪器是否存在
  if ExcelMeters.Meter[MeterID] = nil then
  begin
    mmResult.Lines.Add(format('* 仪器%s不存在', [MeterID]));
    Exit;
  end;

  // 检查参数是否存在
  if not THJXExcelParam.IsMeterParam(PmName) then
  begin
    mmResult.Lines.Add(format('* 参数%s不是合法参数', [PmName]));
    Exit;
  end;

  // 更新参数
  if THJXExcelParam.UpdateParam(MeterID, PmName, pmValue) then
      mmResult.Lines.Add('* 参数更新成功');
  // 显示结果
end;

{ -----------------------------------------------------------------------------
  Procedure  : ParseUpdateCommand
  Description: 解析UpdateParam命令，分解出仪器编号、参数名称和参数值
  UpdateParam命令格式：updateparam meterid paramname = value
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
            FErrList.Add('* 命令格式错误：没有指定要更新的参数');
        { if vartostr(Value) = '' then
            FErrList.Add('* 命令格式错误：没有填写要更新的值'); }
      end
      else
          FErrList.Add('* 命令格式错误：没有指定要更新的参数');
    end
    else
        FErrList.Add('* 命令格式错误：没有指定要更新的参数和值');
  end
  else
      FErrList.Add('* 命令格式错误：没有仪器编号');
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
