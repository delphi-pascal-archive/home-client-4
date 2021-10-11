unit FORMUNIEDIT1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, Ora, StdCtrls, Mask, DBCtrlsEh, DBGridEh,
  DBLookupEh, Buttons;

type
  TFormUNIEDIT = class(TForm)
    OraQuery2: TOraQuery;
    OraQuery1: TOraQuery;
    DBLookupComboboxEh1: TDBLookupComboboxEh;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    OraQuery3: TOraQuery;

    //--------------------Начальное оформление формы
    procedure FORM_MAININIT(Sender: TObject);

    //--------------------Подготовка к закрытию формы
    procedure FORM_CLOSECONNECT;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    //--------------------------------------------Параметры подключения
    //-----------------Схема, где хранится описание формы
    DESC_SHEM:STRING;
    //------------------Описание формы
    n_form:integer;
    //--------------------------------------------Источник данных
    //--------------Сервер, где хранится источник данных
    FORM_SERVER:STRING;
    //--------------Схема, где хранится источник данных
    FORM_SHEM:STRING;
    //--------------Пользователь/Пароль
    FORM_USER:STRING;
    FORM_PASSWORD:STRING;
    //--------------------------Таблица (запрос формы)
    tabgo:string;
    //--------------------Признак того, что при откр формы
    //                      логин/пароль уже введены
    IS_FORM_PASS:boolean;

    //--------------------------Признак, что форма оформлена
    IS_INITIALIZED:BOOLEAN;

    //-------------------------Признак, что форма вызвана
    //                     для редактирования записи
    IS_UPDATEREC:BOOLEAN;

    //-----------------------Условие для перехода на запись
    //                редактирование которой производится
    FILT_UPDATESEL:string;

    //-----------------------------------Описание полей редактир. формы
    //-------------------------------Текстовые поля
    txt_fields:array[1..20] of TDBEDITEH;
    txt_fldnames:array[1..20] of string;

    //-------------------------------Числовые поля
    num_fields:array[1..20] of TDBEDITEH;
    num_fldnames:array[1..20] of string;
    num_defaults:array[1..20] of integer;

    //-------------------------------Поля Дата/Время
    Date_fields:array[1..10] of TDBDATETIMEEDITEH;
    Date_fldnames:array[1..10] of string;
    Date_defaults:array[1..10] of integer;

    memo_fields:array[1..5] of TMEMO;
    memo_fldnames:array[1..5] of string;

    lookup_oraq:array[1..10] of TORAQuery;
    lookup_ds:array[1..10] of TDataSource;
    lookup_fields:array[1..10] of TDBLookupComboBoxEh;
    lookup_fldnames:array[1..10] of string;
    lookup_filtstr:array[1..10] of string;

    //---------------------Число полей редактир. формы по видам
    ntxtfields:integer;
    nnumfields:integer;
    nmemofields:integer;
    nlookupfields:integer;
    nDateTimeFields:integer;

    //--------------------------ENG формат дат
    IS_ENG:boolean;
  end;

var
  FormUNIEDIT: TFormUNIEDIT;

implementation

{$R *.dfm}

//------------------------------------------------------------------
//                  Вывод формы
//------------------------------------------------------------------
procedure TFormUNIEDIT.FormShow(Sender: TObject);
var
   i:integer;

