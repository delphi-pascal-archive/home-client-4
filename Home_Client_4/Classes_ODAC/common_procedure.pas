unit common_procedure;

interface
uses
   SysUtils, Forms, Classes, Graphics, FormBaseV_ALT, DBGridEh, OraSmart;


procedure DBGRID_INIT(Sender:TFormBaseV_ALT; TargetGrid:TDBGridEH;
n_form:integer; TargetQuery:TSmartQuery);

implementation

//------------------------------------------------------------------------------
//          Общая процедура оформления грида, привязанная к форме
//------------------------------------------------------------------------------
procedure DBGRID_INIT(Sender:TFormBaseV_ALT; TargetGrid:TDBGridEH;
n_form:integer; TargetQuery:TSmartQuery);
var
   FORM_SHEM:string;
   TABGO:string;


begin

   //--------------------------------------------------------------------------------
   //         Инициализация запроса для грида
   //--------------------------------------------------------------------------------
   //----------------------------------Таблица источник
   Sender.oraquery2.SQL.Text:=
   'select * from '+Sender.DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
   ' and GLCODE=2';
   Sender.oraquery2.Open;
   //-------------------------Имя таблицы (Вьюшки) с указанием схемы
   //                       Если схема определена
   FORM_SHEM:=Sender.ORAQUERY2.Fields.FIELDBYNAME('CAPTION').AsString;
   if FORM_SHEM<>'' THEN
      TABGO:=FORM_SHEM+'.'+Sender.ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString
   ELSE
      TABGO:=Sender.ORAQUERY2.Fields.FIELDBYNAME('TABNAME').AsString;
   //ENDIF
   TargetQuery.SQL.Text:='SELECT * FROM '+TABGO;
   Sender.OraQuery2.Close;

   //--------------------------------------------------------------------------------
   //         Оформление грида
   //--------------------------------------------------------------------------------

   Sender.oraquery2.SQL.Text:=
   'select * from '+Sender.DESC_SHEM+'.form_descs where nform='+inttostr(n_form)+
   ' and showcode=1 order by showorder';
   Sender.oraquery2.Open;

   TargetGrid.Columns.Clear;

   //--------------------------------------------------------------------------------
   while not(Sender.oraquery2.Eof) do
      begin
         //---------------------------Оформление колонок и заголовков
         TargetGrid.Columns.ADD;
         TargetGrid.Columns[TargetGrid.Columns.Count-1].FieldName:=
         Sender.oraquery2.Fields.fieldbyname('FLDNAME').AsString;
         TargetGrid.Columns[TargetGrid.Columns.Count-1].Title.Caption:=
         Sender.oraquery2.Fields.fieldbyname('CAPTION').AsString;
         TargetGrid.Columns[TargetGrid.Columns.Count-1].Alignment:=taLeftJustify;

         //-------------------Поля типа BOOLEAN
         if Sender.oraquery2.Fields.fieldbyname('IS_BOOLEAN').Asinteger=-1 then
            begin
               TargetGrid.Columns[TargetGrid.Columns.Count-1].Checkboxes:=true;
               TargetGrid.Columns[TargetGrid.Columns.Count-1].KeyList.ADD('-1');
               TargetGrid.Columns[TargetGrid.Columns.Count-1].KeyList.ADD('0');
            end;
         //endif

         //--------------------------Блокирование полей
         TargetGrid.Columns[TargetGrid.Columns.Count-1].readonly:=true;

         //-----------------------------------Ширина полей
         IF Sender.oraquery2.Fields.fieldbyname('WIDTH').AsInteger=0 then
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Width:=40
         else
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Width:=
            Sender.oraquery2.Fields.fieldbyname('WIDTH').AsInteger;
         //endif

         //------------------Поправка на 800x600
         if screen.width=800 then
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Width:=
            round(TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Width/1.3);
         //endif

         //------------------------------
         if Sender.oraquery2.Fields.fieldbyname('COLOR').AsInteger<>0 THEN
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Font.COLOR:=
            Sender.oraquery2.Fields.fieldbyname('COLOR').AsInteger;
         //ENDIF

         //------------------------------
         if Sender.oraquery2.Fields.fieldbyname('BKCOLOR').AsInteger<>0 THEN
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].COLOR:=
            Sender.oraquery2.Fields.fieldbyname('BKCOLOR').AsInteger;
         //ENDIF

         //------------------------------
         if Sender.oraquery2.Fields.fieldbyname('BOLD').AsInteger<>0 THEN
            TargetGrid.COLUMNS [TargetGrid.Columns.Count-1].Font.STYLE:=[fsBold];
         //ENDIF

         //----------------------------------------------------
         //         Включение total в колонку
         //----------------------------------------------------
         if Sender.oraquery2.Fields.FieldByName('TOTALCODE').AsInteger<>0 THEN
            BEGIN
               TargetGrid.COLUMNS[TargetGrid.Columns.Count-1].Footer.DisplayFormat:='#,#.##';
               //----------------Заполнение строки поля аггрегирования
               if Sender.oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=1 THEN
                  begin
                     TargetGrid.COLUMNS[TargetGrid.Columns.Count-1].Footer.ValueType:=fvtSum;
                  end;
               //endif

               if Sender.oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=2 THEN
                  begin
                     TargetGrid.COLUMNS[TargetGrid.Columns.Count-1].Footer.ValueType:=fvtAvg;
                  end;
               //endif

               if Sender.oraquery2.Fields.FieldByName('TOTALCODE').AsInteger=3 THEN
                  begin
                     TargetGrid.COLUMNS[TargetGrid.Columns.Count-1].Footer.ValueType:=fvtCount;
                  end;
               //endif
            END;
         //ENDIF
         Sender.oraquery2.Next;
      end;
   //wend
   Sender.oraquery2.close;

end;

end.
