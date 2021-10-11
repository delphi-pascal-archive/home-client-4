unit frmForm_List;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, MemDS, DBAccess, Ora,DBLogDlg,FormBaseV1_1,Menus,
  ToolWin, ComCtrls, Buttons, ExtCtrls;

type
  TForm_frmLIST = class(TForm)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    Label1: TLabel;
    N9: TMenuItem;
    N10: TMenuItem;
    OraQuery2: TOraQuery;
    WindowMenu: TMenuItem;
    N13: TMenuItem;
    N6: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;


    procedure FormView(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    user_name_gl:string;
    user_password_gl:string;

    //----------------------����� ������
    Work_Mode:integer;
  end;

//-----------------------------------------
//-------------------------�����, �������� ������� �������� ����
const
   DESCRIPTION_SHEMA='BASE_SHEM';

var
  Form_frmLIST: TForm_frmLIST;

implementation

uses
  FormBaseV_Cross1;

{$R *.dfm}

//------------------------------------------------------
//          ����� ����������� �����
//------------------------------------------------------
procedure TForm_frmLIST.FormView(Sender: TObject);
var
   FormBaseV:TFormBaseV1;
   FormBaseV_Cross2:TFormBaseV_Cross;


begin
  //------------------------------------------------------------
  //    ������������� ��� �������������� ������ ������
  //------------------------------------------------------------
  if Work_Mode=5 then
     begin
        FormBaseV_Cross2:=TFormBaseV_Cross.Create(self);
        FormBaseV_Cross2.n_form:=(Sender as TMENUITEM).tag;
        FormBaseV_Cross2.DESC_SHEM:=DESCRIPTION_SHEMA;
        FormBaseV_Cross2.FORM_USER:=user_name_gl;
        FormBaseV_Cross2.FORM_PASSWORD:=user_password_gl;
        FormBaseV_Cross2.IS_FORM_PASS:=TRUE;
        FormBaseV_Cross2.FORM_MAININIT(ORASESSION1,FormBaseV_Cross2);
        FormBaseV_Cross2.WindowState:=wsMaximized;
        //--------------------------------
        IF FormBaseV_Cross2.CONNECT_TRY=false then
           FormBaseV_Cross2.Close
        else
           begin
              FormBaseV_Cross2.FormStyle:=fsMDICHILD;
              FormBaseV_Cross2.Show;
           end;
        //endif
        exit;
     end;
  //endif

  //------------------------------------------------------------
  //    ������������� ��� ������������ ������ ������
  //------------------------------------------------------------

  FormBaseV:=tFormBaseV1.Create(self);

  FormBaseV.n_form:=(Sender as TMENUITEM).tag;
  FormBaseV.DESC_SHEM:=DESCRIPTION_SHEMA;
  FormBaseV.FORM_USER:=user_name_gl;
  FormBaseV.FORM_PASSWORD:=user_password_gl;
  FormBaseV.IS_FORM_PASS:=TRUE;

  //-----------------------���������������� � ���������
  FormBaseV.FORM_MAININIT(ORASESSION1,FormBaseV);
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

   //-------------------����� ��������� ������������
   if not(LoginDialog('Form Sel',user_name_gl,user_password_gl)) then
      begin
         self.Close;
         exit;
      end;
   //endif

   //------------- �������� ������� ����� ������������ �� �������
   orasession1.Server:='OraServer';
   orasession1.Username:=user_name_gl;
   orasession1.Password:=user_password_gl;
   try
   orasession1.Connect;
   except
   application.MessageBox
   ('������������ �� ������ �� ������� ��� ������ ������� ','sys',0);
   self.close;
   exit;
   end;

   //-----------------------------------------------------------
   SELF.Caption:=user_name_gl+'@';
   Work_Mode:=0;

   N9.Caption:='������ ����';
   N6.Caption:='����� ������';
   N18.Caption:='�������';
   N19.Caption:='���������';
   N13.Caption:='�����������';
   //------------------------------------------------------------

   I:=1;
   //-----------------------���������� ������ �������
   ORAQUERY1.SQL.Text:='select * from '+DESCRIPTION_SHEMA+'.FORM_GROUPS order by 2';
   oraquery1.Open;
   while not(oraquery1.eof) do
      begin
         //---------------------����� ���� ��������� ����
         ITEMGO:=TMenuItem.Create(Form_frmLIST);
         ITEMGO.Caption:=' '+oraquery1.Fields[1].asstring;
         mainmenu1.Items[0].Add(ITEMGO);

         //---------------------��������� ����
         ORAQUERY2.SQL.Text:='select distinct A.NFORM,TABNAME '+
         ' FROM '+DESCRIPTION_SHEMA+'.FORM_DESCS A, '+
         DESCRIPTION_SHEMA+'.FORM_GROUP_FRM B WHERE '+
         ' B.ID_FORM=A.NFORM AND GLCODE=1 AND '+
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
   orasession1.Close;
end;



//-----------------------------------------------------------
//          ����� ������ - �������
//-----------------------------------------------------------
procedure TForm_frmLIST.N18Click(Sender: TObject);
begin
   Work_Mode:=0;
   N18.Checked:=true;
   N19.Checked:=false;
end;

//-----------------------------------------------------------
//          ����� ������ - ���������
//-----------------------------------------------------------
procedure TForm_frmLIST.N19Click(Sender: TObject);
begin
   Work_Mode:=5;
   N19.Checked:=true;
   N18.Checked:=false;
end;

end.