begin
   //-------------------------------------------------------
   //     Если форма вызвана в режиме редактирования
   //    заполнить поля текущими значениями
   //-------------------------------------------------------
   if IS_UPDATEREC=TRUE THEN
      begin
         ORAQUERY1.SQL.Text:=
         'SELECT * FROM '+TABGO+' WHERE '+FILT_UPDATESEL;
         ORAQUERY1.Open;

         //-----------------------------Текстовые поля
         for i:=1 to ntxtfields do
            begin
               txt_fields[i].Value:=
               oraquery1.Fields.fieldbyname(txt_fldnames[i]).Value;
            end;
         //endfor

         //-----------------------------Числовые поля
         for i:=1 to nnumfields do
            begin
               num_fields[i].Value:=
               oraquery1.Fields.fieldbyname(num_fldnames[i]).Value;
            end;
         //endfor

         //-----------------------------MEMO поля
         for i:=1 to nmemofields do
            begin
               memo_fields[i].Text:=
               oraquery1.Fields.fieldbyname(memo_fldnames[i]).Value;
            end;
         //endfor

         //-----------------------------DATE/TIME поля
         for i:=1 to ndatetimefields do
            begin
               date_fields[i].Value:=
               oraquery1.Fields.fieldbyname(date_fldnames[i]).Value;
            end;
         //endfor

         //-----------------------------Lookup поля
         for i:=1 to nlookupfields do
            begin
               lookup_fields[i].Value:=
               oraquery1.Fields.fieldbyname(lookup_fldnames[i]).Value;
            end;
         //endfor
      end;
   //endif


   //-------------------------------------------------------
   //     Если форма вызвана в режиме добавления
   //    заполнить поля пустыми значениями
   //-------------------------------------------------------
   if IS_UPDATEREC=FALSE THEN
      begin
         //-----------------------------Текстовые поля
         for i:=1 to ntxtfields do
            begin
               txt_fields[i].Value:='-';
            end;
         //endfor

         //-----------------------------Числовые поля
         for i:=1 to nnumfields do
            begin
               num_fields[i].Value:=num_defaults[i];
            end;
         //endfor

         //-----------------------------MEMO поля
         for i:=1 to nmemofields do
            begin
               memo_fields[i].Text:='-';
            end;
         //endfor

         //-----------------------------DATE/TIME поля
         for i:=1 to ndatetimefields do
            begin
               if date_defaults[i]=2 then
                  date_fields[i].Value:=DATE;
               //endif
            end;
         //endfor

         //-----------------------------Lookup поля
         for i:=1 to nlookupfields do
            begin
               lookup_fields[i].Value:=0;
            end;
         //endfor
      end;
   //endif


end;

//------------------------------------------------------------------
//           Начальное оформление формы
//------------------------------------------------------------------
procedure TFormUNIEDIT.FORM_MAININIT(Sender: TObject);
var
   labgo:tlabel;

   filt_name:string;
   filt_dopid:string;
   filt_tab:string;

   top_offset:integer;
   left_offset:integer;

   TMP_TYPEFLD:integer;
   TMP_HEIGHT:integer;
   TMP_WIDTH:integer;

   i:integer;
   pcLCA:array[0..20] of Char;

