unit CaiWuAction;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, Data.DB, superobject, View,
  BaseAction;

type
  TCaiWuAction = class(TBaseAction)
  public
    procedure Index;
    procedure upfile;
  end;

implementation

{ TCaiWuAction }

procedure TCaiWuAction.Index;
begin
  with View do
  begin
  //  Response.ContentStream
    ShowHTML('index');
  end;

end;

procedure TCaiWuAction.upfile;
var
  FFileName: string;
  AFileName: string;
  AFile: TFileStream;
  ret:ISuperObject;
begin
  with view do
  begin
    FFileName :=AppPath+ '�ļ���' + Request.Files[0].FileName;

    AFileName := ExtractFileName(Request.Files[0].FileName);
    AFileName := ExtractFilePath(GetModuleName(0)) + AFileName;
    AFile := TFileStream.Create(AFileName, fmCreate);
    try
      Request.Files[0].Stream.Position := 0;
      AFile.CopyFrom(Request.Files[0].Stream, Request.Files[0].Stream.Size);  //���Ա����ļ���ͨ����
      ret:=SO();
      ret.I['code']:=0;
      ret.S['message']:='�ϴ����';
      ShowJSON(ret);
    finally
      AFile.Free;

    end;
  end;
end;

end.

