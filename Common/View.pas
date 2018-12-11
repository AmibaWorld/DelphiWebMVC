unit View;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, System.StrUtils,
  FireDAC.Comp.Client, Page, superobject, uConfig, Web.ReqMulti, Vcl.Imaging.jpeg,
  Vcl.Graphics, command, Data.DB, System.RegularExpressions,HTMLParser;

type
  TView = class
  private
    sessionid: string;
    htmlpars:THTMLParser;
    //SessionFilePath: string;
    url: string; // ��ǰģ��·��
    Response: TWebResponse;
    Request: TWebRequest;
    params: TStringList;
    function GetGUID: string;
    procedure CreateSession(); // ������ȡsession

//    function GetSession(): ISuperObject;
 //   procedure SaveSession(jo: ISuperObject);
  public
    Db: TDB;
    ActionP: string;
    function Q(str: string): string;
    procedure SessionSet(key, value: string);   // session���� value����json�ַ�����Ϊ����洢
    function SessionGet(key: string): string;   // session ֵ��ȡ

    function Cookies(): TCookie;                // cookies ����
    function CookiesValue(key: string): string; // cookies ����
    procedure CookiesSet(key, value: string);   // cookies ����
    function Input(param: string): string;      // ���ز���ֵ��get post
    function CDSToJSON(cds: TFDQuery): string;
    procedure setAttr(key, value: string);      // ������ͼ�����ʾ���� ����� value�� json ��������� table �������ʾ
    procedure ShowHTML(html: string);           // ��ʾģ��
    procedure ShowDSJSON(cds: TFDQuery);        // ���ݼ�ת��Ϊjson��ʾ
    procedure ShowText(text: string);           // ��ʾ�ı���json��ʽ��ת������ʾ
    procedure ShowJSON(jo: ISuperObject);       // ��ʾ json
    procedure Redirect(action: string; path: string = '');        // ��ת action ·��,path ·��
    procedure ShowCheckIMG(num: string; width, height: Integer);  // ��ʾ��֤��
    procedure Success(code: Integer = 0; msg: string = '');
    procedure Fail(code: Integer = -1; msg: string = '');
    constructor Create(Response_: TWebResponse; Request_: TWebRequest; ActionPath: string);
    destructor Destroy; override;
  end;

implementation

uses
  SessionList;

{ TView }

function TView.CDSToJSON(cds: TFDQuery): string;
var
  ja, jo: ISuperObject;
  i: Integer;
  ret: string;
begin
  if not cds.Active then
    cds.OpenOrExecute;
  ja := SA([]);
  ret := '';
  with cds do
  begin
    First;
    while not Eof do
    begin
      jo := SO();
      for i := 0 to Fields.Count - 1 do
      begin
        jo.S[Fields[i].DisplayLabel] := Fields[i].AsString;
      end;
      ja.AsArray.Add(jo);
      Next;
    end;
    ret := ja.AsString;
  end;
  result := ret;
end;

procedure TView.setAttr(key, value: string);
begin
  params.Values[key] := value;
end;

procedure TView.ShowText(text: string);
begin

  Response.ContentType := 'text/html; charset=' + default_charset;
  Response.Content := text;
  Response.SendResponse;
end;

procedure TView.Success(code: Integer; msg: string);
var
  jo: ISuperObject;
begin
  jo := SO();

  jo.I['code'] := code;
  if Trim(msg) = '' then
    msg := '�����ɹ�';
  jo.S['message'] := msg;
  ShowJSON(jo);
end;

procedure TView.ShowHTML(html: string);
var
  p: string;
  S: string;
  page: TPage;
  htmlcontent: string;
begin
  p := '';
  Response.Content := '';
  Response.ContentType := 'text/html; charset=' + default_charset;
  if (Trim(html) <> '') then
  begin
    S := url + html + template_type;
    if (not FileExists(S)) then
      Response.Content := html + template_type + ' ģ���ļ�δ�ҵ�'
    else
    begin
      try
        page := TPage.Create(S, params, self.url);
        htmlcontent := page.HTML;
        htmlpars.Parser(htmlcontent,params,self.url);
        Response.Content := htmlcontent;
      finally
        FreeAndNil(page);
      end;
    end;

  end
  else
  begin
    Response.Content := 'δָ��ģ���ļ�';
  end;
  Response.SendResponse;
end;

procedure TView.ShowJSON(jo: ISuperObject);
begin
  Response.ContentType := 'application/Json; charset=' + default_charset;
  Response.Content := jo.AsString;
  Response.SendResponse;
end;

procedure TView.ShowCheckIMG(num: string; width, height: Integer);
var
  bmp_t: TBitmap;
  jp: TJPEGImage;
  m: TMemoryStream;
begin

  jp := TJPEGImage.Create;
  bmp_t := TBitmap.Create;
  try
    bmp_t.SetSize(width, height);
    bmp_t.Transparent := True;
    bmp_t.Canvas.Font.Color := clGreen; // �½���ˮӡ������ɫ
    bmp_t.Canvas.Pen.Style := psClear;

    bmp_t.Canvas.Brush.Style := bsClear;

    bmp_t.Canvas.Font.Size := 16;
    bmp_t.Canvas.Font.Style := [fsBold];
    bmp_t.Canvas.Font.Name := 'Verdana';
    bmp_t.Canvas.TextOut(0, 5, num); // ��������
    // for I := 0 to 1 do
    // begin
    //
    // bmp_t.Canvas.Pen.Color:=clGreen;
    // bmp_t.Canvas.Pen.Width:=2;
    // bmp_t.Canvas.MoveTo(0,13+i*8);
    // bmp_t.Canvas.LineTo(width,13+i*8);
    //
    // end;
    jp.Assign(bmp_t);
    // jp.CompressionQuality := 25;

    // jp.Compress;
   // jp.SaveToFile('img.jpg');
    m := TMemoryStream.Create;

    jp.SaveToStream(m);
    m.Position := 0;
    self.Response.ContentType := 'image/jpeg';
    self.Response.ContentStream := m;
    //Response.SendResponse;
  finally
    bmp_t.Free;
    jp.Free;
  end;
