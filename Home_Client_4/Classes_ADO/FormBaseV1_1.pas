unit FormBaseV1_1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FormBaseV_edit1, DBGridEh, Menus, DB, 
  Buttons, ExtCtrls, Grids, StdCtrls, Mask, DBCtrlsEh, DBLookupEh,
  ADODB, FormBaseV_ALT;

type
  TFormBaseV1 = class(TFormBaseV_EDIT)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure BitBtn3Click(Sender: TObject);
    //--------------------Начальное оформление формы (потомок)
    procedure FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);override;
  private
    { Private declarations }
  public
    { Public declarations }
    //--------------Переменные для работы с расш. фильтром
    //----------Типы условия фильтров
    COM_FIL_FLD:array[1..50] of string;

    //----------------------Типы полей (для фильтра)
    mainfld_types:array[1..50] of TFieldType;

    //---------Строки включения фильтров
    TX_VALUE:array[1..50] of string;
    DATESTART_VALUE:array[1..50] of TDateTime;
    DATEEND_VALUE:array[1..50] of TDateTime;
  end;

implementation
uses frm_Filter2;

{$R *.dfm}


//---------------------------------------------------------------
//       Форма расширенного фильтра
//---------------------------------------------------------------
procedure TFormBaseV1.BitBtn3Click(Sender: TObject);
begin
  Form_Filter2.Parent_Form:=self;
  Form_Filter2.ShowModal;
end;

//--------------------------------------------------------
//        Начальное оформление формы (потомок)
//--------------------------------------------------------
procedure TFormBaseV1.FORM_MAININIT(GLSESSION:TADOConnection;Sender: TObject);
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

end.
