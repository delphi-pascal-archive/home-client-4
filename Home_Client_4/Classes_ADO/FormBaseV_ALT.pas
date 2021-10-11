unit FormBaseV_ALT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dbcgrids, DB, DBTables, StdCtrls, Mask, DBCtrls, ExtCtrls, Menus,
  DBCtrlsEh, DBLookupEh, Grids, DBGridEh,
  Buttons, OleServer, Excel97, DBGRIDEHIMPEXP,
  clipbrd,comobj, ADODB,ToolCtrlsEh,DBLogDlg, frmInDialog;

type
  TFormBaseV_ALT = class(TForm)
    Label1: TLabel;
    Label4: TLabel;
    DataSource1: TDataSource;
    Label2: TLabel;
    DBLookupComboboxEh1: TDBLookupComboboxEh;
    Button2: TButton;
    Label3: TLabel;
    DataSource2: TDataSource;
    DBGridEh1: TDBGridEh;
    Panel1: TPanel;
    Panel2: TPanel;
    Button3: TBitBtn;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N1231: TMenuItem;
    N2: TMenuItem;
    Like1: TMenuItem;
    test1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    likeexclude1: TMenuItem;
    N8: TMenuItem;
    N11: TMenuItem;
    X1: TMenuItem;
    Button4: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    DBGridEh2: TDBGridEh;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource3: TDataSource;
    DBGridEh_COP: TDBGridEh;
    DataSource_COP: TDataSource;
    Button_Refr: TButton;
    OraQuery2: TADOQuery;
    OraQuery3: TADOQuery;
    OraQuery1: TADOQuery;
    OraQuery_COP: TADOQuery;
    procedure FormShow(Sender: TObject);

    //-------------------Применение сортировок
    procedure asc_filtergo(Sender: TObject);
    procedure desc_filtergo(Sender: TObject);

    //-----------------------Процедура выбора фильтра
    procedure DBLookupComboboxEh1CloseUp(Sender: TObject; Accept: Boolean);

    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Like1Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure likeexclude1Click(Sender: TObject);
    procedure X1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1ColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);

    //--------------------Начальное оформление формы
    procedure FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);virtual;

    //--------------------Проверка возможности запроса данных
    function CONNECT_TRY:boolean;

    //-------------------Обновление всех состояний
    //           В классе ALT только основного набора
    //
    procedure updstate(Sender: TObject);
    //-------------------Часть процедуры, выполняемая в потомках
    procedure updstate_child;virtual;

    //--------------Часть процедуры закрытия, выполняемая в потомках
    procedure CLOSE_CHILD;virtual;

    //-------------------Обновление состояний фильтров
    procedure updstate_filter(Sender: TObject);virtual;
    procedure Button_RefrClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mainrecid:integer;

    //------------------Описание формы
    n_form:integer;
    //------------------Сопряженная форма редактирования
    //                (использ. в дочерних классах)
    n_form_edit:integer;

    //--------------------------------------------Источник данных
    //--------------------Схема, где находится таб. форм
    DESC_SHEM:STRING;
    //--------------Сервер, где хранится источник данных
    FORM_SERVER:STRING;
    //--------------Схема, где хранится источник данных
    FORM_SHEM:STRING;
    //--------------Пользователь/Пароль
    FORM_USER:STRING;
    FORM_PASSWORD:STRING;
    //----------------------------Таблица-Запрос (внутри схемы)
    FORM_TABLE:STRING;
    //--------------------------Таблица (запрос формы)
    tabgo:string;
    //---------------------Таблица (запрос) для формирования
    //                       зависимого фильтра
    tabgo_filter:string;

    //--------------------Ключевое поле в запросе на ред. одной записи
    tabgo_KeyEdit:string;
    //--------------------UpdatingTable в редактируемом наборе
    tabgo_UpdatingTable:string;

    //--------------------Признак того, что при откр формы
    //                      логин/пароль уже введены
    IS_FORM_PASS:boolean;
    //-------------------Признак того, что в качестве источн.
    //                     данных используется запрос
    IS_QUERY:boolean;

    //----------------Признак того, что нужно запрашивать RowID
    IS_ROWID:boolean;

    //--------------------------Признак, что форма оформлена
    IS_INITIALIZED:BOOLEAN;

    //------------------------------базовые строки фильтров
    labfil:array[1..15] of TLabel;
    labfil2:array[1..15] of TLabel;

    //------------------------------строки фильтров (текущих значений)
    filstr:array[1..15] of string;
    //-------------------------------Запросы фильтров
    oraqgo:array[1..15] of TADOquery;
    dsgo:array[1..15] of TDatasource;

    //---------------------------------combo фильтров
    //    в альт. версии заменены на dbgrigeh-s
    //
    dblookgo:array[1..15] of TDBLookupComboboxEh;
    //-----------------Поля для фильтрации по лукапу
    filt_lookfld:array[1..15] of string;

    //----------------------------------check фильтров
    checkgo:array[1..15] of TCheckbox;
    //----------------------------------число фильтров

    //-----------------------Зависимые фильтр для Combo
    zavfilter:array[1..15] of string;

    nfilters:integer;
    //--------------------------------------спец-фильтры
    check_spec:array[1..15] of TCheckbox;
    fil_spec:array[1..15] of string;

    nfilters_spec:integer;

    //---------------------------------Кнопки перехода
    button_move:array[1..7] of TButton;
    nbuttons_move:integer;

    //------------------------------------сортировки
    sort_ascBut:array[1..15] of TSpeedButton;
    sort_descBut:array[1..15] of TSpeedButton;

    //------------------------------------Поля сортировки
    sort_ascgo:array[1..15] of string;

    //----------------------------------Поля формы  (Основные)
    mainfld_go:array[1..50] of string;
    mainfld_caption:array[1..50] of string;

    //--------------------------Номер колонки грида отобр. поле
    mainfld_ncolumn:array[1..50] of integer;

    //--------------------------Признаки возможности ред.полей
    mainfld_isedit:array[1..50] of integer;

    //--------------------------Фильтры и сорт по главным полям
    //------------(Хранение значений для фильтров и сортировок)
    mainfld_filter:array[1..50] of string;
    mainfld_sort:array[1..50] of string;

    //----------------Номера полей послед-но в порядке сортировок
    sort_fldnums:array[1..50] of integer;
    nsorts:integer;

    //-------------------------------Дополнительные поля
    dopfld_go:array[1..30] of string;
    dopfld_caption:array[1..30] of string;
    db_dopfld:array[1..30] of TDBText;

    //------------------------------Число основных и доп. полей
    nfields:integer;
    ndopfields:integer;

    //--------------------------Отображаемые в тек. момент поля
    Viewfld_go:array[1..80] of string;
    Viewfld_caption:array[1..80] of string;
    Viewfld_aggrgo:array[1..80] of string;
    //--------------------Число отображаемых полей
    nviewfields:integer;

    //---------------------------------------------
    //           Группировки
    //---------------------------------------------
    //---------Чеки группировок
    checkgr:array[1..30] of TCheckBox;
    //---------Номера групп(из справочника), привязанные к чекам
    ngroup:array[1..30] of integer;

    //--------------Номера групп (из справочника), привязанные к полям
    mainfld_group:array[1..50] of integer;
    dopfld_group:array[1..30] of integer;

    //-------------Число группировок
    nofgroups:integer;

    aggreg:boolean;

    //------------------------текущая сортировка
    actualsort:string;
    //------------------------Входной фильтр
    input_filter:widestring;
    //------------------------Фильтр пользователя
    user_filter:string;

    //-----------------------Минимальная ширина
    self_min_width:integer;
    //-----------------------Минимальная высота
    self_min_height:integer;
    //-----------------------Сокращенные расстояния между чеками групп
    is_check_group_short:boolean;

    //----------------------------------------------
    //    Взаимодействие с графиком
    //----------------------------------------------
    
    //------------------Детальное разбиение запроса
    //-------------------------до группировки (для базы Access)
    SQL_1_beforeGROUP5:string;

    //------------------------группировка
    SQL_2_GROUP:string;
    //-----------------------сортировка
    SQL_3_SORT:string;

    //----------------------Базовая строка и общий текущий фильтр
    BaseStr:string;
    GlFilter:string;
    //------------------Фильтр образованный комбо-элементами
    GlFilter_el:string;
    //--------------------Фильтр образованный спец-условиями
    Spec_filter:string;
    //--------------------Фильтр образованный спец-условиями(Для комбо-фильтров)
    Spec_filter1:string;
    //------------------Отображаемые в текущий момент поля
    viewflds:string;
    aggr_flds:string;

    //-----------------Путь ко временной базе
    TMP_MDB_PATH:string;
    //-----------------Директ. открыта
    IS_DIR_READY:boolean;
    //-----------------ENG Формат дат
    IS_ENG:boolean;
    //------------------Окно диалога
    frm_Dialog:TFormInDialog;

    //-----------------Переход на смежную форму
    procedure Otherform(Sender: TObject);virtual;

    //-----------------Поиск номера массива по названию поля
    function FLDMASNUM(FLDNAME:string):integer;

    //------------------------------Очистка фильтра пользователя
    procedure CLEAR_USER_FILTER;
    //------------------------------Очистка сортировки
    procedure CLEAR_USER_SORT;

    //-----------------------------------------------------------
    //       Вывод отчетов в Эксель
    //-----------------------------------------------------------
    //       SQL_IN  Запрос для отчета
    //-----------------------------------------------------------
    //       IS_SAVE Сохранить выложенный лист
    //       IS_FIRST Первый лист многолистового документа
    //-----------------------------------------------------------
    //           xlSHEET Название листа
    //           xlFILE  Название файла Excel
    //-----------------------------------------------------------
    //       IS_TEMPLATE  Наличие темплэйта для форматирования
    //-----------------------------------------------------------
    //           ID_TEMPLATE (ID - файла с макросом обработки листа OBRMACRO)
    //-----------------------------------------------------------
    //       IS_ACCESS_OBR Предварительная подготовка отчета в MSACCESS(statdb.mdb)
    //       IS_LINKTABLE  Использовать экспорт в ACCESS с
    //                     помощью линка таблицы
    //-----------------------------------------------------------
    //       LINKTABLE Название линкуемой таблицы для экспорта
    //-----------------------------------------------------------
    //          ID_MDB_REAL Номер обработчкика отчета в MSACCESS
    //-----------------------------------------------------------
    //       IS_VISIBLE Сделать приложение видимым после выкладки
    //-----------------------------------------------------------
    procedure EXCEL_REPORT_UNI(
    SQL_IN:widestring;
    IS_SAVE:boolean;
    IS_FIRST:boolean;
    xlSHEET:string;
    xlFILE:string;
    IS_TEMPLATE:boolean;
    ID_TEMPLATE:integer;
    ENGINE_TYPE:integer;  // 1- COPY  2- ACCESS 3- ODBC
    IS_LINKTABLE:boolean;
    LINKTABLE:string;
    ID_MDB_REAL:integer;
    IS_Visible:boolean
    );

    //-----------------------------------------------------------
    //    Простой формат отчет Excel  (ODBC с шаблоном)
    //-----------------------------------------------------------
    procedure EXCEL_SCREEN(SQL_IN:widestring;ID_TEMPLATE:INTEGER);

    //------------------------------------------------------------
    //            Вспомогательные процедуры
    //------------------------------------------------------------
    //        Выкладка шаблона для отчета Excel
    //------------------------------------------------------------
    procedure OUT_TEMPLATE(
    ID_TEMPLATE1:integer;
    xlFILE1:string);

    //------------------------------------------------------------
    //     Поддержка формирования отчетов с использ. MS Access
    //------------------------------------------------------------
    //     Подготовка базы к работе  statdb.mdb
    //------------------------------------------------------------
    procedure MAKE_TMP_BASE;
    //-------------------------------------------------------------------
    //   Выбрать данные через линк или PATH-THOUGH таблицы в statdb.mdb
    //--------------------------------------------------------------------
    procedure LINK_COPY(
    DEST_TABLE:string;
    SQL_IN1:widestring;
    IS_LINK1:boolean;
    LINKTABLE1:string);
    //--------------------------------------------------------------
    //     Выполнить скрипт запросов Access
    //--------------------------------------------------------------
    procedure EXEC_ACCESS_SCRIPT(NSCRIPT1:integer);

   //---------------------------------------------------------------
   //       Внутренняя процедура вывода отчета
   //---------------------------------------------------------------
   procedure EXCEL_OUT(
    SQL_IN:widestring;
    IS_SAVE:boolean;
    IS_FIRST:boolean;
    xlSHEET:string;
    xlFILE:string;
    IS_TEMPLATE:boolean;
    ID_TEMPLATE:integer;
    ENGINE_TYPE:integer; // 1- COPY  2- ACCESS 3- ODBC
    IS_Visible:boolean
    );