end;

procedure TView.ShowDSJSON(cds: TFDQuery);
var
  ret: string;
begin
  try
    if not cds.Active then
      cds.OpenOrExecute;
    ret := Db.CDSToJSONArray(cds).AsString;

  except
    on E: Exception do
      ret := e.ToString;
  end;

  Response.Content := ret;
  Response.SendResponse;
end;

function TView.Cookies: TCookie;
begin
  result := Response.Cookies.Add;
end;

procedure TView.CookiesSet(key, value: string);
begin
  Request.CookieFields.Values[key] := value;
end;

function TView.CookiesValue(key: string): string;
begin
  result := Request.CookieFields.Values[key];
end;

constructor TView.Create(Response_: TWebResponse; Request_: TWebRequest; ActionPath: string);
begin

  params := TStringList.Create;
  htmlpars:=THTMLParser.Create;
  Db := TDB.Create();
  self.ActionP := ActionPath;
  if (Trim(self.ActionP) <> '') then
  begin
    self.ActionP := self.ActionP + '\';
  end;
  url := WebApplicationDirectory + template + '\' + self.ActionP;
  self.Response := Response_;
  self.Request := Request_;

  if (session_start) then
    CreateSession;

end;

procedure TView.CreateSession;
var
  timerout: TDateTime;
  iscreate: boolean;
  sessionobj: TSessionObj;
begin

  iscreate := false;

  sessionid := CookiesValue(SessionName);
  if (sessionid <> '') and (SessionListMap.count > 0) then
  begin
    sessionobj := SessionListMap.get(sessionid);
    if not (sessionobj = nil) then
    begin
      if sessionobj.SessionID = '' then
      begin
        iscreate := True;
      end
      else
      begin
        if (session_timer = 0) then
        begin
          timerout := Now + (1 / 24 / 60) * 60;   //1Сʱ����
          sessionobj := SessionListMap.get(sessionid);
          sessionobj.TimerOut := timerout;
        end;
      end;
    end
    else
    begin
      iscreate := True;
    end;

  end
  else
  begin
    sessionid := GetGUID();
    iscreate := true;
  end;
  if (iscreate) and (sessionid <> '') then
  begin
    with Cookies() do
    begin
      Path := '/';
      Name := SessionName;
      value := sessionid;
    end;

    if (session_timer <> 0) then
    begin
      timerout := Now + (1 / 24 / 60) * session_timer;
    end
    else
    begin
      timerout := Now + (1 / 24 / 60) * 60; //1Сʱ����
    end;

    sessionobj := TSessionObj.Create;
    sessionobj.SessionID := sessionid;
    sessionobj.TimerOut := timerout;
    SessionListMap.put(sessionid, sessionobj);
    log('����Session-' + sessionid);
  end;
end;

function TView.GetGUID: string;
var
  LTep: TGUID;
  sGUID: string;
begin
  CreateGUID(LTep);
  sGUID := GUIDToString(LTep);
  sGUID := StringReplace(sGUID, '-', '', [rfReplaceAll]);
  sGUID := Copy(sGUID, 2, Length(sGUID) - 2);
  result := sGUID;
end;

destructor TView.Destroy;
begin
  FreeAndNil(htmlpars);
  params.Clear;
//  FreeAndNil(Page);
  FreeAndNil(params);

  FreeAndNil(Db);

  inherited;
end;

procedure TView.Fail(code: Integer; msg: string);
var
  jo: ISuperObject;
begin
  jo := SO();
  jo.I['code'] := code;
  if Trim(msg) = '' then
    msg := '�����ɹ�';
  jo.S['message'] := msg;
  ShowJSON(jo);
end;



function TView.Input(param: string): string;
begin
  if (Request.MethodType = mtPost) then
  begin
    result := Request.ContentFields.Values[param];
  end
  else if (Request.MethodType = mtGet) then
  begin
    result := Request.QueryFields.Values[param];
  end;

end;

function TView.Q(str: string): string;
begin
  result := '''' + str + '''';
end;

procedure TView.Redirect(action: string; path: string = '');
var
  S: string;
begin
  S := '';
  if (Trim(action) <> '') then
  begin
    S := action + '/';
    if (Trim(path) <> '') then
    begin
      S := '/' + S + path;
    end;
    Response.Content := '<script>window.location.href=''' + S + ''';</script>';
    Response.SendResponse;
   // Response.SendRedirect(S);
  end;

end;

procedure TView.SessionSet(key, value: string);
begin
  if (not session_start) then
    exit;
  SessionListMap.get(sessionid).jo.Values[key] := value;
end;

function TView.SessionGet(key: string): string;
begin
  if (not session_start) then
    exit;
  result := SessionListMap.get(sessionid).jo.Values[key];
end;

end.

