﻿unit CreateAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Imaging.pngimage,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, DateUtils, System.JSON, System.IOUtils,
  System.Win.TaskbarCore, Vcl.Taskbar, System.RegularExpressions, StrUtils,
  Vcl.Skia, emailUI;

type
  User = class
    Vorname: string;
    Nachname: string;
    email: string;
    pwd: string;
    dob: TDate;
  private

  public
    function ToJSON: TJSONObject;
  end;

  TForm1 = class(TForm)
    EditVorname: TEdit;
    EditNachname: TEdit;
    EditEmail: TEdit;
    EditPassword: TEdit;
    EditPasswordRepeat: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelSecurityQuestion1: TLabel;
    LabelSecurityQuestion2: TLabel;
    LabelSecurityQuestion3: TLabel;
    LabelSecurityQuestion4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ImageBrand_email: TImage;
    Button4: TButton;
    ImageCaptcha: TImage;
    EditCaptcha: TEdit;
    Button5: TButton;
    Label5: TLabel;
    Button6: TButton;
    DateTimePickerBirthday: TDateTimePicker;
    Label6: TLabel;
    ImageBrand_Gmail: TImage;
    ImageBrand_Outlook: TImage;
    ImageBrand_GMX: TImage;
    ImageBrand_IServ: TImage;
    LabelSecondPWIsCorrect: TLabel;
    LabelDOBIsFits: TLabel;
    function CreateEmailBasedName(Vorname: string; Nachname: string;
      ServiceAdress: string): string;
    procedure CheckEmail(email: String);
    procedure HideAllPic();
    procedure ShowLogo(email: String);
    procedure CheckPassword(Password: string);
    procedure SecondPwrdIsCorrect(Pwrd1: string; Pwrd2: string);
    procedure GenerateNewCaptcha();
    procedure CheckBirthday(BDay: TDate);
    procedure CheckAllowToLogin();
    procedure EditEmailChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4MouseEnter(Sender: TObject);
    procedure Button4MouseLeave(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
    procedure EditPasswordRepeatChange(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  EmailCorrect, PwrdCorrect, Sec8Characters, SecHasUpper, SecHasLower,
    SecHasDigit, SecHasSpecial, PwrdIsBothCorrect, CaptcherCorrect, OldEnough,
    AllowToLogin: Boolean;
  CaptchaCode: String;

const
  MindestAlter = 16;

implementation

{$R *.dfm}

function User.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('Vorname', Vorname);
    Result.AddPair('Nachname', Nachname);
    Result.AddPair('email', email);
    Result.AddPair('pwd', pwd);
    Result.AddPair('dob', DateToStr(dob));
  except
    FreeAndNil(Result); // Falls Fehler auftreten, wird das Objekt gelöscht
    raise;
  end;
end;


function ReadJSONFromFile(const FileName: string): TJSONObject;
var
  JSONString: string;
begin
  Result := nil;
  try
    JSONString := TFile.ReadAllText(FileName);
    Result := TJSONObject.ParseJSONValue(JSONString) as TJSONObject;
    if not Assigned(Result) then
      raise Exception.Create('Fehler beim Parsen der JSON-Datei.');
  except
    on E: Exception do
      ShowMessage('Fehler beim Laden der JSON-Datei: ' + E.Message);
  end;
end;

procedure WriteJSONToFile(const FileName: string; JSONData: TJSONObject);
begin
  // JSON-Objekt in einen String umwandeln und in eine Datei speichern
  TFile.WriteAllText(FileName, JSONData.ToString);
end;

function NormalizeEmail(email: String): String;
begin
  email := StringReplace(email, 'ä', 'ae', [rfReplaceAll, rfIgnoreCase]);
  email := StringReplace(email, 'ö', 'oe', [rfReplaceAll, rfIgnoreCase]);
  email := StringReplace(email, 'ü', 'ue', [rfReplaceAll, rfIgnoreCase]);
  email := StringReplace(email, 'ß', 'ss', [rfReplaceAll, rfIgnoreCase]);
  email := StringReplace(email, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  Result := email;
end;

function TForm1.CreateEmailBasedName(Vorname: string; Nachname: string;
  ServiceAdress: string): string;
begin
  if (Vorname = EmptyStr) or (Nachname = EmptyStr) then
    Exit;
  Result := Vorname + '.' + Nachname + '@' + ServiceAdress;
  Result := NormalizeEmail(Result);
end;

procedure TForm1.CheckEmail(email: String);
var
  Regex: TRegEx;
begin
  if email = EmptyStr then
    Exit;
  NormalizeEmail(email);

  // wenn die email ein ä.ö,ü enthält
  Regex := TRegEx.Create
    ('^[a-zA-Z0-9]+([._%+-][a-zA-Z0-9]+)*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    [TRegExOption.roIgnoreCase]);
  try
    if Regex.IsMatch(email) then
      EmailCorrect := true
    else
      EmailCorrect := false;
  except
    on E: Exception do
      ShowMessage('Regex-Fehler: ' + E.Message);
  end;
  ShowLogo(email)
end;

procedure TForm1.HideAllPic();
begin
  ImageBrand_email.Visible := false;
  ImageBrand_Gmail.Visible := false;
  ImageBrand_Outlook.Visible := false;
  ImageBrand_GMX.Visible := false;
  ImageBrand_IServ.Visible := false;
end;

procedure TForm1.ShowLogo(email: String);
var
  Domain: String;
begin
  HideAllPic();
  Domain := Copy(email, Pos('@', email) + 1, Length(email));

  if LowerCase(Domain) = 'gmail.com' then
    ImageBrand_Gmail.Visible := true
  else if (LowerCase(Domain) = 'outlook.com') or
    (LowerCase(Domain) = 'outlook.de') then
    ImageBrand_Outlook.Visible := true
  else if LowerCase(Domain) = 'gmx.de' then
    ImageBrand_GMX.Visible := true
  else if LowerCase(Domain) = 'herder.ndh-schule.de' then
    ImageBrand_IServ.Visible := true
  else
    ImageBrand_email.Visible := true;
end;

procedure TForm1.CheckPassword(Password: string);
var
  i: Integer;
const
  SpecialChars = '!@#$%^&*()-_=+[]{}|;:,.<>?/';
begin
  if Password = EmptyStr then
    Exit;
  // Zurücksetzen der Variablen
  Sec8Characters := Length(Password) >= 8;
  SecHasUpper := false;
  SecHasLower := false;
  SecHasDigit := false;
  SecHasSpecial := false;

  // Durchlaufe alle Zeichen des Passworts
  for i := 1 to Length(Password) do
  begin
    case Password[i] of
      'A' .. 'Z':
        SecHasUpper := true;
      'a' .. 'z':
        SecHasLower := true;
      '0' .. '9':
        SecHasDigit := true;
    else
      if Pos(Password[i], SpecialChars) > 0 then
        SecHasSpecial := true;
    end;

    // Falls alle Bedingungen erfüllt sind, Schleife beenden
    if SecHasUpper and SecHasLower and SecHasDigit and SecHasSpecial then
      Break;
  end;
end;

procedure TForm1.SecondPwrdIsCorrect(Pwrd1: string; Pwrd2: string);
begin
  if (Pwrd1 = EmptyStr) or (Pwrd2 = EmptyStr) then
    Exit;
  if (Pwrd1 = Pwrd2) then
  begin
    PwrdIsBothCorrect := true;
    LabelSecondPWIsCorrect.Font.Color := clGreen;
    LabelSecondPWIsCorrect.Caption := '✔'
  end
  else begin
    PwrdIsBothCorrect := false;
    LabelSecondPWIsCorrect.Font.Color := clRed;
    LabelSecondPWIsCorrect.Caption := '❌'
  end;

end;

procedure GenerateCaptcha(CaptchaText: String; Image: TImage);
var
  Bitmap: TBitmap;
  i: Integer;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := 200;
    Bitmap.Height := 200;
    Bitmap.Canvas.Brush.Color := clWhite;
    Bitmap.Canvas.FillRect(Rect(0, 0, Bitmap.Width, Bitmap.Height));

    // Captcha-Text hinzufügen
    Bitmap.Canvas.Font.Size := 24;
    Bitmap.Canvas.Font.Color := clBlack;
    Bitmap.Canvas.TextOut(50, 10, CaptchaText);

    // Verzerrungslinien hinzufügen
    for i := 1 to 120 do
    begin
      Bitmap.Canvas.Pen.Color := RGB(Random(255), Random(255), Random(255));
      Bitmap.Canvas.MoveTo(Random(Bitmap.Width), Random(Bitmap.Height));
      Bitmap.Canvas.LineTo(Random(Bitmap.Width), Random(Bitmap.Height));
    end;

    // Bild in TImage laden
    Image.Picture.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TForm1.GenerateNewCaptcha;
begin
  CaptchaCode := IntToStr(Random(9000) + 1000); // Zufällige 4-stellige Zahl
  GenerateCaptcha(CaptchaCode, ImageCaptcha);
end;

procedure TForm1.CheckBirthday(BDay: TDate);
begin
  // birthday check
  if YearsBetween(BDay, Now) >= MindestAlter then
  begin
    OldEnough := true;
    LabelDOBIsFits.Font.Color := clGreen;
    LabelDOBIsFits.Caption := '✔'
  end
  else
  begin
    OldEnough := false;
    LabelDOBIsFits.Font.Color := clRed;
    LabelDOBIsFits.Caption := '❌'
  end;

end;

procedure TForm1.CheckAllowToLogin();
begin
  CheckEmail(EditEmail.Text);
  CheckPassword(EditPassword.Text);
  SecondPwrdIsCorrect(EditPassword.Text, EditPasswordRepeat.Text);
  CheckBirthday(DateTimePickerBirthday.Date);

  Button2.Enabled := EmailCorrect and PwrdCorrect and PwrdIsBothCorrect and
    CaptcherCorrect and OldEnough;

  // Debugging-Nachricht
  { ShowMessage('Status: ' + 'email: ' + EmailCorrect.ToString() + ' PwrdCorret: '
    + PwrdCorrect.ToString() + ' PwrdIsBothCorrect: ' +
    PwrdIsBothCorrect.ToString() + ' CaptcherCorrect: ' +
    CaptcherCorrect.ToString()); }
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Vorname, Nachname: string;
begin
  EditEmail.Text := CreateEmailBasedName(EditVorname.Text, EditNachname.Text,
    'email.de')
end;

procedure TForm1.EditEmailChange(Sender: TObject);
begin
  // Code für das Symbol
  CheckEmail(EditEmail.Text);
end;

procedure TForm1.EditPasswordChange(Sender: TObject);
begin
  CheckPassword(EditPassword.Text);

  case Sec8Characters of
    true:
      begin
        LabelSecurityQuestion1.Font.Color := clGreen;
        LabelSecurityQuestion1.Caption :=
          '✅ Passwort muss mindestens 8 Zeichen haben.';
      end;
    false:
      begin
        LabelSecurityQuestion1.Font.Color := clRed;
        LabelSecurityQuestion1.Caption :=
          '❎ Passwort muss mindestens 8 Zeichen haben.';
      end;
  end;

  case SecHasUpper and SecHasLower of
    true:
      begin
        LabelSecurityQuestion2.Font.Color := clGreen;
        LabelSecurityQuestion2.Caption :=
          '✅ Passwort muss GROSS- und kleinbuchstaben enthalten.';
      end;
    false:
      begin
        LabelSecurityQuestion2.Font.Color := clRed;
        LabelSecurityQuestion2.Caption :=
          '❎ Passwort muss GROSS- und kleinbuchstaben enthalten.';
      end;
  end;

  case SecHasDigit of
    true:
      begin
        LabelSecurityQuestion3.Font.Color := clGreen;
        LabelSecurityQuestion3.Caption :=
          '✅ Passwort muss mindestens eine Zahl enthalten.';
      end;
    false:
      begin
        LabelSecurityQuestion3.Font.Color := clRed;
        LabelSecurityQuestion3.Caption :=
          '❎ Passwort muss mindestens eine Zahl enthalten.';
      end;
  end;

  case SecHasSpecial of
    true:
      begin
        LabelSecurityQuestion4.Font.Color := clGreen;
        LabelSecurityQuestion4.Caption :=
          '✅ Passwort muss mindestens ein Sonderzeichen enthalten.';
      end;
    false:
      begin
        LabelSecurityQuestion4.Font.Color := clRed;
        LabelSecurityQuestion4.Caption :=
          '❎ Passwort muss mindestens ein Sonderzeichen enthalten.';
      end;
  end;
  if (Sec8Characters and SecHasUpper and SecHasLower and SecHasDigit and
    SecHasSpecial) then
    PwrdCorrect := true
  else
    PwrdCorrect := false;

  CheckAllowToLogin();
end;

procedure TForm1.EditPasswordRepeatChange(Sender: TObject);
begin
  CheckAllowToLogin();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GenerateNewCaptcha();
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  NewUser: User;
  UsersJSON: TJSONObject;
  UserArray: TJSONArray;
  UserObject: TJSONObject;
  i: Integer;
begin
  // Benutzerobjekt erstellen
  NewUser := User.Create;
  NewUser.Vorname := EditVorname.Text;
  NewUser.Nachname := EditNachname.Text;
  NewUser.email := LowerCase(EditEmail.Text);
  NewUser.pwd := EditPassword.Text;
  NewUser.dob := DateTimePickerBirthday.Date;

  try
    if FileExists('users.json') then
      UsersJSON := ReadJSONFromFile('users.json')
    else
      UsersJSON := TJSONObject.Create;

    if Assigned(UsersJSON) then
    begin
      UserArray := UsersJSON.GetValue('users') as TJSONArray;
      if not Assigned(UserArray) then
      begin
        UserArray := TJSONArray.Create;
        UsersJSON.AddPair('users', UserArray);
      end;
      UserArray.AddElement(NewUser.ToJSON);
      WriteJSONToFile('users.json', UsersJSON);
      ShowMessage('Benutzer erfolgreich erstellt!');


      // Benutzeranmeldeinformationen überprüfen
    for i := 0 to UserArray.Count - 1 do
    begin
      UserObject := UserArray.Items[i] as TJSONObject;
      if (UserObject.GetValue('email').Value = EditEmail.Text) and
        (UserObject.GetValue('pwd').Value = EditPassword.Text) then
      // Beachte: Passwörter niemals unverschlüsselt speichern!
      begin
        ShowMessage('Anmeldung erfolgreich!');
        // Neues Formular öffnen und Daten übergeben
        Form4 := TForm4.Create(Self);
        Form4.LoadUserData(UserObject);
        Form4.ShowModal;
        Form4.Free;
        ModalResult := mrOK; // Formular schließen
        Self.Close;
        Exit;
      end;
    end;
    end;
  finally
    NewUser.Free;
    if Assigned(UsersJSON) then
      UsersJSON.Free;
  end;
end;


procedure TForm1.Button3Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm1.Button4MouseEnter(Sender: TObject);
begin
  // Pw visable
  EditPassword.PasswordChar := #0;
end;

procedure TForm1.Button4MouseLeave(Sender: TObject);
begin
  // pw invisble
  EditPassword.PasswordChar := '*';
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if EditCaptcha.Text = CaptchaCode then
    // true
    CaptcherCorrect := true
  else
    // else
    ShowMessage('❌ Captcha falsch! Bitte erneut versuchen.');

  CheckAllowToLogin();
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  GenerateNewCaptcha();
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  CheckEmail(EditEmail.Text);
end;

end.
