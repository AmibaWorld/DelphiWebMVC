unit UsersService;

interface

uses
  UsersInterface, superobject, System.SysUtils, System.Classes,
  BaseService;

type
  TUsersService = class(TBaseService, IUsersInterface)
  published
    function checkuser(map: ISuperObject): ISuperObject;
    function check(map:ISuperObject):ISuperObject;
    function getAlldata(map: ISuperObject): ISuperObject;
  end;

implementation

uses
  uTableMap;

{ TUsersService }

function TUsersService.check(map: ISuperObject): ISuperObject;
var
  jo: ISuperObject;
  s: string;
begin
  //bpl������ ���� ���� �ຯ��  ����(json�ṹ)

  jo := exec('loginpackage', 'TLoginPackage', 'getdata', map);
  if jo <> nil then
    s := jo.AsString;
  Result := jo;
end;


function TUsersService.checkuser(map: ISuperObject): ISuperObject;
var
  jo: ISuperObject;
  s: string;
begin
  //bpl������ ���� ���� �ຯ�� ����(json�ṹ)

  jo := exec('userpackage', 'TUserPackage', 'checkuser', map);
  if jo <> nil then
    s := jo.AsString;
  Result := jo;
end;

function TUsersService.getAlldata(map: ISuperObject): ISuperObject;
begin
 // Result:= db.Find(tb_users,'');
 Result:=  exec('userpackage', 'TUserPackage', 'getAlldata', map);
end;

end.

