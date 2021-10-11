unit frm_Filter1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MemDS, DBAccess, Ora,DBLogDlg, StdCtrls, Grids, DBGridEh,FormBaseV_Cross1,
  
  OraSmart, ExtCtrls, ComCtrls,teEngine,mxcommon,comObj, DBCtrls,Excel97, DBGridEhImpExp,
  Buttons;

type
  TForm_Filter = class(TForm)
    PageControl1: TPageControl;
    QUERY_TMP: TOraQuery;
    TabSheet2: TTabSheet;
    ListBox1: TListBox;
    Memo6: TMemo;
    Button4: TSpeedButton;
    Button3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Parent_Form:TFormBaseV_Cross;

    LAB_FIL_FLD:ARRAY[1..50] of TLABEL;
    TX_VALUE:ARRAY[1..50] of TEdit;

    COM_FIL_FLD:ARRAY[1..50] of TCombobox;
    CHK_FIL_FLD:ARRAY[1..50] of TCheckBox;
    DATESTART_FLD:ARRAY[1..50] of TDateTimePicker;
    DATEEND_FLD:ARRAY[1..50] of TDateTimePicker;
    FIELD_TYPES:ARRAY[1..50] of TFieldType;
    YET_OPENED:INTEGER;

    //--------------------Активный чекбокс
    N_ACT_ELEMENT:integer;
    //--------------------Отступ сверху
    SYS_TOP_OFFSET:integer;

    procedure UPDSTATE(Sender: TObject);
    procedure UPDSTATE1(Sender: TObject);
  end;

const xlLCID = LOCALE_USER_DEFAULT;

var
  Form_Filter: TForm_Filter;

implementation

{$R *.dfm}


//---------------------------------------------------------------------
//        Открытие формы
//---------------------------------------------------------------------
procedure TForm_Filter.FormShow(Sender: TObject);
var
   i,J:integer;

begin
   //-----------------Нет активного чекбокса
   N_ACT_ELEMENT:=0;
   listbox1.Clear;

   //--------------Инициализация, если есть родит. форма
   if PARENT_FORM=nil then
      exit;
   //endif
   //-------------------------------------------------------Сессия
   QUERY_TMP.Session:=PARENT_FORM.OraQuery1.Session;

   //--------------------------------Инициализация шаблона фильтра
   for i:=1 to 50 do
      begin
         LAB_FIL_FLD[i].Visible:=false;
         COM_FIL_FLD[i].Visible:=false;
         CHK_FIL_FLD[i].Visible:=false;
         TX_VALUE[i].Visible:=false;
         DATESTART_FLD[i].Visible:=false;
         DATEEND_FLD[i].Visible:=false;
         TX_VALUE[i].Color:=clWhite;
      end;
   //endfor

   if PARENT_FORM.nfields<=50 then
      j:=PARENT_FORM.nfields
   else
      j:=50;
   //endif

   //-------------------------------------------------------------------
   //                        Заполнение полей
   //-------------------------------------------------------------------
   for i:=1 to J do
      begin
         LAB_FIL_FLD[i].Caption:=PARENT_FORM.mainfld_caption[i];

         COM_FIL_FLD[i].Items.Clear;
         COM_FIL_FLD[i].Items.add('=');
         COM_FIL_FLD[i].Items.add('<>');
         COM_FIL_FLD[i].Items.add('>');
         COM_FIL_FLD[i].Items.add('<');
         COM_FIL_FLD[i].Items.add('>=');
         COM_FIL_FLD[i].Items.add('<=');
         COM_FIL_FLD[i].Items.add('BETWEEN');

         if (PARENT_FORM.mainfld_types[i]<>ftDateTime) then
            begin
               COM_FIL_FLD[i].Items.add('IN');
               COM_FIL_FLD[i].Items.add('NOT IN');
            end;
         //endif

         LAB_FIL_FLD[i].Visible:=true;
         CHK_FIL_FLD[i].Visible:=true;
         COM_FIL_FLD[i].Visible:=true;

         if ((PARENT_FORM.mainfld_types[i]=ftDateTime) or
            (PARENT_FORM.mainfld_types[i]=ftDate)) then
            begin
               DATESTART_FLD[i].Visible:=true;
               DATEEND_FLD[i].Visible:=true;
               TX_VALUE[i].Color:=clCream;
            end;
         //endif
         TX_VALUE[i].Visible:=true;

         //--------------------Если фильтр предустановлен
         //          обновить информацию из вызвающей формы
         if (PARENT_FORM.COM_FIL_FLD[i]<>'') then
            begin
               CHK_FIL_FLD[i].Checked:=true;
               COM_FIL_FLD[i].Text:=PARENT_FORM.COM_FIL_FLD[i];
               TX_VALUE[i].text:=PARENT_FORM.TX_VALUE[i];
               DATESTART_FLD[i].DateTime:=PARENT_FORM.DATESTART_VALUE[i];
               DATEEND_FLD[i].DateTime:=PARENT_FORM.DATEEND_VALUE[i];               
            end
         else
            begin
               CHK_FIL_FLD[i].Checked:=false;
            end;
         //endif
      end;
   //enfor

   SYS_TOP_OFFSET:=20+(J+1)*15;
   MEMO6.Top:=SYS_TOP_OFFSET;
   memo6.Height:=self.Height-100-memo6.Top;

   UPDSTATE(CHK_FIL_FLD[1]);

