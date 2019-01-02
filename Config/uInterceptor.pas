unit uInterceptor;

interface

uses
  System.SysUtils, View, System.Classes;

type
  TInterceptor = class
    urls: TStringList;
    function execute(View: TView; error: Boolean): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TInterceptor }

constructor TInterceptor.Create;
begin
  urls := TStringList.Create;
  //������Ĭ�Ϲر�״̬uConfig�ļ��޸�
  //����Ҫ���صĵ�ַ��ӵ�����
  urls.Add('/');
  urls.Add('/check');
  urls.Add('/checknum');
end;

function TInterceptor.execute(View: TView; error: Boolean): Boolean;
var
  url: string;
begin
  Result := false;
  with View do
  begin
    if (error) then
    begin
      Result := true;
      exit;
    end;
    url := LowerCase(Request.PathInfo);
    if urls.IndexOf(url) < 0 then
    begin
      if (SessionGet('username') = '') then
      begin
        Result := true;
        Response.Content := '<script>window.location.href=''/'';</script>';
        Response.SendResponse;
      end;
    end;
  end;
end;

destructor TInterceptor.Destroy;
begin
  urls.Free;
  inherited;
end;

end.


