unit FormBaseV_Cross1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FormBaseV_Edit1, DBGridEh, ADODB, DB, Menus, OraSmart, MemDS,
  DBAccess, Ora, Buttons, ExtCtrls, Grids, StdCtrls, Mask, DBCtrlsEh,
  DBLookupEh, ComCtrls, VirtualTable, DBGRIDEHIMPEXP;

type
  TFormBaseV_Cross = class(TFormBaseV_EDIT)
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2_1: TPanel;
    Panel3_1: TPanel;
    Panel5_1: TPanel;
    Panel4_1: TPanel;
    RadioGroup1: TRadioGroup;
    DBGridEh3: TDBGridEh;
    SpeedButton6: TSpeedButton;
    BitBtn2: TBitBtn;
    VirtualTable1: TVirtualTable;
    DataSource4: TDataSource;
    Label9: TLabel;
    PopupMenu2: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    SpeedButton7: TSpeedButton;
    BitBtn5: TBitBtn;
    DetailButt: TSpeedButton;
    BitBtn_QF: TBitBtn;
    //--------------------Начальное оформление формы (потомок)
    procedure FORM_MAININIT(GLSESSION:TOraSession;Sender: TObject);override;
    procedure UPDSTATE_CHILD;override;
    
    procedure RadioGroup1Click(Sender: TObject);
    //-------------------Обновление состояний фильтров
    procedure Panel2_1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Panel2_1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel3_1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Panel3_1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel5_1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Panel5_1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel4_1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Panel4_1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure DetailButtClick(Sender: TObject);
    procedure BitBtn_QFClick(Sender: TObject);
    
  private
    { Private declarations }
  public
    //-----------------------------------------------------------------
    //       Поля управления Кросс-таблицей
    //-----------------------------------------------------------------
    button_fld:array[1..80] of TButton;
    Viewfld_types:array[1..80] of TFieldType;

    //----------------------Типы полей (для фильтра)
    mainfld_types:array[1..50] of TFieldType;

    //---------------------Индексы выбранных полей
    Index_x:array[1..5] of integer;
    Index_y:array[1..3] of integer;
    Index_z:integer;
    //-------------Поля группировки (признак необх. обновл.)
    SQL2GROUP_OLD:string;
    SQL_OLD:string;

    //------------------Типы аггрегирования для поля
    //  1-SUM
    //  2-AVG
    //  3-MIN
    //  4-MAX
    Aggrtype_z: integer;
    //---------------------Число выбранных полей
    Count_x:integer;
    Count_y:integer;
    Count_z:integer;
    //-----------------------Позиция полей
    Field_Position:integer;

    //---------------------------------Управление Pivot
    //---------------Значения Pivot
    Pivot_Values:array[1..200] of string;
    Column_widths:array[1..200] of integer;
    //---------------Число значений Pivot
    PivotValuesCount:integer;

    //--------------Переменные для работы с расш. фильтром
    //----------Типы условия фильтров
    COM_FIL_FLD:array[1..50] of string;

    //---------Строки включения фильтров
    TX_VALUE:array[1..50] of string;
    DATESTART_VALUE:array[1..50] of TDateTime;
    DATEEND_VALUE:array[1..50] of TDateTime;    

    //--------------------Обновление панели упр. Pivot
    procedure ReAlignButt;

  end;

var
  FormBaseV_Cross: TFormBaseV_Cross;

implementation

uses frm_AgrOLAP1, frm_Filter1;

{$R *.dfm}

//-------------------------------------------------------------
//     Обновление панели управления Pivot-таблицей
//-------------------------------------------------------------
procedure TFormBaseV_Cross.UPDSTATE_CHILD;
var
   i:integer;
   TMP_QUERY:widestring;
   TMP_FIELDS:widestring;

