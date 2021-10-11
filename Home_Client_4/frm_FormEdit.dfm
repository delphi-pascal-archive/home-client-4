object Form_Editor: TForm_Editor
  Left = 81
  Top = 100
  Width = 925
  Height = 535
  Caption = 'Form_Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    917
    508)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 216
    Top = 478
    Width = 145
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1092#1086#1088#1084#1091
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGridEh1: TDBGridEh
    Left = 8
    Top = 24
    Width = 665
    Height = 447
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    EditActions = [geaCutEh, geaCopyEh, geaPasteEh, geaDeleteEh, geaSelectAllEh]
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    TitleHeight = 30
    OnGetCellParams = DBGridEh1GetCellParams
    Columns = <
      item
        Color = cl3DDkShadow
        EditButtons = <>
        FieldName = 'GLCODE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Footers = <>
        Width = 47
      end
      item
        EditButtons = <>
        FieldName = 'NFORM'
        Footers = <>
        Width = 39
      end
      item
        EditButtons = <>
        FieldName = 'TABNAME'
        Footers = <>
        Width = 56
      end
      item
        DropDownShowTitles = True
        DropDownSizing = True
        EditButtons = <>
        FieldName = 'FLDNAME'
        Footers = <>
        Width = 56
      end
      item
        Color = 15400938
        EditButtons = <>
        FieldName = 'IS_BOOLEAN'
        Footers = <>
        Width = 25
      end
      item
        Color = 14811135
        EditButtons = <>
        FieldName = 'BOLD'
        Footers = <>
        Width = 26
      end
      item
        Color = 15400959
        EditButtons = <
          item
            Style = ebsPlusEh
            OnClick = DBGridEh1Columns6EditButtons0Click
          end>
        FieldName = 'COLOR'
        Footers = <>
        Width = 24
      end
      item
        Color = 15269887
        EditButtons = <
          item
            Style = ebsPlusEh
            OnClick = DBGridEh1Columns7EditButtons0Click
          end>
        FieldName = 'BKCOLOR'
        Footers = <>
        Width = 22
      end
      item
        Color = 15395583
        EditButtons = <>
        FieldName = 'TOTALCODE'
        Footers = <>
        Width = 22
      end
      item
        EditButtons = <>
        FieldName = 'CAPTION'
        Footers = <>
        Width = 58
      end
      item
        EditButtons = <>
        FieldName = 'DESCRIPTION'
        Footers = <>
        Width = 23
      end
      item
        Color = 15921919
        EditButtons = <>
        FieldName = 'NFILTER'
        Footers = <>
        Width = 28
      end
      item
        Color = 16053503
        EditButtons = <>
        FieldName = 'FLAGFILTER'
        Footers = <>
        Width = 25
      end
      item
        EditButtons = <>
        FieldName = 'SHOWCODE'
        Footers = <>
        Width = 30
      end
      item
        EditButtons = <>
        FieldName = 'SHOWORDER'
        Footers = <>
        Width = 30
      end
      item
        EditButtons = <>
        FieldName = 'WIDTH'
        Footers = <>
        Width = 31
      end
      item
        Color = clInactiveCaption
        EditButtons = <>
        FieldName = 'NGROUP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Footers = <>
        Width = 40
      end
      item
        Color = clInactiveCaption
        EditButtons = <>
        FieldName = 'CAPGROUP'
        Footers = <>
        Width = 31
      end
      item
        EditButtons = <
          item
            Style = ebsPlusEh
            OnClick = DBGridEh1Columns18EditButtons0Click
          end>
        FieldName = 'BKREPORT'
        Footers = <>
        Width = 41
      end
      item
        EditButtons = <>
        FieldName = 'IS_BOOLEAN'
        Footers = <>
        Width = 21
      end
      item
        EditButtons = <>
        FieldName = 'IS_EDIT'
        Footers = <>
        Width = 27
      end>
  end
  object Edit2: TEdit
    Left = 472
    Top = 478
    Width = 121
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 2
  end
  object Button3: TButton
    Left = 448
    Top = 478
    Width = 17
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button5: TButton
    Left = 32
    Top = 0
    Width = 41
    Height = 25
    Caption = 'del'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button2: TButton
    Left = 648
    Top = 474
    Width = 265
    Height = 15
    Anchors = [akLeft, akBottom]
    Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080' '#1087#1086' '#1086#1087#1080#1089#1072#1085#1080#1102' '#1076#1083#1103' '#1092#1086#1088#1084#1099' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
    TabOrder = 5
    OnClick = Button2Click
  end
  object DBLookupListBox1: TDBLookupListBox
    Left = 680
    Top = 24
    Width = 234
    Height = 433
    Anchors = [akTop, akRight, akBottom]
    KeyField = 'NFORM'
    ListField = 'TABNAME'
    ListSource = DataSource2
    TabOrder = 6
    OnClick = DBLookupListBox1Click
  end
  object Button4: TButton
    Left = 682
    Top = 1
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Requery'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button6: TButton
    Left = 648
    Top = 490
    Width = 265
    Height = 15
    Anchors = [akLeft, akBottom]
    Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080' '#1087#1086' '#1086#1087#1080#1089#1072#1085#1080#1102' '#1092#1086#1088#1084#1099' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103
    TabOrder = 8
    OnClick = Button6Click
  end
  object DataSource1: TDataSource
    DataSet = OraTable1
    Left = 456
    Top = 296
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 408
    Top = 424
  end
  object DataSource2: TDataSource
    DataSet = OraQuery1
    Left = 648
    Top = 280
  end
  object OraTable1: TADOTable
    Connection = Form_frmLIST.ADOConnection1
    CursorType = ctStatic
    TableName = 'FORM_DESCS1'
    Left = 408
    Top = 304
    object OraTable1RECORD_ID: TAutoIncField
      FieldName = 'RECORD_ID'
      ReadOnly = True
    end
    object OraTable1GLCODE: TIntegerField
      FieldName = 'GLCODE'
    end
    object OraTable1NFORM: TIntegerField
      FieldName = 'NFORM'
    end
    object OraTable1TABNAME: TWideStringField
      FieldName = 'TABNAME'
      Size = 50
    end
    object OraTable1FLDNAME: TWideStringField
      FieldName = 'FLDNAME'
      Size = 50
    end
    object OraTable1IS_BOOLEAN: TIntegerField
      FieldName = 'IS_BOOLEAN'
    end
    object OraTable1BOLD: TIntegerField
      FieldName = 'BOLD'
    end
    object OraTable1COLOR: TIntegerField
      FieldName = 'COLOR'
    end
    object OraTable1BKCOLOR: TIntegerField
      FieldName = 'BKCOLOR'
    end
    object OraTable1TOTALCODE: TIntegerField
      FieldName = 'TOTALCODE'
    end
    object OraTable1CAPTION: TWideStringField
      FieldName = 'CAPTION'
      Size = 50
    end
    object OraTable1DESCRIPTION: TWideStringField
      FieldName = 'DESCRIPTION'
      Size = 50
    end
    object OraTable1NFILTER: TIntegerField
      FieldName = 'NFILTER'
    end
    object OraTable1FLAGFILTER: TIntegerField
      FieldName = 'FLAGFILTER'
    end
    object OraTable1SHOWCODE: TIntegerField
      FieldName = 'SHOWCODE'
    end
    object OraTable1SHOWORDER: TIntegerField
      FieldName = 'SHOWORDER'
    end
    object OraTable1WIDTH: TIntegerField
      FieldName = 'WIDTH'
    end
    object OraTable1NGROUP: TIntegerField
      FieldName = 'NGROUP'
    end
    object OraTable1CAPGROUP: TWideStringField
      FieldName = 'CAPGROUP'
      Size = 50
    end
    object OraTable1BKREPORT: TIntegerField
      FieldName = 'BKREPORT'
    end
    object OraTable1IS_EDIT: TIntegerField
      FieldName = 'IS_EDIT'
    end
  end
  object OraQuery1: TADOQuery
    Connection = Form_frmLIST.ADOConnection1
    Parameters = <>
    SQL.Strings = (
      
        'select distinct NFORM,TABNAME FROM FORM_DESCS WHERE GLCODE=3 ord' +
        'er by 2')
    Left = 680
    Top = 248
  end
end
