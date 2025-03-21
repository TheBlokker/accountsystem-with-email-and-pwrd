unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  System.IOUtils, CreateAccount, emailUI;

type
  TForm2 = class(TForm)
    Label10: TLabel;
    Button3: TButton;
    Button4: TButton;
    EditPassword: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    EditEmail: TEdit;
    Button2: TButton;
    procedure Button4MouseEnter(Sender: TObject);
    procedure Button4MouseLeave(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function ReadJSONFromFile(const FileName: string): TJSONObject;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function TForm2.ReadJSONFromFile(const FileName: string): TJSONObject;
var
  JSONString: string;
begin
  if not FileExists(FileName) then
    Result := TJSONObject.Create
  else
  begin
    JSONString := TFile.ReadAllText(FileName);
    Result := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  UsersJSON: TJSONObject;
  UserArray: TJSONArray;
  UserObject: TJSONObject;
  i: Integer;
begin
  try
    // JSON-Datei lesen
    if not FileExists('users.json') then
    begin
      ShowMessage('Benutzerdatei nicht gefunden.');
      Exit;
    end;
    UsersJSON := ReadJSONFromFile('users.json');

    // Benutzerarray holen
    UserArray := UsersJSON.GetValue('users') as TJSONArray;
    if UserArray = nil then
    begin
      ShowMessage('Keine Benutzer gefunden.');
      Exit;
    end;

    // Benutzeranmeldeinformationen �berpr�fen
    for i := 0 to UserArray.Count - 1 do
    begin
      UserObject := UserArray.Items[i] as TJSONObject;
      if (LowerCase(UserObject.GetValue('email').Value) = LowerCase(EditEmail.Text)) and
        (UserObject.GetValue('pwd').Value = EditPassword.Text) then
      // Beachte: Passw�rter niemals unverschl�sselt speichern!
      begin
        ShowMessage('Anmeldung erfolgreich!');
        // Neues Formular �ffnen und Daten �bergeben
        Form4 := TForm4.Create(Self);
        Form4.LoadUserData(UserObject);
        Form4.ShowModal;
        Form4.Free;
        ModalResult := mrOK; // Formular schlie�en
        Self.Close;
        Exit;
      end;
    end;

    ShowMessage('Ung�ltige E-Mail oder Passwort.');
  finally
    UsersJSON.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm2.Button4MouseEnter(Sender: TObject);
begin
  // Pw visable
  EditPassword.PasswordChar := #0;
end;

procedure TForm2.Button4MouseLeave(Sender: TObject);
begin
  // pw invisble
  EditPassword.PasswordChar := '*';
end;

end.
