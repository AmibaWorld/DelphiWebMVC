unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfmMain = class(TForm)
    grp1: TGroupBox;
    edtkey: TEdit;
    btnkey: TBitBtn;
    btn1: TBitBtn;
    grp3: TGroupBox;
    mmokey: TMemo;
    grp2: TGroupBox;
    mmokeyvalue: TMemo;
    procedure btnkeyClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  DES;

{$R *.dfm}

procedure TfmMain.btn1Click(Sender: TObject);
begin
  if (Trim(edtkey.Text) = '') or (Trim(mmokeyvalue.Text) = '') then
  begin
    ShowMessage('��Կ����ܽ�����');
    exit;
  end;
  ShowMessage(DeCryptStr(mmokeyvalue.Text, edtkey.Text));
end;

procedure TfmMain.btnkeyClick(Sender: TObject);
begin
  if (Trim(edtkey.Text) = '') or (Trim(mmokey.Text) = '') then
  begin
    ShowMessage('��Կ��������ݱ��');
    exit;
  end;
  mmokeyvalue.Text := EnCryptStr(mmokey.Text, edtkey.Text);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
end;

end.
