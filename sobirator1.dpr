program sobirator1;

uses
  Vcl.Forms,
  Unit1sobirator in 'Unit1sobirator.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
