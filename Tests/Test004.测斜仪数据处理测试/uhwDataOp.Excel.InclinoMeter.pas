{ -----------------------------------------------------------------------------
  Unit Name: uhwDataOp.Excel.InclinoMeter
  Author:    ��ΰ
  Date:      17-����-2017
  Purpose:   ��б�����ݲ�ѯ��Ԫ������Ԫ����Excel�ļ����ݣ��ṩ��xls��xlsx��ʽ
  �ļ��ķ��ʣ���ȡ���еĲ�б�����ݡ�
  ����ÿ�δ�Excel�ļ�����Ҫ�ķѺܶ�ʱ�䣬��������Ҫȡ������ݣ�Ӧ
  ������һ����ȡ��ȫ�����ݡ�
  History:
  ----------------------------------------------------------------------------- }

unit uhwDataOp.Excel.InclinoMeter;

interface

uses
  System.Classes, System.SysUtils, System.Variants, nExcel, System.DateUtils,
    {--------------} uhwDataType.DSM.InclinoMeter {--------------};

// ��Excel�����ļ������ز�б�����ݻ�����Ϣ������������������
function OpenInDatafile(AFile: string; var AInfo: TdtInclineHoleInfo; DateList: TStrings): Integer;

{ �������ļ�������ָ�����ڵ����� }
function GetInclineDataFromXLS(AFile: string; ADate: TDateTime; AData: PdtInclinometerDatas)
  : Integer; overload;
function GetInclineDataFromXLS(ABook: IXLSWorkBook; ADate: TDateTime; AData: PdtInclinometerDatas)
  : Integer; overload;

{ �������ļ�������ȫ����б�׹۲����� }
procedure GetInclineAllDatasFromXLS(AFile: string; ADatas: PdtInHistoryDatas);

{ �������ļ��������û���ѡ�Ķ�����ڵĹ۲����ݡ�����MultDTs���ַ����������������û���ѡ���
  ������ڣ�ÿ�������ûس����з��������ʿ��Ը�ֵ��TStrings.Text��Ȼ����һȡ���������� }
procedure GetInclineMultDatasFromXLS(AFile: string; MultDTs: string; ADatas: PdtInHistoryDatas);

implementation

{ �Ӹ�����workbook�з���ָ�����ڵ����ݡ����ջƽ�Ͽ��б�������ļ���ʽ��ÿ�ι۲����ݵ��������һ��
  �������У�����������־��ǹ۲����ڡ� }
function GetDataByDate(ABook: IXLSWorkBook; ADate: TDateTime;
  TheData: PdtInclinometerDatas): Boolean;
var
  sn : string;
  i  : Integer;
  dt : TDateTime;
  sht: IXLSWorksheet;
    { -----------�Ӹ�����������ȡ���ݣ�������Ҳ���Ե������ڡ�---------------- }
  function GetData(ASheet: IXLSWorksheet; Data: PdtInclinometerDatas): Boolean;
  var
    iRow, iCol, iStartRow, i: Integer;
    s, s1                   : string;
    d, a, b, sa, sb         : Single;
  begin
    Result := false;
    if ASheet = nil then
        Exit;
    // �ڵ�һ����"FLevel"������ҵ���10�С�
    iStartRow := 0;
    for iRow := 1 to 10 do
    begin
      s := VarToStr(ASheet.Cells.Item[iRow, 1].Value);
      if s <> 'FLevel' then
      begin
        iStartRow := iRow + 1;
        Break;
      end;
    end;

    if iStartRow = 0 then
        Exit;

        // ��ʼ��ȡ���ݣ���б�׵������ᳬ��1000����Ϊ����ᳬ��500�ף����0.5��һ����㣩
    for iRow := iStartRow to 1000 do
    begin
      s := VarToStr(ASheet.Cells.Item[iRow, 1].Value);
      s1 := VarToStr(ASheet.Cells.Item[iRow, 2].Value);
      if s = '' then // ��һ���ǿ�����õ�λΪ�ձ������Ѿ�����ȫ���������ˡ�
          Break;
      if trim(s1) = '' then // �ӵڶ��п�ʼ�����ݣ���Ϊ�գ����������Ѿ�����
          Break;
            // ���Խ�sת��Ϊ��������
      if TryStrToFloat(s, d) then
      begin
        // A�������
        s := VarToStr(ASheet.Cells.Item[iRow, 8].Value);
        if TryStrToFloat(s, a) = false then
            a := 0;
        // B�������
        s := VarToStr(ASheet.Cells.Item[iRow, 9].Value);
        if TryStrToFloat(s, b) = false then
            b := 0;
        // A���ۼƱ�����
        s := VarToStr(ASheet.Cells.Item[iRow, 10].Value);
        if TryStrToFloat(s, sa) = false then
            sa := 0;
        // B���ۼƱ�����
        s := VarToStr(ASheet.Cells.Item[iRow, 11].Value);
        if TryStrToFloat(s, sb) = false then
            sb := 0;

                // ��չ���飬��������
        Data.AddData(d, a, b, sa, sb);
                // SetLength(Data.Datas, Length(Data.Datas) + 1);
                // i := High(Data.Datas);
                // New(Data.Datas[i]);
                // Data.Datas[i].Level := d;
                // Data.Datas[i].sgmDA := a;
                // Data.Datas[i].sgmDB := b;
      end;
    end;
    Result := True;
  end;

