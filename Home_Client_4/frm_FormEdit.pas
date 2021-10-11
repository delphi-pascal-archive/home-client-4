unit frm_FormEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Grids, DBGridEh,
  Mask, DBCtrlsEh, DBLookupEh, Buttons, ExtCtrls, DBCtrls, ADODB;

type
  TForm_Editor = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    DBGridEh1: TDBGridEh;
    Edit2: TEdit;
    ColorDialog1: TColorDialog;
    Button3: TButton;
    DataSource2: TDataSource;
    Button5: TButton;
    Button2: TButton;
    DBLookupListBox1: TDBLookupListBox;
    Button4: TButton;
    Button6: TButton;
    OraTable1: TADOTable;
    OraQuery1: TADOQuery;
    OraTable1RECORD_ID: TAutoIncField;
    OraTable1GLCODE: TIntegerField;
    OraTable1NFORM: TIntegerField;
    OraTable1TABNAME: TWideStringField;
    OraTable1FLDNAME: TWideStringField;
    OraTable1IS_BOOLEAN: TIntegerField;
    OraTable1BOLD: TIntegerField;
    OraTable1COLOR: TIntegerField;
    OraTable1BKCOLOR: TIntegerField;
    OraTable1TOTALCODE: TIntegerField;
    OraTable1CAPTION: TWideStringField;
    OraTable1DESCRIPTION: TWideStringField;
    OraTable1NFILTER: TIntegerField;
    OraTable1FLAGFILTER: TIntegerField;
    OraTable1SHOWCODE: TIntegerField;
    OraTable1SHOWORDER: TIntegerField;
    OraTable1WIDTH: TIntegerField;
    OraTable1NGROUP: TIntegerField;
    OraTable1CAPGROUP: TWideStringField;
    OraTable1BKREPORT: TIntegerField;
    OraTable1IS_EDIT: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBGridEh1Columns4EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure DBGridEh1Columns5EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure Button5Click(Sender: TObject);
    procedure OraTable1AfterPost(DataSet: TDataSet);
    procedure OraTable1AfterDelete(DataSet: TDataSet);
    procedure DBGridEh1Columns7EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure DBGridEh1Columns6EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure OraTable1AfterInsert(DataSet: TDataSet);
    procedure DBGridEh1Columns18EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DBLookupListBox1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    
  private
    { Private declarations }
  public
    { Public declarations }
    chuform:integer;
    sys_format:integer;
  end;


var
  Form_Editor: TForm_Editor;

implementation

uses FormBaseV1_1, frm_HELP, frmForm_List;

{$R *.dfm}

procedure TForm_Editor.Button1Click(Sender: TObject);
var
   FormBaseV:TFormBaseV1;

begin
  if chuform=0 then
     begin
        application.MessageBox('Необходимо выбрать форму в списке справа.','sys',0);
        exit;
     end;
  //edif

  FormBaseV:=tFormBaseV1.Create(self);

  FormBaseV.n_form:=chuform;

  FormBaseV.DESC_SHEM:='';
  FormBaseV.FORM_USER:='';
  FormBaseV.FORM_PASSWORD:='';
  FormBaseV.IS_FORM_PASS:=TRUE;
  FormBaseV.FORM_MAININIT(Form_frmList.ADOCONNECTION1,FormBaseV);

  FormBaseV.WindowState:=wsMaximized;

  //--------------------------------
  IF FormBaseV.CONNECT_TRY=false then
     FormBaseV.Close
  else
     begin
        FormBaseV.FormStyle:=fsMDICHILD;
        FormBaseV.Show;
     end;
  //endif
end;



//---------------------------Поиск номера цвета
procedure TForm_Editor.Button3Click(Sender: TObject);
begin
   if ColorDialog1.Execute then
      edit2.text:=inttostr(colordialog1.color);
   //endif
end;

//----------------------------------Простановка цвета
procedure TForm_Editor.DBGridEh1Columns4EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
   OraTable1.Edit;
   if colordialog1.Execute then
      OraTable1.Fields.FieldByName('color').AsInteger:=colordialog1.color;
   //endif
   oratable1.Post;
