program Home_cl;

uses
  Forms,
  frmForm_List in 'frmForm_List.pas' {Form_frmLIST},
  frm_FormEdit in 'frm_FormEdit.pas' {Form_Editor},
  frm_HELP in 'frm_HELP.pas' {Frm_ReportHLP},
  FormBaseV_ALT in 'Classes_ADO\FormBaseV_ALT.pas' {FormBaseV_ALT},
  FormBaseV_Edit1 in 'Classes_ADO\FormBaseV_Edit1.pas' {FormBaseV_EDIT},
  FormRecordEDIT in 'Classes_ADO\FormRecordEDIT.pas' {FormRecEdit},
  FORMUNIEDIT1 in 'Classes_ADO\FORMUNIEDIT1.pas' {FormUNIEDIT},
  frm_Filter2 in 'Classes_ADO\frm_Filter2.pas' {Form_Filter2},
  FormBaseV1_1 in 'Classes_ADO\FormBaseV1_1.pas' {FormBaseV1},
  frmInDialog in 'Classes_ADO\frmInDialog.pas' {formInDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_frmLIST, Form_frmLIST);
  Application.CreateForm(TForm_Editor, Form_Editor);
  Application.CreateForm(TFrm_ReportHLP, Frm_ReportHLP);
  Application.CreateForm(TForm_Filter2, Form_Filter2);
  Application.Run;
end.
