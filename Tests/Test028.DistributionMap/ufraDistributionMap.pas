{-----------------------------------------------------------------------------
 Unit Name: ufraDistributionMap
 Author:    黄伟
 Date:      31-七月-2019
 Purpose:   本Frame用于显示给定仪器的分布图
            观测数据分布图是连线的散点图，纵坐标为物理量，横坐标是仪器，将相同
            观测日期的散点连线，多个观测日期形成多条线。
 History:   2019-07-31
-----------------------------------------------------------------------------}

unit ufraDistributionMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Vcl.ExtCtrls,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series;

type
  TframDistributionMap = class(TFrame)
    Chart1: TChart;
    Panel1: TPanel;
    Series1: TLineSeries;
    TeeGDIPlus1: TTeeGDIPlus;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
