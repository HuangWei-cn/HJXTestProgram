unit Unit1;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.StdCtrls,
    {------------------} uhwDataType.DSM.Inclinometer {---------------------------------} ,
    ufraInclineCharts, Vcl.Menus, Vcl.Grids, sSkinProvider, sSkinManager, Vcl.Buttons,
    System.ImageList, Vcl.ImgList, sSpeedButton, sSplitter;

type
    TfrmMain = class(TForm)
        spltvw1: TSplitView;
        btn1: TButton;
        dlgOpen1: TOpenDialog;
        spl1: TSplitter;
        pnl1: TPanel;
        grdDatas: TStringGrid;
        pnl2: TPanel;
        dlgOpenExcelFile: TOpenDialog;
        lstDTScale: TListBox;
        btnGetData: TButton;
        PopupMenu1: TPopupMenu;
        sSkinManager1: TsSkinManager;
        sSkinProvider1: TsSkinProvider;
        ImageList1: TImageList;
        sSpeedButton2: TsSpeedButton;
        ImageList2: TImageList;
        sSpeedButton1: TsSpeedButton;
        sSpeedButton3: TsSpeedButton;
        sSpeedButton4: TsSpeedButton;
        sSplitter1: TsSplitter;
        procedure btn1Click(Sender: TObject);
        procedure btnOpenExcelFileClick(Sender: TObject);
        procedure btnGetDataClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure lstDTScaleDblClick(Sender: TObject);
        procedure sbtnGetHistoryDatasClick(Sender: TObject);
        procedure sSpeedButton2Click(Sender: TObject);
        procedure sSpeedButton1Click(Sender: TObject);
        procedure sSpeedButton3Click(Sender: TObject);
        procedure sSpeedButton4Click(Sender: TObject);
    private
        { Private declarations }
        FfraInCharts: ufraInclineCharts.TfraInclineCharts;
        FDataFile   : string;
        FMultDateStr: string; // �����ڣ������û��ظ���ѡ�������
        // function CheckDataValid: boolean;
        procedure GetDataByDate(AFile: string; ADate: TDate);
        procedure GetAllDatas;
        procedure ShowOriginalData;
        procedure OpenExcelWorkbook;
        procedure ShowSelectedData;
    public
        { Public declarations }
    end;

var
    frmMain: TfrmMain;

implementation

uses
    uhwDataOp.Excel.Inclinometer, ufrmOriDataWind, ufrmMultDates;
{$R *.dfm}


{ -----------------------------------------------------------------------------
  Procedure  : btn1Click
  Description: ����������ͬͼ��ʾ
  ��ʽ����������ѡ�񴰿ڣ�������ȫ�����ݸ�fra��֮����Ƴ���
----------------------------------------------------------------------------- }
procedure TfrmMain.btn1Click(Sender: TObject);
var
    // dts  : string; // �û�ѡ��Ķ������
    frm  : TfrmMultDates; // ����ѡ��Ի���
    Datas: PdtInHistoryDatas;
begin
    // ShowOriginalData;
    frm := TfrmMultDates.Create(Self);
    try
        New(Datas);
        frm.clstDates.Items.AddStrings(lstDTScale.Items);
        if FMultDateStr <> '' then
            frm.SetSelectedDates(FMultDateStr);
        frm.ShowModal;
        if frm.ModalResult = mrOk then
        begin
            FMultDateStr := frm.GetSelectedDates;
            GetInclineMultDatasFromXLS(FDataFile, frm.GetSelectedDates, Datas);
            FfraInCharts.DrawMultDate2DLines(Datas);
        end
        else
            ShowMessage('User cancel');
    finally
        frm.Release;
        Datas.ReleaseDatas;
        Dispose(Datas);
    end;
end;

procedure TfrmMain.btnGetDataClick(Sender: TObject);
begin
    ShowSelectedData;
end;

procedure TfrmMain.btnOpenExcelFileClick(Sender: TObject);
begin
    OpenExcelWorkbook;
end;

