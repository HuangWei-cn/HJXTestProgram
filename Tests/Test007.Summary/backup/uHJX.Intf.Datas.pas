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
        { 取回指定监测仪器的最后一次监测数据 }
        function GetLastPDDatas(ADsnName: string; var Values: TDoubleDynArray): Boolean;
        { 取回指定时段内监测仪器的最后一次数据 }
        function GetLastPDDatasBeforeDate(ADsnName: string; DT: TDateTime; var Values: TDoubleDynArray): boolean;
        { 取回最接近指定日期的观测数据 }
        function GetNearestPDDatas(ADsnName: String; DT: TDateTime; var Values: TDoubleDynArray; DTDelta: Integer=0): Boolean;
        { 取回指定时段内监测仪器所有观测数据 }
        function GetPDDatasInPeriod(ADsnName: string; DT1,DT2: TDateTime; DS: TDataSet): boolean;
        { 取回全部观测数据}
        function GetAllPDDatas(ADsnName: string; DS: TDataSet): Boolean;
        { 取回当前特征值，弃用，被GetEVDatas方法取代。 }
        function GetEVData(ADsnName: string; EVData: PEVDataStru): boolean; overload;
        function GetEVData(ADsnName: string; var EVDatas: TDoubleDynArray): Boolean; overload;
        { 取回指定仪器所有具有特征值的物理量的特征值 }
        function GetEVDatas(ADsnName: String; var EVDatas: PEVDataArray): Boolean;
        { 取回指定时段内的特征值 }
        function GetEVDataInPeriod(ADsnName: string; DT1, DT2: TDateTime; var EVDatas: TDoubleDynArray): Boolean;
        { 设置DataSet的字段别名 }
        procedure SetFieldDisplayName(DS: TDataSet);
    end;

var
    IHJXClientFuncs: IClientFuncs;
implementation

end.
