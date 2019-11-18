program sobirator2;

uses
  Vcl.Forms,
  Unit2sobirator in 'Unit2sobirator.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
