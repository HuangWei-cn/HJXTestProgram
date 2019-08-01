unit ufrmDistMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ufraDistMap;

type
  TfrmDistMap = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FMap: TfraDistMap;
  public
    { Public declarations }
    procedure SetDistMap(ADefine: string);
  end;

var
  frmDistMap: TfrmDistMap;

implementation

{$R *.dfm}

procedure TfrmDistMap.FormCreate(Sender: TObject);
begin
  FMap := TfraDistMap.Create(Self);
  FMap.Parent := Self;
  FMap.Align := alClient;
  FMap.Visible := True;
end;

procedure TfrmDistMap.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FMap);
end;

procedure TfrmDistMap.SetDistMap(ADefine: string);
begin
  FMap.SetDistMapDefine(ADefine);
end;

end.