end;

const xlLCID = LOCALE_USER_DEFAULT;

implementation
{$R *.dfm}

//----------------------------------------------------------------
//                Переход по формам
//----------------------------------------------------------------
procedure TFormBaseV_ALT.Otherform(Sender: TObject);
var
   newform:TFormBaseV_ALT;
   inp_filter:string;

   fld_source:string;
   fld_dest:string;
   val_dest:string;
   crit_type:integer;

begin
   if aggreg=true then
      begin
         Application.MessageBox('Невозможен вызов в режиме группировки','sys',0);
         exit;
      end;
   //endif
   IS_ROWID:=false;
   //---------------------------Поиск текущей записи
   if IS_ROWID=FALSE then
      oraquery3.SQL.Text:=' SELECT a.* FROM '+TABGO+ ' A where A.'+
      TABGO_KEYEDIT+'='+oraquery1.fields.fieldbyname(TABGO_KEYEDIT).AsString
   else
      oraquery3.SQL.Text:=' SELECT a.* FROM '+TABGO+ ' A where A.rowID='+chr(39)+
      oraquery1.fields.fieldbyname('rowID').AsString+chr(39);
   //Endif
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
   newform:=TFormBaseV_ALT.Create(application);
   newform.n_form:=(sender as TButton).Tag;
   newform.input_filter:=inp_filter;
   newform.Color:=14934237;
   newform.DESC_SHEM:=DESC_SHEM;
   newform.FORM_USER:=FORM_USER;
   newform.FORM_PASSWORD:=FORM_PASSWORD;
   IS_FORM_PASS:=TRUE;

   //--------------------Инициализировать заранее
   newform.FORM_MAININIT(oraquery1.Connection,newform);

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

//----------------------------------------------------------------
//       Применение сортировки по возрастанию
//----------------------------------------------------------------
procedure TFormBaseV_ALT.asc_filtergo(Sender: TObject);
var
   gobt: Tbutton;

begin
    gobt:=TButton(Sender);
    nsorts:=nsorts+1;
    sort_fldnums[nsorts]:=FLDMASNUM(sort_ascgo[gobt.tag]);

    mainfld_sort[FLDMASNUM(sort_ascgo[gobt.tag])]:=sort_ascgo[gobt.tag];
    updstate(sender);
end;

//----------------------------------------------------------------
//       Применение сортировки по убыванию
//----------------------------------------------------------------
procedure TFormBaseV_ALT.desc_filtergo(Sender: TObject);
var
   gobt:tbutton;

begin
   gobt:=tbutton(Sender);
   nsorts:=nsorts+1;
   sort_fldnums[nsorts]:=FLDMASNUM(sort_ascgo[gobt.tag]);

   mainfld_sort[FLDMASNUM(sort_ascgo[gobt.tag])]:=sort_ascgo[gobt.tag]+' DESC';
   updstate(sender);
end;

//----------------------------------------------------------------
//            Обновление combo-фильтров
//----------------------------------------------------------------
procedure TFormBaseV_ALT.updstate_filter(Sender: TObject);
var
   i:integer;

begin
   UPDSTATE(SENDER);

   i:=(Sender as TCheckBox).Tag;
   if checkgo[i].checked=true then
      BEGIN
         DBLookGo[i].Enabled:=true;
         oraqgo[i].Close;
         oraqgo[i].SQL.Text:=
         'SELECT * FROM ('+labfil[i].caption+zavfilter[i]+
         labfil2[i].caption;

         oraqgo[i].Open;
      END;
   //endif
end;

//----------------------------------------------------------------
//                 GLOBAL FILTER AND ALL
//----------------------------------------------------------------
procedure TFormBaseV_ALT.updstate(Sender: TObject);
var
   i,j:integer;
   flfld:string;
   UNISTR,unistr1:string;
   TMP_SQL:string;

begin
   DBGRIDEH1.SumList.Active:=False;
   screen.Cursor:=crHourGlass;

   //---------------------------Число отображаемых полей
   nviewfields:=0;

   aggreg:=false;
   viewflds:='';
   aggr_flds:='';
   //-----------------------------------------------------------
   //                Оформление группировок
   //-----------------------------------------------------------
   for i:=1 to nofgroups do
      begin
         if checkgr[i].checked=true then
            aggreg:=true;
         //endif
      end;
   //endfor

   //--------------------------------Если стоит режим группировки
   if aggreg=true then
   //-------------------------По всем группам
   for i:=1 to nofgroups do
      begin
         //-------------------------------Для пустого чека группировки
         if checkgr[i].checked=false then
            begin
               //-------------------------Проверка всех полей, входящих в группу
               for j:=1 to nfields do
                  begin
                     if mainfld_group[j]=ngroup[i] then
                        begin
                           if viewflds<>'' then
                              viewflds:=viewflds+',';
                           //endif
                           //-----------------И включение этих полей в список запроса
                           viewflds:=viewflds+mainfld_go[j];
                           //-----------------Добавить в список текущих полей
                           nviewfields:=nviewfields+1;
                           viewfld_go[nviewfields]:=mainfld_go[j];
                           viewfld_caption[nviewfields]:=mainfld_caption[j];
                           viewfld_aggrgo[nviewfields]:='';

                           //--------------Восстановление значений
                           dbgrideh1.Columns[mainfld_ncolumn[j]].FieldName:=mainfld_go[j];
                        end;
                     //endif
                  end;
               //endfor
               //-------------------------Проверка всех доп. полей
               for j:=1 to ndopfields do
                  begin
                     if dopfld_group[j]=ngroup[i] then
                        begin
                           if viewflds<>'' then
                              viewflds:=viewflds+',';
                           //endif
                           //-----------------И включение этих полей в список запроса
                           viewflds:=viewflds+dopfld_go[j];
                           //-----------------Добавить в список текущих полей
                           nviewfields:=nviewfields+1;
                           viewfld_go[nviewfields]:=dopfld_go[j];
                           viewfld_caption[nviewfields]:=dopfld_caption[j];
                           viewfld_aggrgo[nviewfields]:='';

                           //-----------------Восстановление значений доп полей
                           db_dopfld[J].DataSource:=nil;
                           db_dopfld[J].dataField:=dopfld_go[J];
                        end;
                     //endif
                  end;
               //endfor
            end
         //----------------------------Если чек установлен (поля скрыты)
         //-------------------------------------------------------
         //               Скрытие полей
         //-------------------------------------------------------
         else
            begin
               //------------------Скрытие основных полей
               for j:=1 to nfields do
                  begin
                     if mainfld_group[j]=ngroup[i] then
                        begin
                           dbgrideh1.Columns[mainfld_ncolumn[j]].FieldName:='';

                           //------------Снять сортировку по скр. полю
                           mainfld_sort[j]:='';
                        end;
                     //endif
                  end;
               //endfor

               //-------------------Скрытие дополнительных полей
               for j:=1 to ndopfields do
                  begin
                     if dopfld_group[j]=ngroup[i] then
                        db_dopfld[j].dataField:='';
                     //endif
                  end;
               //endfor
            end;
         //endif
      end;
   //endfor
   //endif

   //---------------------------------------------------------
   //           Заполненние полей аггрегирования
   //---------------------------------------------------------
   if aggreg=true then
      begin
         //----------------------------------------------Основные аггрегируемые поля
         for i:=1 to nfields do
            begin
               if ((mainfld_group[i]=1001) or (mainfld_group[i]=1002)) then
                  begin
                     //-------------------------------------
                     if aggr_flds<>'' then
                        aggr_flds:=aggr_flds+',';
                     //endif
                     //--------------------------------Суммы
                     if mainfld_group[i]=1001 then
                        begin
                           aggr_flds:=aggr_flds+'sum('+mainfld_go[i]+') as total'+mainfld_go[i]+' ';
                           viewfld_aggrgo[nviewfields]:='sum('+mainfld_go[i]+')';
                        end;
                     //endif

                     //------------------------------Средние
                     if mainfld_group[i]=1002 then
                        begin
                           aggr_flds:=aggr_flds+' avg('+mainfld_go[i]+') as total'+mainfld_go[i]+' ';
                           viewfld_aggrgo[nviewfields]:='avg('+mainfld_go[i]+')';
                           dbgrideh1.Columns[mainfld_ncolumn[i]].DisplayFormat:='#.##';
                        end;
                     //endif

                     //-----------------Добавить в список текущих полей
                     nviewfields:=nviewfields+1;
                     viewfld_go[nviewfields]:='total'+mainfld_go[i];
                     viewfld_caption[nviewfields]:=mainfld_caption[i];

                     //-----Модификация осн. полей под суммы
                     dbgrideh1.Columns[mainfld_ncolumn[i]].FieldName:='total'+mainfld_go[i];

                     //-------------------Очистить фильтр и сорт. по тек полю
                     mainfld_sort[i]:='';
                     mainfld_filter[i]:='';
                  end;
               //endif
            end;
         //endfor

         //-----------------------------------------Дополнительные аггрегируемые поля
         for i:=1 to ndopfields do
            begin
               if ((dopfld_group[i]=1001) or (dopfld_group[i]=1002)) then
                  begin
                     //---------------------------------------
                     if aggr_flds<>'' then
                        aggr_flds:=aggr_flds+',';
                     //endif

                     //----------------------------------Суммы
                     if dopfld_group[i]=1001 then
                        begin
                           aggr_flds:=aggr_flds+'sum('+dopfld_go[i]+') as total'+dopfld_go[i]+' ';
                           viewfld_aggrgo[nviewfields]:='sum('+mainfld_go[i]+')';
                        end;
                     //endif

                     //--------------------------------Cредние
                     if dopfld_group[i]=1002 then
                        begin
                           aggr_flds:=aggr_flds+'avg('+dopfld_go[i]+') as total'+dopfld_go[i]+' ';
                           viewfld_aggrgo[nviewfields]:='avg('+mainfld_go[i]+')';
                        end;
                     //endif

                     //------------------------Добавить в список текущих полей
                     nviewfields:=nviewfields+1;
                     viewfld_go[nviewfields]:='total'+dopfld_go[i];
                     viewfld_caption[nviewfields]:=dopfld_caption[i];
                     //------------------------Модификация доп. полей под суммы
                     db_dopfld[i].DataSource:=nil;
                     db_dopfld[i].dataField:='total'+dopfld_go[i];
                  end;
               //endif
            end;
         //endfor
      END
   else
   //-------------------------------------------------------------
   //  Если режим групп. не стоит возвращаем все осн и доп поля
   //-------------------------------------------------------------
      begin
         //----------------------Основные поля
         for i:=1 to nfields do
            begin
               dbgrideh1.Columns[mainfld_ncolumn[i]].FieldName:=mainfld_go[i];

               //-----------------Добавить в список текущих полей
               nviewfields:=nviewfields+1;
               viewfld_go[nviewfields]:=mainfld_go[i];
               viewfld_caption[nviewfields]:=mainfld_caption[i];
            end;
         //endfor

         //----------------------Дополнительные поля
         for i:=1 to ndopfields do
            begin
               db_dopfld[i].DataSource:=nil;
               db_dopfld[i].dataField:=dopfld_go[i];

               //-----------------Добавить в список текущих полей
               nviewfields:=nviewfields+1;
               viewfld_go[nviewfields]:=dopfld_go[i];
               viewfld_caption[nviewfields]:=dopfld_caption[i];
            end;
         //endfor
      end;
   //end if

   //-----------------------------------------------------------
   //         Фильтр пользователя
   //-----------------------------------------------------------
   user_filter:='';
   for i:=1 to nfields do
      begin
         if mainfld_filter[i]<>'' then
            user_filter:=user_filter+' '+mainfld_filter[i];
         //endif
      end;
   //endfor

   //-----------------------------------------------------------
   //                  Заполнение фильтров
   //-----------------------------------------------------------
   basestr:='';
   for i:=1 to nfilters do
      begin
          //-----------------Очистить текущее значение фильтра
          filstr[i]:='';

          //-----------------------------Чек фильтра не стоит
          If Checkgo[i].Checked = false Then
             begin
                dblookgo[i].keyvalue:=null;
                dblookgo[i].Enabled:=false;
             end;
          //End If

          //------------Базовая строка (ставится по 1-му фильтру)
          if i=1 then
             basestr:=' where A.'+dblookgo[i].KeyField+'<>0 ';
          //endif

          //---------------------------------------Чек фильтра стоит
          If (Checkgo[i].Checked=true) Then
             begin
                dblookgo[i].Enabled:=false;
                If dblookgo[i].Keyvalue<>null Then
                   begin
                      flfld:=filt_lookfld[i];
                      //--------------------Присвоение текущего значения фильтра
                      //-----------------------Тектовый ключ
                      if dsgo[i].tag=777 then
                         filstr[i]:= ' and A.'+flfld+'='+chr(39) +
                         vartostr(dblookgo[i].KeyValue) + chr(39)
                      else
                      //-----------------------Ключ типа дата
                      if dsgo[i].tag=778 then
                         if IS_ENG=false then
                            filstr[i]:= ' and A.'+flfld+'=CDate(' +
                            chr(39)+vartostr(dblookgo[i].KeyValue)+chr(39)+')'
                         else
                            filstr[i]:= ' and A.'+flfld+'=CDate(' +
                            chr(39)+vartostr(dblookgo[i].KeyValue)+chr(39) +')'
                         //endif
                      else
                      //-----------Числовой ключ
                         filstr[i]:= ' and A.'+flfld+'=' +vartostr(dblookgo[i].KeyValue) + ' ';
                      //endif
                   end;
               //End If
             end;
          //End If
      end;
   //endfor

   //-------------------------------------------------------------
   //                      Заполнение Спец--Фильтров
   //-------------------------------------------------------------
   spec_filter:='';
   spec_filter1:='';
   for i:=1 to nfilters_spec do
      begin
         if check_spec[i].checked=true then
            begin
               //---------------------Фильтры для основного набора
               spec_filter:=spec_filter+fil_spec[i];

               //-------------------------Фильтры для Combos
               if CHECK_SPEC[i].Tag<>999 then
                  spec_filter1:=spec_filter1+fil_spec[i];
               //endif
            end;
         //endif
      end;
   //endfor


   GlFilter_el:='';
   //--------------------------Заполнение фильтра (combos)
   for i:=1 to nfilters do
      begin
         GlFilter_el:=GlFilter_el+filstr[i];
      end;
   //endfor
   
   glfilter:=GlFilter_el+' '+spec_filter+' '+user_filter+' '+input_filter;

   //------------------------------------------------------------------
   //                    Заполнение зависимых фильтров
   //------------------------------------------------------------------
   for i:=1 to nfilters do
      begin
          zavfilter[i]:=basestr;

          //-----------------------Присвоение значений фильтров
          for j:=1 to nfilters do
             begin
                if i<>j then
                   begin
                      zavfilter[i]:=zavfilter[i]+filstr[j];
                   end;
                //endif
             end;
          //endfor
          //-------------------Присвоение значений спецфильтров
          zavfilter[i]:=zavfilter[i]+spec_filter1;
          zavfilter[i]:=zavfilter[i]+input_filter;
      end;
   //endfor

   //-----------------------------------------------------------
   //           Если группировка не уст, заполняем список полей
   //-----------------------------------------------------------
   if aggreg=false then
      begin
         viewflds:='';
         //----------------------------------
         for i:=1 to nfields do
            begin
               if i<>1 then
                  viewflds:=viewflds+',';
               //endif

               viewflds:=viewflds+'A.'+mainfld_go[i];
            end;
         //endfor
         //----------------------------------
         for i:=1 to ndopfields do
            begin
               if nfields<>0 then
                  viewflds:=viewflds+',';
               //endif

               viewflds:=viewflds+'A.'+dopfld_go[i];
            end;
         //endfor
      end;
   //endif

   //-----------------------------------------------------------
   //         Вычисление текущей сортировки
   //-----------------------------------------------------------
   actualsort:=' ORDER BY ';
   for i:=1 to nsorts do
      begin
         if (actualsort<>' ORDER BY ') and
            (mainfld_sort[sort_fldnums[i]]<>'') then
            actualsort:=actualsort+',';
         //endif
         actualsort:=actualsort+mainfld_sort[sort_fldnums[i]];
      end;
   //endfor
   if actualsort=' ORDER BY ' then
      actualsort:='';
   //endif

   //----------------------------------------------------------
   //           Окончательное формирование запроса
   //----------------------------------------------------------
   //-----         Режим группировки не установлен
   //----------------------------------------------------------
   if aggreg=false then
      begin
         //--------------------Не запрашивать RowID
         TMP_SQL:='SELECT '+viewflds+
         ' FROM '+TABGO+' A '+basestr+
         glfilter+actualsort;
      end
   else
      //----------------------------------------------------------
      //--------        Установлен режим группировки
      //----------------------------------------------------------
      begin
         if (AGGR_FLDS='') or (VIEWFLDS='') then
            unistr:=''
         else
            unistr:=',';
         //endif

         if VIEWFLDS<>'' then
            unistr1:=' GROUP BY '
         else
            unistr1:='';
         //endif

         TMP_SQL:='SELECT '+VIEWFLDS+unistr+AGGR_FLDS+
         ' FROM '+TABGO+' A '+basestr+glfilter+
         unistr1+VIEWFLDS+actualsort;
      end;
   //endif

   //-----------------------------------------------------------
   //       Если запрос изменился, перезапрос
   //-----------------------------------------------------------
   IF Trim(ORAQUERY1.SQL.TEXT)<>Trim(TMP_SQL) then
      begin
         ORAQUERY1.Close;
         ORAQUERY1.SQL.Text:=TMP_SQL;
         oraquery1.Open;
      END;
   //ENDIF

   //---------------------Связывание доп. полей (Скрыты из-за разницы в запросах)
   for i:=1 to ndopfields do
      db_dopfld[i].DataSource:=DATASOURCE1;
   //endfor

   DBGRIDEH1.Refresh;
   DBGRIDEH1.SetFocus;

   updstate_child;

   screen.Cursor:=crDefault;
