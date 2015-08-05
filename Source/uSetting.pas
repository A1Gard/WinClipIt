unit uSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections, uTClipStack,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.Clipbrd,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ComCtrls,shellapi;

type
  TfrmSetting = class(TForm)
    trycn1: TTrayIcon;
    pmNotif: TPopupMenu;
    N1: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    Exit1: TMenuItem;
    tmrclipb: TTimer;
    OfflinetheClipIt1: TMenuItem;
    tmrSave: TTimer;
    Clear1: TMenuItem;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    seMax: TSpinEdit;
    chkStartUP: TCheckBox;
    lbl4: TLabel;
    seChar: TSpinEdit;
    lbl5: TLabel;
    btnSave: TBitBtn;
    btnCansel: TBitBtn;
    chkPasteOnSelect: TCheckBox;
    hk1: THotKey;
    procedure Exit1Click(Sender: TObject);
    procedure tmrclipbTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OfflinetheClipIt1Click(Sender: TObject);
    procedure tmrSaveTimer(Sender: TObject);
    procedure trycn1Click(Sender: TObject);
    procedure btnCanselClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure About2Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
  private
    { Private declarations }

    procedure UpdateMenu();
    procedure HandlePopupItem(Sender: TObject);
    procedure PasteLastFocosed();
    procedure FindLastFocused;

  public
    { Public declarations }
    MaxItem,MaxChar: Integer;
    PasteOnSel : Boolean;
  end;

var
  frmSetting: TfrmSetting;
  // clipborad controller
  CB: TClipboard;
  // aStack clipbread
  ClipStack: TClipStack;
  // Sort : array of byte;
  // last clip borad content
  lastCBText: WideString;

  lastFocused :HWND;

  lastAactiveWin: HWND;

  MaxItem,MaxChar: Integer;

implementation

{$R *.dfm}

uses uRegistry;


procedure TfrmSetting.FindLastFocused;
var
  Handle: THandle;
  Len: LongInt;
  Title,cap: string;

begin
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    Len := GetWindowTextLength(Handle) + 1;
    SetLength(Title, Len);
    GetWindowText(Handle, PChar(Title), Len);
    cap := Trim(Title);
    if Length(cap) > 1 then
    begin
      lastAactiveWin := Handle;
    end;
  end;
end;

procedure TfrmSetting.PasteLastFocosed();
var
  hOtherWin,OtherThreadID,hFocusWin: HWND;
  a : Word     ;
begin
 hOtherWin := GetForegroundWindow;

  OtherThreadID := GetWindowThreadProcessID( hOtherWin,@a);
  //mmo1.Lines.Add(ActiveCaption);
  If AttachThreadInput( GetCurrentThreadID, OtherThreadID, True ) Then
  Begin
    hFocusWin := GetFocus;
    If hFocusWin <> 0 Then
    try
      SendMessage(hFocusWin, WM_PASTE, 1, 0);
    finally
      AttachThreadInput( GetCurrentThreadID, OtherThreadID, False );
    end;
  End;
end;
function XTrim(InStr: string): string;
begin
  result := Trim(StringReplace(Trim(InStr), '&', '', [rfReplaceAll]));
end;

procedure TfrmSetting.HandlePopupItem(Sender: TObject);
var
  tmp: string;
  I: Integer;
  ah: HWND;
begin
  tmp := TMenuItem(Sender).Caption;
  for I := Low(ClipStack.Item) to High(ClipStack.Item) do
  begin
    // ShowMessage(xTrim(ClipStack.Item[i].Title) +'|' +xTrim(tmp));
    if XTrim(ClipStack.Item[I].Title) = XTrim(tmp) then
    begin;
      try
        CB.AsText := ClipStack.Item[I].Content;
        if PasteOnSel then
        begin
          SetForegroundWindow(lastAactiveWin);
          Sleep(100);
          PasteLastFocosed;
        end;
      except

      end;
    end;
  end;

end;

procedure TfrmSetting.UpdateMenu;
var
  Item: TMenuItem;
  singleClip: Clip;
  I: Integer;
  tmp: string;
begin
  // tmpStack := TStack<Clip>.Create;
  for I := pmNotif.Items.Count downto 7 do
  begin
    pmNotif.Items.Delete(0);
  end;

  ClipStack.ReSeek;
  I := 0;
  while ClipStack.Read(singleClip) do
  begin
    Item := TMenuItem.Create(pmNotif);
    tmp := singleClip.Title;
    // tmp := UTF8Encode(tmp);
    // ShowMessage(tmp);
    Item.Caption := '&' + tmp;
    // insert
    pmNotif.Items.Insert(I, Item);
    Item.OnClick := HandlePopupItem;
    Inc(I);
  end;