end;


//---------------------------------------------------------------------
//            Корректное закрытие формы
//---------------------------------------------------------------------
procedure TForm_Filter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   QUERY_TMP.close;
end;

//---------------------------------------------------------------------
//           Обновление состояния формы
//---------------------------------------------------------------------
procedure TForm_Filter.UPDSTATE(Sender: TObject);
VAR
   i,j:integer;
   RCH:TCheckBox;

BEGIN
   RCH:=TCheckBox(Sender);
   //----------------------Установка текущего активного чекбокса
   N_ACT_ELEMENT:=RCH.tag;

   //-----------------------------------------------------
   //     Заполнение списка для подстановки
   //-----------------------------------------------------
   if N_ACT_ELEMENT<>0 then
   if CHK_FIL_FLD[N_ACT_ELEMENT].CHECKED=true then
      begin
         QUERY_TMP.SQL.Text:=
         'select distinct '+PARENT_FORM.mainfld_go[N_ACT_ELEMENT]+
         ' from '+ PARENT_FORM.tabgo;

         QUERY_TMP.Open;
         //-------------------------Заполнение списка
         ListBox1.clear;
         while not(QUERY_TMP.Eof) do
            begin
               listbox1.AddItem(QUERY_TMP.Fields[0].asstring,nil);
               QUERY_TMP.Next;
            end;
        //endw
        QUERY_TMP.Close;
     end;
   //endif
   //endif

   //-----------------------------------------------------
   //      Проверка чекбоксов и обновление условий
   //-----------------------------------------------------
   if PARENT_FORM.nfields<=50 then
      j:=PARENT_FORM.nfields
   else
      j:=50;
   //endif

   for i:=1 to j do
      begin
         if CHK_FIL_FLD[i].Checked=false then
            begin
               COM_FIL_FLD[i].Enabled:=false;
               TX_VALUE[i].enabled:=false;
               DATESTART_FLD[i].Enabled:=false;
               DATEEND_FLD[i].Enabled:=false;
               TX_VALUE[i].text:='';
               COM_FIL_FLD[i].Text:='';
            end
         else
            begin
               //---------------Активный чекбокс
               if N_ACT_ELEMENT=i then
                  begin
                     if PARENT_FORM.mainfld_types[i]=ftDateTime then
                        begin
                           DATESTART_FLD[i].Enabled:=true;
                           DATEEND_FLD[i].Enabled:=true;
                        end
                     else
                        TX_VALUE[i].enabled:=true;
                     //endif
                     COM_FIL_FLD[i].Enabled:=true;
                  end
               else
                  begin
                     DATESTART_FLD[i].Enabled:=false;
                     DATEEND_FLD[i].Enabled:=false;
                     TX_VALUE[i].enabled:=false;
                     COM_FIL_FLD[i].Enabled:=false;
                  end;
               //endif
            end;
         //endif
      end;
   //endfor
END;

//---------------------------------------------------------------------
//              Добавление значения из списка
//---------------------------------------------------------------------
procedure TForm_Filter.Button3Click(Sender: TObject);
VAR
   I,N_SEL_ITEM:integer;
   //formatset:TFORMATSETTINGS;

