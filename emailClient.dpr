program emailClient;

uses
  Vcl.Forms,
  CreateAccount in 'CreateAccount.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Login in 'Login.pas' {Form2},
  Startup in 'Startup.pas' {Form3},
  emailUI in 'emailUI.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
