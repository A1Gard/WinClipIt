unit uTClipStack;

interface

type
  // record of clipborad values
  Clip = record
    Title: String;
    Content: WideString;
  end;

  TClz = array of Clip;

type
  TClipStack = Class
    // These variables and methods are not visible outside this class
    // They are purely used in the implementation below
    // Note that variables are all prefixed bt '_'. This allows us, for example
    // to use 'WordCount' as the property name - properties cannot use the same
    // name as a variable.
  private
    _Count: Cardinal; // The string passed to the constructor
    _mArray: TClz;
    _Seek: Cardinal;
    _Max: Cardinal;

    
  _LAST_FILE : string;

    // These methods and properties are all usable by instances of the class

    procedure _CopyData(source: TClz; var destination: TClz);

  published
    // Called when creating an instance (object) from this class
    // The passed string is the one that is operated on by the methods below
    constructor Create(Max: Cardinal);

    procedure ToArray(var ArrIn: TClz);

    procedure Push(Input: Clip);

    procedure Sync(Input: Clip);

    function Pop: Clip;

    procedure ReSeek();

    procedure Clear();



    function Read(var Output: Clip): Boolean;

    function SaveToFile(fName: string): Boolean;
    function LoadFromFile(fName: string): Boolean;
    // The string itself - allow it to be read and overwritten
    { property Text : String
      read stText
      write SetText;    // We call a method to do this }

    property Count: Cardinal read _Count;

    property Item: TClz read _mArray;

  end;

implementation

uses System.Classes, System.SysUtils, Vcl.Dialogs,Vcl.Forms;

constructor TClipStack.Create(Max: Cardinal);
begin
  _Count := 0;
  _Max := Max;
end;

procedure TClipStack.Push(Input: Clip);
begin
  Inc(_Count);
  SetLength(_mArray, _Count);
  _mArray[_Count - 1] := Input;
  ReSeek;
end;

function TClipStack.Pop;
begin
  Dec(_Count);
  Result := _mArray[_Count];
  SetLength(_mArray, _Count);
  ReSeek;
end;

procedure TClipStack.ToArray(var ArrIn: TClz);
begin
  _CopyData(_mArray, ArrIn);
end;

procedure TClipStack.ReSeek;
begin
  _Seek := _Count;
end;

function TClipStack.Read(var Output: Clip): Boolean;
begin
  Result := False;
  if _Seek > 0 then
  begin
    Output := _mArray[_Seek - 1];
    Dec(_Seek);
    Result := True;
  end;
end;

procedure TClipStack._CopyData(source: TClz; var destination: TClz);
var
  I: Integer;
  tmp: Clip;
begin
  SetLength(destination, Length(source));
  for I := Low(source) to High(source) do
  begin
    tmp := source[I];
    destination[I] := tmp;
  end;
end;

procedure TClipStack.Sync(Input: Clip);
var
  syncArr: TClz;
  I: Integer;
  Find: Boolean;
  Index: Cardinal;
  tmp: WideString;

begin
  if _Count = 0 then
  begin
    Push(Input);
    Exit;
  end;
  _CopyData(_mArray, syncArr);
  Find := False;
  for I := Low(syncArr) to High(syncArr) do
  begin
    if syncArr[I].Content = Input.Content then
    begin
      Find := True;
      Index := I;
    end;
  end;
  if Find then
  begin
    for I := Index to High(syncArr) - 1 do
    begin
      _mArray[I] := syncArr[I + 1];
    end;
    _mArray[_Count - 1] := Input;
  end
  else
  begin
    if _Max > _Count then
    begin
      Push(Input);
      Exit;
    end;
    for I := Low(syncArr) to High(syncArr) - 1 do
    begin
      _mArray[I] := syncArr[I + 1];
    end;
    _mArray[_Count - 1] := Input;
  end;

end;

function TClipStack.SaveToFile(fName: string): Boolean;
type
  Title = array [00 .. 255] of WideChar;
var
  fh: file of Title;
  I: Integer;
  St: TStringList;
  tmp: Title;
begin
  _LAST_FILE := fName;
  AssignFile(fh, fName);
  Rewrite(fh);
  St := TStringList.Create;
  for I := Low(_mArray) to High(_mArray) do
  begin
    StringToWideChar(_mArray[I].Title, @tmp, 255);
    Write(fh, tmp);
    St.Text := _mArray[I].Content;
    St.SaveToFile(ExtractFilePath(Application.ExeName)+'store/' + IntToStr(I) + '__.con', TEncoding.UTF8);
    // ShowMessage(IntToStr(I) + '__.con');
  end;
  CloseFile(fh);
end;

function TClipStack.LoadFromFile(fName: string): Boolean;
type
  Title = array [00 .. 255] of WideChar;
var
  fh: file of Title;
  I: Integer;
  ste: Title;
  sclp: Clip;
  St: TStringList;
begin
  _LAST_FILE := fName;
  try
    AssignFile(fh, fName);
    Reset(fh);
  except
    Exit;
  end;
  St := TStringList.Create;
  I := 0;
  try
    while not Eof(fh) do
    begin
      System.Read(fh, ste);
      sclp.Title := ste;
      try
        St.LoadFromFile( ExtractFilePath(Application.ExeName)+'store/' + IntToStr(I) + '__.con', TEncoding.UTF8);
        sclp.Content := TrimRight(St.Text);
      except
        sclp.Content := 'Saved clipboard was defunct.';
      end;
      Sync(sclp);
      Inc(I);
    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Beep;
    end;
  end;
  CloseFile(fh);
end;
procedure TClipStack.Clear;
var
    St: TStringList;
begin
  St := TStringList.Create;
  St.Clear;
  St.SaveToFile(_LAST_FILE);
  //St.LoadFromFile(_LAST_FILE);
  St.Free;
end;

end.
