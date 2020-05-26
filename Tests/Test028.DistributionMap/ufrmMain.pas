{ -----------------------------------------------------------------------------
 Unit Name: ufrmMain
 Author:    黄伟
 Date:      31-七月-2019
 Purpose:   测试分布图的创建、定义生成等功能
 History:   2019-07-31
----------------------------------------------------------------------------- }

unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  uHJX.Intf.AppServices;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnOpenProject: TButton;
    btnCreateNewDM: TButton;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Splitter1: TSplitter;
    procedure btnOpenProjectClick(Sender: TObject);
  private
    { Private declarations }
    FMTList: TFrame;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uHJX.Excel.InitParams, ufraMeterList;

{$R *.dfm}


procedure TfrmMain.btnOpenProjectClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if uHJX.Excel.InitParams.LoadProjectConfig(OpenDialog1.FileName) then
    begin
      Label1.Color := clLime;
      ShowMessage('工程加载完成');
      FMTList := TfraMeterList.Create(Self);
      (FMTList as TfraMeterList).ShowMeters;
      FMTList.Parent := Panel2;
      FMTList.Align := alClient;
      FMTList.Visible := True;
    end
    else
    begin
      Label1.Color := clmaroon;
      FreeAndNil(FMTList);
    end;
  end;
end;

end.