end;

procedure TfrmSetting.About1Click(Sender: TObject);
begin
  // show setting form
  frmSetting.Show;
end;

procedure TfrmSetting.About2Click(Sender: TObject);
begin
  ShellAboutW(Handle,'WinClipit v0.1 - GPL v2',
  'Code by : A1Gard'+#13#10+'github: https://github.com/A1Gard/WinClipIt',
  Application.Icon.Handle);
end;

procedure TfrmSetting.btnCanselClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmSetting.btnSaveClick(Sender: TObject);
begin
  SetValue('Max',IntToStr(seMax.Value));
  SetValue('Char',IntToStr(seChar.Value));
  MaxChar := seChar.Value;
  MaxItem := seMax.Value;
  if chkPasteOnSelect.Checked then
  begin
    SetValue('PasteOnSelect','true');
  end
  else
  begin
    SetValue('PasteOnSelect','false');
  end;
  if chkStartUP.Checked then
  begin
    SetStartUp(Application.ExeName);
  end
  else
  begin
    UnsetStartUP(Application.ExeName);
  end;
  PasteOnSel := chkPasteOnSelect.Checked;
  Close;
end;

procedure TfrmSetting.Clear1Click(Sender: TObject);
begin
  tmrSave.Enabled := False;
  ClipStack.Clear;
  ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil, SW_SHOWNORMAL);
  Application.Terminate; // or, if this is the main form, simply Close;
end;

procedure TfrmSetting.Exit1Click(Sender: TObject);
begin
  // exit app
  Application.Terminate;
end;

procedure TfrmSetting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // free used resouces
  CB.Free;
end;

procedure TfrmSetting.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // hjide setting form
  Self.Hide;
  CanClose := false;
end;

procedure TfrmSetting.FormCreate(Sender: TObject);
var
  tmp : string;
begin

  // load config
  MaxItem := StrToIntDef(GetValue('Max'),10);
  MaxChar := StrToIntDef(GetValue('Char'),20);
  tmp := GetValue('PasteOnSelect');
  if tmp = 'true' then
  begin
    PasteOnSel := True;
  end
  else
  begin
    PasteOnSel := False;
  end;
  // initilaze app bootstrap
  CB := TClipboard.Create;
  ClipStack := TClipStack.Create(MaxItem);
  ClipStack.LoadFromFile(ExtractFilePath(Application.ExeName) + 'store/title.dat');
  try
    lastCBText := ClipStack.Item[ClipStack.Count - 1].Content;
  except
    lastCBText := '';
  end;
  // ShowMessage(lastCBText);
  UpdateMenu;
end;

procedure TfrmSetting.FormShow(Sender: TObject);
begin
  seMax.Value := MaxItem;
  seChar.Value := MaxChar;
  chkPasteOnSelect.Checked := PasteOnSel;
  chkStartUP.Checked := IsStartUp(Application.ExeName);
end;

procedure TfrmSetting.OfflinetheClipIt1Click(Sender: TObject);
begin
  // chnage info ;
  OfflinetheClipIt1.Checked := not OfflinetheClipIt1.Checked;
  // set timer by offline status
  tmrSave.OnTimer(frmSetting);
  tmrclipb.Enabled := not OfflinetheClipIt1.Checked;
  tmrSave.Enabled := not OfflinetheClipIt1.Checked;
end;

(* *
  *  note: this is main procedure
  *  do: timer check clipborader and control the app menu
  *  result : null
  * *)
procedure TfrmSetting.tmrclipbTimer(Sender: TObject);
var
  singleClip: Clip;
  a, b: WideString;
begin
  try
    FindLastFocused;
    // a := lastCBText;
    // b := CB.AsText;
    // check if clipborad conetent chnage and not null
    if ((lastCBText <> CB.AsText) and (CB.AsText <> '')) then
    begin
      // save last clipboard content
      lastCBText := CB.AsText;
      // add to head of menu
      // set title ;
      if Length(lastCBText) < MaxChar then
      begin
        singleClip.Title := lastCBText;
      end
      else
      begin
        singleClip.Title := Copy(lastCBText, 0, MaxChar) + '...';
      end;
      // ShowMessage(lastCBText);
      singleClip.Content := lastCBText;
      ClipStack.Sync(singleClip);
      UpdateMenu;
    end;
  except
  end;
end;

procedure TfrmSetting.tmrSaveTimer(Sender: TObject);
begin
  ClipStack.SaveToFile(ExtractFilePath(Application.ExeName) + 'store/title.dat');
end;

procedure TfrmSetting.trycn1Click(Sender: TObject);
begin
  pmNotif.Popup(Mouse.CursorPos.X, Mouse.CursorPos.y+20);
end;

end.
