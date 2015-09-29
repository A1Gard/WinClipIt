program ClipIt;

uses
  Vcl.Forms,Windows,
  uSetting in 'uSetting.pas' {frmSetting},
  uTClipStack in 'uTClipStack.pas',
  uRegistry in 'uRegistry.pas';


var
  // for one intance app
  Mutex : THandle;

{$R *.res}

begin
  Mutex := CreateMutex(nil, True, 'WinClipit');
  if (Mutex <> 0) and (GetLastError = 0) then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.ShowMainForm := False;
    Application.CreateForm(TfrmSetting, frmSetting);
    Application.Run;
    if Mutex <> 0 then
      CloseHandle(Mutex);
  end;

end.
