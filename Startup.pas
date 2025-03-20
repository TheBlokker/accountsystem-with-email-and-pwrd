unit Startup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Login, CreateAccount;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label10: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;
  FormLogin: TForm2;
  FormRegister: TForm1;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  // FormLogin (anstatt Form2) erstellen
  FormLogin := TForm2.Create(nil);
  try
    FormLogin.ShowModal;  // ÷ffnet das Formular als modales Fenster
  finally
    FormLogin.Free;  // Formular wird nach dem Schlieﬂen freigegeben
  end;
end;


procedure TForm3.Button2Click(Sender: TObject);
begin
  FormRegister := TForm1.Create(nil);
  try
    FormRegister.ShowModal;  // ÷ffnet das Formular als modales Fenster
  finally
    FormRegister.Free;  // Formular wird nach dem Schlieﬂen freigegeben
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
Form3.Close
end;

end.