begin
  Result := false;
  if ABook = nil then
      Exit;
  if TheData = nil then
      Exit;
  for i := 1 to ABook.Sheets.Count do
  begin
    sht := ABook.Sheets[i];
    if sht.Visible = 1 then Continue; //��Worksheet��������״̬����Visible = 1������Ϊ0

    sn := sht.Name;
        // ����s�Ƿ����ת��Ϊ���ڣ����ǣ���͸������ڽ��бȽϣ��ɹ���ȡ����
    if TryStrToDate(sn, dt) then
      if dt = ADate then
      begin
        TheData.DTScale := ADate;
        Result := GetData(sht, TheData);
                { ----- �����˳�ѭ������������ }
                // Result := true;
        Break;
      end;
  end;
end;

{ �򿪸����Ĳ�б�������ļ�������ļ���ʽ�����ز�б����Ϣ�͹۲������б� }
function OpenInDatafile(AFile: string; var AInfo: TdtInclineHoleInfo; DateList: TStrings): Integer;
var
  i    : Integer;
  book : IXLSWorkBook;
  sheet: IXLSWorksheet;
  dt   : TDateTime;
begin
  System.SysUtils.FormatSettings.DateSeparator := '-';
  System.SysUtils.FormatSettings.ShortDateFormat := 'yyyy-MM-dd';

  book := TXLSWorkbook.Create;
    { todo:�����Excel�ļ�ʱ�Ĵ����� }
    // IXLSWorkbook.Open�򿪳ɹ�����1���޷����ļ�����-1��-3000��-3001��-3002Ϊ
    // ����ȷ���ļ���ʽ������-3001Ϊhtml��-3002Ϊxml��ʽ��
  Result := book.Open(AFile);
  if Result <> 1 then
      Exit;

  if DateList <> nil then
      DateList.Clear;

    // �ҵ���Info����������ȡ���е���Ϣ��ע��nExcel���ýӿڣ�û��ʹ��for in do���
  for i := 1 to book.Sheets.Count do
  begin
    sheet := book.Sheets[i];
    //���г����صĹ�����
    if Sheet.Visible = 1 then Continue; //nExcel�У��������Visible����Ϊ0-��ʾ��1-����

    if sheet.Name = 'Info' then
    begin
      AInfo.DesignID := VarToStr(sheet.Cells[3, 2].Value);
      AInfo.Position := VarToStr(sheet.Cells[4, 2].Value);
      AInfo.StakeNo := VarToStr(sheet.Cells[5, 2].Value);
      if not VarIsNull(sheet.Cells.Item[6, 2].Value) then
          AInfo.Elevation := sheet.Cells[6, 2].Value;
      if not VarIsNull(sheet.Cells.Item[7, 2].Value) then
          AInfo.BottomEL := sheet.Cells[7, 2].Value;
      AInfo.BaseDate := VarToDateTime(sheet.Cells[12, 2].Value);
            // Break;
    end;

        // �ж��Ƿ��ǹ۲����ݱ����жϹ����������Ƿ�������
    if DateList <> nil then
    begin
      if TryStrToDate(sheet.Name, dt) then //�������������ڸ�ʽ
          if dt>strtodate('2000-1-1') then //�������ڱ�������2000�꣬����Ĳ�֧��
            DateList.Add(DateToStr(dt));
    end;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetInclineDataFromXLS
  Description: ��ָ����Excel�������ļ�����ȡ�ƶ����ڵĲ�б�׹۲����ݡ�����ֵ
  -1���޷����ļ�����-1����Excel�ļ���ʽ��0��û��ȡ�����ݣ�1��ȡ�����ݡ�
  ----------------------------------------------------------------------------- }
