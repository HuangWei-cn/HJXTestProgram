unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  uHJX.Intf.AppServices,
  ufraMeterList, ufraTerminal;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    btnOpenConfig: TButton;
    Splitter1: TSplitter;
    pnlMtLst: TPanel;
    fraTerminal1: TfraTerminal;
    Panel2: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenConfigClick(Sender: TObject);
  private
    { Private declarations }
    FMeterList: TfraMeterList;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
{$R *.dfm}

procedure TfrmMain.btnOpenConfigClick(Sender: TObject);
begin
  if Assigned(IAppServices) then
    IAppServices.OpenDatabaseManager;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMeterList := TfraMeterList.Create(Self);
  fmeterlist.Parent := pnlMtLst;
  fmeterlist.Align := alClient;
end;

end.
