{-----------------------------------------------------------------------------
 Unit Name: ufrmMain
 Author:    黄伟
 Date:      27-五月-2020
 Purpose:   分布图测试程序
            本测试主要的功能件是ufrmDistMapEditor, ufrmDistMap, ufraDistMap.
            2020-05-27
            目前的情况是基本能用，但是好像还是有一些问题。需要添加的两个功能
            是：
            1、手工挑选监测仪器的监测量，而非根据下拉框为全部仪器指定相同的
               PDIndex；
            2、可以保存定义。目前程序在编辑器完成编辑后，实际上已经生成了定
               义，只是没有保存。保存用户设置应由将来的主程序统一考虑。
 History:
-----------------------------------------------------------------------------}

unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uHJX.Intf.AppServices, uHJX.Classes.Meters;

type
  TForm1 = class(TForm)
    pnlMain: TPanel;
    pnlMeterList: TPanel;
    spl1: TSplitter;
    pnl1: TPanel;
    btnOpenProject: TButton;
    btnNewDM: TButton;
    pnlLED: TPanel;
    dlgOpenProject: TOpenDialog;
    procedure btnOpenProjectClick(Sender: TObject);
    procedure btnNewDMClick(Sender: TObject);
  private
    { Private declarations }
    FMTList: TFrame;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uHJX.Excel.InitParams, ufraMeterList, ufrmDistMapEditor;
{$R *.dfm}

procedure TForm1.btnNewDMClick(Sender: TObject);
var frm:TfrmDMEditor;
begin
  frm := TfrmDMEditor.create(Self);
  frm.init;
  frm.ShowModal;
  frm.release;
end;

procedure TForm1.btnOpenProjectClick(Sender: TObject);
begin
  if dlgOpenProject.Execute then
  begin
    if FMTList <> nil then freeandnil(FMTList);
    if LoadProjectConfig(dlgOpenProject.FileName) then
    begin
      pnlLED.color := clLime;
      FMTList := tfraMeterlist.create(Self);
      (FMTList as tfraMeterlist).ShowMeters;
      FMTList.parent := pnlMeterList;
      FMTList.align := alclient;
      FMTList.visible := True;
    end
    else
    begin
      pnlLED.color := clMaroon;
      freeandnil(FMTList);
    end;;
  end;
end;

end.