begin
   //--------Если группировка не изменилась, не обновляем ПанУпр
   //         и перезапрашиваем Кросс
   if SQL2GROUP_OLD=VIEWFLDS then
      begin
         if (DBGridEh3.Visible=true) and
            (Trim(oraquery1.SQL.Text)<>Trim(SQL_OLD)) then
            BitBtn2Click(nil);
         //endif
         exit;
      end;
   //endif

   SQL2GROUP_OLD:=VIEWFLDS;
   count_x:=0;
   count_y:=0;
   count_z:=0;
   Field_Position:=1;
   //----------------------------------------------------
   //     ОФормление управляющей схемы Pivot- отчета
   //----------------------------------------------------
   while Panel2_1.ControlCount>0 do
      begin
         Panel2_1.Controls[0].Free;
      end;
   //wend
   while Panel3_1.ControlCount>0 do
      begin
         Panel3_1.Controls[0].Free;
      end;
   //wend
   while Panel4_1.ControlCount>0 do
      begin
         Panel4_1.Controls[0].Free;
      end;
   //wend
   while Panel5_1.ControlCount>0 do
      begin
         Panel5_1.Controls[0].Free;
      end;
   //wend
   //----------------------------------------------------
   for i:=1 to nviewfields do
      begin
         button_fld[i]:=TButton.Create(nil);
         button_fld[i].Left:=2;
         button_fld[i].Top:=2+(i-1)*16;
         button_fld[i].width:=110;
         button_fld[i].Height:=15;
         button_fld[i].Caption:=viewfld_caption[i];
         button_fld[i].Parent:=Panel2_1;
         button_fld[i].DragMode:=dmAutomatic;
         button_fld[i].Tag:=i;
      end;
   //end for

   //-----------------------Проверка типов всех выбранных полей
   TMP_QUERY:='';
   TMP_FIELDS:='';
   for i:=1 to nviewfields do
      begin
         if i>1 then
            TMP_FIELDS:=TMP_FIELDS+',';
         //endif
         TMP_FIELDS:=TMP_FIELDS+viewfld_go[i];
      end;
   //endfor

   //--------------------Запрос на выборку типов полей
   TMP_QUERY:='SELECT '+TMP_FIELDS+' FROM ('+oraquery1.SQL.Text+')';
   oraquery2.SQL.Text:=TMP_QUERY;
   try
      oraquery2.open;
   except
      application.MessageBox(
      'Отображение данной формы в аналитическом режиме невозможно','sys',0);
      self.Close;
      exit;
   end;
   oraquery2.first;

   //------------------Выборка типов полей
   for i:=1 to nviewfields do
      begin
         Viewfld_types[i]:=oraquery2.Fields[i-1].DataType;
      end;
   //endfor
   oraquery2.Close;
   ReAlignButt;

   //----------------Установить стандартную ширину колонок
   Column_widths[1]:=100;
   Column_widths[2]:=100;
   for i:=3 to 200 do
      Column_widths[i]:=60;
   //endfor
end;



//-------------------------------------------------------------
//      Переключение режимов Стандартный/Pivot
//-------------------------------------------------------------
procedure TFormBaseV_Cross.RadioGroup1Click(Sender: TObject);
begin
   if RadioGroup1.ItemIndex=0 then
      begin
         DBGridEh3.Visible:=false;
         panel2_1.Enabled:=false;
         panel3_1.Enabled:=false;
         panel4_1.Enabled:=false;
         panel5_1.Enabled:=false;
         BitBtn2.Enabled:=false;
         speedbutton6.Enabled:=false;
      end
   else
      begin
         DBGridEh3.Visible:=true;
         panel2_1.Enabled:=true;
         panel3_1.Enabled:=true;
         panel4_1.Enabled:=true;
         panel5_1.Enabled:=true;
         BitBtn2.Enabled:=true;
         speedbutton6.Enabled:=true;
      end;
   //endif

end;

//------------------------------------------------------------
//    Перенос кнопки обратно (в исходную панель)
//------------------------------------------------------------
procedure TFormBaseV_Cross.Panel2_1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   (Source as Tbutton).Parent:=Panel2_1;
   reAlignButt;
end;

//------------------------------------------------------------
//          Перенос кнопки в панель ROWS
//------------------------------------------------------------
procedure TFormBaseV_Cross.Panel3_1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   if count_x<3 then
      begin
         (Source as Tbutton).Parent:=Panel3_1;
         reAlignButt;
      end;
   //endif
