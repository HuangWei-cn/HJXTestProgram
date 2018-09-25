unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  SimpleGraph;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    dlgOpen: TOpenDialog;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    Fsg: TSimpleGraph;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    if dlgopen.execute then
    begin
        fsg.LoadFromFile(dlgopen.filename);
        fsg.CommandMode := cmPan;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    fsg := tsimplegraph.create(self);
    fsg.parent := self;
    fsg.align := alclient;
    fsg.Visible := true;
end;

end.
