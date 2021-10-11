unit frm_AgrOLAP1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Tfrm_AgrOLAP = class(TForm)
    ListBox1: TListBox;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    selitem:integer;
  end;

var
  frm_AgrOLAP: Tfrm_AgrOLAP;

implementation

{$R *.dfm}

//-------------------------------------------
//               Отмена
//-------------------------------------------
procedure Tfrm_AgrOLAP.BitBtn1Click(Sender: TObject);
begin
   ModalResult:=-1;
end;

//-------------------------------------------
//       Ок- выбор аггрегатной функции
//-------------------------------------------
procedure Tfrm_AgrOLAP.BitBtn2Click(Sender: TObject);
begin
   ModalResult:=selitem;
end;

//-------------------------------------------
procedure Tfrm_AgrOLAP.ListBox1Click(Sender: TObject);
var
   i:integer;
begin
   for i:=0 to 4 do
      if listbox1.Selected[i] then
         selitem:=i+1;
      //endif
   //endfor
end;

//-------------------------------------------
procedure Tfrm_AgrOLAP.FormShow(Sender: TObject);
begin
   selitem:=-1;
end;

end.