end;


//--------------------------------------------------------------------------
//         Часть обновления, выполняемая в формах-потомках
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.updstate_child;
begin
//
end;

//--------------------------------------------------------------------------
//          Часть процедуры закрытия, выполняемая в потомках
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.close_child;
begin
//
end;

//--------------------------------------------------------------------------
//                      Отображение формы
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.FormShow(Sender: TObject);
begin
   //------------------Инициализация формы
   if IS_INITIALIZED=false then
      begin
         application.MessageBox('Ошибка. Форма не инициализирована','sys',0);
         self.Close;
         exit;
      end;
   //endif

   //--------------------------------
   IF CONNECT_TRY=false then
      begin
         self.Close;
         exit;
      end;
   //endif

   updstate(self);
end;

//--------------------------------------------------------------------------
//        Проверка соединения
//--------------------------------------------------------------------------
function TFormBaseV_ALT.CONNECT_TRY:boolean;
var
   RET_CONN:boolean;

begin
   RET_CONN:=TRUE;

   //-------------------------------------------------------
   //       Проверка доступности источника данных
   //-------------------------------------------------------
   try
      //----------------------
      ORAQUERY3.SQL.Text:='SELECT * FROM '+TABGO+
      ' A where A.'+dblookgo[1].KeyField+'=0 ';
      ORAQUERY3.Open;
   except
      screen.Cursor:=crDefault;
      RET_CONN:=false;
      application.MessageBox
      ('Ошибка. Недостаточно прав для просмотра.','sys',0);
   end;

   ORAQUERY3.Close;
   //-------------------------------------------------------
   CONNECT_TRY:=RET_CONN;
end;

//--------------------------------------------------------------------------
//                       Оформление формы
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);
var
   labgo:tlabel;

   filt_id:string;
   filt_name:string;
   filt_dopid:string;
   filt_tab:string;
   filt_lookup:string;
   filt_descr:string;

   i:integer;
   top_offset:integer;
   left_offset:integer;
   otherform_go:TButton;
   ngroup_go:integer;
   Glob_item:TMenuItem;

   FREEPOS:INTEGER;
   tmp_width:integer;
   tmp_sort:integer;
   pcLCA:array[0..20] of Char;