function GetInclineDataFromXLS(AFile: string; ADate: TDateTime;
  AData: PdtInclinometerDatas): Integer;
var
  book: IXLSWorkBook;
begin
    // ���ȣ�Ҫ�ܴ��ļ�------------------------------------------------------
  Result := 0;
  if AData = nil then
      Exit;

  book := TXLSWorkbook.Create;
  Result := book.Open(AFile);
  if Result <> 1 then
      Exit;
    // ��Σ�����GetDataByDate����---------------------------------------------
  Result := GetInclineDataFromXLS(book, ADate, AData);
end;

function GetInclineDataFromXLS(ABook: IXLSWorkBook; ADate: TDateTime;
  AData: PdtInclinometerDatas): Integer;
begin
  if ABook = nil then
      Exit;
  Result := 1;
    // ��Σ�����GetDataByDate����---------------------------------------------
  if GetDataByDate(ABook, ADate, AData) = false then
      Result := 0;
end;

procedure GetInclineAllDatasFromXLS(AFile: string; ADatas: PdtInHistoryDatas);
var
  pdt     : PdtInclinometerDatas;
  WBook   : IXLSWorkBook;
  HoleInfo: TdtInclineHoleInfo;
  dtList  : TStringList;
  i       : Integer;
begin
  if AFile = '' then
      Exit;
  WBook := TXLSWorkbook.Create;
  if WBook.Open(AFile) <> 1 then
      Exit;

  if ADatas = nil then
      Exit;
  ADatas.ReleaseDatas;
  ADatas.HoleID := '';

  dtList := TStringList.Create;
  try
    OpenInDatafile(AFile, HoleInfo, dtList);
    ADatas.HoleID := HoleInfo.DesignID;
    dtList.Sorted := True;

    if dtList.Count > 0 then
      for i := 0 to dtList.Count - 1 do
      begin
        pdt := ADatas.NewData;
        GetInclineDataFromXLS(WBook, StrToDate(dtList[i]), pdt);
      end;
  finally
    dtList.Free;
  end;
end;

{ -----------------------------------------------------------------------------
  Procedure  : GetInclineMultDatasFromXLS
  Description: ��ָ�������ļ����������û�ѡ��Ķ�����ڵĹ۲�����
----------------------------------------------------------------------------- }
procedure GetInclineMultDatasFromXLS(AFile: string; MultDTs: string; ADatas: PdtInHistoryDatas);
var
  pdt    : PdtInclinometerDatas;
  WBook  : IXLSWorkBook;
  strsDTs: TStrings;
  i      : Integer;
begin
  if AFile = '' then
      Exit;
  if MultDTs = '' then
      Exit;
  WBook := TXLSWorkbook.Create;
  if WBook.Open(AFile) <> 1 then
      Exit;

  if ADatas = nil then
      Exit;
  ADatas.ReleaseDatas;
  strsDTs := TStringList.Create;
  try
    strsDTs.Text := MultDTs;
    if strsDTs.Count > 0 then
      for i := 0 to strsDTs.Count - 1 do
      begin
        pdt := ADatas.NewData;
        GetInclineDataFromXLS(WBook, StrToDate(strsDTs.Strings[i]), pdt);
      end;
  finally
    strsDTs.Free;
  end;

end;

initialization

System.SysUtils.FormatSettings.DateSeparator := '-';
System.SysUtils.FormatSettings.LongDateFormat := 'yyyy-mm-dd';

end.
