unit FormBaseV_Edit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FormBaseV_ALT, DBGridEh, ADODB, Menus, DB, 
  Buttons, ExtCtrls, Grids, StdCtrls, Mask, DBCtrlsEh,
  DBLookupEh, FORMUNIEDIT1, FormRecordEDIT;

type
  TFormBaseV_EDIT = class(TFormBaseV_ALT)
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;

    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    //-------------------------Сопряженная форма редактирования
    FORMEDITGO:TFormUniEdit;
    FRM_RECEDIT:TFormRecEdit;

    //--------------------Начальное оформление формы (потомок)
    procedure FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);override;

    //-----------------Переход на смежную форму (потомок)
    procedure Otherform(Sender: TObject);override;

    procedure EDITFIELD(Sender: TObject; Var Handled:boolean);
  end;

implementation

{$R *.dfm}

//----------------------------------------------------------------
//                Переход по формам
//----------------------------------------------------------------
procedure TFormBaseV_EDIT.Otherform(Sender: TObject);
var
   newform:TFormBaseV_EDIT;
   inp_filter:string;

   fld_source:string;
   fld_dest:string;
   val_dest:string;
   crit_type:integer;

begin
   IS_ROWID:=false;
   //-------------------------Запуск в режиме группировки
   if aggreg=true then
      begin
         oraquery3.SQL.Text:=
         ' SELECT a.* FROM '+TABGO+ ' A '+BaseStr+GlFilter;
      end
   else
      //---------------------------Поиск текущей записи
      if IS_ROWID=FALSE then
         oraquery3.SQL.Text:=' SELECT a.* FROM '+TABGO+ ' A where A.'+
         TABGO_KEYEDIT+'='+oraquery1.fields.fieldbyname(TABGO_KEYEDIT).AsString
      else
         oraquery3.SQL.Text:=' SELECT a.* FROM '+TABGO+ ' A where A.rowID='+chr(39)+
         oraquery1.fields.fieldbyname('rowID').AsString+chr(39);
      //EndIf
   //EndIf
   oraquery3.open;

   //---------------------------Оформление переходного фильтра
   oraquery2.sql.text:=
   'select * from '+DESC_SHEM+'.form_descs where glcode=6 AND NFORM='+inttostr(n_form)+
   ' and bold='+ inttostr((sender as TButton).Tag);

   oraquery2.open;
   oraquery2.First;

   while not(oraquery2.eof) do
      begin
         //----------------------Поля исходной и конечной формы
         //                       тип полей и передаваемое знач
         fld_source:=oraquery2.Fields.fieldbyname('FLDNAME').AsString;
         fld_dest:=oraquery2.Fields.fieldbyname('TABNAME').AsString;
         crit_type:=oraquery2.Fields.fieldbyname('COLOR').AsInteger;
         val_dest:=oraquery3.Fields.fieldbyname(fld_source).AsString;

         inp_filter:=inp_filter+' and ';
         //---------------------------Фильтруемое поле конечной формы
         if crit_type=2 then
            if IS_ENG=false then
               inp_filter:=inp_filter+fld_dest+'=To_Date(' +
               chr(39)+vartostr(val_dest)+chr(39) +
               ','+chr(39)+'DD.MM.YYYY'+chr(39)+')'
            else
               inp_filter:=inp_filter+fld_dest+'=To_Date(' +
               chr(39)+vartostr(val_dest)+chr(39) +
               ','+chr(39)+'MM/DD/YYYY'+chr(39)+')'
            //endif
         else
            if crit_type=1 then
               inp_filter:=inp_filter+fld_dest+'='+chr(39)+val_dest+chr(39)
            else
               inp_filter:=inp_filter+fld_dest+'='+val_dest;
            //endif
         //endif
         //--------------------------------------------------------
         oraquery2.next
      end;
   //wend
   oraquery2.close;
   oraquery3.Close;

   //---------------------Дополнительные передаваемые фильтры
   oraquery2.sql.text:=
   'select * from '+DESC_SHEM+'.form_descs where glcode=7 AND NFORM='+inttostr(n_form)+
   ' and bold='+ inttostr((sender as TButton).Tag);

   oraquery2.open;
   oraquery2.First;

   while not(oraquery2.eof) do
      begin
         inp_filter:=inp_filter+oraquery2.Fields.fieldbyname('FLDNAME').AsString;
         oraquery2.next
      end;
   //wend
   oraquery2.close;

   //-----------------------------------------------------------------
   //            Создание новой формы
   //       Передается логин и пароль текущей формы
   //-----------------------------------------------------------------
   newform:=TFormBaseV_EDIT.Create(application);
   newform.n_form:=(sender as TButton).Tag;
   newform.input_filter:=inp_filter;
   newform.Color:=14934237;
   newform.DESC_SHEM:=DESC_SHEM;
   newform.FORM_USER:=FORM_USER;
   newform.FORM_PASSWORD:=FORM_PASSWORD;
   IS_FORM_PASS:=TRUE;

   //--------------------Инициализировать заранее
   newform.FORM_MAININIT(oraquery1.connection,newform);

   //------------------------Попытка соединения
   if newform.CONNECT_TRY=false then
      newform.Close
   else
      begin
         newform.FormStyle:=fsMDICHILD;
         newform.Show;
      end;
   //endif