end;

//------------------------------------------------------------
//      Перенос кнопки в панель Columns
//------------------------------------------------------------
procedure TFormBaseV_Cross.Panel4_1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   if count_y<2 then
      begin
         (Source as Tbutton).Parent:=Panel4_1;
         reAlignButt;
      end;
   //endif
end;

//------------------------------------------------------------
//     Перенос кнопки в панель VALUES
//------------------------------------------------------------
procedure TFormBaseV_Cross.Panel5_1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
   if count_z=0 then
      begin
         (Source as Tbutton).Parent:=Panel5_1;
         reAlignButt;
      end;
   //endif
end;


//------------------------------------------------------------
//         Перегуппировка кнопок в панелях
//------------------------------------------------------------
procedure TFormBaseV_Cross.reAlignButt;
var
   i:integer;
   tmp1:integer;

begin
   //----------------------------------Выделенный список полей
   for i:=0 to Panel2_1.ControlCount-1 do
      begin
         (Panel2_1.Controls[i] as tButton).Visible:=false;
      end;
   //end for
   //-----------------------------------------
   if (Field_Position-1+12)<Panel2_1.ControlCount-1 then
      tmp1:=Field_Position-1+12
   else
      tmp1:=Panel2_1.ControlCount-1;
   //endif
   //-----------------------------------------
   for i:=Field_Position-1 to tmp1 do
      begin
         (Panel2_1.Controls[i] as tButton).Visible:=true;
         (Panel2_1.Controls[i] as tButton).Top:=2+(i-(Field_Position-1))*16;
      end;
   //end for
   //---------------------------------------Панели Target
   for i:=0 to Panel3_1.ControlCount-1 do
      begin
         (Panel3_1.Controls[i] as tButton).Top:=2+i*16;
         Index_x[i+1]:=(Panel3_1.Controls[i] as tButton).Tag;
      end;
   //end for
   Count_x:=Panel3_1.ControlCount;

   //--------------------------------------------------
   for i:=0 to Panel4_1.ControlCount-1 do
      begin
         (Panel4_1.Controls[i] as tButton).Top:=2+i*16;
         Index_y[i+1]:=(Panel4_1.Controls[i] as tButton).Tag;
      end;
   //end for
   Count_y:=Panel4_1.ControlCount;

   //--------------------------------------------------
   if Panel5_1.ControlCount>0 then
      begin
         (Panel5_1.Controls[0] as tButton).Top:=2;
         Index_z:=(Panel5_1.Controls[0] as tButton).Tag;
         Count_z:=1;
      end
   else
      Count_z:=0;
   //endif
   //----------------------Заблокировать кнопку детализации
   DetailButt.Enabled:=false;
end;

//------------------------------------------------------------
procedure TFormBaseV_Cross.Panel2_1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;
procedure TFormBaseV_Cross.Panel3_1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;
procedure TFormBaseV_Cross.Panel5_1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;
procedure TFormBaseV_Cross.Panel4_1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;

//------------------------------------------------------------
//            Выбор типа аггрегирования
//------------------------------------------------------------
procedure TFormBaseV_Cross.SpeedButton6Click(Sender: TObject);
var
   modres:integer;

begin
   modres:=frm_AgrOLAP.ShowModal;

   if modres<>-1 then
      Aggrtype_z:=modres;
   //endif

   Case Aggrtype_z of
      1:SpeedButton6.Caption:='Сумма';
      2:SpeedButton6.Caption:='Среднее';
      3:SpeedButton6.Caption:='Минимум';
      4:SpeedButton6.Caption:='Максимум';
      5:SpeedButton6.Caption:='Количество';
   end;
end;

