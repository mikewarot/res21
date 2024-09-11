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
  x : byte;
  s   : string;

  Function Y:Byte;
  begin
    Y := BinarySource[SourceOffset];
    Inc(SourceOffset);
  end;

begin
  S := SourceOffset.ToHexString(4)+': ';
  x := BinarySource[SourceOffset];
  inc(SourceOffset);
  Case X of
    $00 		: S := S + 'NOP';
    $03 		: S := S + 'ADD     A,#'+Y.ToHexString(2)+'h';
    $04,$24,$44,$64 	: S := S + 'JMP     '+ (((X SHR 5) SHL 8) + Y).ToHexString(4);
    $07                 : S := S + 'DEC     A';
    $08..$0a 		: S := S + 'IN      A,P' + (X and 3).ToHexString(1);
    $10..$11  		: S := S + 'INC     @R'  +(X and $01).ToHexString(1);
    $13 		: S := S + 'ADDC    A,#'+Y.ToHexString(2)+'h';
    $14,$34,$54,$74 	: s := S + 'CALL    '+ (((X SHR 5) SHL 8) + Y).ToHexString(4);
    $16 		: S := S + 'JTF     '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $17                 : S := S + 'INC     A';
    $18..$1f  		: S := S + 'INC     R'   +(X and $07).ToHexString(1);

    $23 		: S := S + 'MOV     A,#'+Y.ToHexString(2)+'h';
    $27                 : S := S + 'CLR     A';
    $28..$2f  		: S := S + 'XCH     A,R'   +(X and $07).ToHexString(1);
    $37                 : S := S + 'CMPL    A';

    $39                 : S := S + 'OUTL    P1,A';
    $3a                 : S := S + 'OUTL    P2,A';

    $40..$41  		: S := S + 'ORL     A,@R'  +(X and $01).ToHexString(1);
    $42                 : S := S + 'MOV     A,T';
    $43 		: S := S + 'ORL     A,#'+Y.ToHexString(2)+'h';
    $45                 : S := S + 'STRT    CNT';
    $46 		: S := S + 'JNT1    '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $47                 : S := S + 'SWAP    A';
    $48..$4f  		: S := S + 'ORL     A,R'   +(X and $07).ToHexString(1);
    $50..$51  		: S := S + 'ANL     A,@R'  +(X and $01).ToHexString(1);
    $53 		: S := S + 'ANL     A,#'+Y.ToHexString(2)+'h';
    $55                 : S := S + 'STRT    T';
    $56 		: S := S + 'JT1     '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $57                 : S := S + 'DA      A';
    $58..$5f  		: S := S + 'ANL     A,R'   +(X and $07).ToHexString(1);
    $60..$61  		: S := S + 'ADD     A,@R'  +(X and $01).ToHexString(1);
    $62                 : S := S + 'MOV     T,A';

    $65                 : S := S + 'STOP    TCNT';
    $67                 : S := S + 'RRC     A';

    $68..$6f  		: S := S + 'ADD     A,R'   +(X and $07).ToHexString(1);
    $70..$71  		: S := S + 'ADDC    A,@R' +(X and $01).ToHexString(1);
    $77                 : S := S + 'RR      A';
    $78..$7f  		: S := S + 'ADDC    A,R'  +(X and $07).ToHexString(1);
    $83                 : S := S + 'RET';

    $90                 : S := S + 'OUTL    P0,A';
    $96 		: S := S + 'JNZ     '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $97                 : S := S + 'CLR     C';
    $9c..$9f  		: S := S + 'ANLD    P' + ((X and $03)+4).ToHexString(1) + ',A';
    $a0..$a1            : S := S + 'MOV     @R'+(X AND $01).ToHexString(1)+',A';
    $a7                 : S := S + 'CPL     C';
    $a8..$af  		: S := S + 'MOV     R'+(X and $07).ToHexString(1)+',A';
    $b0..$b1            : S := S + 'MOV     @R'+(X and $01).ToHexString(1)+',#'+Y.ToHexString(2)+'h';
    $b8..$bf  		: S := S + 'MOV     R'+(X AND $07).ToHexString(1)+',#'+Y.ToHexString(2)+'h';
    $c6 		: S := S + 'JZ      '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $d0..$d1  		: S := S + 'XRL     A,@R'+(X AND $01).ToHexString(1);
    $d3                 : S := S + 'XRL     A,#'+Y.ToHexString(2)+'h';
    $d8..$df  		: S := S + 'XRL     A,R'+(X and $07).ToHexString(1);
    $e6 		: S := S + 'JNC     '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $e7                 : S := S + 'RL      A';
    $e8..$ef  		: S := S + 'DJNZ    R'+(X and $07).ToHexString(1)+','+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $f0..$f1  		: S := S + 'MOV     A,@R'+(X AND $01).ToHexString(1);
    $f6 		: S := S + 'JC      '+ (((SourceOffset-1) AND $ff00) OR Y).ToHexString(4);
    $f7                 : S := S + 'RLC     A';
    $f8..$ff  		: S := S + 'MOV     A,R' +(X and $07).ToHexString(1);
  else
    S := S + '$'+x.ToHexString(2);
    Inc(unknown);
//    S := '';
  end;
  If S <> '' then
    Form1.Memo1.Append(S);
end;

procedure Disassemble;
var
  s : string;
begin
  Sourceoffset := 0;
  unknown := 0;
  While (SourceOffset < SourceSize) AND (Unknown = 0) do
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

