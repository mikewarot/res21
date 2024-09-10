program Resource21;
uses
  Forms, Interfaces, MainForm;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Resource21 - 8021 Disassembler';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