//------------------------------------------------------------
//             Начальная инициализация
//------------------------------------------------------------
procedure TFormBaseV_Cross.FormCreate(Sender: TObject);
begin
  inherited;
  Aggrtype_z:=1;
  SQL2GROUP_OLD:='';
  SQL_OLD:='';
  Label6.Caption:='Поля набора данных';
  Label5.Caption:='Поля измерений X';
  Label8.Caption:='Поля измерений Y';
  Label7.Caption:='Поле значений';
  SpeedButton6.Caption:='Сумма';
  BitBtn2.Caption:='Построить Pivot';
  Label9.Caption:='Значение:'
end;

//------------------------------------------------------------
//           Оформление формы (потомок)
//------------------------------------------------------------
procedure TFormBaseV_Cross.FORM_MAININIT(GLSESSION:TOraSession;Sender: TObject);
var
   i:integer;
   TMP_QUERY:widestring;
   TMP_FIELDS:widestring;
   
begin
   inherited;
   //-----------------------Проверка типов всех выбранных полей
   TMP_QUERY:='';
   TMP_FIELDS:='';
   for i:=1 to nfields do
      begin
         if i>1 then
            TMP_FIELDS:=TMP_FIELDS+',';
         //endif
         TMP_FIELDS:=TMP_FIELDS+mainfld_go[i];
      end;
   //endfor

   //--------------------Запрос на выборку типов полей
   TMP_QUERY:='SELECT '+TMP_FIELDS+' FROM '+TABGO;
   oraquery2.SQL.Text:=TMP_QUERY;
   try
      oraquery2.open;
   except
      application.MessageBox('Ошибка инициализации','sys',0);
      self.Close;
      exit;
   end;
   oraquery2.first;

   //------------------Выборка типов полей
   for i:=1 to nfields do
      begin
         mainfld_types[i]:=oraquery2.Fields[i-1].DataType;
      end;
   //endfor
   oraquery2.Close;   
end;

//------------------------------------------------------------
//        Построить Pivot
//------------------------------------------------------------
procedure TFormBaseV_Cross.BitBtn2Click(Sender: TObject);
var
   TMP_FIELDS_X:string;
   TMP_FIELDS_X2:string;
   TMP_FIELDS_Y:string;
   TMP_AGGRS:string;
   X_PREVIOUS:string;
   i:integer;
   TEMP_COLUMN:TColumnEh;