end;


//-----------------------------------------------------------------------
//          Начальное оформление формы (Потомок)
//-----------------------------------------------------------------------
procedure TFormBaseV_EDIT.FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);
var
   i:integer;
   tek_column:integer;

begin
   //---------------------Родительское открытие формы
   inherited;

   //------------------Если парам. редактир. не указаны (блок)
   if (n_form_edit=0) or (tabgo_keyEdit='') or (tabgo_UpdatingTable='') then
      begin
         speedbutton4.Enabled:=false;
         speedbutton5.Enabled:=false;
         speedbutton3.Enabled:=false;
      end;
   //endif

   //--------------------Открыть необходимые поля
   for i:=1 to nfields do
      begin
         if mainfld_isedit[i]=1 then
            begin
               tek_column:=mainfld_ncolumn[i];
               DBGRIDEH1.Columns[tek_column].ButtonStyle:=cbsNone;
               DBGRIDEH1.Columns[tek_column].EditButtons.ADD;
               DBGRIDEH1.Columns[tek_column].EditButtons[0].ONCLICK:=EDITFIELD;
            end;
         //endif
      end;
   //endfor

  //-----------------------------------Создание сопряженной формы редактирования
  if self.n_form_edit<>0 then
     begin
        FORMEDITGO:=TFormUniEdit.CREATE(APPLICATION);
        FORMEDITGO.DESC_SHEM:=DESC_SHEM;
        FORMEDITGO.FORM_USER:=FORM_USER;
        FORMEDITGO.FORM_PASSWORD:=FORM_PASSWORD;
        FORMEDITGO.IS_FORM_PASS:=TRUE;
        FORMEDITGO.n_form:=n_form_edit;
        //------------сокр числа сессий
        //         (на сессию главной формы)
        //-----------------------------------
        FORMEDITGO.OraQuery1.connection:=oraquery1.connection;
        FORMEDITGO.OraQuery2.connection:=oraquery1.connection;
        FORMEDITGO.OraQuery3.connection:=oraquery1.connection;

        FRM_RECEDIT:=TFormRecEdit.Create(Application);

        //---------------------Если прав нет блокировать на этапе создания
        if CONNECT_TRY=TRUE then
           begin
              FORMEDITGO.FORM_MAININIT(FORMEDITGO);
              FORMEDITGO.IS_INITIALIZED:=true;
           end
        //endif
    end;
  //endif
end;


//-----------------------------------------------------------
//      Процедура редактирования нередакт набора
//-----------------------------------------------------------
procedure TFormBaseV_Edit.EDITFIELD(Sender: TObject; Var Handled:boolean);
Var
   EditString:string;
   EditField:string;
   EditType:integer;
   DataType1:TFieldType;

