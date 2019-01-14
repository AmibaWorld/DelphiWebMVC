{ *************************************************************************** }
{  SynWebApp.pas is the 4th file of SynBroker Project                         }
{  by c5soft@189.cn  Version 0.9.1.0  2018-6-2                                }
{ *************************************************************************** }

{$DENYPACKAGEUNIT}

unit SynWebApp;

interface

uses
  Classes, SysUtils, WebBroker, HTTPApp, SynCommons, SynCrtSock, SynWebServer;

type
  TSynWebApplication = class(TWebApplication)
  private
    fServer: TSynWebServer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TSynWebApplication }

constructor TSynWebApplication.Create(AOwner: TComponent);
begin
  inherited;
  fServer := TSynWebServer.Create(Self);
end;

destructor TSynWebApplication.Destroy;
begin
  fServer.Free;
  inherited;
end;

procedure InitApplication;
begin
  Application := TSynWebApplication.Create(nil);
end;

initialization
  InitApplication;

end.

