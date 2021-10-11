unit FormRecordEDIT;

interface

uses
  Windows, Messages, OraSmart, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DBGridEh, Mask, DBCtrlsEh,
  DBLookupEh;

type
  TFormRecEdit = class(TForm)
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    DateTimePicker1: TDateTimePicker;
    DBLookupComboboxEh1: TDBLookupComboboxEh;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
 
  public
    Query_Post:TSmartQuery;
    Field_Name:string;
    Edit_Type:integer;

    PROCEDURE Form_Execute(
    QueryPost:TSmartQuery;
    FieldName:string;
    DefaultValue:string;
    //-----------------Тип входящего поля 1-текст 2-дата 3-выбор
    InFieldType:integer);
    
  end;

var
  FormRecEdit: TFormRecEdit;


implementation

//--------------------------------------------------------------------------
//                    Начальная инициализация
//--------------------------------------------------------------------------
PROCEDURE TFormRecEdit.Form_Execute(
            QueryPost:TSmartQuery;
            FieldName:string;
            DefaultValue:string;
            //-----------------Тип входящего поля 1-текст 2-дата 3-выбор
            InFieldType:integer);
begin
   Query_Post:=QueryPost;
   Field_Name:=FieldName;

   //--------------------------Тип поля по умолчанию
   if InFieldType=1 then
      begin
         Memo1.Visible:=true;
         DateTimePicker1.Visible:=false;
         DBLookUpComboBoxEh1.Visible:=false;
         Memo1.Text:=DefaultValue;
         Height:=253;
      end;
   //endif


   //--------------------------Если тип редактируемого поля - дата
   if InFieldType=2 then
      begin
         Memo1.Visible:=false;
         DateTimePicker1.Visible:=true;
         DBLookUpComboBoxEh1.Visible:=false;
         try
            DateTimePicker1.Date:=StrToDate(DefaultValue);
         except
            DateTimePicker1.Date:=Date();
         end;

         Height:=70;
      end;
   //endif

   Edit_Type:=InFieldType;


   ShowModal;
end;

{$R *.dfm}

//--------------------------------Сохранение записи
procedure TFormRecEdit.SpeedButton1Click(Sender: TObject);
begin
   Query_Post.Edit;

   //-----------------------По умолчанию
   if Edit_Type=1 then
      Query_Post.Fields.FieldByName(Field_Name).AsString:=memo1.Text;
   //endif

   //-----------------------Тип -Дата
   if Edit_Type=2 then
      Query_Post.Fields.FieldByName(Field_Name).Asstring:=DateToStr(DateTimePicker1.Date);
   //endif

   Query_Post.Post;
   close;
end;

//--------------------------Отмена
procedure TFormRecEdit.SpeedButton2Click(Sender: TObject);
begin
   Close;
end;

end.
