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
    //-----------------��� ��������� ���� 1-����� 2-���� 3-�����
    InFieldType:integer);
    
  end;

var
  FormRecEdit: TFormRecEdit;


implementation

//--------------------------------------------------------------------------
//                    ��������� �������������
//--------------------------------------------------------------------------
PROCEDURE TFormRecEdit.Form_Execute(
            QueryPost:TSmartQuery;
            FieldName:string;
            DefaultValue:string;
            //-----------------��� ��������� ���� 1-����� 2-���� 3-�����
            InFieldType:integer);
begin
   Query_Post:=QueryPost;
   Field_Name:=FieldName;

   //--------------------------��� ���� �� ���������
   if InFieldType=1 then
      begin
         Memo1.Visible:=true;
         DateTimePicker1.Visible:=false;
         DBLookUpComboBoxEh1.Visible:=false;
         Memo1.Text:=DefaultValue;
         Height:=253;
      end;
   //endif


   //--------------------------���� ��� �������������� ���� - ����
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

//--------------------------------���������� ������
procedure TFormRecEdit.SpeedButton1Click(Sender: TObject);
begin
   Query_Post.Edit;

   //-----------------------�� ���������
   if Edit_Type=1 then
      Query_Post.Fields.FieldByName(Field_Name).AsString:=memo1.Text;
   //endif

   //-----------------------��� -����
   if Edit_Type=2 then
      Query_Post.Fields.FieldByName(Field_Name).Asstring:=DateToStr(DateTimePicker1.Date);
   //endif

   Query_Post.Post;
   close;
end;

//--------------------------������
procedure TFormRecEdit.SpeedButton2Click(Sender: TObject);
begin
   Close;
end;

end.
