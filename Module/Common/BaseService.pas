{*******************************************************}
{                                                       }
{       DelphiWebMVC                                    }
{                                                       }
{       ��Ȩ���� (C) 2019 ����ӭ(PRSoft)                }
{                                                       }
{*******************************************************}
unit BaseService;

interface

uses
  uConfig,uDBConfig;

type
  TBaseService = class(TInterfacedObject)
  public
    Db: TDBConfig;
    function Q(str: string): string;
    constructor Create(_Db: TDBConfig);
  end;

implementation

{ TBaseService }

constructor TBaseService.Create(_Db: TDBConfig);
begin
  Db := _Db;
end;

function TBaseService.Q(str: string): string;
begin
  result := '''' + str + '''';
end;

end.