begin
    //---------------------------------------------------------
    //         Оформление формы
    //---------------------------------------------------------
    ntxtfields:=0;
    nnumfields:=0;
    nmemofields:=0;
    nlookupfields:=0;
    nDateTimeFields:=0;

    //-------------------------------------------ENG формат дат
    if (GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SSHORTDATE,pcLCA,19)<=0) then
       pcLCA[0]:=#0;
    //endif
    if (pcLCA='M/d/yyyy') or (pcLCA='MM/dd/yyyy') then
       IS_ENG:=true;
    //endif
    //---------------------------------------------------    

    oraquery2.SQL.Text:=
    'select * from '+DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
    ' and GLCODE=3';
    oraquery2.Open;

    //----------------------------Если не описание формы редактирования
    if ORAQUERY2.Fields.FIELDBYNAME('BOLD').AsInteger<>2 then
       begin
          Application.MessageBox('Ошибка: Описание формы не соотв. классу','sys',0);
          close;
       end;
    //endif
    oraquery2.close;

    //----------------------------------Таблица источник
    oraquery2.SQL.Text:=
    'select * from '+DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
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
    Label3.Caption:=
    '>> Добавление и редактирование информации '+
    ' Пользователь: '+FORM_USER;

    //-------------------------Имя таблицы с указанием схемы
    //                       Если схема определена
    if FORM_SHEM<>'' THEN
       TABGO:=FORM_SHEM+'.'+ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString
    ELSE
       TABGO:=ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;
    //ENDIF
    oraquery2.Close;

    //--------------------Кэпшен формы
    oraquery2.SQL.Text:=
    'select * from '+DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
    ' and GLCODE=1';
    oraquery2.Open;
    self.Caption:=ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;
    oraquery2.Close;

    //---------------------------------------------------------
    //      Оформление списка полей для редактирования
    //---------------------------------------------------------
    oraquery2.SQL.Text:=
    'select * from '+DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
    ' and showcode=1 order by showorder';
    oraquery2.Open;

    top_offset:=30;
    left_offset:=160;
    while not(oraquery2.Eof) do
       begin
          //--------------------------------Высота поля
          TMP_HEIGHT:=oraquery2.Fields.fieldbyname('WIDTH').AsInteger;
          IF TMP_HEIGHT=0 THEN
             TMP_HEIGHT:=20;
          //ENDIF

          //------------------------------Ширина поля
          TMP_WIDTH:=oraquery2.Fields.fieldbyname('BKREPORT').AsInteger;
          IF TMP_WIDTH=0 THEN
             TMP_WIDTH:=200;
          //ENDIF

          //-----------------------------------------Подпись ред. поля
          labgo:=tlabel.Create(sender as TFormUNIEDIT);
          labgo.Top:=top_offset;
          labgo.Color:=9400939;
          labgo.Font.Color:=clWhite;
          labgo.Font.Style:=[fsBOLD];
          labgo.Left:=5;
          labgo.Caption:=' '+oraquery2.Fields.fieldbyname('CAPTION').AsString;
          labgo.Width:=150;
          labgo.Height:=TMP_HEIGHT;
          labgo.Parent:=sender as TFormUNIEDIT;



          //------------------Выяснить тип выводимого поля
          TMP_TYPEFLD:=oraquery2.Fields.fieldbyname('NFILTER').AsInteger;

          //---------------------------------------------------------
          //     Текстовое поле
          //---------------------------------------------------------
          if TMP_TYPEFLD=1 then
             begin
                ntxtfields:=ntxtfields+1;
                txt_fields[ntxtfields]:=tdbEditEH.Create(sender as TFormUNIEDIT);
                txt_fields[ntxtfields].Top:=top_offset;
                txt_fields[ntxtfields].Left:=left_offset;
                txt_fields[ntxtfields].WIDTH:=TMP_WIDTH;
                txt_fields[ntxtfields].Visible:=TRUE;
                txt_fields[ntxtfields].Height:=TMP_HEIGHT;
                if TMP_HEIGHT<>20 then
                   txt_fields[ntxtfields].WordWrap:=true;
                //endif
                txt_fields[ntxtfields].AutoSize:=false;

                txt_fields[ntxtfields].parent:=sender as TFormUNIEDIT;

                //----------------------Имя сохр. поля
                txt_fldnames[ntxtfields]:=
                oraquery2.Fields.fieldbyname('FLDNAME').AsString;

                //-----------------------Смещение по вертикали
             end;
          //endif

          //---------------------------------------------------------
          //     Числовое поле
          //---------------------------------------------------------
          if TMP_TYPEFLD=2 then
             begin
                nnumfields:=nnumfields+1;
                num_fields[nnumfields]:=tdbEditEH.Create(sender as TFormUNIEDIT);
                num_fields[nnumfields].Top:=top_offset;
                num_fields[nnumfields].Left:=left_offset;
                num_fields[nnumfields].WIDTH:=TMP_WIDTH;
                num_fields[nnumfields].Visible:=TRUE;
                num_fields[nnumfields].Height:=TMP_HEIGHT;
                num_fields[nnumfields].AutoSize:=FALSE;

                num_fields[nnumfields].parent:=sender as TFormUNIEDIT;

                //----------------------Имя сохр. поля
                num_fldnames[nnumfields]:=
                oraquery2.Fields.fieldbyname('FLDNAME').AsString;

                //--------------Значения по умолчанию для числ полей
                num_defaults[nnumfields]:=
                oraquery2.Fields.fieldbyname('COLOR').AsInteger;
             end;
          //endif

          //---------------------------------------------------------
          //     Поле MEMO
          //---------------------------------------------------------
          if TMP_TYPEFLD=3 then
             begin
                nmemofields:=nmemofields+1;
                memo_fields[nmemofields]:=TMEMO.Create(sender as TFormUNIEDIT);
                memo_fields[nmemofields].Top:=top_offset;
                memo_fields[nmemofields].Left:=left_offset;
                memo_fields[nmemofields].WIDTH:=TMP_WIDTH;
                memo_fields[nmemofields].Visible:=TRUE;
                memo_fields[nmemofields].Height:=TMP_HEIGHT;
                memo_fields[nmemofields].parent:=sender as TFormUNIEDIT;

                //----------------------Имя сохр. поля
                memo_fldnames[nmemofields]:=
                oraquery2.Fields.fieldbyname('FLDNAME').AsString;
             end;
          //endif

          //---------------------------------------------------------
          //     Поле DATE/TIME
          //---------------------------------------------------------
          if TMP_TYPEFLD=4 then
             begin
                ndatetimefields:=ndatetimefields+1;
                date_fields[ndatetimefields]:=
                TDBDateTimeEditEh.Create(sender as TFormUNIEDIT);

                date_fields[ndatetimefields].Top:=top_offset;
                date_fields[ndatetimefields].Left:=left_offset;
                date_fields[ndatetimefields].Visible:=TRUE;
                date_fields[ndatetimefields].WIDTH:=TMP_WIDTH;
                date_fields[ndatetimefields].Height:=TMP_HEIGHT;
                date_fields[ndatetimefields].AutoSize:=FALSE;

                date_fields[ndatetimefields].parent:=sender as TFormUNIEDIT;

                //----------------------Имя сохр. поля
                date_fldnames[ndatetimefields]:=
                oraquery2.Fields.fieldbyname('FLDNAME').AsString;

                //--------------Значения по умолчанию для числ полей
                date_defaults[ndatetimefields]:=
                oraquery2.Fields.fieldbyname('COLOR').AsInteger;
             end;
          //endif

          //---------------------------------------------------------
          //     Поле LOOKUP
          //---------------------------------------------------------
          if TMP_TYPEFLD=1001 then
             begin
                nlookupfields:=nlookupfields+1;

                //-------------------------------------Поле ключа справочника
                filt_dopid:= oraquery2.Fields.fieldbyname('TABNAME').AsString;

                //-------------------------------------Поле таблицы справочника
                filt_tab:= oraquery2.Fields.fieldbyname('DESCRIPTION').AsString;

                //-------------------------------------Поле отображения
                filt_name:=oraquery2.Fields.fieldbyname('CAPGROUP').AsString;

                //-------------------------------------- запрос фильтра
                lookup_oraq[nlookupfields]:=
                TOraquery.create(sender as TFormUNIEDIT);

                lookup_oraq[nlookupfields].Session:=
                ORAQUERY1.Session;

                lookup_oraq[nlookupfields].SQL.Text:=
                'select  B.'+filt_DOPID+', B.'+filt_NAME+
                ' DOP_TX from '+filt_tab+' B order by 2';

                //---------------------------------Датасет
                lookup_ds[nlookupfields]:=TDatasource.Create(sender as TFormUNIEDIT);
                lookup_ds[nlookupfields].DataSet:=lookup_oraq[nlookupfields];

                //-------------------------------------------Комбо фильтра
                lookup_fields[nlookupfields]:=
                TdblookupComboBoxEh.Create(sender as TFormUNIEDIT);

                lookup_fields[nlookupfields].Top:=top_offset;

                lookup_fields[nlookupfields].Width:=TMP_WIDTH;
                lookup_fields[nlookupfields].left:=left_offset;
                lookup_fields[nlookupfields].Height:=TMP_HEIGHT;
                lookup_fields[nlookupfields].AutoSize:=FALSE;

                lookup_fields[nlookupfields].ListSource:=lookup_ds[nlookupfields];
                lookup_fields[nlookupfields].KeyField:=filt_DOPid;
                lookup_fields[nlookupfields].ListField:='DOP_TX';
                lookup_fields[nlookupfields].DropDownBox.Width:=300;
                lookup_fields[nlookupfields].DropDownBox.Rows:=30;
                lookup_fields[nlookupfields].Parent:=sender as TFormUNIEDIT;

                //----------------------Имя сохр. поля
                lookup_fldnames[nlookupfields]:=
                oraquery2.Fields.fieldbyname('FLDNAME').AsString;
             end;
          //endif

          top_offset:=top_offset+1+TMP_HEIGHT;
          oraquery2.Next;
       end;
    //wend

    oraquery2.close;

    self.Height:=top_offset+60;

    //-------------------------------------------------------
    //       Подключение к источнику данных
    //-------------------------------------------------------
    //ORASESSION1.Server:=FORM_SERVER;
    //ORASESSION1.ConnectString:=FORM_USER+'/'+FORM_PASSWORD+'@'+FORM_SERVER;
    //ORASESSION1.Connect;

    //----------------Открыть запросы фильтров Lookup
    for i:=1 to nlookupfields do
       begin
          lookup_oraq[i].Open;
       end;
    //endif