begin
   SQL_OLD:=oraquery1.SQL.Text;
   //------------------------------------------------------
   //     Проверка корректности заполнения
   //------------------------------------------------------
   if (count_x=0) or (count_y=0) or (count_z=0) then
      begin
         //application.MessageBox
         //('Необходимо заполнить поля измерений и значений','sys',0);
         exit;
      end;
   //endif

   TMP_FIELDS_X:='';
   TMP_FIELDS_X2:='';
   TMP_FIELDS_Y:='';
   TMP_AGGRS:='';

   //--------------------------X измерения
   for i:=1 to count_x do
      begin
         if (TMP_FIELDS_X<>'') then
            begin
               TMP_FIELDS_X:=TMP_FIELDS_X+',';
               TMP_FIELDS_X2:=TMP_FIELDS_X2+'||'+chr(39)+'-'+chr(39)+'||';
            end;
         //endif
         TMP_FIELDS_X:=TMP_FIELDS_X+'to_char('+viewfld_go[Index_x[i]]+')';
         TMP_FIELDS_X2:=TMP_FIELDS_X2+'to_char('+viewfld_go[Index_x[i]]+')';
      end;
   //endfor
   //--------------------------Y измерения
   for i:=1 to count_y do
      begin
         if (TMP_FIELDS_Y<>'') then
            TMP_FIELDS_Y:=TMP_FIELDS_Y+'||'+chr(39)+'-'+chr(39)+'||';
         //endif
         TMP_FIELDS_Y:=TMP_FIELDS_Y+'to_char('+viewfld_go[Index_y[i]]+')';
      end;
   //endfor

   //--------------------------Значение
   //--------------------------------------
   //  Проверка допустимости типа
   //    поля значения (Иначе Count)
   //--------------------------------------
   if (viewfld_types[Index_z]<>ftSmallInt) and
      (viewfld_types[Index_z]<>ftInteger) and
      (viewfld_types[Index_z]<>ftWord) and
      (viewfld_types[Index_z]<>ftFloat) and
      (viewfld_types[Index_z]<>ftCurrency) and
      (viewfld_types[Index_z]<>ftLargeInt) then
      begin
         Aggrtype_z:=5;
      end;
   //endif

   //------------------1- Сумма
   if Aggrtype_z=1 then
      begin
         TMP_AGGRS:=' sum('+viewfld_go[Index_z]+') SUMF ';
         label9.caption:=
         'Значения: Сумма('+viewfld_caption[Index_z]+')';
      end;
   //endif

   //------------------2- Среднее
   if Aggrtype_z=2 then
      begin
         TMP_AGGRS:=' avg('+viewfld_go[Index_z]+') SUMF ';
         label9.caption:=
         'Значения: Среднее('+viewfld_caption[Index_z]+')';
      end;
   //endif

   //------------------3- Минимум
   if Aggrtype_z=3 then
      begin
         TMP_AGGRS:=' min('+viewfld_go[Index_z]+') SUMF ';
         label9.caption:=
         'Значения: Минимум('+viewfld_caption[Index_z]+')';
      end;
   //endif

   //------------------4- Максимум
   if Aggrtype_z=4 then
      begin
         TMP_AGGRS:=' max('+viewfld_go[Index_z]+') SUMF ';
         label9.caption:=
         'Значения: Максимум('+viewfld_caption[Index_z]+')';
      end;
   //endif

   //------------------5- Количество
   if Aggrtype_z=5 then
      begin
         TMP_AGGRS:=' count('+viewfld_go[Index_z]+') SUMF ';
         label9.caption:=
         'Значения: Количество('+viewfld_caption[Index_z]+')';
      end;
   //endif


   //--------------------------------------------
   //      Составление Pivot-запроса
   //    и заполнение источника данных для Pivot
   //--------------------------------------------
   DBGridEh3.Columns.Clear;
   VirtualTable1.FieldDefs.Clear;
   //------------------------------Добавление колонок (строки)
   for i:=1 to Count_x do
      begin
         VirtualTable1.FieldDefs.Add('FieldX'+IntToStr(i),ftString,200);
         TEMP_COLUMN:=DBGridEh3.Columns.Add;
         TEMP_COLUMN.FieldName:='FieldX'+IntToStr(i);
         TEMP_COLUMN.Title.Caption:=viewfld_caption[Index_x[i]];
         TEMP_COLUMN.AutoFitColWidth:=false;
         TEMP_COLUMN.Width:=Column_Widths[i];
         TEMP_COLUMN.Color:=15925247;
      end;
   //endfor

   //------------------------------Добавление колонок (Pivot)

   oraquery2.SQL.Text:='SELECT '+TMP_FIELDS_Y+
   ' FROM ('+oraquery1.SQL.Text+') GROUP BY '+TMP_FIELDS_Y+
   ' ORDER BY '+TMP_FIELDS_Y;
   oraquery2.Open;
   if oraquery2.RecordCount>0 then
      oraquery2.First;
   //endif

   i:=1;
   while not(oraquery2.Eof) and (i<=100) do
      begin
         VirtualTable1.FieldDefs.Add('FieldP'+IntToStr(i),ftString,20);
         TEMP_COLUMN:=DBGridEh3.Columns.Add;
         TEMP_COLUMN.FieldName:='FieldP'+IntToStr(i);
         TEMP_COLUMN.Title.Caption:=oraquery2.Fields[0].AsString;
         TEMP_COLUMN.AutoFitColWidth:=false;
         TEMP_COLUMN.Width:=Column_Widths[i+Count_x];
         Pivot_Values[i]:=oraquery2.Fields[0].AsString;
         i:=i+1;
         oraquery2.Next;
      end;
   //wend
   oraquery2.Close;
   PivotValuesCount:=i-1;

   VirtualTable1.Open;
   //---------------------------------------------------------------
   //                        Оформление таблицы
   //---------------------------------------------------------------
   //-----------------------------Заполнение базовых строк
   oraquery2.SQL.text:=
   'SELECT '+TMP_FIELDS_X+' FROM ('+oraquery1.SQL.Text+')'+
   ' GROUP BY '+TMP_FIELDS_X+' ORDER BY '+TMP_FIELDS_X2;
   oraquery2.Open;
   if oraquery2.RecordCount>0 then
      oraquery2.First;
   //endif
   //-----------------------------------------------------
   while not (oraquery2.eof) do
      begin
         VirtualTable1.Append;
         for i:=1 to count_x do
            begin
               VirtualTable1.Fields[i-1].AsString:=
               oraquery2.Fields[i-1].asstring;
            end;
         //endfor
         for i:=count_x+1 to PivotValuesCount+count_x do
            begin
               VirtualTable1.Fields[i-1].AsString:='0';
            end;
         //endfor
         VirtualTable1.Post;
         oraquery2.Next;
      end;
   //wend
   oraquery2.Close;

   //----------------------------------------------------------------
   //                   Заполнение значений
   //----------------------------------------------------------------
   oraquery2.SQL.text:=
   'SELECT '+TMP_FIELDS_Y+','+TMP_AGGRS+','+TMP_FIELDS_X2+
   ' FROM ('+oraquery1.SQL.Text+')'+
   ' GROUP BY '+TMP_FIELDS_X2+','+TMP_FIELDS_Y+
   ' ORDER BY '+TMP_FIELDS_X2+','+TMP_FIELDS_Y;
   oraquery2.Open;
   if oraquery2.RecordCount>0 then
      oraquery2.first;
   //endif

   if VirtualTable1.RecordCount=0 then
      begin
         oraquery2.Close;
         exit;
      end;
   //endif
   VirtualTable1.First;
   X_PREVIOUS:=oraquery2.Fields[2].AsString;
   //----------------------------------Цикл заполнения
   While not(VirtualTable1.eof) do
      begin
         for i:=count_x+1 to PivotValuesCount+count_x do
            begin
               if (oraquery2.Fields[0].AsString=Pivot_Values[i-count_x]) and
                  (oraquery2.Fields[2].AsString=X_PREVIOUS) then
                  begin
                     VirtualTable1.Edit;
                     VirtualTable1.Fields[i-1].AsString:=
                     oraquery2.Fields[1].AsString;
                     VirtualTable1.Post;
                     oraquery2.Next;
                  end;
               //endif
            end;
         //endfor
         VirtualTable1.Next;
         X_PREVIOUS:=oraquery2.Fields[2].AsString;
      end;
   //wend
   //------------------------------------------------
   oraquery2.Close;
   VirtualTable1.First;

   //----------------------Разблокировать кнопку детализации
   DetailButt.Enabled:=true;