BEGIN
   //-----------------В режиме группировки редактирование невозможно
   if aggreg=true then
      begin
         application.MessageBox(
         'Невозможно редактирование в режиме группировки','sys',MB_OK);
         exit;

      end;
   //endif

   //--------------------Текущее значение
   EditString:=VarToStr(DBGridEh1.SelectedField.Value);
   EditField:=DBGridEh1.SelectedField.DisplayName;

   //-----------------------------Найти текущую запись
   oraquery1.GotoBookmark(pointer(DBGridEh1.Selection.RECT.toprow));
   
   //-------------------------------Запрос для редактирования
      oraquery3.SQL.Text:='SELECT A.* FROM '+
      tabgo_UpdatingTable+' A WHERE '+tabgo_KeyEdit+'='+
      oraquery1.Fields.fieldbyname(tabgo_KeyEdit).AsString;

   oraquery3.Open;

   //----------------------Тип редактируемого поля
   DataType1:=oraquery3.Fields.FieldByName(EditField).DataType;

   EditType:=1;

   //-------------------------------Выбор типа редактирования
   if (DataType1=ftDateTime)  then
      EditType:=2;
   //endif

   //---------------------------Собственно изменение записи
   //                  через форму редактирования
   FRM_RECEDIT.Form_Execute(oraquery3,EditField,EditString,EditType);
   oraquery3.Close;

   oraquery1.Requery;
END;

//-----------------------------------------------------------
//     Вызов сопоставленной формы редактирования
//     редактирование текущей записи 
//-----------------------------------------------------------
procedure TFormBaseV_EDIT.SpeedButton3Click(Sender: TObject);
VAR
   TMP_BOOKM:TBOOKMARKSTR;

begin
   FORMEDITGO.IS_UPDATEREC:=true;
   //-------------------------------Ссылка на текущую запись (ред)
   FORMEDITGO.FILT_UPDATESEL:=
   tabgo_KeyEdit+'='+
   oraquery1.Fields.fieldbyname(tabgo_KeyEdit).AsString;

   FORMEDITGO.ShowModal;

   TMP_BOOKM:=oraquery1.Bookmark;
   oraquery1.Requery;
   try
   oraquery1.GotoBookmark(pointer(TMP_BOOKM));
   except
   end;   
end;

//-----------------------------------------------------------
//             Удаление записи
//-----------------------------------------------------------
procedure TFormBaseV_EDIT.SpeedButton5Click(Sender: TObject);
VAR
   SQL_DELETE:string;
   TMP_BOOKM:TBOOKMARKSTR;

begin
   SQL_DELETE:=
   'DELETE FROM '+self.tabgo_Updatingtable+' WHERE '+
   tabgo_KeyEdit+'='+
   oraquery1.Fields.fieldbyname(tabgo_KeyEdit).AsString;

   if application.MessageBox(
   PAnsiChar('Удалить запись? '+SQL_DELETE),'sys',MB_OKCANCEL)=IDOK then
      BEGIN
         ORAQUERY3.SQL.TEXT:=SQL_DELETE;
         ORAQUERY3.ExecSQL;
      END;
   //ENDIF

   TMP_BOOKM:=oraquery1.Bookmark;
   oraquery1.Requery;
   try
   oraquery1.GotoBookmark(pointer(TMP_BOOKM));
   except
   end;
end;

//-----------------------------------------------------------
//          Добавление новой записи
//-----------------------------------------------------------
procedure TFormBaseV_EDIT.SpeedButton4Click(Sender: TObject);
var
  MAX_NUM:integer;

begin
   FORMEDITGO.IS_UPDATEREC:=false;
   if FORMEDITGO.ShowModal=mrOk then
      begin
         oraquery1.Requery;
         oraquery3.SQL.Text:=
         'SELECT MAX('+tabgo_KeyEdit+') FROM '+tabgo_Updatingtable;
         oraquery3.Open;
         //-------------------------------
         if oraquery3.RecordCount>0 then
            begin
               oraquery3.First;
               MAX_NUM:=oraquery3.Fields[0].AsInteger;
               oraquery1.Filter:=tabgo_KeyEdit+'='+IntToStr(MAX_NUM);
               oraquery1.FindFirst;
            end;
         //endif
         oraquery3.Close;
      end;
   //endif
end;


//-----------------------------------------------------------
//  Часть корректного закрытия формы (ликвидация формы ред.)
//-----------------------------------------------------------
procedure TFormBaseV_EDIT.FormDestroy(Sender: TObject);
begin
   if (self.n_form_edit<>0) and IS_INITIALIZED=TRUE then
      begin
         FORMEDITGO.FORM_CLOSECONNECT;
         FORMEDITGO.Free;
         FRM_RECEDIT.Free;
      end;
   //endif
end;



end.