end;


//------------------------------------------------------------------
//      Начальная инициализация формы
//------------------------------------------------------------------
procedure TFormUNIEDIT.FormCreate(Sender: TObject);
begin
   IS_INITIALIZED:=false;
   IS_FORM_PASS:=FALSE;
   IS_ENG:=false;
end;

//------------------------------------------------------------------
//      Корректное закрытие формы
//------------------------------------------------------------------
procedure TFormUNIEDIT.FORM_CLOSECONNECT;
var
   i:integer;

begin
   if IS_INITIALIZED=true then
      begin
         ORAQUERY1.Close;
         ORAQUERY2.Close;
         ORAQUERY3.Close;

         //----------------Закрыть запросы фильтров Lookup
         for i:=1 to nlookupfields do
            begin
               lookup_oraq[i].Close;
            end;
         //endif
      end;
   //endif
end;

//------------------------------------------------------------------
//     Закрытие формы без сохранения изменений
//------------------------------------------------------------------
procedure TFormUNIEDIT.SpeedButton2Click(Sender: TObject);
begin
   ModalResult:=mrCancel;
   //CLOSE;
end;

//------------------------------------------------------------------
//   Закрытие формы с сохранениями изменений
//------------------------------------------------------------------
procedure TFormUNIEDIT.SpeedButton1Click(Sender: TObject);
VAR
   UPD_SUBSTR:string;
   INS_SUBSTR1:string;
   INS_SUBSTR2:string;

   i:integer;
   //formatset:TFORMATSETTINGS;
   DateFormStr:string;

