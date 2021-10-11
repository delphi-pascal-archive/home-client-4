unit frmForm_List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBLogDlg, FormBaseV1_1,Menus,
  ToolWin, ComCtrls, Buttons, ExtCtrls, ADODB, OleCtrls, SHDocVw;

type
  TForm_frmLIST = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    N9: TMenuItem;
    WindowMenu: TMenuItem;
    N13: TMenuItem;
    ADOConnection1: TADOConnection;
    OraQuery1: TADOQuery;
    OraQuery2: TADOQuery;
    StartItem1: TMenuItem;


    procedure FormView(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public

  end;


//-----------------------------------------

var
  Form_frmLIST: TForm_frmLIST;

implementation

uses
  frm_FormEdit;

{$R *.dfm}

//------------------------------------------------------
//          Вызов стандартной формы
//------------------------------------------------------
procedure TForm_frmLIST.FormView(Sender: TObject);
var
   FormBaseV:TFormBaseV1;

begin

  FormBaseV:=tFormBaseV1.Create(self);

  FormBaseV.n_form:=(Sender as TMENUITEM).tag;

  FormBaseV.DESC_SHEM:='';
  FormBaseV.FORM_USER:='';
  FormBaseV.FORM_PASSWORD:='';
  FormBaseV.IS_FORM_PASS:=TRUE;
  FormBaseV.FORM_MAININIT(ADOCONNECTION1,FormBaseV);

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


//---------------------------------------
procedure TForm_frmLIST.FormShow(Sender: TObject);
var
   i:integer;
   ITEMGO:TMENUITEM;

begin
   //----------------------------------------------------
   Adoconnection1.Open;
   Label1.caption:='     '+
   '------------------------------------------------------------'+
   '------------------------------------------------------------'+
   chr(13)+
   '     '+'Simple Database Client Classes (SDCC) Delphi 6'+chr(13)+
   '     '+'------------------------------------------------------------'+
   '------------------------------------------------------------'+
   chr(13)+'     '+'Набор классов, реализующих пользовательский интерфейс '+
   ' работы с базами данных.'+
   chr(13)+'     '+
   chr(13)+'     '+'Интерфейс представляет собой набор типовых форм просмотра/редактирования '+
   'табличной информации,'+
   chr(13)+'     '+'реализующих стандартный функционал:'+
   chr(13)+'     '+'(Фильтры, сортировки, drill-up/drill-down, вывод отчетов в Excel, '+
   'контекстные переходы между формами.)'+
   chr(13)+'     '+
   chr(13)+'     '+'Формы настраиваются на основе специальной таблицы спецификации,'+
   chr(13)+'     '+'размещаемой в базе данных, с которой ведется работа.'+
   chr(13)+'     '+'(Структура таблицы спецификации и правила спецификации форм описаны '+
   'в техническом описании)'+
   chr(13)+'     '+'Также прилагаемый пример (Home_cl.dpr) включает простой редактор форм (frm_FormEdit).'+
   chr(13)+'     '+'(Вызывается из меню Administration->Form_Editor)'+
   chr(13)+'     '+'Редактор содержит краткую справку по правилам спецификации форм.'+
   chr(13)+'     '+'Также через него можно посмотреть готовые описания форм тестовой базы данных SAMPLE.MDB'+ 
   chr(13)+'     '+chr(13)+
   chr(13)+'     '+'Примечание: Описание типовых форм как правило включает не более 20-30 '+
   'строк спецификации,'+
   chr(13)+'     '+'поэтому разработка интерфейса с базовой функциональностью может быть '+
   'выполнена очень быстро.'+
   chr(13)+'     '+'(Например реализация интерфейса для тестового примера "Управление складом"'+
   ' была выполнена за 2 часа)'+
   chr(13)+'     '+'Расширение базовой функциональности может быть выполнено '+
   'путем наследования '+
   chr(13)+'     '+'или расширения функциональности базовых классов.'+
   chr(13)+'     '+'Так как классы основаны на TForm, возможно визуальное наследование.'+
   chr(13)+'     '+chr(13)+
   chr(13)+'     '+'Включает следующие классы:'+
   chr(13)+'     '+'TFormBaseV_ALT: Базовая форма просмотра табличной информации.'+
   chr(13)+'     '+'TFormBaseV_Edit: Форма просмотра/редактирования табличной информации.'+
   ' (расширение TFormBaseV_ALT)'+
   chr(13)+'     '+'TFormUNIEdit: Форма редактирования.'+
   chr(13)+'     '+'TFormBaseV1: Расширение TFormBaseV_Edit с подключением расширенного фильтра'+
   chr(13)+'     '+'(Более детальная информация в техническом описании)'+
   chr(13)+'     '+
   chr(13)+'     '+'Пакет включает набор исходников для Delphi 6:'+
   chr(13)+'     '+'Classes_ADO:  Классы SDCC для работы с базами данных MS Access '+
   chr(13)+'     '+'Classes_ODAC: Классы SDCC для работы с базами данных Oracle'+
   chr(13)+'     '+'Home_cl.dpr: Демонстрационный пример использования SDCC для работы с БД Access'+
   chr(13)+'     '+'SAMPLE.mdb:  Демонстрационная база данных'+
   chr(13)+'     '+'Техническое описание в формате MS Word'+
   chr(13)+'     '+
   chr(13)+'     '+'Для компиляции модулей (Classes_ADO, Classes_ODAC) требуется библиотека EhLib 3.6'+
   chr(13)+'     '+'Для компиляции модулей Classes_ODAC требуется дополнительно библиотека ODAC'+
   chr(13)+'     '+'(Библиотеки EhLib, ODAC в данный пакет не входят)'+
   chr(13)+'     '+   
   chr(13)+'     '+'Freeware, Автор: Дмитрий Ким, 2007 г.';

   mainmenu1.Items[0].Caption:='Примеры интерфейсов';
 
   //------------------------------------------------------------

   I:=1;
   //-----------------------Заполнение списка вкладок
   ORAQUERY1.SQL.Text:='select * from FORM_GROUPS order by 2';
   oraquery1.Open;
   while not(oraquery1.eof) do
      begin
         //---------------------Пункт меню подсписка форм
         ITEMGO:=TMenuItem.Create(Form_frmLIST);
         ITEMGO.Caption:=' '+oraquery1.Fields[1].asstring;
         mainmenu1.Items[0].Add(ITEMGO);

         //---------------------Подсписок форм
         ORAQUERY2.SQL.Text:='select distinct FORM_DESCS.NFORM,TABNAME '+
         ' FROM FORM_DESCS, FORM_GROUP_FRM WHERE '+
         ' FORM_GROUP_FRM.ID_FORM=FORM_DESCS.NFORM AND GLCODE=1 AND '+
         ' ID_FORMGROUP='+
         oraquery1.Fields[0].asstring+' ORDER BY TABNAME';

         oraquery2.Open;

         while not(oraquery2.Eof) do
            begin
               ITEMGO:=TMenuItem.Create(Form_frmLIST);
               ITEMGO.OnClick:=formVIEW;
               ITEMGO.Caption:=oraquery2.fields.fieldbyname('TABNAME').AsString;
               ITEMGO.Tag:=oraquery2.fields.fieldbyname('NFORM').AsInteger;
               mainmenu1.Items[0].Items[i].Add(ITEMGO);
               oraquery2.next;
            end;
         //wend
         oraquery2.Close;


         oraquery1.next;
         I:=I+1;
      end;
   //wend
   oraquery1.Close;
   //SELF.WindowState:=wsMaximized;
end;

//------------------------------------------------------------------
//          Корректное закрытие приложения
//------------------------------------------------------------------
procedure TForm_frmLIST.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   i:integer;
   tmp_mdi:integer;

begin
   //---------------------Закрыть все дочерние MDI формы
   tmp_mdi:=MDIChildCount;
   for i:=1 to tmp_mdi do
      begin
         MDIChildren[i-1].close;
      end;
   //endfor

   oraquery1.Close;
   oraquery2.Close;
   adoconnection1.Close;


end;


procedure TForm_frmLIST.N5Click(Sender: TObject);
begin
   form_Editor.show;
end;

end.
