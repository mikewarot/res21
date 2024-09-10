unit MainForm;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  SourceSize : LongInt;
  SourceOffset : Longint;
  unknown  : Longint;

implementation

{$R *.lfm}

{ TForm1 }

procedure Disassemble1; // disassemble the current instruction
var
  x,y : byte;
  s   : string;
begin
  S := SourceOffset.ToHexString(4)+': ';
  x := BinarySource[SourceOffset];
  y := BinarySource[SourceOffset+1];
  inc(SourceOffset);
  Case X of
    $68..$6f  : begin   //  add A,Rr
      S := S + 'ADD A,R'+(X and $07).ToHexString(1);
    end;
  else
    S := S + '$'+x.ToHexString(2);
    Inc(unknown);
  end;
  Form1.Memo1.Append(S);
end;

procedure Disassemble;
var
  s : string;
begin
  Sourceoffset := 0;
  unknown := 0;
  While SourceOffset < SourceSize do
    Disassemble1;
  If unknown <> 0 then
  begin
    S := unknown.ToString +' unknown bytes';
    Form1.Memo1.Append(S);
  end;
end;

procedure DumpAll;
var
  i : integer;
  s : string;
begin
  Form1.Memo1.Append('--- DUMP ---');
  for i := 0 to SourceSize-1 do
  begin
    s := (i).ToHexString(4)+': '+Ord(BinarySource[i]).ToHexString(2);
    Form1.Memo1.Append(s);
  end;
  s := '--- '+SourceSize.ToString+' Bytes Dumped ---';
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
  BlockRead(F,BinarySource,2048,SourceSize);
  Close(F);
  SourceOffset := 0;
  s := SourceSize.ToString + ' bytes loaded';
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  Disassemble;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FillChar(BinarySource,2048,0);
  SourceSize := 0;
  SourceOffset := 0;
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