end;

//-----------------------------------------------------------------
//                       Закрытие формы
//-----------------------------------------------------------------
procedure TFormBaseV_Cross.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  VirtualTable1.Close;
  inherited;
end;


//---------------------------------Выделить все
procedure TFormBaseV_Cross.N9Click(Sender: TObject);
begin
   DBGridEh3.SelectedRows.SelectAll;
end;

//---------------------------------Копировать
procedure TFormBaseV_Cross.N10Click(Sender: TObject);
begin
   DBGridEh_DoCopyAction(DBGridEh3,False);
end;

//------------------------------------------------------------------------
//               Позиция в управляющем боксе полей
//------------------------------------------------------------------------
procedure TFormBaseV_Cross.BitBtn3Click(Sender: TObject);
begin
   Field_Position:=Field_Position-12;
   if Field_Position<1 then
      Field_Position:=1;
   //endif
   ReAlignButt;
end;
procedure TFormBaseV_Cross.BitBtn4Click(Sender: TObject);
begin
   if (Field_Position+12)<Panel2_1.ControlCount then
      Field_Position:=Field_Position+12;
   //endif
   ReAlignButt;
end;

//------------------------------------------------------------------------
//        Сохранить информацию о ширине колонки
//------------------------------------------------------------------------
procedure TFormBaseV_Cross.SpeedButton7Click(Sender: TObject);
var
   i:integer;

