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
  uConfig;

type
  TBaseService = class(TInterfacedObject)
  public
    Db: TDB;
    constructor Create(_Db: TDB);
  end;

implementation

{ TBaseService }

constructor TBaseService.Create(_Db: TDB);
begin
  Db := _Db;
end;



end.

