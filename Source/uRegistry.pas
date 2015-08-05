unit uRegistry;

interface

uses Winapi.Windows, System.Win.Registry;

function SetValue(key, value: string): Boolean;
function GetValue(key: string): string;
function IsStartUp(app:string):Boolean;
function SetStartUp(app:string):Boolean;
function UnsetStartUP(app:string):Boolean;

const
  _KEY_ = 'WinClipIt';
  APP_KEY = 'SOFTWARE\' + _KEY_;
  START_KEY = 'Software\Microsoft\Windows\CurrentVersion\Run';

  
implementation

function SetValue(key, value: string): Boolean;
var
  rg: TRegistry;
begin
  rg := TRegistry.Create;
  rg.RootKey := HKEY_CURRENT_USER;
  if rg.OpenKey(APP_KEY, true) then
  begin
    rg.WriteString(key, value);
    Result := true;
  end
  else
  begin
    Result := False;
  end;
  rg.Free;
end;

function GetValue(key: string): string;
var
  rg: TRegistry;
begin
  rg := TRegistry.Create;
  rg.RootKey := HKEY_CURRENT_USER;
  if rg.OpenKey(APP_KEY, False) then
  begin
    if rg.ValueExists(key) then
    begin
      Result := rg.ReadString(key);
    end
    else
    begin
      Result := 'null';
    end;
  end
  else
  begin
    Result := 'null';
  end;
  rg.Free;
end;


function IsStartUp(app:string):Boolean;
var
  rg: TRegistry;
begin
  rg := TRegistry.Create;
  rg.RootKey := HKEY_CURRENT_USER;
  Result := False;
  if rg.OpenKey(START_KEY, False) then
  begin
    if ((rg.ValueExists(_KEY_)) and (rg.ReadString(_KEY_) = app)) then
    begin
       Result := true;
    end;  
  end;
  rg.Free;
end;

function SetStartUp(app:string):Boolean;
var
  rg: TRegistry;
begin
  rg := TRegistry.Create;
  rg.RootKey := HKEY_CURRENT_USER;
  Result := False;
  if rg.OpenKey(START_KEY, True) then
  begin
    rg.WriteString(_KEY_,app); 
    Result := true;
  end;
  rg.Free;
end;

function UnsetStartUP(app:string):Boolean;
 var
  rg: TRegistry;
begin
  rg := TRegistry.Create;
  rg.RootKey := HKEY_CURRENT_USER;
  Result := False;
  if rg.OpenKey(START_KEY, False) then
  begin
    if rg.ValueExists(_KEY_) and (rg.ReadString(_KEY_) = app) then
    begin
      rg.DeleteValue(_KEY_);
      Result := true;
    end;
  end;
  rg.Free;
end;




end.
