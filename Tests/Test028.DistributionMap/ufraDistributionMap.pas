{-----------------------------------------------------------------------------
 Unit Name: ufraDistributionMap
 Author:    ��ΰ
 Date:      31-����-2019
 Purpose:   ��Frame������ʾ���������ķֲ�ͼ
            �۲����ݷֲ�ͼ�����ߵ�ɢ��ͼ��������Ϊ��������������������������ͬ
            �۲����ڵ�ɢ�����ߣ�����۲������γɶ����ߡ�
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