end;

//----------------------------------Простановка цвета
procedure TForm_Editor.DBGridEh1Columns5EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
   OraTable1.Edit;
   if colordialog1.Execute then
      OraTable1.Fields.FieldByName('bkcolor').AsInteger:=colordialog1.color;
   //endif
   oratable1.Post;
end;



//----------------------------------------------------
//               Форматирование
//----------------------------------------------------
procedure TForm_Editor.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
VAR
   DGRID1:TDBGRIDEH;

begin

  DGRID1:=TDBGRIDEH(SENDER);

  //----------------Проставленные ячейки
  if (column.Field.AsString <> '0') and
     (COLUMN.Field.ASSTRING<>'') AND
     (column.Fieldname<>'gogo') then
     begin
        background := 16775914;
        afont.color:=62;
     end;
  //endif

  //--------------------------------Управляющие записи таблиц
  if column.FieldName='GLCODE' then
     if (column.Field.AsInteger>0) and
        (column.Field.AsInteger<4) then
        begin
           sys_format:=5;
        end
     else
        sys_format:=0;
     //endif
  //endif

  //--------------------------Управляющие записи таблиц 2
  if ((column.FieldName='TABNAME') or (column.FieldName='GLCODE')) and (sys_format=5) then
     begin
        afont.Style:=[fsBold];

        if DGRID1.Columns[0].Field.ASINTEGER=3 then
           begin
              afont.Color:=clwhite;
              background:=8421504;
           end;
        //endif
     end;
  //endif

  //------------------------------------------------Отображаемые поля
  if (DGRID1.Columns[13].Field.ASINTEGER<>0) AND
     ((COLUMN.FieldName='CAPTION') or (COLUMN.FieldName='SHOWCODE') or
      (COLUMN.FieldName='SHOWORDER'))  then
     begin
        afont.style:=[fsbold];

        if (DGRID1.Columns[13].Field.ASINTEGER=1) then
           afont.Color:=128
        else
           afont.Color:=16384;
        //endif
     end;
  //ENDIF

  //-----------------------------------Фильтры
  if (dgrid1.Columns[11].Field.asinteger<>0) and (dgrid1.Columns[11].Field.asinteger<1000) and
     ((COLUMN.FieldName='NFILTER') or (COLUMN.FieldName='FLAGFILTER')or
     (COLUMN.FieldName='CAPTION')) then
     begin
        Background:=16568279 ;

        if (dgrid1.Columns[12].Field.asinteger=2) then
           afont.style:=[fsBold];
        //endif
     end;
  //endif

  //------------------------------------Фильтры с запросами к таблицам
  if (dgrid1.Columns[11].Field.asinteger>=1000) and
     ((COLUMN.FieldName='NFILTER') or (COLUMN.FieldName='FLAGFILTER')or
     (COLUMN.FieldName='CAPTION') or (COLUMN.FieldName='FLDNAME') or
     (COLUMN.FieldName='TABNAME') or (COLUMN.FieldName='CAPGROUP') ) then
     begin
        Background:=16701907;

        if (dgrid1.Columns[12].Field.asinteger=2) then
           afont.style:=[fsBold];
        //endif
     end;
  //endif


  //----------------------------Дополнительные фильтры
  if (dgrid1.Columns[0].Field.asinteger=4) and
     ( (COLUMN.FieldName='FLDNAME')) then
     begin
        AFONT.COLOR:=clRED;
     end;
  //endif

   //-----------------------------Поля форм ссылок
   if ((dgrid1.Columns[0].Field.asinteger=5) or
       (dgrid1.Columns[0].Field.asinteger=6) or
       (dgrid1.Columns[0].Field.asinteger=7) ) and
     ( (COLUMN.FieldName='TABNAME') or (COLUMN.FieldName='FLDNAME') OR
     (COLUMN.FieldName='BOLD')) then
     begin
        AFONT.COLOR:=8388672;
        AFONT.STYLE:=[FSbold];

        IF (COLUMN.FieldName='TABNAME') then
           BEGIN
              background:=15000804;
              AFONT.Style:=[FSItalic,fsBold]
           END;
        //endif
     end;
  //endif

  //--------------------------Поля аггрегирования
  if (COLUMN.fieldname='NGROUP') and (Column.Field.asinteger>1000) then
     background:=12703487;
  //endif   



