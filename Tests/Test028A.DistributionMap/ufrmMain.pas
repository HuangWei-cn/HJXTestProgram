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
