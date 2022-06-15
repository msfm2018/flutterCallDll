library abc;

uses
  System.SysUtils,
  Winapi.Windows,
  vcl.Dialogs,
  Vcl.Forms,
  System.Classes,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}
function MyThreadFun(): Integer; stdcall;
begin
  if Form1 = nil then
    Form1 := tform1.Create(nil);
  Form1.ShowModal;
  Result := 0;
end;

procedure DLLEntryInit(fdwReason: DWord);
var
  Id: Dword;
begin
  case (fdwReason) of
    DLL_PROCESS_ATTACH:
      begin
        Createthread(nil, 0, @MyThreadFun, 0, 0, Id);

      end;
    DLL_PROCESS_DETACH:
      ;
    DLL_THREAD_ATTACH:
      ;
    DLL_THREAD_DETACH:
      ;
  end;
end;

procedure setCaption(i, j: Integer; info: PansiChar); stdcall;
begin

  var xxv := Utf8String(info);
  if form1 = nil then
    ShowMessage(xxv)
  else
    form1.Caption := xxv;

end;


function retString(i, j: Integer; info: PansiChar): pansichar; stdcall;
var
  p: pansichar;
  str: string;
begin

  var xxv := Utf8String(info);

  Form1.caption := xxv;
  str := 'delphi返回消息：' + DateTimeToStr(now)+' '+xxv;
  result := PAnsiChar(AnsiToUtf8(str));

end;

exports
  setCaption,
  retString;

begin
//直接显示 窗口
  DllProc := @DLLEntryInit;
  DLLEntryInit(DLL_PROCESS_ATTACH);
end.