begin
    frm_Dialog:=TFormInDialog.Create(Application);
    //---------------------------------------------------------
    //         Оформление формы
    //---------------------------------------------------------
    oraquery1.Connection:=GLSESSION;
    oraquery2.Connection:=GLSESSION;
    oraquery3.Connection:=GLSESSION;
    oraquery_COP.Connection:=GLSESSION;

    //---------------------------------------------------------
    N1.Caption:='Фильтр по выделенному';
    N6.Caption:='Фильтр, исключая выделенное';
    LIKE1.Caption:='Фильтр (Like) по выделенному';
    TEST1.Caption:='Применить Like';
    LIKEEXCLUDE1.Caption:='Применить Like Exclude';
    N2.Caption:='X Снять фильтр';
    N3.Caption:='Упорядочить по возрастанию';
    N5.Caption:='Упорядочить по убыванию';
    X1.Caption:='X Снять сортировку';
    //---------------------------------------------------------

    IS_INITIALIZED:=true;
    //-------------------------------------------ENG формат дат
    if (GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SSHORTDATE,pcLCA,19)<=0) then
       pcLCA[0]:=#0;
    //endif
    if (pcLCA='M/d/yyyy') or (pcLCA='MM/dd/yyyy') then
       IS_ENG:=true;
    //endif

    //---------------------------------------------------------
    user_filter:='';
    nfields:=0;
    ndopfields:=0;
    nfilters:=0;
    nfilters_spec:=0;
    ngroup_go:=0;
    nofgroups:=0;
    nsorts:=0;
    nbuttons_move:=0;
    self_min_width:=0;

    is_check_group_short:=false;
    IS_QUERY:=false;

    //-------------------------Основная сортировка
    actualsort:='';

    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and GLCODE=3';
    oraquery2.Open;

    //-----------------------------Ключевое поле в запросе на редактирование
    tabgo_KeyEdit:=ORAQUERY2.Fields.FIELDBYNAME('CAPGROUP').AsString;

    //---------------------------UpdatingTable для редактирования
    tabgo_UpdatingTable:=ORAQUERY2.Fields.FIELDBYNAME('DESCRIPTION').AsString;

    //----------------------------Сопряженная форма редактирования
    n_form_edit:=ORAQUERY2.Fields.FIELDBYNAME('COLOR').AsInteger;

    //----------------------------Если описание формы редактирования
    if ORAQUERY2.Fields.FIELDBYNAME('BOLD').AsInteger=2 then
       begin
          Application.MessageBox('Ошибка: описание формы для класса Edit','sys',0);
          close;
       end;
    //endif
    oraquery2.close;

    //----------------------------------Таблица источник
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and GLCODE=2';
    oraquery2.Open;

    FORM_SERVER:=ORAQUERY2.Fields.FIELDBYNAME('FLDNAME').AsString;
    FORM_SHEM:=ORAQUERY2.Fields.FIELDBYNAME('CAPTION').AsString;

    //---------------------Если пользователь-пароль для формы указаны явно
    //                     подключиться по явному указанию

    if (ORAQUERY2.Fields.FIELDBYNAME('CAPGROUP').AsString<>'NA') AND
       (IS_FORM_PASS=FALSE) THEN
       begin
          FORM_USER:=ORAQUERY2.Fields.FIELDBYNAME('DESCRIPTION').AsString;
          FORM_PASSWORD:=ORAQUERY2.Fields.FIELDBYNAME('CAPGROUP').AsString;
       end;
    //ENDIF

    //-------------------------Имя таблицы (Вьюшки) с указанием схемы
    //                       Если схема определена
    if FORM_SHEM<>'' THEN
       TABGO:=FORM_SHEM+'.'+ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString
    ELSE
       TABGO:=ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;
    //ENDIF
    FORM_TABLE:=ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;

    //--------------------------Признак -(сокращенные расст чеков групп.)
    if ORAQUERY2.Fields.FIELDBYNAME('COLOR').AsINTEGER=1 THEN
       is_check_group_short:=TRUE;
    //ENDIF

    //--------------------------Признак - В качестве источника данных
    //                          Используется запрос
    if ORAQUERY2.Fields.FIELDBYNAME('BOLD').AsINTEGER=1 THEN
       IS_QUERY:=TRUE;
    //ENDIF

    //--------------------------Признак - не включать
    //                          в запрос ROWID
    if ORAQUERY2.Fields.FIELDBYNAME('BKCOLOR').AsINTEGER=1 THEN
       IS_ROWID:=FALSE;
    //ENDIF
    oraquery2.Close;

    //--------------------Кэпшен формы
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and GLCODE=1';
    oraquery2.Open;
    self.Caption:=ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;

    //---------------------Источник данных для автофильтра
    tabgo_filter:=ORAQUERY2.Fields.FIELDBYNAME('FLDNAME').AsString;
    oraquery2.Close;

    //---------------------------линии расстановки
    label2.Width:=self.width-20;
    label2.Height:=18;
    label3.Width:=self.Width-20;
    label3.Height:=18;

    //-----------------------------------------------------------
    //                    Оформление основного набора полей
    //-----------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and showcode=1 order by showorder';
    oraquery2.Open;

    DBGRIDEH1.Columns.Clear;

    //--------------------------------------------------------------------------------
    while not(oraquery2.Eof) do
       begin
          //------------------------------------Поля

          nfields:=nfields+1;
          //-------------------------------Значение поля
          mainfld_go[nfields]:=oraquery2.Fields.fieldbyname('FLDNAME').AsString;
          mainfld_caption[nfields]:=oraquery2.Fields.fieldbyname('CAPTION').AsString;

          //-------------------Вхождение поля в группировку
          mainfld_group[nfields]:=oraquery2.Fields.fieldbyname('NGROUP').AsINTEGER;

          //---------------------------Оформление колонок и заголовков
          DBGRIDEH1.Columns.ADD;
          DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].FieldName:=mainfld_go[nfields];
          DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].Title.Caption:=
          oraquery2.Fields.fieldbyname('CAPTION').AsString;
          DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].Alignment:=taLeftJustify;

          //-------------------Закрепление за полем номера колонки грида
          mainfld_ncolumn[nfields]:=DBGRIDEH1.Columns.Count-1;

          //------------------Признак допустимости редактирования поля
          //                  (для класса - потомка)
          mainfld_isedit[nfields]:=oraquery2.Fields.fieldbyname('IS_EDIT').AsInteger;

          //-------------------Поля типа BOOLEAN
          if oraquery2.Fields.fieldbyname('IS_BOOLEAN').Asinteger=-1 then
             begin
                DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].Checkboxes:=true;
                DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].KeyList.ADD('-1');
                DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].KeyList.ADD('0');
             end;
          //endif
          //-------------------Числовые поля с разделением знаков
          if oraquery2.Fields.fieldbyname('BKREPORT').Asinteger=20 then
             DBGRIDEH1.COLUMNS[DBGRIDEH1.Columns.Count-1].DisplayFormat:='#,#.##';
          //endif

          //--------------------------Блокирование полей
          DBGRIDEH1.Columns[DBGRIDEH1.Columns.Count-1].readonly:=true;

          //-----------------------------------Ширина полей
          IF oraquery2.Fields.fieldbyname('WIDTH').AsInteger=0 then
             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Width:=40
          else
             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Width:=
             oraquery2.Fields.fieldbyname('WIDTH').AsInteger;
          //endif

          //------------------Поправка на 800x600
          if screen.width=800 then
             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Width:=
             round(DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Width/1.3);
          //endif

          //------------------------------
          if oraquery2.Fields.fieldbyname('COLOR').AsInteger<>0 THEN
             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Font.COLOR:=
             oraquery2.Fields.fieldbyname('COLOR').AsInteger;
          //ENDIF

          //------------------------------
          if oraquery2.Fields.fieldbyname('BKCOLOR').AsInteger<>0 THEN
             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].COLOR:=
             oraquery2.Fields.fieldbyname('BKCOLOR').AsInteger;
          //ENDIF

          //------------------------------
          if oraquery2.Fields.fieldbyname('BOLD').AsInteger<>0 THEN

             DBGRIDEH1.COLUMNS [DBGRIDEH1.Columns.Count-1].Font.STYLE:=[fsBold];
          //ENDIF

          //----------------------------------------------------
          //         Включение total в колонку
          //----------------------------------------------------
          if oraquery2.Fields.FieldByName('TOTALCODE').AsInteger<>0 THEN
             BEGIN
                DBGRIDEH1.COLUMNS[DBGRIDEH1.Columns.Count-1].Footer.DisplayFormat:='#,#.##';
                //----------------Заполнение строки поля аггрегирования
                if oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=1 THEN
                   begin
                      DBGRIDEH1.COLUMNS[DBGRIDEH1.Columns.Count-1].Footer.ValueType:=fvtSum;
                   end;
                //endif

                if oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=2 THEN
                   begin
                      DBGRIDEH1.COLUMNS[DBGRIDEH1.Columns.Count-1].Footer.ValueType:=fvtAvg;
                   end;
                //endif

                if oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=3 THEN
                   begin
                      DBGRIDEH1.COLUMNS[DBGRIDEH1.Columns.Count-1].Footer.ValueType:=fvtCount;
                   end;
                //endif
             END;
          //ENDIF
          oraquery2.Next;
       end;
    //wend
    oraquery2.close;

    //---------------------------------------------------------
    //      Оформление дополнительного набора полей
    //---------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and showcode=2 order by showorder';
    oraquery2.Open;

    top_offset:=(sender as TFormBaseV_ALT).Height-120;
    left_offset:=5;
    i:=0;
    //-------------------------------------------
    while not(oraquery2.Eof) do
       begin
          //-------------------------------Оформление подписи
          labgo:=TLabel.create(sender as TFormBaseV_ALT);
          labgo.Left:=left_offset;
          labgo.Top:=top_offset;
          labgo.Caption:=oraquery2.Fields.fieldbyname('CAPTION').AsString;
          labgo.Color:= 10388870;
          labgo.Font.Color:=clWhite;
          labgo.Anchors:=[akBottom,akleft] ;
          labgo.Parent:=(sender as TFormBaseV_ALT);
          labgo.Width:=100;
          labgo.Height:=21;

          ndopfields:=ndopfields+1;
          //--------------------------------Оформление поля
          db_dopfld[ndopfields]:=tdbtext.Create(sender as TFormBaseV_ALT);
          db_dopfld[ndopfields].Top:=top_offset;
          db_dopfld[ndopfields].Left:=left_offset+105;
          db_dopfld[ndopfields].Height:=21;
          db_dopfld[ndopfields].Visible:=true;
          db_dopfld[ndopfields].DataSource:=datasource1;
          db_dopfld[ndopfields].Color:=clWhite;
          db_dopfld[ndopfields].Anchors :=[akBottom,akleft];

          //---------------------------------
          dopfld_go[ndopfields]:=oraquery2.Fields.fieldbyname('FLDNAME').AsString;
          dopfld_caption[ndopfields]:=oraquery2.Fields.fieldbyname('CAPTION').AsString;

          //-------------------------------Значение поля
          db_dopfld[ndopfields].datafield:=dopfld_go[ndopfields];
          //--------------------------------Вхождение поля в группировку
          dopfld_group[ndopfields]:=oraquery2.Fields.fieldbyname('NGROUP').AsINTEGER;


          if oraquery2.Fields.fieldbyname('BKCOLOR').asinteger<>0 THEN
             db_dopfld[ndopfields].Color:=oraquery2.Fields.fieldbyname('BKCOLOR').asinteger;
          //ENDIF

          if oraquery2.Fields.fieldbyname('COLOR').asinteger<>0 THEN
             db_dopfld[ndopfields].FONT.COLOR:=oraquery2.Fields.fieldbyname('COLOR').asinteger;
          //ENDIF

          //---------------поправка на 800x600
          if (oraquery2.Fields.fieldbyname('WIDTH').asinteger<>0) and
             (screen.Width<>800) then
              db_dopfld[ndopfields].WIDTH:=oraquery2.Fields.fieldbyname('WIDTH').asinteger
          else
             db_dopfld[ndopfields].Width:=130;
          //ENDIF

          if oraquery2.Fields.fieldbyname('BOLD').asinteger<>0 THEN
             db_dopfld[ndopfields].Font.Style:= [fsBold];
          //ENDIF

          db_dopfld[ndopfields].parent:=sender as TFormBaseV_ALT;

          top_offset:=top_offset+25;
          oraquery2.Next;

          i:=i+1;
          if i>=3 then
             begin
                top_offset:=(sender as TFormBaseV_ALT).Height-120;
                left_offset:=left_offset+240;
                i:=0;
             end;
          //endif
       end;
    //wend
    oraquery2.close;

    left_offset:=20;
    top_offset:=35;
    tmp_width:=0;
    tmp_sort:=0;

    //---------------------------------------------------------------
    //            Оформление фильтров
    //---------------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and nfilter<>0 and nfilter<1000 order by nfilter,flagfilter';
    oraquery2.Open;

    while not(oraquery2.Eof) do
       begin
          IF oraquery2.fields.FieldByName('FLAGFILTER').AsInteger=1 then
             begin
                //-------------------------Ключевое поле фильтра
                filt_id:=oraquery2.Fields.fieldbyname('FLDNAME').AsString;

                //------------------------Расширенное поле фильтра
                if oraquery2.fields.FieldByName('BOLD').AsInteger=2 then
                   tmp_width:=300
                else
                   tmp_width:=200;
                //endif

                //------------------------Обратный порядок сортировки
                if oraquery2.fields.FieldByName('COLOR').AsInteger=2 then
                   tmp_sort:=2
                else
                   tmp_sort:=1;
                //endif
             end
          else
          //------------------------------------------------------
          //       Найдено поле текста фильтра
          //------------------------------------------------------
             begin
                nfilters:=nfilters+1;
                //--------------2-я строка
                if nfilters=11 then
                   begin
                      left_offset:=20;
                      top_offset:=55;
                   end;
                //endif

                //-------------------------------Поле отображения
                filt_name:=oraquery2.Fields.fieldbyname('FLDNAME').AsString;

                //-------------------------------Текст базового запроса
                LABFIL[nfilters]:=TLabel.Create(sender as TFormBaseV_ALT);
                LABFIL2[nfilters]:=TLabel.Create(sender as TFormBaseV_ALT);

                LABFIL[nfilters].Caption:= 'select '+filt_id+','+filt_name+
                ' as DOP_TX from '+TABGO_FILTER+' A ';

                if TMP_SORT=2 then
                   LABFIL2[nfilters].Caption:=
                   ' GROUP BY '+filt_id+','+filt_name+' ) ORDER BY 2 DESC'
                else
                   LABFIL2[nfilters].Caption:=
                   ' GROUP BY '+filt_id+','+filt_name+' ) ORDER BY 2';
                //endif

                //-------------------------------- запрос фильтра
                oraqgo[nfilters]:=TADOquery.create(sender as TFormBaseV_ALT);
                oraqgo[nfilters].connection:=oraquery1.connection;

                //---------------------------------Датасет
                dsgo[nfilters]:=TDatasource.Create(sender as TFormBaseV_ALT);
                dsgo[nfilters].DataSet:=oraqgo[nfilters];

                //------------------------Чек фильтра
                checkgo[nfilters]:=TCheckbox.Create(sender as TFormBaseV_ALT);

                if nfilters>=11 then
                   checkgo[nfilters].Left:=left_offset+68
                else
                   checkgo[nfilters].Left:=left_offset-12;
                //endif

                checkgo[nfilters].Top:=top_offset;
                checkgo[nfilters].Parent:=sender as TFormBaseV_ALT;
                checkgo[nfilters].Checked:=false;

                //--------------Ключ текстовый!
                if oraquery2.fields.FieldByName('FLAGFILTER').AsInteger=3 then
                   dsgo[nfilters].Tag:=777
                else
                //--------------Ключ типа дата
                if oraquery2.fields.FieldByName('FLAGFILTER').AsInteger=4 then
                   dsgo[nfilters].Tag:=778
                else
                   dsgo[nfilters].Tag:=0;
                //endif

                //----------------------------Тэг указывающий на номер
                //                фильтра обновление которого будет проведено
                CHECKGO[NFILTERS].Tag:=NFILTERS;
                checkgo[nfilters].OnClick:=updstate_FILTER;

                //-------------------------------------------Комбо фильтра
                dblookgo[nfilters]:=TdblookupComboBoxEh.Create(sender as TFormBaseV_ALT);
                dblookgo[nfilters].Top:=top_offset;
                dblookgo[nfilters].Width:=80;

                if nfilters>=11 then
                   dblookgo[nfilters].left:=left_offset+80
                else
                   dblookgo[nfilters].left:=left_offset;
                //end if

                dblookgo[nfilters].ListSource:=dsgo[nfilters];
                dblookgo[nfilters].KeyField:=filt_id;
                dblookgo[nfilters].ListField:='DOP_TX';
                dblookgo[nfilters].DropDownBox.Width:=tmp_width;
                dblookgo[nfilters].DropDownBox.Rows:=30;
                dblookgo[nfilters].Parent:=sender as TFormBaseV_ALT;

                //----------------------------Тэг указывающий на номер
                //                фильтра обновление которого будет проведено
                dblookgo[NFILTERS].Tag:=NFILTERS;
                dblookgo[nfilters].OnCloseUp:=DBLookupComboboxEh1CloseUp;

                //--------------------Поле для фильтрации в осн наборе
                filt_lookfld[nfilters]:=filt_id;

                //-----------------------------------------Подпись фильтра
                labgo:=tlabel.Create(sender as TFormBaseV_ALT);
                if nfilters>=11 then
                   begin
                      labgo.Top:=top_offset;
                      labgo.Left:=left_offset;
                   end
                else
                   begin
                      labgo.Top:=20;
                      labgo.Left:=left_offset;
                   end;
                //endif
                LABGO.Color:=9400939;
                LABGO.Font.Color:=clWhite;
                
                labgo.Caption:=oraquery2.Fields.fieldbyname('CAPTION').AsString;;
                labgo.Parent:=sender as TFormBaseV_ALT;
                LABGO.Width:=80;

                //------------------------------------------------------
                //    Оформление сортировок (только для главн. полей)
                //------------------------------------------------------
                if (FLDMASNUM(filt_name)<>0) and (nfilters<11) then
                   begin
                      //------------------Кнопка сортировки по возрастанию
                      sort_ascBut[nfilters]:=TSpeedButton.create(sender as TFormBaseV_ALT);
                      sort_ascBut[nfilters].top:=2;
                      sort_ascBut[nfilters].left:=left_offset;
                      sort_ascBut[nfilters].Height:=18;
                      sort_ascBut[nfilters].Width:=25;
                      sort_ascBut[nfilters].tag:=nfilters;
                      sort_ascBut[nfilters].Flat:=TRUE;
                      sort_ascBut[nfilters].Glyph:=SpeedButton1.glyph;
                      sort_ascBut[nfilters].OnClick:=asc_filtergo;
                      sort_ascBut[nfilters].Parent:=sender as TFormBaseV_ALT;

                      //--------------------Кнопка сортировки по убыванию
                      sort_descBut[nfilters]:=TSpeedButton.create(sender as TFormBaseV_ALT);
                      sort_descBut[nfilters].top:=2;
                      sort_descBut[nfilters].left:=left_offset+25;
                      sort_descBut[nfilters].Height:=18;
                      sort_descBut[nfilters].Width:=25;
                      sort_DescBut[nfilters].Tag:=nfilters;
                      sort_DESCBut[nfilters].Flat:=TRUE;
                      sort_DESCBut[nfilters].Glyph:=SpeedButton2.glyph;
                      sort_DescBut[nfilters].OnClick:=desc_FilterGo;
                      sort_descBut[nfilters].Parent:=sender as TFormBaseV_ALT;

                      //----------------------Запрос сортировки
                      sort_ascgo[nfilters]:=filt_name;
                   end;
                //endif

                //----------------------------------
                if nfilters>=11 then
                   left_offset:=left_offset+175
                else
                   left_offset:=left_offset+95;
                //endif
                //---------------------------------
                if left_offset>self_min_width then
                   self_min_width:=left_offset;
                //endif
            end;
          //endif
          oraquery2.Next;
       end;
    //wend
    oraquery2.close;

    //---------------------------------------------------------------
    //            Оформление фильтров  с запросами к справочникам
    //---------------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and nfilter<>0 and nfilter>=1000 order by nfilter,flagfilter';
    oraquery2.Open;

    while not(oraquery2.Eof) do
       begin
          nfilters:=nfilters+1;

          LABFIL[nfilters]:=TLabel.Create(sender as TFormBaseV_ALT);
          LABFIL2[nfilters]:=TLabel.Create(sender as TFormBaseV_ALT);

          //------------------------------------------------------Поле основного ключа
          filt_id:= oraquery2.Fields.fieldbyname('FLDNAME').AsString;
          //------------------------------------------------------Поле ключа справочника
          filt_dopid:= oraquery2.Fields.fieldbyname('TABNAME').AsString;
          //------------------------------------------------------Поле таблицы справочника
          filt_tab:= oraquery2.Fields.fieldbyname('CAPTION').AsString;
          //------------------------------------------------------Поле отображения
          filt_name:=oraquery2.Fields.fieldbyname('CAPGROUP').AsString;
          //------------------------------------------------Подпись фильтра
          filt_descr:=oraquery2.Fields.fieldbyname('DESCRIPTION').AsString;

          //------------------------Расширенное поле фильтра
          if oraquery2.fields.FieldByName('BOLD').AsInteger=2 then
             tmp_width:=300
          else
             tmp_width:=200;
          //endif

          //------------------------Обратный порядок сортировки
          if oraquery2.fields.FieldByName('COLOR').AsInteger=2 then
             tmp_sort:=2
          else
             tmp_sort:=1;
          //endif

          //-------------------------------Текст базового запроса
          LABFIL[nfilters].Caption:=
          'select B.'+filt_DOPID+', B.'+filt_NAME+
          ' AS DOP_TX from '+filt_tab+' AS B WHERE B.'+
          filt_DOPID+' IN (SELECT '+filt_ID+' FROM '+TABGO_FILTER+' AS A ';

          //-----------------------------Учитываем порядок сортировки
          if TMP_SORT=2 then
             LABFIL2[nfilters].CAPTION:=' )) ORDER BY 2 DESC'
          else
             LABFIL2[nfilters].CAPTION:=' )) ORDER BY 2';
          //endif
          //----------------------------------Тэг, указывающий на характер фильтра
          labFIL[nfilters].Tag:=888;

          //-------------------------------- запрос фильтра
          oraqgo[nfilters]:=TADOquery.create(sender as TFormBaseV_ALT);
          oraqgo[nfilters].connection:=oraquery1.connection;

          //---------------------------------Датасет
          dsgo[nfilters]:=TDatasource.Create(sender as TFormBaseV_ALT);
          dsgo[nfilters].DataSet:=oraqgo[nfilters];

          //------------------------Чек фильтра
          checkgo[nfilters]:=TCheckbox.Create(sender as TFormBaseV_ALT);
          checkgo[nfilters].Left:=left_offset-12;
          checkgo[nfilters].Top:=35;
          checkgo[nfilters].Parent:=sender as TFormBaseV_ALT;
          checkgo[nfilters].Checked:=false;

          //----------------------------Тэг указывающий на номер
          //                 фильтра,обновление которого будет проведено
          CHECKGO[NFILTERS].Tag:=NFILTERS;
          checkgo[nfilters].OnClick:=updstate_FILTER;

          //-------------------------------------------Комбо фильтра
          dblookgo[nfilters]:=TdblookupComboBoxEh.Create(sender as TFormBaseV_ALT);

          dblookgo[nfilters].Top:=35;
          dblookgo[nfilters].Width:=80;
          dblookgo[nfilters].left:=left_offset;
          dblookgo[nfilters].ListSource:=dsgo[nfilters];
          dblookgo[nfilters].KeyField:=filt_DOPid;
          dblookgo[nfilters].ListField:='DOP_TX';
          dblookgo[nfilters].DropDownBox.Width:=tmp_width;
          dblookgo[nfilters].DropDownBox.Rows:=30;
          dblookgo[nfilters].Parent:=sender as TFormBaseV_ALT;

          //----------------------------Тэг указывающий на номер
          //                фильтра обновление которого будет проведено
          dblookgo[NFILTERS].Tag:=NFILTERS;
          dblookgo[nfilters].OnCloseUp:=DBLookupComboboxEh1CloseUp;

          //--------------------Поле для фильтрации в осн наборе
          filt_lookfld[nfilters]:=filt_id;
          
          //oraqgo[nfilters].Open;
          //dblookgo[nfilters].Enabled:=false;

          //-----------------------------------------Подпись фильтра
          labgo:=tlabel.Create(sender as TFormBaseV_ALT);
          labgo.Top:=20;
          LABGO.Color:=9400939;
          LABGO.Font.Color:=clWhite;
          labgo.Left:=left_offset;
          labgo.Caption:=filt_descr;
          labgo.Parent:=sender as TFormBaseV_ALT;
          LABGO.Width:=80;

          left_offset:=left_offset+95;
          //---------------------------------
          if left_offset>self_min_width then
             self_min_width:=left_offset;
          //endif
        
          oraquery2.Next;
       end;
    //wend
    oraquery2.close;

    //------------------------------------------------------------------
    //         Оформление дополнительных фильтров
    //------------------------------------------------------------------

    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and glcode=4 order by showorder';
    oraquery2.Open;
    left_offset:=5;
    while not(oraquery2.Eof) do
       begin
          nfilters_spec:=nfilters_spec+1;
          //--------------------------------------Чек дополнительного фильтра
          check_spec[nfilters_spec]:=TCheckbox.create(sender as TFormBaseV_ALT);
          check_spec[nfilters_spec].Left:=left_offset;
          check_spec[nfilters_spec].Width:=15;
          check_spec[nfilters_spec].Top:=78;
          CHECK_SPEC[nfilters_spec].Parent:=sender as TFormBaseV_ALT;

          //------------------------Предустановленные фильтры
          if oraquery2.fields.fieldbyname('BOLD').AsInteger=1 THEN
             CHECK_SPEC[nfilters_spec].Checked:=TRUE
          else
             CHECK_SPEC[nfilters_spec].Checked:=false;
          //endif

          CHECK_SPEC[nfilters_spec].OnClick:=updstate;

          //--------------Фильтры не действующие на запросы комбо-фильтров
          if oraquery2.fields.fieldbyname('COLOR').AsInteger=1 THEN
             begin
                CHECK_SPEC[nfilters_spec].Tag:=999;
                CHECK_SPEC[nfilters_spec].Color:=$000000AA;
             end
          else
             CHECK_SPEC[nfilters_spec].Tag:=0;
          //endif

          //---------------------------------------Запрос фильтра
          fil_spec[nfilters_spec]:=oraquery2.fields.fieldbyname('FLDNAME').ASSTRING;
          //---------------------------------------Подпись дополнительного фильтра
          Labgo:=TLabel.Create(sender as TFormBaseV_ALT);
          labgo.Top:=78;
          labgo.Left:=left_offset+15;
          labgo.Color:=ClInfoBk;
          labgo.Caption:=oraquery2.Fields.fieldbyname('TABNAME').AsString;
          LABGO.PARENT:=sender as TFormBaseV_ALT;

          left_offset:=left_offset+100;
          //------------------------------
          if left_offset>self_min_width then
             self_min_width:=left_offset;
          //endif
          Oraquery2.Next;
       end;
    //wend
    oraquery2.Close;

    //-----------------------------------------------------
    //       Оформление ссылок на другие формы
    //-----------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and glcode=5 order by nfilter';
    oraquery2.Open;

    left_offset:=panel1.Left+5;
    while not(oraquery2.Eof) do
       begin
           nbuttons_move:=nbuttons_move+1;

           button_move[nbuttons_move]:=TButton.Create(sender as TFormBaseV_ALT);
           button_move[nbuttons_move].Left:=left_offset;
           button_move[nbuttons_move].Top:= panel1.Top+4;
           button_move[nbuttons_move].width:=50;
           button_move[nbuttons_move].Height:=25;
           button_move[nbuttons_move].Caption:=oraquery2.fields.fieldbyname('TABNAME').AsString;
           button_move[nbuttons_move].Parent:=sender as TFormBaseV_ALT;
           button_move[nbuttons_move].anchors:=[akRight,akBottom];
           button_move[nbuttons_move].Tag:= oraquery2.fields.fieldbyname('BOLD').Asinteger;
           button_move[nbuttons_move].OnClick:=otherform;

           left_offset:=left_offset+55;

           //-------------Установка защиты от несанкц. доступа на ссылки
           //if (Form_frmLIST.GL_all_forms[otherform_go.Tag]=100) then
           //   otherform_go.Enabled:=true
           //else
           //   otherform_go.Enabled:=false;
           //endif

           oraquery2.Next;
       end;
    //wend
    oraquery2.close;

    //-----------------------------------------------------------------
    //             Оформление группировок
    //-----------------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from form_descs where nform='+inttostr(n_form)+
    ' and ngroup<>0 and ngroup<=1000 and capgroup is not null';
    oraquery2.Open;

    left_offset:=10;
    //--------------------------
    while not(oraquery2.Eof) do
       begin
          if oraquery2.Fields.FieldByName('NGROUP').AsInteger<>NGROUP_GO THEN
             begin
                NGROUP_GO:=oraquery2.Fields.FieldByName('NGROUP').AsInteger;
                nofgroups:=nofgroups+1;
                //-------------------------Чек группировки
                checkgr[nofgroups]:=TCheckbox.Create(sender as TFormBaseV_ALT);
                checkgr[nofgroups].Caption:=oraquery2.Fields.fieldbyname('CAPGROUP').AsString;
                checkgr[nofgroups].Left:=left_offset;
                checkgr[nofgroups].Checked:=false;
                
                checkgr[nofgroups].top:=97;

                if is_check_group_short=TRUE then
                   checkgr[nofgroups].width:=60
                else
                   checkgr[nofgroups].width:=90;
                //endif

                checkgr[nofgroups].height:=15;
                checkgr[nofgroups].OnClick:=updstate;
                checkgr[nofgroups].Parent:=(sender as TFormBaseV_ALT);
                //------------------------Номер группировки
                ngroup[nofgroups]:=NGROUP_GO;

                if is_check_group_short=TRUE then
                   left_offset:=left_offset+70
                else
                   left_offset:=left_offset+100;
                //endif
                //--------------------------------
                if left_offset>self_min_width then
                   self_min_width:=left_offset;
                //endif
             end;
          //endif
          oraquery2.Next;
       end;
    //wend
    oraquery2.Close;

    self_min_width:=self_min_width+10;

    //---------------------Путь врем. базы
    randomize;
    TMP_MDB_PATH:='MDB'+IntToStr(round(random*100000));
    IS_DIR_READY:=false;