// function TfrmMain.CheckDataValid: boolean;
// var
// sLine, sDate, sTime, sHoleNo, s1, s2: string;
// i, iStart, iData, iPos              : Integer;
// d, t                                : TDateTime;
// FS                                  : TFormatSettings;
// begin
// result := false;
// if mmo1.Lines.Count = 0 then
// Exit;
// // ��������Ϊ"***"
// sLine := mmo1.Lines[0];
// if sLine <> '***' then
// begin
// ShowMessage('���ǺϷ��Ļ�����б�������ļ���������ѡ���ļ�');
// Exit;
// end;
//
// iStart             := 0;
// FS                 := TFormatSettings.Create('en-US');
// FS.ShortDateFormat := 'm/d/yy';
// FS.DateSeparator   := '/';
// // FS.ShortTimeFormat
//
// // ���м�飬ֱ��������FLEVEL������
// for i := 0 to mmo1.Lines.Count - 1 do
// begin
// sLine := mmo1.Lines[i];
// // �ж��Ƿ�������FLEVEL�������ǣ�����һ�����������ݣ����򡭡�
// if Pos('FLEVEL', sLine) > 0 then
// begin
// // ShowMessage(sLine);
// iData := i + 1;
// Break;
//
// end;
// // ---------------------
// // �ж�sLine���Ƿ����ð�ţ�������ֽ�֮��
// iPos := Pos(':', sLine);
// if iPos > 0 then
// begin
// s1 := Trim(Copy(sLine, 1, iPos - 1));
// s2 := Copy(sLine, iPos + 1, Length(sLine) - iPos);
// // ShowMessage(s1 + '---' + s2);
//
// if s1 = 'HOLE NO.' then
// sHoleNo := s1
// else if s1 = 'DATE' then
// begin
// // sDate := s2;
// // d := StrToDate(s2,FS);
// // ShowMessage(DateToStr(d));
// // ����ʽm/d/yy��ʽת�ɵ�ǰϵͳĬ�ϵĸ�ʽ��
// { TODO -oHW -cGeneral : �ڳ����ж���һ��TFormatSettings��Ϊ����ͳһ�����ڵȸ�ʽ }
// sDate := datetostr(StrToDate(s2, FS));
// end
// else if s1 = 'TIME' then
// sTime := s2
// else if s1 = '#READINGS' then
// begin
// // �������������Ϊ�����������������ļ�
// end;
// end;
// end;
//
// ShowMessage('iData: ' + IntToStr(iData));
//
// result := True;
// end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    FfraInCharts := TfraInclineCharts.Create(Self);
    FfraInCharts.Parent := pnl2;
    FfraInCharts.Align := alclient;
    System.SysUtils.FormatSettings.DateSeparator := '-';
    System.SysUtils.FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
end;

procedure TfrmMain.GetDataByDate(AFile: string; ADate: TDate);
var
    pdt: PdtInclinometerDatas;
    rst: Integer;

    procedure FillDataInGrid;
    var
        iRow, iCol, i: Integer;
        d            : double;
    begin
        for iRow := 0 to grdDatas.RowCount - 1 do
            for iCol := 0 to grdDatas.ColCount - 1 do
                grdDatas.Cells[iCol, iRow] := '';
        grdDatas.Cells[0, 0] := '����(m)';
        grdDatas.Cells[1, 0] := 'A��(mm)';
        grdDatas.Cells[2, 0] := 'B��(mm)';
        grdDatas.Cells[3, 0] := 'D(mm)';

        if Length(pdt.Datas) > 0 then
            for i := 0 to High(pdt.Datas) do
            begin
                grdDatas.Cells[0, i + 1] := FormatFloat('0.00', pdt.Datas[i].Level);
                grdDatas.Cells[1, i + 1] := FormatFloat('0.00', pdt.Datas[i].sgmDA);
                grdDatas.Cells[2, i + 1] := FormatFloat('0.00', pdt.Datas[i].sgmDB);
                d := pdt.Datas[i].sgmDA * pdt.Datas[i].sgmDA + pdt.Datas[i].sgmDB *
                    pdt.Datas[i].sgmDB;
                d := Sqrt(d);
                grdDatas.Cells[3, i + 1] := FormatFloat('0.00', d);
            end;
    end;

begin
    New(pdt);
    try
        rst := GetInclineDataFromXLS(AFile, ADate, pdt);
        case rst of
            - 1:
                ShowMessage('�޷��������ļ����ļ������ڻ�����Excelʹ��');
            -3001, -3002:
                ShowMessage('ָ�����ļ�����Excel������');
            0:
                ShowMessage('δ��ȡ�����ݣ�ָ���Ĺ۲����ڲ����ڣ�����������');
        else
            FillDataInGrid;
            FfraInCharts.Draw2DLine(pdt);
            FfraInCharts.Draw3DLine(pdt);
            FfraInCharts.ShowEigenValue(pdt);
        end;

    finally
        pdt.ReleaseDatas;
        Dispose(pdt);
    end;
end;

