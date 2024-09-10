unit MainForm;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuFileOpen: TMenuItem;
    MenuFileExit: TMenuItem;
    Separator1: TMenuItem;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuFileExitClick(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  BinarySource : Array[0..2048] of byte;
  ByteCount : LongInt;

implementation

{$R *.lfm}

{ TForm1 }

procedure DumpAll;
var
  i : integer;
  s : string;
begin
  Form1.Memo1.Append('--- DUMP ---');
  for i := 0 to ByteCount-1 do
  begin
    s := (i).ToHexString(4)+': '+Ord(BinarySource[i]).ToHexString(2);
    Form1.Memo1.Append(s);
  end;
  s := '--- '+ByteCount.ToString+' Bytes Dumped ---';
  Form1.Memo1.Append(s);
end;

procedure LoadFile(FileName : String);
var
  s : string;
  f : file;
begin
  S := '';
  FillChar(BinarySource,2048,0);
  s := 'File Load: '+FileName;
  Form1.Memo1.Append(s);
  Assign(F,FileName);
  Reset(F,1);
  BlockRead(F,BinarySource,2048,ByteCount);
  Close(F);
  s := ByteCount.ToString + ' bytes loaded';
  Form1.Memo1.Append(s);
  DumpAll;
end;

procedure TForm1.MenuOpenClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuHelpAboutClick(Sender: TObject);
begin
  ShowMessage('Resource21 - an 8021 disassembler');
end;

procedure TForm1.MenuFileExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuFileOpenClick(Sender: TObject);
begin
  If OpenDialog1.Execute then
  begin
    StatusBar1.Panels[0].Text:='SRC: '+OpenDialog1.FileName;
    LoadFile(OpenDialog1.FileName);
  end
  else
    StatusBar1.Panels[0].Text:='SRC: No File';
end;

end.