begin
   //formatset.DecimalSeparator:='.';

   //-------------------------------
   if (N_ACT_ELEMENT<>0) and
      ((COM_FIL_FLD[N_ACT_ELEMENT].text='IN') or
       (COM_FIL_FLD[N_ACT_ELEMENT].text='NOT IN') or
      (TX_VALUE[N_ACT_ELEMENT].Text='')) then
      begin
         if (TX_VALUE[N_ACT_ELEMENT].Text<>'')  THEN
            TX_VALUE[N_ACT_ELEMENT].Text:=TX_VALUE[N_ACT_ELEMENT].Text+',';
         //ENDIF
         //-------------------------------
         n_sel_item:=0;
         for i:=0 to listbox1.Items.Count-1 do
            begin
               if listbox1.Selected[i]=true then
                  begin
                     n_sel_item:=i;
                  end;
               //endif
            end;
         //endfor
         //------------------Для полей типа дата операция не работает
         if (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftDateTime) then
            //-------------------Если текущий тип поля текстовый
            if (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftSmallInt) and
               (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftInteger) and
               (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftWord) and
               (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftFloat) and
               (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftCurrency) and
               (PARENT_FORM.mainfld_types[N_ACT_ELEMENT]<>ftLargeInt) then
               TX_VALUE[N_ACT_ELEMENT].Text:=
               TX_VALUE[N_ACT_ELEMENT].Text+
               chr(39)+LISTBOX1.Items[n_sel_item]+chr(39)
            else
            //--------------------Иначе
               TX_VALUE[N_ACT_ELEMENT].Text:=
               TX_VALUE[N_ACT_ELEMENT].Text+
               floattostr(strtofloat(vartostr(LISTBOX1.Items[n_sel_item])){,formatset});
            //endif
         //endif

         //-------------------Занести информацию в Memo
         memo6.Text:=tx_value[n_act_element].Text;
      end;
   //endif
end;

//---------------------------------------------------------------
//                 Применить расширенный фильтр
//---------------------------------------------------------------
procedure TForm_Filter.Button4Click(Sender: TObject);
var
   go_filter:string;
   i:integer;
   DateFormStr:string;

begin
   if PARENT_FORM.IS_ENG=false then
      DateFormStr:='DD.MM.YYYY'
   else
      DateFormStr:='MM/DD/YYYY';
   //endif

   for i:=1 to 50 do
      begin
         //--------------------------------------------
         //   Удаление некорректно поставл. условий
         //--------------------------------------------
         if (PARENT_FORM.mainfld_types[i]<>ftDateTime) and
            ((COM_FIL_FLD[i].Text='') or (TX_VALUE[i].Text='')) then
            CHK_FIL_FLD[i].Checked:=false;
         //endif

         //--------------------------------------------
         //  Если расширенный фильтр для поля выбран
         //--------------------------------------------
         if CHK_FIL_FLD[i].Checked=true then
            begin
               if PARENT_FORM.mainfld_types[i]=ftDateTime then
                  if COM_FIL_FLD[i].text='BETWEEN' then
                     go_filter:=' and '+PARENT_FORM.mainfld_go[i]+' '+
                     COM_FIL_FLD[i].text+
                     ' to_date('+CHR(39)+DATETOSTR(DATESTART_FLD[i].Date)+CHR(39)+','+
                     CHR(39)+DateFormStr+CHR(39)+')'+
                     ' and to_date('+CHR(39)+DATETOSTR(DATEEND_FLD[i].Date)+CHR(39)+','+
                     CHR(39)+DateFormStr+CHR(39)+')'
                  else
                     go_filter:=' and '+PARENT_FORM.mainfld_go[i]+' '+
                     COM_FIL_FLD[i].text+
                     ' to_date('+CHR(39)+DATETOSTR(DATESTART_FLD[i].Date)+CHR(39)+','+
                     CHR(39)+DateFormStr+CHR(39)+')'
                  //endif
               else
                  go_filter:=' and '+PARENT_FORM.mainfld_go[i]+' '+
                  COM_FIL_FLD[i].Text+' ('+TX_VALUE[i].text+') ';
               //endif

               //----------------------------------------------
               //   Сохранить установки в вызывающей форме
               //----------------------------------------------
               PARENT_FORM.COM_FIL_FLD[i]:=COM_FIL_FLD[i].Text;
               PARENT_FORM.TX_VALUE[i]:=TX_VALUE[i].text;
               PARENT_FORM.DATESTART_VALUE[i]:=DATESTART_FLD[i].DateTime;
               PARENT_FORM.DATEEND_VALUE[i]:=DATEEND_FLD[i].DateTime;
               PARENT_FORM.mainfld_filter[i]:=go_filter;
            end
         else
            //-------------------------------------------
            //       Фильтр не выбран
            //-------------------------------------------
            begin
               PARENT_FORM.COM_FIL_FLD[i]:='';            
               PARENT_FORM.mainfld_filter[i]:='';
            end;
         //endif
      end;
   //endfor

   PARENT_FORM.UPDSTATE(NIL);
   ModalResult:=mrOK;
