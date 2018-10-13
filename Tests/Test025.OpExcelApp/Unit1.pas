unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FExcelApp: Variant;
    FSrcBk   : Variant;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ComObj;
{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
  FExcelApp := CreateOleObject('Excel.Application');
  FExcelApp.Visible := True;
  FExcelApp.WindowState := -4140; // xlMinimized (-4143=xlNormal; -4137=xlMaximized)
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Bk, sht: Variant;
  i      : integer;
begin
  if OpenDialog1.Execute then
  begin
    FSrcBk := FExcelApp.workbooks.open(OpenDialog1.FileName);
    if not varisNull(FSrcBk) then
    begin
      for i := 1 to FSrcBk.worksheets.count do
      begin
        sht := FSrcBk.worksheets.item[i];
        ListBox1.Items.Add(sht.name);
      end;
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  NewBK: Variant;
  Sht1 : Variant;
  ShtSrc:Variant;
  ShtNew:Variant;
begin
  if ListBox1.ItemIndex = -1 then Exit;
  ShtSrc := FSrcBk.WorkSheets.Item[ListBox1.Items.Strings[listbox1.ItemIndex]];
  ShowMessage('Source sheet name:' + shtsrc.name);
  //create new workbook
  NewBK := FExcelApp.workbooks.Add;
  //select first sheet
  Sht1 := NewBK.worksheets.item[1];
  // showmessage(sht1.name);
  //copy sheet to new book
  shtSrc.Copy(null,Sht1);
  //set new sheet activate
  ShtNew := NewBK.Worksheets.item[ShtSrc.Name];
  shtNew.Activate;
  ShowMessage('Copy Done.');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  try
    FExcelApp.workbooks.close;
    FExcelApp.quit;
    FSrcBk := null;
  finally

  end;
end;

end.
