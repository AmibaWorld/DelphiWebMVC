unit UsersService;

interface

uses
  UsersInterface, uConfig, superobject, uTableMap, System.SysUtils, System.Classes;

type
  TUsersService = class(TInterfacedObject, IUsersInterface)
  private
    Db: TDB;
  public
    constructor Create(_Db: TDB);
    function checkuser(map: ISuperObject): ISuperObject;
  end;

implementation

uses
  command;

{ TUsersService }

function TUsersService.checkuser(map: ISuperObject): ISuperObject;
begin
  //bpl������ ���� ���� �ຯ�� ���ݼ����� ��������(json�ṹ)
  Result := _PackageManager.exec('userpackage', 'TUserPackage', 'getdata', self.Db, map);
end;

constructor TUsersService.Create(_Db: TDB);
begin
  Db := _Db;
end;

end.