//---------------------Добавить запятую
procedure APP_ZPT(var A:STRING);
begin
   if A<>'' THEN
      A:=A+',';
   //ENDIF
end;
//------------------------------------------------------------------

begin
   UPD_SUBSTR:='';
   INS_SUBSTR1:='';
   INS_SUBSTR2:='';

   //formatset.DecimalSeparator:='.';

   //-----------------------------Текстовые поля
   for i:=1 to ntxtfields do
      begin
         APP_ZPT(UPD_SUBSTR);
         APP_ZPT(INS_SUBSTR1);
         APP_ZPT(INS_SUBSTR2);

         //------------------INS1
         INS_SUBSTR1:=INS_SUBSTR1+txt_fldnames[i];

         //------------------INS2
         INS_SUBSTR2:=INS_SUBSTR2+
         CHR(39)+VARTOSTR(txt_fields[i].value)+CHR(39);

         //---------------------UPD
         UPD_SUBSTR:=UPD_SUBSTR+txt_fldnames[i]+'='+
         CHR(39)+VARTOSTR(txt_fields[i].value)+CHR(39);
      end;
   //endfor

   //-----------------------------Числовые поля
   for i:=1 to nnumfields do
      begin
         if vartostr(num_fields[i].Value)<>'' then
            begin
               APP_ZPT(UPD_SUBSTR);
               APP_ZPT(INS_SUBSTR1);
               APP_ZPT(INS_SUBSTR2);
               
               //------------------INS1
               INS_SUBSTR1:=INS_SUBSTR1+num_fldnames[i];

               //------------------INS2
               INS_SUBSTR2:=INS_SUBSTR2+
               floattostr(strtofloat(vartostr(num_fields[i].Value)){,formatset});

               //---------------------UPD
               UPD_SUBSTR:=UPD_SUBSTR+num_fldnames[i]+'='+
               floattostr(strtofloat(vartostr(num_fields[i].Value)){,formatset});
            end;
         //endif      
      end;
   //endfor

   //-----------------------------MEMO поля
   for i:=1 to nmemofields do
      begin
         APP_ZPT(UPD_SUBSTR);
         APP_ZPT(INS_SUBSTR1);
         APP_ZPT(INS_SUBSTR2);

         //------------------INS1
         INS_SUBSTR1:=INS_SUBSTR1+memo_fldnames[i];

         //------------------INS2
         INS_SUBSTR2:=INS_SUBSTR2+
         CHR(39)+memo_fields[i].TEXT+CHR(39);

         //---------------------UPD
         UPD_SUBSTR:=UPD_SUBSTR+memo_fldnames[i]+'='+
         CHR(39)+memo_fields[i].TEXT+CHR(39);
      end;
   //endfor

   //-----------------------------DATE/TIME поля
   for i:=1 to ndatetimefields do
      begin
         APP_ZPT(UPD_SUBSTR);
         APP_ZPT(INS_SUBSTR1);
         APP_ZPT(INS_SUBSTR2);

         //------------------INS1
         INS_SUBSTR1:=INS_SUBSTR1+date_fldnames[i];

         if IS_ENG=false then
            DateFormStr:='DD.MM.YYYY'
         else
            DateFormStr:='MM/DD/YYYY';
         //endif

         //------------------INS2
         INS_SUBSTR2:=INS_SUBSTR2+
         'to_date('+CHR(39)+VARTOSTR(date_fields[i].Value)+CHR(39)+','+
         CHR(39)+DateFormStr+CHR(39)+')';

         //---------------------UPD
         UPD_SUBSTR:=UPD_SUBSTR+date_fldnames[i]+'='+
         'to_date('+CHR(39)+VARTOSTR(date_fields[i].Value)+CHR(39)+','+
         CHR(39)+DateFormStr+CHR(39)+')';
      end;
   //endfor

   //-----------------------------Lookup поля
   for i:=1 to nlookupfields do
      begin
         if lookup_fields[i].Value<>null then
            begin
               APP_ZPT(UPD_SUBSTR);
               APP_ZPT(INS_SUBSTR1);
               APP_ZPT(INS_SUBSTR2);

               //------------------INS1
               INS_SUBSTR1:=INS_SUBSTR1+lookup_fldnames[i];

               //------------------INS2
               INS_SUBSTR2:=INS_SUBSTR2+
               VARTOSTR(lookup_fields[i].Value);

               //---------------------UPD
               UPD_SUBSTR:=UPD_SUBSTR+lookup_fldnames[i]+'='+
               VARTOSTR(lookup_fields[i].Value);
            end;
         //endif
      end;
   //endfor

   //-----------------------------------------
   //       update
   //-----------------------------------------
   if IS_UPDATEREC=TRUE then
      begin
         ORAQUERY1.SQL.Text:=' UPDATE '+TABGO+' SET '+UPD_SUBSTR+
         ' WHERE '+FILT_UPDATESEL;

         ORAQUERY1.ExecSQL;
         ORAQUERY1.Session.Commit;
      end;
   //endif

   //-----------------------------------------
   //      INSERT
   //-----------------------------------------
   if IS_UPDATEREC=FALSE then
      begin
         ORAQUERY1.SQL.Text:=
         ' INSERT INTO '+TABGO+'('+INS_SUBSTR1+') '+
         ' VALUES('+INS_SUBSTR2+')';

         ORAQUERY1.ExecSQL;
         ORAQUERY1.Session.Commit;
      end;
   //endif
   ModalResult:=mrOK;
   //CLOSE;
end;

end.
