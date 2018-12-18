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
        FMultDateStr: string; // 多日期，用于用户重复挑选多个日期
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
  Description: 将多日数据同图显示
  方式：弹出日期选择窗口，将日期全部传递给fra，之后绘制出来
----------------------------------------------------------------------------- }
procedure TfrmMain.btn1Click(Sender: TObject);
var
    // dts  : string; // 用户选择的多个日期
    frm  : TfrmMultDates; // 日期选择对话窗
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
// // 首行内容为"***"
// sLine := mmo1.Lines[0];
// if sLine <> '***' then
// begin
// ShowMessage('不是合法的基康测斜仪数据文件，请重新选择文件');
// Exit;
// end;
//
// iStart             := 0;
// FS                 := TFormatSettings.Create('en-US');
// FS.ShortDateFormat := 'm/d/yy';
// FS.DateSeparator   := '/';
// // FS.ShortTimeFormat
//
// // 逐行检查，直到遇到‘FLEVEL’字样
// for i := 0 to mmo1.Lines.Count - 1 do
// begin
// sLine := mmo1.Lines[i];
// // 判断是否遇到‘FLEVEL’，若是，则下一行是首行数据，否则……
// if Pos('FLEVEL', sLine) > 0 then
// begin
// // ShowMessage(sLine);
// iData := i + 1;
// Break;
//
// end;
// // ---------------------
// // 判断sLine中是否包含冒号，若是则分解之。
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
// // 将美式m/d/yy格式转成当前系统默认的格式。
// { TODO -oHW -cGeneral : 在程序中定义一个TFormatSettings作为程序统一的日期等格式 }
// sDate := datetostr(StrToDate(s2, FS));
// end
// else if s1 = 'TIME' then
// sTime := s2
// else if s1 = '#READINGS' then
// begin
// // 检查数据行数，为零则不是正常的数据文件
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
        grdDatas.Cells[0, 0] := '孔深(m)';
        grdDatas.Cells[1, 0] := 'A向(mm)';
        grdDatas.Cells[2, 0] := 'B向(mm)';
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
                ShowMessage('无法打开数据文件，文件不存在或正被Excel使用');
            -3001, -3002:
                ShowMessage('指定的文件不是Excel工作簿');
            0:
                ShowMessage('未能取回数据：指定的观测日期不存在，或其他错误');
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
    // 打开新文件，清空多选
    FMultDateStr := '';
end;

procedure TfrmMain.sSpeedButton4Click(Sender: TObject);
begin
    FMultDateStr := ''; // 显示单次曲线时，清空多选
    ShowSelectedData;
end;

procedure TfrmMain.GetAllDatas;
var
    hisDatas: PdtInHistoryDatas;
begin
    // 用户已选择测斜孔，该孔有数据:
    if FDataFile = '' then
        Exit;
    if lstDTScale.Count = 0 then
        Exit;

    New(hisDatas);
    try
        // 调用uhwDataOp.Excel.InclinoMeter.GetInclineAllData...函数
        // GetInclineAllDatasFromXLS(FDataFile, hisDatas);
        GetInclineAllDatasFromXLS(FDataFile, FfraInCharts.HistoryDatas);
        // 显示这些数据
        // ShowMessage('取回' + IntToStr(Length(hisDatas.hisDatas)) + '次观测数据，现在开始绘图');
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
        // // 检查文件格式
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

                msg := '设计编号：' + InInfo.DesignID + #13#10;
                msg := msg + '工程部位：' + InInfo.Position + #13#10;
                msg := msg + '桩    号：' + InInfo.StakeNo + #13#10;
                msg := msg + '初值日期：' + datetostr(InInfo.BaseDate) + #13#10;
                msg := msg + '观测次数：' + IntToStr( { dtList.Count } lstDTScale.Count);
            end
            else if OpenResult = -1 then
                msg := '无法打开文件。文件可能不存在，或Excel正在使用该文件。'
            else
                msg := '不是有效的Excel工作簿文件。';

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
        ShowMessage('打开一个测斜孔数据文件(Excel文件)');
        Exit;
    end;
    if lstDTScale.ItemIndex = -1 then
    begin
        ShowMessage('请选择一个观测日期');
        Exit;
    end;
    // ShowMessage(lstDTScale.Items[lstDTScale.ItemIndex]);
    GetDataByDate(FDataFile, StrToDate(lstDTScale.Items[lstDTScale.ItemIndex]));
end;

end.
