unit uRouleMap;

interface

uses
  Roule;

type
  TRouleMap = class(TRoule)
  public
    constructor Create(); override;
  end;

implementation

uses
  IndexController;

constructor TRouleMap.Create;
begin
  inherited;
  //·��,������,��ͼĿ¼
  SetRoule('', TIndexController, 'index');

end;

end.

