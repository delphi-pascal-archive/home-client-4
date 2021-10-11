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
//          ����� ����������� �����
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
   chr(13)+'     '+'����� �������, ����������� ���������������� ��������� '+
   ' ������ � ������ ������.'+
   chr(13)+'     '+
   chr(13)+'     '+'��������� ������������ ����� ����� ������� ���� ���������/�������������� '+
   '��������� ����������,'+
   chr(13)+'     '+'����������� ����������� ����������:'+
   chr(13)+'     '+'(�������, ����������, drill-up/drill-down, ����� ������� � Excel, '+
   '����������� �������� ����� �������.)'+
   chr(13)+'     '+
   chr(13)+'     '+'����� ������������� �� ������ ����������� ������� ������������,'+
   chr(13)+'     '+'����������� � ���� ������, � ������� ������� ������.'+
   chr(13)+'     '+'(��������� ������� ������������ � ������� ������������ ���� ������� '+
   '� ����������� ��������)'+
   chr(13)+'     '+'����� ����������� ������ (Home_cl.dpr) �������� ������� �������� ���� (frm_FormEdit).'+
   chr(13)+'     '+'(���������� �� ���� Administration->Form_Editor)'+
   chr(13)+'     '+'�������� �������� ������� ������� �� �������� ������������ ����.'+
   chr(13)+'     '+'����� ����� ���� ����� ���������� ������� �������� ���� �������� ���� ������ SAMPLE.MDB'+ 
   chr(13)+'     '+chr(13)+
   chr(13)+'     '+'����������: �������� ������� ���� ��� ������� �������� �� ����� 20-30 '+
   '����� ������������,'+
   chr(13)+'     '+'������� ���������� ���������� � ������� ����������������� ����� ���� '+
   '��������� ����� ������.'+
   chr(13)+'     '+'(�������� ���������� ���������� ��� ��������� ������� "���������� �������"'+
   ' ���� ��������� �� 2 ����)'+
   chr(13)+'     '+'���������� ������� ���������������� ����� ���� ��������� '+
   '����� ������������ '+
   chr(13)+'     '+'��� ���������� ���������������� ������� �������.'+
   chr(13)+'     '+'��� ��� ������ �������� �� TForm, �������� ���������� ������������.'+
   chr(13)+'     '+chr(13)+
   chr(13)+'     '+'�������� ��������� ������:'+
   chr(13)+'     '+'TFormBaseV_ALT: ������� ����� ��������� ��������� ����������.'+
   chr(13)+'     '+'TFormBaseV_Edit: ����� ���������/�������������� ��������� ����������.'+
   ' (���������� TFormBaseV_ALT)'+
   chr(13)+'     '+'TFormUNIEdit: ����� ��������������.'+
   chr(13)+'     '+'TFormBaseV1: ���������� TFormBaseV_Edit � ������������ ������������ �������'+
   chr(13)+'     '+'(����� ��������� ���������� � ����������� ��������)'+
   chr(13)+'     '+
   chr(13)+'     '+'����� �������� ����� ���������� ��� Delphi 6:'+
   chr(13)+'     '+'Classes_ADO:  ������ SDCC ��� ������ � ������ ������ MS Access '+
   chr(13)+'     '+'Classes_ODAC: ������ SDCC ��� ������ � ������ ������ Oracle'+
   chr(13)+'     '+'Home_cl.dpr: ���������������� ������ ������������� SDCC ��� ������ � �� Access'+
   chr(13)+'     '+'SAMPLE.mdb:  ���������������� ���� ������'+
   chr(13)+'     '+'����������� �������� � ������� MS Word'+
   chr(13)+'     '+
   chr(13)+'     '+'��� ���������� ������� (Classes_ADO, Classes_ODAC) ��������� ���������� EhLib 3.6'+
   chr(13)+'     '+'��� ���������� ������� Classes_ODAC ��������� ������������� ���������� ODAC'+
   chr(13)+'     '+'(���������� EhLib, ODAC � ������ ����� �� ������)'+
   chr(13)+'     '+   
   chr(13)+'     '+'Freeware, �����: ������� ���, 2007 �.';

   mainmenu1.Items[0].Caption:='������� �����������';
 
   //------------------------------------------------------------

   I:=1;
   //-----------------------���������� ������ �������
   ORAQUERY1.SQL.Text:='select * from FORM_GROUPS order by 2';
   oraquery1.Open;
   while not(oraquery1.eof) do
      begin
         //---------------------����� ���� ��������� ����
         ITEMGO:=TMenuItem.Create(Form_frmLIST);
         ITEMGO.Caption:=' '+oraquery1.Fields[1].asstring;
         mainmenu1.Items[0].Add(ITEMGO);

         //---------------------��������� ����
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
//          ���������� �������� ����������
//------------------------------------------------------------------
procedure TForm_frmLIST.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   i:integer;
   tmp_mdi:integer;

begin
   //---------------------������� ��� �������� MDI �����
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
