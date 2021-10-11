object Form_frmLIST: TForm_frmLIST
  Left = 213
  Top = 117
  Width = 768
  Height = 570
  Caption = 'tn'
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  WindowMenu = WindowMenu
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 169
    Height = 13
    AutoSize = False
    Caption = 'Oracle Sample Shell'
  end
  object OraSession1: TOraSession
    ConnectPrompt = False
    Server = 'poler'
    Left = 96
    Top = 72
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    SQL.Strings = (
      
        'select distinct NFORM,TABNAME FROM CONTRACTORS.FORM_DESCS WHERE ' +
        'GLCODE=3')
    Left = 128
    Top = 64
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 128
    object N9: TMenuItem
      Caption = 'Forms List'
      object N10: TMenuItem
        Caption = 'Start'
      end
    end
    object N6: TMenuItem
      Caption = 'Work Mode'
      object N18: TMenuItem
        Caption = 'Standart'
        Checked = True
        OnClick = N18Click
      end
      object N19: TMenuItem
        Caption = 'Analitic'
        OnClick = N19Click
      end
    end
    object WindowMenu: TMenuItem
      AutoCheck = True
      Caption = 'Windows'
      object N13: TMenuItem
        Caption = 'Arrange'
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 120
    Top = 152
    object TMenuItem
    end
  end
  object OraQuery2: TOraQuery
    Session = OraSession1
    Left = 128
    Top = 96
  end
end
