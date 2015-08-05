program ClipIt;

uses
  Vcl.Forms,
  uSetting in 'uSetting.pas' {frmSetting},
  uTClipStack in 'uTClipStack.pas',
  uRegistry in 'uRegistry.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmSetting, frmSetting);
  Application.Run;
end.