begin
   for i:=1 to DBGridEh3.Columns.Count do
      Column_widths[i]:=DBGridEh3.Columns[i-1].Width;
   //endfor
end;


//---------------------------------------------------------------
//       Форма расширенного фильтра
//---------------------------------------------------------------
procedure TFormBaseV_Cross.BitBtn5Click(Sender: TObject);
begin
  Form_Filter.Parent_Form:=self;
  Form_Filter.ShowModal;
end;

//---------------------------------------------------------------
//       Детальная информация по Pivot-у
//---------------------------------------------------------------
procedure TFormBaseV_Cross.DetailButtClick(Sender: TObject);
var
   newform:TFormBaseV_EDIT;
   inp_filter:string;
   i:integer;
   TMP_FIELDS_X2:string;
   TMP_FIELDS_Y:string;
   TMP_FIELDS_X_VAL:string;
   TMP_FIELDS_Y_VAL:string;

begin
   inp_filter:='';
   TMP_FIELDS_X2:='';
   TMP_FIELDS_Y:='';
   TMP_FIELDS_X_VAL:='';
   TMP_FIELDS_Y_VAL:='';

   //--------------------------X поля
   for i:=1 to count_x do
      begin
         //-----------------------------------
         if (TMP_FIELDS_X2<>'') then
            TMP_FIELDS_X2:=TMP_FIELDS_X2+'||'+chr(39)+'-'+chr(39)+'||';
         //endif
         TMP_FIELDS_X2:=TMP_FIELDS_X2+'to_char('+viewfld_go[Index_x[i]]+')';
         //-----------------------------------
         if (TMP_FIELDS_X_VAL<>'') then
            TMP_FIELDS_X_VAL:=TMP_FIELDS_X_VAL+'-';
         //endif
         TMP_FIELDS_X_VAL:=TMP_FIELDS_X_VAL+VirtualTable1.Fields[i-1].AsString;
      end;
   //endfor
   //--------------------------Y поля
   for i:=1 to count_y do
      begin
         if (TMP_FIELDS_Y<>'') then
            TMP_FIELDS_Y:=TMP_FIELDS_Y+'||'+chr(39)+'-'+chr(39)+'||';
         //endif
         TMP_FIELDS_Y:=TMP_FIELDS_Y+'to_char('+viewfld_go[Index_y[i]]+')';
      end;
   //endfor
   TMP_FIELDS_Y_VAL:=DBGridEh3.Columns[DBGridEh3.Col-1].Title.Caption;

   //-----------------------------------------------------------------
   inp_filter:=' and '+TMP_FIELDS_X2+'='+ chr(39)+TMP_FIELDS_X_VAL+chr(39)+
   ' and '+TMP_FIELDS_Y+'='+chr(39)+TMP_FIELDS_Y_VAL+chr(39);
   //-----------------------------------------------------------------

   //-----------------------------------------------------------------
   //            Создание новой формы
   //       Передается логин и пароль текущей формы
   //-----------------------------------------------------------------
   newform:=TFormBaseV_EDIT.Create(application);
   newform.n_form:=n_form;
   newform.input_filter:=GlFilter+' '+inp_filter;
   newform.Color:=14934237;
   newform.DESC_SHEM:=DESC_SHEM;
   newform.FORM_USER:=FORM_USER;
   newform.FORM_PASSWORD:=FORM_PASSWORD;
   IS_FORM_PASS:=TRUE;

   //--------------------Инициализировать заранее
   newform.FORM_MAININIT(oraquery1.Session,newform);

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

//---------------------------------------------------------------
//       Выгрузка данных большого объема через ODBC
//---------------------------------------------------------------
procedure TFormBaseV_Cross.BitBtn_QFClick(Sender: TObject);
begin
   SCREEN.Cursor:=crHourGlass;
   EXCEL_OUT(oraquery1.SQL.text,false,false,'','',3,true);
   SCREEN.CURSOR:= CRDEFAULT;
end;

end.
