program Simp_Client;

uses
  Forms,
  frmForm_List in 'frmForm_List.pas' {Form_frmLIST},
  FormBaseV_ALT in '..\Classes_ODAC\FormBaseV_ALT.pas' {FormBaseV_ALT},
  FormBaseV_Edit1 in '..\Classes_ODAC\FormBaseV_Edit1.pas' {FormBaseV_EDIT},
  FORMUNIEDIT1 in '..\Classes_ODAC\FORMUNIEDIT1.pas' {FormUNIEDIT},
  FormRecordEDIT in '..\Classes_ODAC\FormRecordEDIT.pas' {FormRecEdit},
  FormBaseV1_1 in '..\Classes_ODAC\FormBaseV1_1.pas' {FormBaseV1},
  FormBaseV_Cross1 in '..\Classes_ODAC\FormBaseV_Cross1.pas' {FormBaseV_Cross},
  frm_AgrOLAP1 in '..\Classes_ODAC\frm_AgrOLAP1.pas',
  frm_Filter1 in '..\Classes_ODAC\frm_Filter1.pas' {Form_Filter},
  frm_Filter2 in '..\Classes_ODAC\frm_Filter2.pas' {Form_Filter2},
  frmInDialog in '..\Classes_ODAC\frmInDialog.pas' {formInDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_frmLIST, Form_frmLIST);
  Application.CreateForm(TForm_Filter, Form_Filter);
  Application.CreateForm(TForm_Filter2, Form_Filter2);
  Application.CreateForm(TFormRecEdit, FormRecEdit);
  Application.Run;
end.
