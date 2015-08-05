object frmSetting: TfrmSetting
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Win Clipit v0.1 setting'
  ClientHeight = 343
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 24
    Top = 8
    Width = 157
    Height = 33
    Caption = 'Win Clipit 0.1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 168
    Top = 47
    Width = 49
    Height = 19
    Caption = 'Setting'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 24
    Top = 88
    Width = 108
    Height = 13
    Caption = 'Max save clipedboard:'
  end
  object lbl4: TLabel
    Left = 24
    Top = 135
    Width = 146
    Height = 13
    Caption = 'Max charecter length in menu:'
  end
  object lbl5: TLabel
    Left = 24
    Top = 184
    Width = 97
    Height = 13
    Caption = 'HotKey Show menu:'
    Visible = False
  end
  object seMax: TSpinEdit
    Left = 88
    Top = 107
    Width = 182
    Height = 22
    MaxLength = 2
    MaxValue = 40
    MinValue = 5
    TabOrder = 0
    Value = 10
  end
  object chkStartUP: TCheckBox
    Left = 24
    Top = 228
    Width = 246
    Height = 17
    Caption = 'Application startup windows'
    TabOrder = 1
  end
  object seChar: TSpinEdit
    Left = 88
    Top = 154
    Width = 182
    Height = 22
    MaxLength = 2
    MaxValue = 45
    MinValue = 10
    TabOrder = 2
    Value = 10
  end
  object btnSave: TBitBtn
    Left = 138
    Top = 305
    Width = 132
    Height = 25
    Caption = 'Save'
    Default = True
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnCansel: TBitBtn
    Left = 24
    Top = 305
    Width = 108
    Height = 25
    Caption = 'Cansel'
    TabOrder = 4
    OnClick = btnCanselClick
  end
  object chkPasteOnSelect: TCheckBox
    Left = 24
    Top = 264
    Width = 246
    Height = 17
    Caption = 'Paste On Select item'
    TabOrder = 5
  end
  object hk1: THotKey
    Left = 88
    Top = 203
    Width = 182
    Height = 19
    HotKey = 24699
    Modifiers = [hkShift, hkCtrl]
    TabOrder = 6
    Visible = False
  end
  object trycn1: TTrayIcon
    PopupMenu = pmNotif
    Visible = True
    OnClick = trycn1Click
    Left = 128
    Top = 48
  end
  object pmNotif: TPopupMenu
    Left = 64
    Top = 48
    object N1: TMenuItem
      Caption = '-'
    end
    object OfflinetheClipIt1: TMenuItem
      Caption = 'Offline the ClipIt'
      OnClick = OfflinetheClipIt1Click
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
    object About1: TMenuItem
      Caption = 'Setting'
      OnClick = About1Click
    end
    object About2: TMenuItem
      Caption = 'About'
      OnClick = About2Click
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
  object tmrclipb: TTimer
    Interval = 10
    OnTimer = tmrclipbTimer
    Left = 256
    Top = 8
  end
  object tmrSave: TTimer
    Interval = 3000
    OnTimer = tmrSaveTimer
    Left = 208
    Top = 8
  end
end