end;



//--------------------------------Выбор произвольного фильтра
procedure TFormBaseV_ALT.DBLookupComboboxEh1CloseUp(Sender: TObject;
  Accept: Boolean);
begin
   updstate(sender);
   DBLookGo[(Sender as TDBLookupComboBoxEh).Tag].Enabled:=True;

end;



//------------------------------------------------------------
//                 Корректное закрытие формы
//------------------------------------------------------------
procedure TFormBaseV_ALT.FormClose(Sender: TObject; var Action: TCloseAction);
var
   i:integer;

begin
   //--------------------Закрытие основных запросов
   oraquery1.Close;
   oraquery2.Close;
   oraquery3.Close;
   oraquery_COP.Close;

   //----------------------Закрытие запросов фильтров
   for i:=1 to nfilters do
      oraqgo[i].Close;
   //endfor

   //----------------Закрытие в потомках
   close_child;

   //----------------Очистка временных файлов
   {$I-}
   if IS_DIR_READY=true then
      begin
         {M_1 chdir('c:\');
         chdir('c:\TMP_REP\'+TMP_MDB_PATH);
         deletefile('statdb.mdb');
         deletefile('FKO.xls');
         chdir('c:\TMP_REP');
         RMDIR(TMP_MDB_PATH);}

         chdir('\\buhmonster\TMP_REP\'+TMP_MDB_PATH);
         deletefile('statdb.mdb');
         deletefile('FKO.xls');
         chdir('\\buhmonster\TMP_REP');
         RMDIR(TMP_MDB_PATH);
      end;
   //endif
   {$I+}

   //---------------------Ликвидация формы
   action:=CaFree;
end;

//--------------------------------Закрытие формы
procedure TFormBaseV_ALT.Button3Click(Sender: TObject);
begin
   self.Close;
end;

//--------------------------------------------------------
//               Вывод отчетов в Excel
//--------------------------------------------------------
procedure TFormBaseV_ALT.BitBtn1Click(Sender: TObject);

begin
   SCREEN.Cursor:=crHourGlass;
   EXCEL_SCREEN(oraquery1.SQL.text,9);
   SCREEN.CURSOR:= CRDEFAULT;
end;

//-----------------------------------------------------------
//-------             Фильтр пользователя
//-----------------------------------------------------------
procedure TFormBaseV_ALT.Button1Click(Sender: TObject);
begin
   //---------------------------------------
   frm_Dialog.Memo1.Text:=Input_filter;
   //---------------------------------------
   if frm_Dialog.ShowModal=mrOk then
      Input_filter:=frm_Dialog.Memo1.Text;
   //end if
   //---------------------------------------
   updstate(sender);

end;
//----------------------------------Текущий запрос
procedure TFormBaseV_ALT.Button2Click(Sender: TObject);
begin
   frm_Dialog.Memo1.Text:=oraquery1.SQL.text;
   if frm_Dialog.ShowModal=mrOk then
      begin
         oraquery1.Close;
         oraquery1.SQL.Text:=frm_Dialog.Memo1.Text;
         oraquery1.Open;
      end;
   //endif
end;

//-----------------------------------------------------------
//--------                 Фильтр по выделенному
//-----------------------------------------------------------
procedure TFormBaseV_ALT.N1Click(Sender: TObject);
begin
   mainfld_filter[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
             ' and '+dbgrideh1.SelectedField.FieldName+
             '='+chr(39)+dbgrideh1.SelectedField.AsString+chr(39);
   updstate(sender);
end;

//-----------------------------------------------------------
//-------                Фильтр like по выделенному
//-----------------------------------------------------------
procedure TFormBaseV_ALT.Like1Click(Sender: TObject);

begin
   //--------------Шняга
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), 0, 0);
   keybd_event(Ord('C'), MapVirtualKey(Ord('C'), 0), 2, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 2, 0);
end;

//-----------------------------------------------------------
//-------                 фильтр like 2
//-----------------------------------------------------------
procedure TFormBaseV_ALT.test1Click(Sender: TObject);
begin
   mainfld_filter[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
             ' and ('+dbgrideh1.SelectedField.FieldName+
             ' like '+chr(39)+'%'+clipboard.astext+'%'+chr(39)+')';
             
   updstate(sender);
end;

//-----------------------------------------------------------
//--------              Фильтр, исключая выделенное
//-----------------------------------------------------------
procedure TFormBaseV_ALT.N6Click(Sender: TObject);
begin
   mainfld_filter[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
             ' and '+dbgrideh1.SelectedField.FieldName+
             '<>'+chr(39)+dbgrideh1.SelectedField.AsString+chr(39);
             
   updstate(sender);
end;

//-----------------------------------------------------------
//------               фильтр Like Exclude
//-----------------------------------------------------------
procedure TFormBaseV_ALT.likeexclude1Click(Sender: TObject);
begin
      mainfld_filter[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
      ' and not('+dbgrideh1.SelectedField.FieldName+
      ' like '+chr(39)+'%'+clipboard.astext+'%'+chr(39)+')';

   updstate(sender);
end;

//-----------------------------------------------------------
//-------                  Снять фильтр
//-----------------------------------------------------------
procedure TFormBaseV_ALT.N2Click(Sender: TObject);
var
   i:integer;
begin
   for i:=1 to nfields do
      begin
         mainfld_filter[i]:='';
      end;
   //enfor

   updstate(sender);
end;

//-----------------------------------------------------------
//------              Сортировка по возрастанию
//-----------------------------------------------------------
procedure TFormBaseV_ALT.N3Click(Sender: TObject);
begin
   nsorts:=nsorts+1;
   sort_fldnums[nsorts]:=FLDMASNUM(dbgrideh1.SelectedField.FieldName);

   mainfld_sort[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
                dbgrideh1.SelectedField.FieldName;
   updstate(sender);
end;

//-----------------------------------------------------------
//-------                Сортировка по убыванию
//-----------------------------------------------------------
procedure TFormBaseV_ALT.N5Click(Sender: TObject);
begin
   nsorts:=nsorts+1;
   sort_fldnums[nsorts]:=FLDMASNUM(dbgrideh1.SelectedField.FieldName);

   mainfld_sort[FLDMASNUM(dbgrideh1.SelectedField.FieldName)]:=
                dbgrideh1.SelectedField.FieldName+' DESC';
   updstate(sender);
end;

//-----------------------------------------------------------
//                     Снятие сортировки
//-----------------------------------------------------------
procedure TFormBaseV_ALT.X1Click(Sender: TObject);
begin
   CLEAR_USER_SORT;
end;

//----------------------------------------------------------
//            Заполнение totals
//----------------------------------------------------------
procedure TFormBaseV_ALT.Button4Click(Sender: TObject);

begin
  DBGRIDEH1.SumList.Active:=TRUE;
end;

//-------------------------------------------------------------------------
//          Поиск номера поля в массиве по названию
//-------------------------------------------------------------------------
function TFormBaseV_ALT.FLDMASNUM(FLDNAME:string):integer;
var
   i:integer;
   n_fld:integer;
begin
   n_fld:=0;
   for i:=1 to nfields do
      begin
         if mainfld_go[i]=FLDNAME then
            n_fld:=i;
         //endif
      end;
   //endfor

   FLDMASNUM:=n_fld;
end;

//--------------------------------------------------------------------------
//                 Очистка фильтра пользователя
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.CLEAR_USER_FILTER;
var
   i:integer;

begin
   for i:=1 to nfields do
      begin
         mainfld_filter[i]:='';
      end;
   //endfor
end;

//--------------------------------------------------------------------------
//              Очистка сортировки пользователя
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.CLEAR_USER_SORT;
var
   i:integer;

begin
   nsorts:=0;
   for i:=1 to nfields do
      begin
         mainfld_sort[i]:='';
      end;
   //endfor
end;

//--------------------------------------------------------------------------
//         Проверить корректность изменения размера
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.FormResize(Sender: TObject);
begin
   IF (sender as TFormBaseV_ALT).Width<self_min_width then
      (sender as TFormBaseV_ALT).Width:=self_min_width;
   //endif

   IF (sender as TFormBaseV_ALT).Height<350 then
      (sender as TFormBaseV_ALT).Height:=350;
   //endif
end;

//--------------------------------------------------------------------------
//       Инициализация переменных переопределяемых на FORM_SHOW потомками
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.FormCreate(Sender: TObject);
begin
   self.WindowState:=wsmaximized;
   IS_FORM_PASS:=false;
   IS_INITIALIZED:=false;
   IS_ROWID:=true;
   IS_DIR_READY:=false;
   IS_ENG:=false;
end;

//--------------------------------------------------------------------------
//   Если в гриде меняют местами колонки переопр. индексы колонок для полей
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.DBGridEh1ColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
var
   i,j:integer;
   MinFld,MaxFld:integer;
   //--------------номера полей индексы колонок которых нужно менять
   Field_nch:array[1..50] of integer;


begin
   for i:=1 to 50 do
      Field_nch[i]:=0;
   //endfor   

   if FromIndex<=ToIndex then
      begin
         MinFld:=FromIndex;
         MaxFld:=ToIndex;
      end
   else
      begin
         MinFld:=ToIndex;
         MaxFld:=FromIndex;
      end;
   //endif

   //------------------------Вычисление номеров полей
   //           индексы номеров колонок нужно менять
   for j:=MinFld to MaxFld do
      begin
         for i:=1 to nfields do
            begin
               if MAINFLD_NCOLUMN[i]=j then
                  //------------j индекс колонки i-номер поля
                  Field_nch[j+1]:=i
               //endif
            end;
         //end for
      end;
   //end for

   //----------------------Если колонка сдв. справа налево
   IF FromIndex>ToIndex then
      begin
         //---------     Для поля самой правой
         //          заменяемой колонки поставить индекс
         //          самой левой колонки
         //          остальные поля сдвинуть вправо
         MAINFLD_NCOLUMN[Field_nch[MaxFld+1]]:=MinFld;
         //----------------Замена индексов колонок для полей
         for j:=MinFld to MaxFld-1 do
            begin
               MAINFLD_NCOLUMN[Field_nch[j+1]]:=j+1
            end;
         //endfor
      end
   else
   //------------------------Иначе наоборот
      begin
         MAINFLD_NCOLUMN[Field_nch[MinFld+1]]:=MaxFld;
         //----------------Замена индексов колонок для полей
         for j:=MinFld+1 to MaxFld  do
            begin
               MAINFLD_NCOLUMN[Field_nch[j+1]]:=j-1;
            end;
         //endfor
      end;
   //endif
end;

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//              Вывод отчетов в Excel (унифицированный)
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.EXCEL_REPORT_UNI(
    SQL_IN:Widestring;
    IS_SAVE:boolean;
    IS_FIRST:boolean;
    xlSHEET:string;
    xlFILE:string;
    IS_TEMPLATE:boolean;
    ID_TEMPLATE:integer;
    ENGINE_TYPE:integer;
    IS_LINKTABLE:boolean;
    LINKTABLE:string;
    ID_MDB_REAL:integer;
    IS_Visible:boolean);

//----------------------------------------------------------------
//        Основная процедура вывода отчета
//----------------------------------------------------------------
BEGIN

   SCREEN.Cursor:=crHourGlass;

   //--------------------------------------------------------
   //-         Если расчет через Access ->(обработка)
   //--------------------------------------------------------
   //-------Выбор типа вывода в зависимости от параметра IS_ACCESS_OBR
   if ENGINE_TYPE=2 THEN
      BEGIN
         MAKE_TMP_BASE;
         LINK_COPY('TMP_GOTDATA',SQL_IN,IS_LINKTABLE,LINKTABLE);
         EXEC_ACCESS_SCRIPT(ID_MDB_REAL);
      END;
   //endif

   //--------------------------------------------------------
   //     Выкладка данных в Excel
   //--------------------------------------------------------
   EXCEL_OUT(SQL_IN,IS_SAVE,IS_FIRST,xlSHEET,xlFILE,
   IS_TEMPLATE,ID_TEMPLATE,ENGINE_TYPE,IS_VISIBLE);

   SCREEN.CURSOR:= CRDEFAULT;
END;

//--------------------------------------------------------------------------
//    Простой формат отчет Excel  (Copy с шаблоном)
//--------------------------------------------------------------------------
procedure  TFormBaseV_ALT.EXCEL_SCREEN(SQL_IN:widestring;ID_TEMPLATE:INTEGER);
begin
   EXCEL_OUT(SQL_IN,false,false,'','',true,ID_TEMPLATE,1,true);
end;

//--------------------------------------------------------------------------
//       Вспомогательные процедуры
//--------------------------------------------------------------------------
//        Выкладка шаблона для отчета Excel
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.OUT_TEMPLATE(
    ID_TEMPLATE1:integer;
    xlFILE1:string);

begin
   oraquery2.SQL.Text:=' SELECT * FROM '+DESC_SHEM+'.FILE_SHABLONS T '+
   ' WHERE T.ID_SHABLON='+INTTOSTR(ID_TEMPLATE1) ;
   ORAQUERY2.OPEN;
   TBLOBFIELD(ORAQUERY2.Fields.FieldByName('SHABLON_BODY')).SaveToFile(xlFILE1);
   oraquery2.CLOSE;
end;
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//     Подготовка базы к работе  statdb.mdb
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.MAKE_TMP_BASE;

const
  dbLangGeneral = ';LANGID=0x0419;CP=1252;COUNTRY=0';
  dbVersion30 = 32;

var
  gl_DBEngine:Variant;
  gl_Workspace:Variant;
  gl_ADB:Variant;
  //----------------------Таблицы и запросы
  qDef:Variant;
  i:integer;

begin
  //-------------------------------------------------------------------
  //         Создать statdb.mdb и подключиться к ней
  //-------------------------------------------------------------------
  gl_DBEngine := CreateOleObject('DAO.DBEngine.35');
  gl_Workspace := gl_DBEngine.Workspaces[0];

   {$I-}
   IF IS_DIR_READY=false then
      begin
         {M_1 chdir('c:\');
         mkdir('TMP_REP');
         chdir('c:\TMP_REP');
         mkdir(TMP_MDB_PATH);}

         chdir('\\buhmonster\TMP_REP');
         mkdir(TMP_MDB_PATH);

         IS_DIR_READY:=true;
      end;
   //endif
   {$I+}

  {M_1 if FileExists('c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb')=TRUE then
     begin
        deletefile('c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');
     end;
  //ENDIF
  gl_ADB :=gl_Workspace.CreateDatabase(
  'c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb',
  dbLangGeneral, dbVersion30);
  gl_ADB.CLOSE;
  gl_ADB:=gl_DBEngine.OpenDatabase(
  'c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');}

  if FileExists('\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb')=TRUE then
     begin
        deletefile('\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');
     end;
  //ENDIF

  gl_ADB :=gl_Workspace.CreateDatabase(
  '\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb',
  dbLangGeneral, dbVersion30);

  gl_ADB.CLOSE;
  gl_ADB:=gl_DBEngine.OpenDatabase(
  '\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');

  //-----------------------------------------------------
  //      Создать таблицу номеров (для диапазонов)
  //-----------------------------------------------------
  qDef:=gl_ADB.createQueryDEF('MKMAINTAB');
  qDef.sql:='CREATE TABLE NUMBERS_GO(ID_NUM INTEGER, ID_SORT string)';
  qDef.execute;
  gl_ADB.querydefs.delete('MKMAINTAB');

  //-----------------------------------Занесение диапазонов
  qDef:=gl_ADB.createQueryDEF('MKMAINTAB');
  for i:=0 to 20 do
     begin
        qDef.sql:='INSERT INTO NUMBERS_GO(ID_NUM,ID_SORT) VALUES('+
        inttostr(i)+',"'+CHR(I+65)+'")';
        qDef.execute;
     end;
  //enfor
  gl_ADB.querydefs.delete('MKMAINTAB');
  gl_ADB.CLOSE;
end;

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//   Выбрать данные через линк или PATH-THOUGH таблицы в statdb.mdb
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.LINK_COPY(
    DEST_TABLE:string;    //Таблица в которую выбрать данные
    SQL_IN1:widestring;    //Запрос для выборки
    IS_LINK1:boolean;      //Использовать линк
    LINKTABLE1:string);

var
  gl_DBEngine:Variant;
  gl_Workspace:Variant;
  gl_ADB:Variant;
  //----------------------Соединения
  odbc:String;
  //----------------------Таблицы и запросы
  qDef:Variant;
  TD:Variant;
  rst:Variant;
  temp_allstr:string;


begin
  //-------------------------------------------------------------------
  //        Подключиться к statdb.mdb
  //-------------------------------------------------------------------
  gl_DBEngine := CreateOleObject('DAO.DBEngine.35');
  gl_Workspace := gl_DBEngine.Workspaces[0];

  {M_1 gl_ADB:=gl_DBEngine.OpenDatabase('c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');}
  gl_ADB:=gl_DBEngine.OpenDatabase('\\BUHMONSTER\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');

  //-------------------------------------------------------------------
  //-------        Создать ODBC линк на текущий набор
  //-------------------------------------------------------------------
  odbc:='ODBC;UID='+FORM_USER+';PWD='+FORM_PASSWORD+';DSN='+FORM_SERVER+';'+
  'DBQ='+FORM_SERVER+
  ';DBA=W;APA=T;FEN=T;QTO=T;FRC=10;FDL=10;LOB=T;RST=T;FRL=F;MTS=F;CSR=F;PFC=10;TLO=0;';

  //-------------------------------------------------------------------
  //          Передать в MDB текущий запрос как PATH-THROUGH (или Линк)
  //-------------------------------------------------------------------
  IF IS_LINK1=TRUE then
     begin
        //-----------------------------------Запрос через Линк
        td:=gl_ADB.CreateTableDef('INLINK');
        td.SourceTableName :=LINKTABLE1;
        td.connect:=odbc;
        gl_ADB.TableDefs.Append(td);

        qDef:=gl_ADB.createquerydef('MAIN_LINK_QUERY');
        qDef.sql:=SQL_IN1;
        QDef.ODBCTimeOut:=0;
     end
  else
     begin
        //-------------------------------------Запрос через PATH-THROUGH
        Qdef:=gl_ADB.CreateQueryDef('INLINK');
        Qdef.connect:=odbc;
        Qdef.sql:=SQL_IN1;

        Qdef:=gl_ADB.CreateQueryDef('MAIN_LINK_QUERY');
        QDef.sql:='select * from INLINK ';
        QDef.ODBCTimeOut:=0;
     end;
  //endif

  //-----------------------------------------------------
  //    Выбрать данные локально в Access (TMP_GOTDATA)
  //-----------------------------------------------------
  qDef:=gl_ADB.createQueryDEF('MKMAINTAB');

  //----------------------------------------------------------------
  //           Копирование данных
  //----------------------------------------------------------------
  temp_allstr:='select * into '+DEST_TABLE+' from MAIN_LINK_QUERY ';
  qDef.sql:=temp_allstr;
  QDef.ODBCTimeOut:=0;
  qDef.execute;

  rst:=gl_ADB.openrecordset('SELECT * FROM '+DEST_TABLE);
  if rst.recordcount>0 then
     begin
        rst.movelast;
        rst.movefirst;
     end;
  //endif
  //----------------------------------------------------------------
  //              Добавить колонку ун. идент. записей
  //----------------------------------------------------------------
  {if rst.recordcount<=100000 then
     begin
        rst.close;
        qDef.sql:=' ALTER TABLE '+DEST_TABLE+' ADD COLUMN T_REC_ID AUTOINCREMENT';
        qDef.execute;
     end
  else
     rst.close;}
  //endif

  gl_ADB.querydefs.delete('MKMAINTAB');
  gl_ADB.querydefs.delete('MAIN_LINK_QUERY');

  if IS_LINK1=TRUE THEN
     gl_ADB.tabledefs.delete('INLINK')
  ELSE
     gl_ADB.querydefs.delete('INLINK');
  //ENDIF
end;

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//       Выполнение набора запросов для Access
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
procedure TFormBaseV_ALT.EXEC_ACCESS_SCRIPT(NSCRIPT1:integer);
var
  //-------------------------Работа с расчетной БД Access
  gl_DBEngine:Variant;
  gl_Workspace:Variant;
  gl_ADB:Variant;
  qDef1:Variant;
  qDef2:Variant;
  Q_NAME:string;

BEGIN
   gl_DBEngine := CreateOleObject('DAO.DBEngine.35');
   gl_Workspace := gl_DBEngine.Workspaces[0];
   {M_1 gl_ADB:=gl_DBEngine.OpenDatabase('c:\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');}
   gl_ADB:=gl_DBEngine.OpenDatabase('\\BUHMONSTER\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb');

   qDef1:=gl_ADB.createQueryDEF('MKMAINTAB');

   //--------------------------------------------------------------
   //    Запросить список запросов расчетной последовательности
   //--------------------------------------------------------------
   oraquery2.SQL.Text:=  'SELECT T.*, T.rowID from '+DESC_SHEM+'.FORM_MDB_REAL_SQL T '+
   ' WHERE T.ID_MDB_REAL='+INTTOSTR(NSCRIPT1)+' order by ID_ORDER' ;
   oraquery2.Open;

   oraquery2.First;
   //---------------------------------------------------------------
   //         Выполнить список запросов расчета
   //---------------------------------------------------------------
   while not(oraquery2.eof) do
      begin
         Q_NAME:=oraquery2.Fields.FieldByName('QUERY_NAME').AsString;
         if Q_NAME<>'_' then
            begin
               qDef2:=gl_ADB.createQueryDEF(Q_NAME);
               qDef2.sql:=oraquery2.Fields.FieldByName('TEXT_SQL').AsString;
            end
         else
            begin
               qDef1.sql:=oraquery2.Fields.FieldByName('TEXT_SQL').AsString;
               qDef1.execute;
            end;
         //endif
         oraquery2.Next;
      end;
   //wend
   oraquery2.Close;

   gl_ADB.querydefs.delete('MKMAINTAB');
   gl_ADB.CLOSE;
end;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//       Внутренняя процедура вывода отчета
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure TFormBaseV_ALT.EXCEL_OUT(
    SQL_IN:widestring;
    IS_SAVE:boolean;
    IS_FIRST:boolean;
    xlSHEET:string;
    xlFILE:string;
    IS_TEMPLATE:boolean;
    ID_TEMPLATE:integer;
    ENGINE_TYPE:integer; // 1- COPY  2- ACCESS 3- ODBC
    IS_Visible:boolean
    );

VAR
//------------------------Работа с файлом Excel
   XLAPP:TExcelApplication;
   XLSH:OLEVariant;
   XLWB_SHAB:OLEVariant;
   XLTAB:OLEVariant;

//----------------------------------------------------------------
//      Выброска данных через COPY GRID
//----------------------------------------------------------------
procedure EXCEL_OUT_COPY;
LABEL
   strt_;

VAR
   I:INTEGER;
   A25:string;
   
begin
   //----------------------------------------------------
   //         Закачка данных
   //----------------------------------------------------
   oraquery_COP.SQL.Text:=SQL_IN;
   oraquery_COP.Open;
   
   //----------------------------------------------------
   // Заголовок- Предварительная подготовка листа
   //----------------------------------------------------
   DBGridEh_COP.SelectedRows.CurrentRowSelected:=true;
   DBGridEh_DoCopyAction(DBGridEh_COP,FAlSE);
   try xlSh.Paste; except end;
   //----------------------------------------------------
   for i:=1 to 40 do
      begin
         A25 := xlSh.Cells[1, i].Value;
         IF COPY(A25,1,5)='TOTAL' then
            A25:=COPY(A25,6,length(A25)-5);
         //ENDIF
         //----------------------------------------------
         oraquery2.sql.text:='select * from form_descs where nform='+inttostr(n_form)+
         ' and (showcode>0) and FLDNAME='+chr(39)+A25+chr(39);
         oraquery2.open;
         //--------------------------------------------Text_Format
         if oraquery2.RecordCount<>0 then
            begin
               If (oraquery2.Fields.FieldByName('BKREPORT').AsInteger=10) Then
                  xlsh.columns[i].NumberFormat:='@';
               //end if
            end;
         //endif
         oraquery2.close;
      end;
   //end for

   //----------------------------------------------------
   //        Выгрузка документа
   //----------------------------------------------------
   if oraquery_COP.RecordCount>0 then
      oraquery_COP.First;
   //endif

   while not(oraquery_COP.eof) do
      begin
         DBGridEh_COP.SelectedRows.CurrentRowSelected:=true;
         oraquery_COP.Next;
      end;
   //wend

   DBGridEh_DoCopyAction(DBGridEh_COP,FAlSE);
   try xlSh.Cells[1,1].Select; except end;

   try xlSh.Paste; except
   try xlSh.Paste; except
   try xlSh.Paste; except
   application.MessageBox('Ошибка вставки из буфера обмена','sys',0);
   end;end;end;

   oraquery_COP.Close;

   //----------------------------------------------------
   //        Выровнять все колонки
   //----------------------------------------------------
   For i:= 1 To 15 do
      begin
         If i <= 6 Then
            xlSh.Columns[i].ColumnWidth := 13
         Else
            xlSh.Columns[i].ColumnWidth := 10
         //endif
      end;
   //endfor

   //-----------------Корректировка при пустом листе
   A25 := xlSh.Cells[1, 1].Value;
   if A25='' then
      xlSh.Cells[1, 1].Value:='EMPTY';
   //endif

strt_:
   //----------------------------------------------------
   //    Отформатировать колонки по описанию формы
   //----------------------------------------------------
   for i:=1 to 40 do
      begin
         //------------------------------------------
         A25 := xlSh.Cells[1, i].Value;
         if A25='ROWID' then
            begin
               xlsh.columns[i].delete;
               goto strt_;
            end;
         //endif

         IF COPY(A25,1,5)='TOTAL' then
            A25:=COPY(A25,6,length(A25)-5);
         //ENDIF
         //----------------------------------------------
         oraquery2.sql.text:='select * from form_descs where nform='+inttostr(n_form)+
         ' and (showcode>0) and FLDNAME='+chr(39)+A25+chr(39);
         oraquery2.open;
         //----------------------------------------
         if oraquery2.RecordCount<>0 then
            begin
               //----------------------------------------------del flds
               If (oraquery2.Fields.FieldByName('BKREPORT').AsInteger=64) Then
                  begin
                     xlsh.columns[i].delete;
                     goto strt_;
                  end;
               //endif
               //-----------------------------------------format_fields
               if (oraquery2.Fields.FieldByName('FLDNAME').AsString=A25)  then
                  begin
                     xlSh.Cells[1, i].Value:=
                     oraquery2.Fields.FieldByName('CAPTION').AsString;

                     xlSh.Cells[1, i].HorizontalAlignment:= xlLeft;
                     xlSh.Cells[1, i].font.bold:=0;
                  end;
               //endif
            end;
         //endif
         oraquery2.close;
      end;
   //endfor
   xlsh.range['a2'].autofilter;
end;

//----------------------------------------------------------------
//      Выброска текущих данных через ODBC
//----------------------------------------------------------------
procedure EXCEL_OUT_ODBC;
Label
   WAIT_,STRT_;

VAR
   I:INTEGER;
   A25:string;

BEGIN
  //--------------------------------------------
  //         Закачка данных
  //--------------------------------------------
  exit;

  xltab.BackgroundQuery := false;
  xltab.refresh;

WAIT_:
  A25 := xlSh.Cells[1, 1].Value;
  if pos('External',A25)<>0 THEN
    GOTO WAIT_;
  //ENDIF

   //----------------------------------------------------
   //        Выровнять все колонки
   //----------------------------------------------------
   For i:= 1 To 15 do
      begin
         If i <= 6 Then
            xlSh.Columns[i].ColumnWidth := 13
         Else
            xlSh.Columns[i].ColumnWidth := 10
         //endif
      end;
   //endfor

   //-----------------Корректировка при пустом листе
   A25 := xlSh.Cells[1, 1].Value;
   if A25='' then
      xlSh.Cells[1, 1].Value:='EMPTY';
   //endif

strt_:
   //----------------------------------------------------
   //    Отформатировать колонки по описанию формы
   //----------------------------------------------------
   for i:=1 to 40 do
      begin
         //------------------------------------------
         A25 := xlSh.Cells[1, i].Value;
         if A25='ROWID' then
            begin
               xlsh.columns[i].delete;
               goto strt_;
            end;
         //endif

         IF COPY(A25,1,5)='TOTAL' then
            A25:=COPY(A25,6,length(A25)-5);
         //ENDIF
         //----------------------------------------------
         oraquery2.sql.text:='select * from '+DESC_SHEM+
         '.form_descs where nform='+inttostr(n_form)+
         ' and (showcode>0) and FLDNAME='+chr(39)+A25+chr(39);
         oraquery2.open;
         //----------------------------------------
         if oraquery2.RecordCount<>0 then
            begin
               //----------------------------------------------del flds
               If (oraquery2.Fields.FieldByName('BKREPORT').AsInteger=64) Then
                  begin
                     xlsh.columns[i].delete;
                     goto strt_;
                  end;
               //endif
               //-----------------------------------------format_fields
               if (oraquery2.Fields.FieldByName('FLDNAME').AsString=A25)  then
                  begin
                     xlSh.Cells[1, i].Value:=
                     oraquery2.Fields.FieldByName('CAPTION').AsString;

                     xlSh.Cells[1, i].HorizontalAlignment:= xlLeft;
                     xlSh.Cells[1, i].font.bold:=0;
                  end;
               //endif
            end;
         //endif
         oraquery2.close;
      end;
   //endfor
   xlsh.range['a2'].autofilter;
END;


//----------------------------------------------------------------
//       Выкладка данных через Access (после подготовки)
//----------------------------------------------------------------
procedure EXCEL_OUT_MDB;

BEGIN
   //-------------------------------------------------
   //    Запросить результат расчета
   //-------------------------------------------------
   {ADOConnection1.ConnectionString:=
   'Provider=Microsoft.Jet.OLEDB.4.0;Password=;Persist '+
   'Security Info=true;User ID=Admin;'+
   'Data Source=\\BUHMONSTER\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb';}

   ADOConnection1.ConnectionString:=
   'Provider=MSDASQL;Persist Security Info=False;User ID=Admin;'+
   'Extended Properties="DBQ=\\BUHMONSTER\TMP_REP\'+TMP_MDB_PATH+'\statdb.mdb;'+
   'DefaultDir=\\BUHMONSTER\TMP_REP\'+TMP_MDB_PATH+'\;'+
   'Driver={Microsoft Access Driver (*.mdb)};'+
   'DriverId=281;FIL=MS Access;MaxBufferSize=2048;'+
   'MaxScanRows=8;PageTimeout=5;'+
   'SafeTransactions=0;Threads=3;UID=admin;UserCommitSync=Yes;"';


   ADOConnection1.Connected:=True;
   ADOQuery1.Connection := ADOConnection1;
   ADOQuery1.SQL.TEXT:='SELECT * FROM LASTDRESULT';
   ADOQuery1.Open;

   //----------------------------------------------
   //        Выгрузка документа
   //----------------------------------------------
   if ADOQuery1.RecordCount>0 then
      ADOQuery1.First;
   //endif

   while not(ADOQuery1.eof) do
      begin
         DBGridEh2.SelectedRows.CurrentRowSelected:=true;
         ADOQuery1.Next;
      end;
   //wend

   DBGridEh_DoCopyAction(DBGridEh2,FAlSE);
   try xlsh.Paste; except end;

   ADOQuery1.Close;
   adoconnection1.Close;
END;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
BEGIN

   //---------------При отсутствии временной директории- создать
   {$I-}
   IF IS_DIR_READY=false then
      begin
         chdir('c:\');
         mkdir('TMP_REP');
         chdir('c:\TMP_REP');
         mkdir(TMP_MDB_PATH);

         //chdir('\\BUHMONSTER\TMP_REP');
         //mkdir(TMP_MDB_PATH);
         IS_DIR_READY:=true;
      end;
   //endif
   {$I+}

   //-------------------Создание объекта Excel
   xlapp:=TExcelApplication.Create(NIL);
   xlapp.ConnectKind:=ckNewInstance;
   try xlapp.IgnoreRemoteRequests[0]:=true; except end;
   xlapp.Connect;

   //--------------------Проверка корректности номера шаблона
   //IF ID_TEMPLATE=0 then
      IS_TEMPLATE:=false;
   //endif

   //--------------------------------------------------------
   //      Если указана обработка шаблоном, Выгрузка шаблона
   //--------------------------------------------------------
   if IS_TEMPLATE=TRUE THEN
      BEGIN
         {M_1 OUT_TEMPLATE(ID_TEMPLATE,'c:\TMP_REP\'+TMP_MDB_PATH+'\FKO.XLS');
         try xlapp.Workbooks.Open('c:\TMP_REP\'+TMP_MDB_PATH+'\FKO.XLS',
         emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
         emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,0);
         except end;}

         OUT_TEMPLATE(ID_TEMPLATE,'\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\FKO.XLS');

         try xlapp.Workbooks.Open('\\buhmonster\TMP_REP\'+TMP_MDB_PATH+'\FKO.XLS',
         emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,
         emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,emptyparam,0);
         except end;

         XLWB_SHAB:=XLAPP.Workbooks['FKO.XLS'];
      END;
   //endif

   //--------------------------------------------------------
   //      Создание нового или открытие существующего док-та
   //--------------------------------------------------------
   //------------------Проверка - если лист делается как n-й лист
   //              многолистового документа
   if (IS_SAVE=true) and (IS_FIRST=false) then
      begin
         //--------------------------Тогда открыть существующий док-т
         //                   и добавить новый лист
         try xlapp.Workbooks.Open(xlFILE,emptyparam,emptyparam,
         emptyparam,emptyparam,
         emptyparam,emptyparam,
         emptyparam,emptyparam,
         emptyparam,emptyparam,
         emptyparam,emptyparam,0); except end;

         try xlapp.ActiveWorkbook.Sheets.Add(emptyparam,emptyparam,
         emptyparam,emptyparam,0); except end;

         xlsh:=xlapp.ActiveSheet;
      end
   else
      //---------------------Иначе создание нового документа
      begin
         try xlapp.DisplayAlerts[0]:=false; except end;

         try xlapp.Workbooks.Add(null,xlLCID); except end;
         xlsh:=xlapp.ActiveSheet;
         try xlsh.delete; except end;
         xlsh:=xlapp.ActiveSheet;
         try xlsh.delete; except end;
         xlsh:=xlapp.ActiveSheet;
      end;
   //endif
   
   //--------------------------------------------------------
   //-               Закачка в Excel данных
   //--------------------------------------------------------
   //-------Выбор типа вывода в зависимости от параметра ENGINE_TYPE
   if ENGINE_TYPE=1 THEN
      EXCEL_OUT_COPY;
   //END IF

   if ENGINE_TYPE=2 THEN
      EXCEL_OUT_MDB;
   //END IF

   if ENGINE_TYPE=3 THEN
      EXCEL_OUT_ODBC;
   //END IF
   //----------------------Название листа
   IF IS_SAVE=TRUE then
      begin
         xlSh.Name:=xlSheet;
      END;
   //ENDIF

   //--------------------------------------------------------
   //      Обработка листа с помощью шаблона
   //--------------------------------------------------------
   //------------------Если установлен признак обработки
   //                  с помощью шаблона IS_TEMPLATE
   IF IS_TEMPLATE=TRUE then
      begin
         xlApp.Run('FKO.XLS!OBRMACRO');
         XLWB_SHAB.CLOSE;
      end;
   //endif

   //--------------------------------------------------------
   //     Сохранение листа для многолистовых докумен тов
   //--------------------------------------------------------
   IF IS_SAVE=TRUE then
      begin
         //---------------------Если 1-й лист (сохранить как..)
         if IS_FIRST=TRUE THEN
            try xlApp.ActiveWorkbook.SaveAs(xlFile,
            emptyparam,emptyparam,
            emptyparam,emptyparam,
            emptyparam,0,
            emptyparam,emptyparam,
            emptyparam,emptyparam,0) except end
         ELSE
            try xlAPP.ActiveWorkbook.Save(0) except end;
         //ENDIF
      end;
   //endif
   //----------------------------------Final
   //----------------------------------------------------------
   //      При наличии соотв. признака сделать Excel видимым
   //----------------------------------------------------------
   try xlapp.IgnoreRemoteRequests[0]:=false; except end;

   if IS_VISIBLE=true then
      try xlapp.visible[xlLCID]:=true; except end
   else
      begin
         try xlApp.ActiveWorkbook.close(emptyparam,emptyparam,emptyparam,0); except end;
         try xlApp.Quit; except end;
      end;
   //endif

   xlapp.Free;
END;


//-----------------------------------------------------------------------------
//       Обновление состояния формы (Refresh)
//-----------------------------------------------------------------------------
procedure TFormBaseV_ALT.Button_RefrClick(Sender: TObject);
var
   TMP_BOOKM:TBOOKMARKSTR;
begin
   TMP_BOOKM:=oraquery1.Bookmark;
   oraquery1.ReQUERY;
   try
   oraquery1.GotoBookmark(pointer(TMP_BOOKM));
   except
   end; 
end;

procedure TFormBaseV_ALT.FormDestroy(Sender: TObject);
begin
   frm_Dialog.Free;
end;

end.
