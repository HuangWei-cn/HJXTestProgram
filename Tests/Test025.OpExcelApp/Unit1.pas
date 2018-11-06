unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ExcelXP, Vcl.OleServer, Vcl.ExtCtrls,
  Vcl.ComCtrls, XLSSheetData5, XLSReadWriteII5;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    TabSheet2: TTabSheet;
    ExcelApplication1: TExcelApplication;
    ExcelWorkbook1: TExcelWorkbook;
    ExcelWorkbook2: TExcelWorkbook;
    TabSheet3: TTabSheet;
    ExcelWorksheet1: TExcelWorksheet;
    ExcelWorksheet2: TExcelWorksheet;
    XRW1: TXLSReadWriteII5;
    XRW2: TXLSReadWriteII5;
    ListBox2: TListBox;
    Button5: TButton;
    Button6: TButton;
    TabSheet4: TTabSheet;
    Button7: TButton;
    ListBox3: TListBox;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
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
  ComObj, nExcel;
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
  NewBK : Variant;
  Sht1  : Variant;
  ShtSrc: Variant;
  ShtNew: Variant;
begin
  if ListBox1.ItemIndex = -1 then Exit;
  ShtSrc := FSrcBk.worksheets.item[ListBox1.Items.Strings[ListBox1.ItemIndex]];
  ShowMessage('Source sheet name:' + ShtSrc.name);
  // create new workbook
  NewBK := FExcelApp.workbooks.Add;
  // select first sheet
  Sht1 := NewBK.worksheets.item[1];
  // showmessage(sht1.name);
  // copy sheet to new book
  ShtSrc.Copy(null, Sht1);
  // set new sheet activate
  ShtNew := NewBK.worksheets.item[ShtSrc.name];
  ShtNew.Activate;
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

procedure TForm1.Button5Click(Sender: TObject);
begin
  ExcelApplication1.Connect;
  // ExcelApplication1.Visible := True;
  if OpenDialog1.Execute then
  begin
    ExcelWorkbook1.ConnectTo(ExcelApplication1.workbooks.open(OpenDialog1.FileName, null, True,
      null, null, null, null, null, null, null, null, null, null, null, null, null));
    ListBox2.Clear;
    ShowMessage(IntToStr(ExcelWorkbook1.Sheets.count));
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    XRW1.LoadFromFile(OpenDialog1.FileName);
    if SaveDialog1.Execute then
        XRW1.SaveToFile(SaveDialog1.FileName);
    ShowMessage('Done');
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var Bk: IXLSWorkbook;
begin
  bk := txlsworkbook.Create;
  if OpenDialog1.Execute then
  begin
    bk.Open(opendialog1.FileName);
    if savedialog1.Execute then
      bk.SaveAs(savedialog1.FileName);
    showmessage('done.');
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var i:Integer;
  BK:ixlsworkbook;
  sht:ixlsworksheet;
  s:string;
begin
  listbox3.Clear;
  if opendialog1.Execute then
  begin
    bk := TXLSWorkbook.Create;
    bk.Open(opendialog1.FileName);
    for i := 1 to bk.WorkSheets.Count do
      listbox3.Items.Add(bk.WorkSheets[i].Name);
    sht := BK.WorkSheets[1];
    for i := sht.UsedRange.LastRow + 1 downto 10 do
    begin
      s:=trim(vartostr(sht.Cells[i,1].Value));
      if s = '' then continue;
      sht.cells[i,2].value := Random(10);
    end;
    showmessage('write random data finished');
    if savedialog1.Execute then
      bk.SaveAs(savedialog1.FileName);
    showmessage('save file as new file is done');
  end;
end;

end.