end;



//--------------------------------------------------------
procedure TForm_Editor.Button5Click(Sender: TObject);
begin
   dbgrideh1.SelectedRows.Delete;
end;


//----------------------------Выбор цвета (задний фон)
procedure TForm_Editor.DBGridEh1Columns7EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
   ORATABLE1.Edit;
   IF COLORDIALOG1.Execute THEN
      ORATABLE1.Fields.FieldByName('BKCOLOR').AsInteger:=COLORDIALOG1.COLOR;
   //ENDIF
   ORATABLE1.Post;


end;

//------------------------------Выбор цвета
procedure TForm_Editor.DBGridEh1Columns6EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
   ORATABLE1.Edit;
   IF COLORDIALOG1.Execute THEN
      ORATABLE1.Fields.FieldByName('COLOR').AsInteger:=COLORDIALOG1.COLOR;
   //ENDIF
   ORATABLE1.Post;
end;


//------------------------------------------------
procedure TForm_Editor.FormShow(Sender: TObject);
begin

   //orasession1.Open;
   //---------------Основной набор
   oratable1.Open;

   //---------------Список форм
   oraquery1.Open;
   chuform:=0;
   self.WindowState:=wsMaximized;
   
end;


//--------------------------------------------------------
procedure TForm_Editor.OraTable1AfterPost(DataSet: TDataSet);
begin
   dbgrideh1.Refresh;
   //oraquery1.Refresh;
end;
//--------------------------------------------------------
procedure TForm_Editor.OraTable1AfterDelete(DataSet: TDataSet);
begin
   dbgrideh1.Refresh;
   //oraquery1.refresh;
end;
//--------------------------------------------------------
procedure TForm_Editor.OraTable1AfterInsert(DataSet: TDataSet);
begin
   dbgrideh1.Refresh;
   //oraquery1.refresh;
end;


//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
procedure TForm_Editor.DBGridEh1Columns18EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
   ORATABLE1.Edit;
   IF COLORDIALOG1.Execute THEN
      ORATABLE1.Fields.FieldByName('BKREPORT').AsInteger:=COLORDIALOG1.COLOR;
   //ENDIF
   ORATABLE1.Post;
end;

//-------------------------------------------
procedure TForm_Editor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    
   //---------------Основной набор
   oratable1.close;
   //---------------Список форм
   oraquery1.close;
end;

procedure TForm_Editor.Button2Click(Sender: TObject);

begin
   frm_ReportHLP.Show;
   frm_ReportHLP.MEMO1.VISIBLE:=TRUE;
   frm_ReportHLP.MEMO2.VISIBLE:=FALSE;
end;

//---------------------------------------------------------------------------
//       Обновление списка форм
//---------------------------------------------------------------------------
procedure TForm_Editor.Button4Click(Sender: TObject);
begin
   oraquery1.ReQUERY;
end;
//---------------------------------------------------------------------------
//          Выбор одного из описаний форм
//---------------------------------------------------------------------------
procedure TForm_Editor.DBLookupListBox1Click(Sender: TObject);
begin
   if DBLookupListBox1.KeyValue<>null then
      begin
         chuform:=DBLookupListBox1.KeyValue;
         ORATABLE1.FILTER:='nform='+vartostr(DBLookupListBox1.KeyValue);
         oratable1.Filtered:=true;
      end
   else
      oratable1.Filtered:=false;
   //endif

   dbgrideh1.SetFocus;
end;

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
procedure TForm_Editor.Button6Click(Sender: TObject);
begin
   frm_ReportHLP.Show;
   frm_ReportHLP.MEMO1.VISIBLE:=FALSE;
   frm_ReportHLP.MEMO2.VISIBLE:=TRUE;
end;



end.
