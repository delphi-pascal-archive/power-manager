{Автор Зорков Игорь - zorkovigor@mail.ru}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PowerManager, StdCtrls, Spin, MMSystem;

type
  TForm1 = class(TForm)
    PowerManager1: TPowerManager;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    procedure PowerManager1WakeUp(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  if PowerManager1.IsSuspendAllowed then
  begin
    Button1.Enabled := True;
    CheckBox1.Enabled := True;
    SpinEdit1.Enabled := True;
    Label1.Enabled := True;
  end;
  if PowerManager1.IsHibernateAllowed then
  begin
    Button2.Enabled := True;
    CheckBox2.Enabled := True;
    SpinEdit2.Enabled := True;
    Label2.Enabled := True;
  end;
end;

procedure TForm1.PowerManager1WakeUp(Sender: TObject);
begin
  sndPlaySound(PAnsiChar(ExtractFilePath(ParamStr(0)) + 'music.wav'), SND_ASYNC);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    PowerManager1.StartWakeUpTimer(SpinEdit1.Value);
  PowerManager1.Suspend(True);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    PowerManager1.StartWakeUpTimer(SpinEdit2.Value);
  PowerManager1.Hibernate(True);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  PowerManager1.LockWorkStation;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  PowerManager1.Logoff(True);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  PowerManager1.Shutdown(True);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  PowerManager1.Reboot(True);
end;

end.

