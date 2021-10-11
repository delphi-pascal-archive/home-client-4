object Form_frmLIST: TForm_frmLIST
  Left = 171
  Top = 48
  Width = 768
  Height = 669
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
    Left = 0
    Top = 1
    Width = 641
    Height = 611
    AutoSize = False
    Caption = 'Uni_Database_Client_Demo'
    Color = clCream
    ParentColor = False
    WordWrap = True
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 128
    object N9: TMenuItem
      Caption = 'Forms List'
      object StartItem1: TMenuItem
        Caption = 'Start Item'
      end
    end
    object N1: TMenuItem
      Caption = 'Administration'
      object N4: TMenuItem
        Caption = '-'
      end
      object N5: TMenuItem
        Caption = 'Forms Editor'
        OnClick = N5Click
      end
    end
    object WindowMenu: TMenuItem
      AutoCheck = True
      Caption = 'Windows'
      Checked = True
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
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=SAMPL' +
      'E.mdb;Mode=Share Deny None;Extended Properties="";Persist Securi' +
      'ty Info=False;Jet OLEDB:System database="";Jet OLEDB:Registry Pa' +
      'th="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet' +
      ' OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops' +
      '=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database P' +
      'assword="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encr' +
      'ypt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;' +
      'Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=Fal' +
      'se'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 72
    Top = 192
  end
  object OraQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 128
    Top = 200
  end
  object OraQuery2: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 128
    Top = 240
  end
end
