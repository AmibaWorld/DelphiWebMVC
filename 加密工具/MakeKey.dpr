program MakeKey;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  DES in 'DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title:='���ܹ���';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
