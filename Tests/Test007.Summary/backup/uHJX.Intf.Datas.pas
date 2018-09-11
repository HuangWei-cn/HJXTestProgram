unit uHJX.Intf.Datas;

interface
uses
    System.Classes, system.Types, Data.DB,
    uHJX.Data.Types;

type
    IClientFuncs = interface(IInterface)
        ['{E54FEFEB-41EF-49F8-B242-8983452D7593}']
        procedure SessionBegin;
        procedure SessionEnd;
        { ȡ��ָ��������������һ�μ������ }
        function GetLastPDDatas(ADsnName: string; var Values: TDoubleDynArray): Boolean;
        { ȡ��ָ��ʱ���ڼ�����������һ������ }
        function GetLastPDDatasBeforeDate(ADsnName: string; DT: TDateTime; var Values: TDoubleDynArray): boolean;
        { ȡ����ӽ�ָ�����ڵĹ۲����� }
        function GetNearestPDDatas(ADsnName: String; DT: TDateTime; var Values: TDoubleDynArray; DTDelta: Integer=0): Boolean;
        { ȡ��ָ��ʱ���ڼ���������й۲����� }
        function GetPDDatasInPeriod(ADsnName: string; DT1,DT2: TDateTime; DS: TDataSet): boolean;
        { ȡ��ȫ���۲�����}
        function GetAllPDDatas(ADsnName: string; DS: TDataSet): Boolean;
        { ȡ�ص�ǰ����ֵ�����ã���GetEVDatas����ȡ���� }
        function GetEVData(ADsnName: string; EVData: PEVDataStru): boolean; overload;
        function GetEVData(ADsnName: string; var EVDatas: TDoubleDynArray): Boolean; overload;
        { ȡ��ָ���������о�������ֵ��������������ֵ }
        function GetEVDatas(ADsnName: String; var EVDatas: PEVDataArray): Boolean;
        { ȡ��ָ��ʱ���ڵ�����ֵ }
        function GetEVDataInPeriod(ADsnName: string; DT1, DT2: TDateTime; var EVDatas: TDoubleDynArray): Boolean;
        { ����DataSet���ֶα��� }
        procedure SetFieldDisplayName(DS: TDataSet);
    end;

var
    IHJXClientFuncs: IClientFuncs;
implementation

end.