procedure TfrmMain.lstDTScaleDblClick(Sender: TObject);
begin
    btnGetDataClick(Sender);
end;

procedure TfrmMain.sbtnGetHistoryDatasClick(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
    GetAllDatas;
    Screen.Cursor := crDefault;
end;

procedure TfrmMain.sSpeedButton1Click(Sender: TObject);
begin
    ShowOriginalData;
end;

procedure TfrmMain.sSpeedButton2Click(Sender: TObject);
begin
    Screen.Cursor := crHourGlass;
    GetAllDatas;
    Screen.Cursor := crDefault;
end;

procedure TfrmMain.sSpeedButton3Click(Sender: TObject);
begin
    OpenExcelWorkbook;
    // �����ļ�����ն�ѡ
    FMultDateStr := '';
end;

procedure TfrmMain.sSpeedButton4Click(Sender: TObject);
begin
    FMultDateStr := ''; // ��ʾ��������ʱ����ն�ѡ
    ShowSelectedData;
end;

procedure TfrmMain.GetAllDatas;
var
    hisDatas: PdtInHistoryDatas;
begin
    // �û���ѡ���б�ף��ÿ�������:
    if FDataFile = '' then
        Exit;
    if lstDTScale.Count = 0 then
        Exit;

    New(hisDatas);
    try
        // ����uhwDataOp.Excel.InclinoMeter.GetInclineAllData...����
        // GetInclineAllDatasFromXLS(FDataFile, hisDatas);
        GetInclineAllDatasFromXLS(FDataFile, FfraInCharts.HistoryDatas);
        // ��ʾ��Щ����
        // ShowMessage('ȡ��' + IntToStr(Length(hisDatas.hisDatas)) + '�ι۲����ݣ����ڿ�ʼ��ͼ');
        FfraInCharts.Draw2dHistoryLines;
    finally
        hisDatas.ReleaseDatas;
        Dispose(hisDatas);
    end;
end;

procedure TfrmMain.ShowOriginalData;
var
    frm: TfrmOriDataWindow;
begin
    if dlgOpen1.Execute then
    begin
        frm := TfrmOriDataWindow.Create(Self);
        frm.ShowData(dlgOpen1.FileName);
        frm.ShowModal;
        frm.Release;
        // mmo1.Lines.Clear;
        // mmo1.Lines.LoadFromFile(dlgOpen1.FileName);
        // // ����ļ���ʽ
        // if not CheckDataValid then
        // Exit;
    end;
end;

procedure TfrmMain.OpenExcelWorkbook;
var
    InInfo: TdtInclineHoleInfo;
    msg   : string;
    // dtList    : TStrings;
    OpenResult: Integer;
begin
    if dlgOpenExcelFile.Execute then
    begin
        // dtList := TStringList.Create;
        try
            OpenResult := OpenInDatafile(dlgOpenExcelFile.FileName, InInfo,
                { dtList } lstDTScale.Items);
            if OpenResult = 1 then
            begin
                FDataFile := dlgOpenExcelFile.FileName;
                FfraInCharts.SetHoleInfo(InInfo);
                FfraInCharts.pgcInclineCharts.ActivePage := FfraInCharts.tabEigenValue;

                msg := '��Ʊ�ţ�' + InInfo.DesignID + #13#10;
                msg := msg + '���̲�λ��' + InInfo.Position + #13#10;
                msg := msg + '׮    �ţ�' + InInfo.StakeNo + #13#10;
                msg := msg + '��ֵ���ڣ�' + datetostr(InInfo.BaseDate) + #13#10;
                msg := msg + '�۲������' + IntToStr( { dtList.Count } lstDTScale.Count);
            end
            else if OpenResult = -1 then
                msg := '�޷����ļ����ļ����ܲ����ڣ���Excel����ʹ�ø��ļ���'
            else
                msg := '������Ч��Excel�������ļ���';

            ShowMessage(msg);
        finally
            // dtList.Free;
        end;
    end;
end;

procedure TfrmMain.ShowSelectedData;
begin
    if (lstDTScale.Count = 0) then
    begin
        ShowMessage('��һ����б�������ļ�(Excel�ļ�)');
        Exit;
    end;
    if lstDTScale.ItemIndex = -1 then
    begin
        ShowMessage('��ѡ��һ���۲�����');
        Exit;
    end;
    // ShowMessage(lstDTScale.Items[lstDTScale.ItemIndex]);
    GetDataByDate(FDataFile, StrToDate(lstDTScale.Items[lstDTScale.ItemIndex]));
end;

end.
