unit Loger;
//=======================================================================
//    ��־�ࣨTLoger�� ver.1.0
//    PFeng  (http://www.pfeng.org / xxmc01#gmail.com)
//    2012/11/08
//    ��־����Լ����
//          0 - Information
//          1 - Notice
//          2 - Warning
//          3 - Error
//=======================================================================

interface

uses Windows,Classes, SysUtils,StdCtrls,ComCtrls,ComObj,Messages;

const
  WRITE_LOG_DIR = 'log\'; //��¼��־Ĭ��Ŀ¼
  WRITE_LOG_MIN_LEVEL = 2; //��¼��־����ͼ���С�ڴ˼���ֻ��ʾ����¼
  WRITE_LOG_ADD_TIME = True; //��¼��־�Ƿ����ʱ��
  WRITE_LOG_TIME_FORMAT = 'hh:nn:ss.zzz';//��¼��־���ʱ��ĸ�ʽ
  SHOW_LOG_ADD_TIME = True; //��־��ʾ�����Ƿ����ʱ��
  SHOW_LOG_TIME_FORMAT = 'yyyy/mm/dd hh:nn:ss.zzz'; //��־��ʾ���ʱ��ĸ�ʽ
  SHOW_LOG_CLEAR_COUNT = 1000; //��־��ʾ���������ʾ����

type TLogger = class
  private
    FCSLock: TRTLCriticalSection; //�ٽ���
    FFileStream: TFileStream; //�ļ���
    FLogShower: TComponent; //��־��ʾ����
    FLogDir: AnsiString; //��־Ŀ¼
    FLogName: AnsiString; //��־����
  protected
    procedure ShowLog(Log:AnsiString; const LogLevel:Integer = 0);
  public
    procedure WriteLog(Log:AnsiString; const LogLevel:Integer = 0);
      overload;
    procedure WriteLog(Log:AnsiString; const Args: array of const;
      const LogLevel:Integer = 0);overload;
    constructor Create(LogShower: TComponent;LogDir: AnsiString);
    destructor Destroy; override;
end;

implementation

  constructor TLogger.Create(LogShower: TComponent;LogDir: AnsiString);
  begin
    InitializeCriticalSection(FCSLock);
    FLogShower := LogShower;
    if Trim(LogDir) = '' then
      FLogDir := ExtractFilePath(ParamStr(0)) + WRITE_LOG_DIR
    else
      FLogDir := LogDir;
    if not DirectoryExists(FLogDir) then
    if not ForceDirectories(FLogDir) then
    begin
      raise Exception.Create('��־·��������־������ܱ�����');
    end;
  end;

  procedure TLogger.WriteLog(Log:AnsiString; const Args: array of const;
      const LogLevel:Integer = 0);
  begin
    WriteLog(Format(Log, args),LogLevel);
  end;

  procedure TLogger.WriteLog(Log:AnsiString; const LogLevel:Integer = 0);
  var
    logName: AnsiString;
    fMode: Word;
  begin
    EnterCriticalSection(FCSLock);
    try
      ShowLog(Log,LogLevel); //��ʾ��־������
      if LogLevel >= WRITE_LOG_MIN_LEVEL  then
      begin
        logName := FormatDateTime('yyyymmdd',Now)+'.log';
        if FLogName <> logName then FLogName := logName;
        if FileExists(FLogDir+FLogName) then //����������־�ļ�����
          fMode := fmOpenWrite or fmShareDenyNone
        else
          fMode := fmCreate or fmShareDenyNone;
        if Assigned(FFileStream) then FreeAndNil(FFileStream);
        FFileStream := TFileStream.Create(FLogDir+FLogName,fmode);
        FFileStream.Position := FFileStream.Size; //׷�ӵ����
        case LogLevel of
          0: Log := '[Information] ' + Log;
          1: Log := '[Notice] ' + Log;
          2: Log := '[Warning] ' + Log;
          3: Log := '[Error] ' + Log;
        end;
        if WRITE_LOG_ADD_TIME then
        Log := FormatDateTime(WRITE_LOG_TIME_FORMAT, Now) + ' '+ Log
               + #13#10;
        FFileStream.Write(PAnsiChar(Log)^, StrLen(PAnsiChar(Log)));
      end;
    finally
      LeaveCriticalSection(FCSLock);
    end;
  end;

  procedure TLogger.ShowLog(Log:AnsiString; const LogLevel:Integer = 0);
  var
    lineCount: Integer;
    listItem: TListItem;
  begin
    if FLogShower = nil then Exit;
    if (FLogShower is TMemo) then
    begin
      if SHOW_LOG_ADD_TIME then
      Log := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now) + ' '+ Log;
      lineCount := TMemo(FLogShower).Lines.Add(Log);
      //���������һ��
      SendMessage(TMemo(FLogShower).Handle,WM_VSCROLL,SB_LINEDOWN,0);
      if lineCount >= SHOW_LOG_CLEAR_COUNT then
        TMemo(FLogShower).Clear;
    end
    else if (FLogShower is TListBox) then
    begin
      if SHOW_LOG_ADD_TIME then
      Log := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now) + ' '+ Log;
      lineCount := TListBox(FLogShower).Items.Add(Log);
      SendMessage(TListBox(FLogShower).Handle,WM_VSCROLL,SB_LINEDOWN,0);
      if lineCount >= SHOW_LOG_CLEAR_COUNT then
        TListBox(FLogShower).Clear;
    end
    else if (FLogShower is TListView) then
    begin
      ListItem := TListView(FLogShower).Items.Add;
      if SHOW_LOG_ADD_TIME then
      ListItem.Caption := FormatDateTime(SHOW_LOG_TIME_FORMAT, Now);
      if Assigned(TListView(FLogShower).SmallImages) and
       (TListView(FLogShower).SmallImages.Count - 1 >= LogLevel) then
      ListItem.ImageIndex := LogLevel; //���Ը��ݲ�ͬ�ȼ���ʾ��ͬͼƬ
      ListItem.SubItems.Add(Log);
      SendMessage(TListView(FLogShower).Handle,WM_VSCROLL,SB_LINEDOWN,0);
      if TListView(FLogShower).Items.Count >= SHOW_LOG_CLEAR_COUNT then
        TListView(FLogShower).Items.Clear;
    end
    else
      raise Exception.Create('��־�������Ͳ�֧��:' + FLogShower.ClassName);
  end;

  destructor TLogger.Destroy;
  begin
    DeleteCriticalSection(FCSLock);
  end;

end.
