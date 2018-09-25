unit ufrmMain;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
    uhjx.intf.appServices,
    uhjx.Excel.InitParams,
    ufraDataPresentation, Vcl.StdCtrls;

type
    TForm1 = class(TForm)
        Panel1: TPanel;
    Button1: TButton;
    dlgOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    private
        { Private declarations }
        FLayout: TfraDataPresentation;
    public
        { Public declarations }
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    if dlgOpen.execute then
    begin
        LoadProjectConfig(dlgopen.filename)
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    flayout := TfraDataPresentation.Create(Self);
    flayout.parent := Self;
    flayout.align := alclient;
end;

end.