end;

//---------------------------------------------------------------------
//        Информация по строке фильтра (Загрузить в MEMO)
//---------------------------------------------------------------------
procedure TForm_Filter.UPDSTATE1(Sender: TObject);
VAR
   RCH:TEdit;
   intag:integer;

BEGIN
   RCH:=TEdit(Sender);
   intag:=RCH.tag;

   if intag<>0 THEN
      BEGIN
         MEMO6.Text:=RCH.Text;
      END;
   //ENDIF

//
END;


//---------------------------------------------------------------------
//             Создание формы
//---------------------------------------------------------------------
procedure TForm_Filter.FormCreate(Sender: TObject);
var
   i:integer;

begin
   for i:=1 to 50 do
      begin
         //------------------------Названия полей
         LAB_FIL_FLD[i]:=TLabel.Create(sender as TForm_Filter);
         LAB_FIL_FLD[i].AutoSize:=false;
         LAB_FIL_FLD[i].Width:=100;
         LAB_FIL_FLD[i].Caption:='test';
         LAB_FIL_FLD[i].Top:=10+i*15;
         LAB_FIL_FLD[i].Left:=20;
         LAB_FIL_FLD[i].Color:= 15400959;
         LAB_FIL_FLD[i].Visible:=false;
         LAB_FIL_FLD[i].Parent:=TABSHEET2;

         //---------------------------Тексты фильтров
         TX_VALUE[i]:=TEdit.Create(sender as TForm_Filter);
         TX_VALUE[i].Width:=200;
         TX_VALUE[i].Height:=15;
         TX_VALUE[i].Top:=10+i*15;
         TX_VALUE[i].Left:=190;
         TX_VALUE[i].Visible:=false;
         TX_VALUE[i].Tag:=i;
         TX_VALUE[i].OnClick:=UPDSTATE1;
         TX_VALUE[i].Parent:=TABSHEET2;

         //-------------------------Элементы ограничения дат
         DATESTART_FLD[i]:=TDateTimePicker.Create(Sender as TForm_Filter);
         DATESTART_FLD[i].Width:=80;
         DATESTART_FLD[i].Height:=20;
         DATESTART_FLD[i].Top:=10+i*15;
         DATESTART_FLD[i].Left:=190;
         DATESTART_FLD[i].Visible:=false;
         DATESTART_FLD[i].Enabled:=false;
         DATESTART_FLD[i].Parent:=TABSHEET2;

         DATEEND_FLD[i]:=TDateTimePicker.Create(Sender as TForm_Filter);
         DATEEND_FLD[i].Width:=80;
         DATEEND_FLD[i].Height:=20;
         DATEEND_FLD[i].Top:=10+i*15;
         DATEEND_FLD[i].Left:=270;
         DATEEND_FLD[i].Visible:=false;
         DATEEND_FLD[i].Enabled:=false;
         DATEEND_FLD[i].Parent:=TABSHEET2;

         //-----------------------------Тип условия
         COM_FIL_FLD[i]:=TComboBox.Create(sender as TForm_Filter);
         COM_FIL_FLD[i].Width:=60;
         COM_FIL_FLD[i].Top:=10+i*15;
         COM_FIL_FLD[i].Left:=130;
         COM_FIL_FLD[i].height:=15;
         COM_FIL_FLD[i].Visible:=false;
         COM_FIL_FLD[i].Parent:=TABSHEET2;

         //--------------------------------Чеки выбора условий
         CHK_FIL_FLD[i]:=TCheckBox.Create(sender as TForm_Filter);
         CHK_FIL_FLD[i].Width:=10;
         CHK_FIL_FLD[i].Top:=10+i*15;
         CHK_FIL_FLD[i].Left:=120;
         CHK_FIL_FLD[i].height:=15;
         CHK_FIL_FLD[i].Visible:=false;
         CHK_FIL_FLD[i].tag:=i;
         CHK_FIL_FLD[i].OnClick:=UPDSTATE;
         CHK_FIL_FLD[i].Parent:=TABSHEET2;
      end;
   //endfor
end;

procedure TForm_Filter.SpeedButton1Click(Sender: TObject);
begin
   ModalResult:=mrCancel;
end;

end.
