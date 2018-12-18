unit CaiWuController;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, Data.DB, superobject, View,
  BaseController;

type
  TCaiWuController = class(TBaseController)
  public
    procedure Index;
    procedure upfile;
  end;

implementation

{ TCaiWuController }

procedure TCaiWuController.Index;
begin
  with View do
  begin
  //  Response.ContentStream
    ShowHTML('index');
  end;

end;

procedure TCaiWuController.upfile;
var
  FFileName: string;
  AFile: TFileStream;
  ret: ISuperObject;
  k: integer;
begin
  with view do
  begin
    k := Request.Files.Count - 1;
    FFileName := AppPath + 'upfile\' + Request.Files[k].FileName;
    AFile := TFileStream.Create(FFileName, fmCreate);
    try
      Request.Files[k].Stream.Position := 0;
      AFile.CopyFrom(Request.Files[k].Stream, Request.Files[k].Stream.Size);  //���Ա����ļ���ͨ����

    finally
      AFile.Free;

    end;
    ret := SO();
    ret.I['code'] := 0;
    ret.S['message'] := '�ϴ����';
    ShowJSON(ret);
  end;
end;

end.

