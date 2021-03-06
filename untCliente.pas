unit untCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ComCtrls, ToolWin, ImgList, DB,
  DBClient, DBCtrls, Mask, Menus, IdBaseComponent, IdComponent,
  IdTCPServer, IdCustomHTTPServer, IdHTTPServer, Buttons, IdTCPConnection,
  IdTCPClient, IdHTTP, RpCon, RpConDS, RpDefine, RpRave, IdAntiFreezeBase,
  IdAntiFreeze, IdMessage, IdMessageClient, IdSMTP, IdIOHandler,
  IdIOHandlerSocket, IdSSLOpenSSL,  ComObj, RpRender, RpRenderPDF, RpBase,
  RpFiler;

type
  TfrmCliente = class(TForm)
    cds_principal: TClientDataSet;
    DtSrc: TDataSource;
    ImageList1: TImageList;
    ToolBar2: TToolBar;
    btnIncluir: TToolButton;
    btnGravar: TToolButton;
    btnExcluir: TToolButton;
    btnRelatorio: TToolButton;
    ToolButton8: TToolButton;
    btnPesquisar: TToolButton;
    ToolButton10: TToolButton;
    btnSair: TToolButton;
    lbl_caption_form: TLabel;
    pgPrincipal: TPageControl;
    tbPesquisar: TTabSheet;
    edit_Pesquisa: TEdit;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    cmbPesquisar: TComboBox;
    tbCadastro: TTabSheet;
    grb_DADOSPESSOAIS: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    edt_TCLI_NOME: TDBEdit;
    edt_TCLI_IDENTIDADE: TDBEdit;
    edt_TCLI_CPF: TDBEdit;
    edt_TCLI_EMAIL: TDBEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edt_TCLI_ENDERECO: TDBEdit;
    edt_TCLI_LOGRADOURO: TDBEdit;
    edt_TCLI_NUMERO: TDBEdit;
    edt_TCLI_COMPLEMENTO: TDBEdit;
    edt_TCLI_BAIRRO: TDBEdit;
    edt_TCLI_CEP: TDBEdit;
    edt_TCLI_CIDADE: TDBEdit;
    edt_TCLI_PAIS: TDBEdit;
    StatusBar1: TStatusBar;
    cds_principalTCLI_NOME: TStringField;
    cds_principalTCLI_IDENTIDADE: TStringField;
    cds_principalTCLI_CPF: TStringField;
    cds_principalTCLI_TELEFONE: TStringField;
    cds_principalTCLI_EMAIL: TStringField;
    cds_principalTCLI_ENDERECO: TStringField;
    cds_principalTCLI_CEP: TStringField;
    cds_principalTCLI_LOGRADOURO: TStringField;
    cds_principalTCLI_NUMERO: TStringField;
    cds_principalTCLI_COMPLEMENTO: TStringField;
    cds_principalTCLI_BAIRRO: TStringField;
    cds_principalTCLI_CIDADE: TStringField;
    cds_principalTCLI_ESTADO: TStringField;
    cds_principalTCLI_PAIS: TStringField;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    CarregarDadosviaXML1: TMenuItem;
    btnViaCep: TSpeedButton;
    IdHTTP1: TIdHTTP;
    edt_TCLI_ESTADO: TDBEdit;
    SalvarDadosviaXML1: TMenuItem;
    RvProject1: TRvProject;
    RvDataSetConnection1: TRvDataSetConnection;
    GroupBox3: TGroupBox;
    edt_REMETENTE: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    edt_DESTINATARIO: TEdit;
    btnAnexar: TSpeedButton;
    btnEnviar: TSpeedButton;
    IdSMTP: TIdSMTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
    IdAntiFreeze: TIdAntiFreeze;
    IdMessage: TIdMessage;
    RvRenderPDF1: TRvRenderPDF;
    RvNDRWriter1: TRvNDRWriter;
    edt_anexo: TEdit;
    procedure DtSrcStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure CarregarDadosviaXML1Click(Sender: TObject);
    procedure btnViaCepClick(Sender: TObject);
    procedure edt_TCLI_CEPKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SalvarDadosviaXML1Click(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure btnAnexarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure edit_PesquisaKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure prEmail_Outlook(str_Remetente, str_Destinatario, str_Anexo: string);

  public
    { Public declarations }
  end;

var
  frmCliente: TfrmCliente;

implementation

uses uLkJSON, Math;

{$R *.dfm}

procedure TfrmCliente.DtSrcStateChange(Sender: TObject);
const
  estados : array[TDataSetState] of string =
  ('FECHADO','CONSULTANDO DADOS','ALTERANDO DADOS','INSERINDO DADOS','','','','','','','','','');
begin

  btnIncluir.Enabled := DtSrc.State in [dsBrowse,dsInactive,dsInsert];
  btnGravar.Enabled := DtSrc.State in [dsInsert,dsEdit];
  btnExcluir.Enabled := DtSrc.State in [dsBrowse];
  btnPesquisar.Enabled := DtSrc.State in [dsInsert,dsEdit,dsBrowse,dsInactive];
  btnRelatorio.Enabled := true;

  frmCliente.StatusBar1.Panels.Items[0].Text := estados[DtSrc.state];
  lbl_caption_form.Caption := estados[DtSrc.state];

end;

procedure TfrmCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if (DtSrc.State in [dsInsert,dsEdit]) then
  begin
    if MessageDlg('O informa??o n?o foi salva. Deseja reamente sair ?',mtConfirmation, [mbYes,mbNo],0) = mrNo then
    begin

       Abort;

    end ;

  end;

end;

procedure TfrmCliente.btnSairClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCliente.FormCreate(Sender: TObject);
var
  I :integer;

begin

  //-> Definindo Padrao para os componentes DBEDIT

   for I := 0 to ComponentCount-1 do
   begin
     if (Components[I] is TDBEdit) then
      begin
        TDBEdit(Components[I]).CharCase := ecUpperCase;
        TDBEdit(Components[I]).Color := clInfoBk;
      end;

   end;

  //-> Definindo Padrao para os componentes DBCOMBOBOX

   for I := 0 to ComponentCount-1 do
   begin
     if (Components[I] is TDBComboBox) then
      begin
        TDBComboBox(Components[I]).CharCase := ecUpperCase;
        TDBComboBox(Components[I]).Color := clInfoBk;
      end;

   end;

   //-> Carrega Combo de Pesquisa

   for I := 0 to cds_principal.FieldCount -1 do
   begin

    if cds_principal.fields.Fields[I].Origin <> '' then
     begin
      cmbPesquisar.Items.Add(cds_principal.Fields.Fields[I].FieldName);
    //  ShowMessage( IntToStr( cmbPesquisar.Items.IndexOf(cds_TCLI.Fields.Fields[I].DisplayName)  ));
     end;

   end;


  //-> Preenche o label com o nome do form
  lbl_caption_form.Caption := Self.Caption;

  //-> Seta o pgPrincipal para op??o de consulta;
  pgPrincipal.TabIndex := 0;

  //-> Cria??o do DataSet com os campos pr?-definidos
  cds_principal.CreateDataSet;
  cds_principal.EmptyDataSet;
  cds_principal.Active := true;


end;

procedure TfrmCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = VK_ESCAPE then begin

     Close;

   end;

   if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TfrmCliente.btnIncluirClick(Sender: TObject);
begin
  if not dtsrc.DataSet.Active then //verifica se esta fechado
  begin
    (dtsrc.DataSet as TClientDataSet).Open;
  end;
  (dtsrc.DataSet as TClientDataSet).Append;

  if pgPrincipal.PageCount > 1 then
   begin

      pgPrincipal.TabIndex := 1;

   end;

   cds_principal.Fields[0].FocusControl;

end;

procedure TfrmCliente.btnGravarClick(Sender: TObject);
begin

  if MessageDlg('Confirma os dados inseridos na tela ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin



   try

     DtSrc.DataSet.Post;
     MessageDlg('REGISTRO SALVO TEMPORARIO !',mtInformation,[mbOK],MB_ICONINFORMATION);


   except

    MessageDlg('ERRO AO SALVAR O REGISTRO TEMPORARIO !',mtInformation,[mbOK],MB_ICONINFORMATION);

   end;

  end
  else
    Abort;




end;

procedure TfrmCliente.CarregarDadosviaXML1Click(Sender: TObject);
begin

  //-> Se a op??o de aba for pesquisar,  pergunta se deseja carregar
  if pgPrincipal.TabIndex = 0 then
  begin


      if MessageDlg('Deseja Importar os dados do arquivo XML ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
       begin

          OpenDialog1.Execute;
          
          cds_principal.LoadFromFile(OpenDialog1.FileName);

          cds_principal.open;

          OpenDialog1.FileName := '';


       end;

  end;
end;

procedure TfrmCliente.btnViaCepClick(Sender: TObject);
var
  Obj_json: TlkJSONobject;
  Str_json :String;

begin

 //-> Iniciando tratamento API Via Cep - Json
 if  Trim( edt_TCLI_CEP.Text ) <> '' then
  begin
   Str_json := IdHTTP1.Get('http://viacep.com.br/ws/' + edt_TCLI_CEP.Text + '/json/');
   Obj_json := TlkJSON.ParseText(Str_json) as TlkJSONobject;

   edt_TCLI_CEP.Text    := VarToStr(Obj_json.Field['cep'].Value);
   edt_TCLI_CIDADE.Text := VarToStr(Obj_json.Field['localidade'].Value);
   edt_TCLI_ESTADO.Text := VarToStr(Obj_json.Field['uf'].Value);

   edt_TCLI_LOGRADOURO.Text  := VarToStr(Obj_json.Field['logradouro'].Value);
   edt_TCLI_ENDERECO.Text    := VarToStr(Obj_json.Field['logradouro'].Value);
   edt_TCLI_COMPLEMENTO.Text := VarToStr(Obj_json.Field['complemento'].Value);
   edt_TCLI_BAIRRO.Text      := VarToStr(Obj_json.Field['bairro'].Value);


  end
  else
  begin

    MessageDlg('Favor informar o CEP !',mtInformation,[mbOK],MB_ICONINFORMATION);
    Abort;
    edt_TCLI_CEP.SetFocus;

  end;

end;

procedure TfrmCliente.edt_TCLI_CEPKeyPress(Sender: TObject; var Key: Char);
begin

  if key = #13 then
   begin

     btnViaCepClick(Sender);


   end;

end;

procedure TfrmCliente.DBGrid1DblClick(Sender: TObject);
begin
  //-> Ativa a pagina de cadastro com os dados em tela;
  pgPrincipal.TabIndex := 1;
end;

procedure TfrmCliente.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then  pgPrincipal.TabIndex := 1; 
end;

procedure TfrmCliente.SalvarDadosviaXML1Click(Sender: TObject);
begin

   SaveDialog1.Execute;

   try

     DeleteFile(SaveDialog1.FileName);
     cds_principal.MergeChangeLog;
     cds_principal.SaveToFile(SaveDialog1.FileName, dfXMLUTF8);
     cds_principal.Close;


     MessageDlg('ARQUIVO XML CRIADO COM SUCESSO !',mtInformation,[mbOK],MB_ICONINFORMATION) ;

   except

    MessageDlg('ERRO NA CRIA??O DO ARQUIVO XML !',mtInformation,[mbOK],MB_ICONINFORMATION);

    end;
end;

procedure TfrmCliente.btnExcluirClick(Sender: TObject);
begin
  if MessageDlg('Deseja realmente excluir este registro?',
     mtConfirmation,[mbyes,mbno],0) = mryes then
  begin
    DtSrc.DataSet.Delete;
    DtSrc.DataSet.Active := true;
     
  end;
end;

procedure TfrmCliente.btnRelatorioClick(Sender: TObject);
var
MStream: TMemoryStream;
begin

   RvProject1.ExecuteReport('Report1');

end;

procedure TfrmCliente.btnEnviarClick(Sender: TObject);
var
  // objetos necess?rios para o funcionamento
  obj_SSL : TIdSSLIOHandlerSocket;
  obj_SMTP: TIdSMTP;
  obj_Mensagem: TIdMessage;
  str_Anexo : string;

begin

  if ( edt_REMETENTE.Text = '' ) or (edt_DESTINATARIO.Text = '') then
   begin

      MessageDlg('Favor informar o Remetente e o Destinat?rio do E-mail !',mtInformation,[mbOK],MB_ICONINFORMATION);
      edt_REMETENTE.SetFocus;
      Exit;

   end;

   // Verifica se existe anexo
    if OpenDialog1.FileName <> '' then
     begin
      str_Anexo := ExtractFileDir(OpenDialog1.FileName);
      if FileExists(str_Anexo) then
        TIdAttachment.Create(IdMessage.MessageParts, str_Anexo);

     end
     else
     begin
       if MessageDlg('Deseja enviar Email sem anexo ?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
        exit  ;

      end;


  // iniciando os  objetos
  obj_SSL := TIdSSLIOHandlerSocket.Create(Self);
  obj_SMTP := TIdSMTP.Create(Self);
  obj_Mensagem := TIdMessage.Create(Self);

  try
    // seta propriedades - SSL
    obj_SSL.SSLOptions.Method := sslvSSLv23;
    obj_SSL.SSLOptions.Mode := sslmClient;

    // seta propriedades - SMTP
    obj_SMTP.IOHandler := IdSSLIOHandlerSocket;
    obj_SMTP.AuthenticationType := atLogin;
    obj_SMTP.Port := 465;
    obj_SMTP.Host := 'smtp.gmail.com';
    obj_SMTP.Username := 'leodiasp@gmail.com';
    obj_SMTP.Password := '!30n@rd0';

    // realiza a conex?o e autentica??o
    try
      obj_SMTP.Connect;
      obj_SMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conex?o e/ou autentica??o: ' +
                    E.Message, mtWarning, [mbOK], 0);
        obj_SMTP.Disconnect;
        if MessageDlg('Deseja enviar o e-mail via Outlook ?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
         begin
          // libera??o dos objetos da mem?ria
          FreeAndNil(IdMessage);
          FreeAndNil(IdSSLIOHandlerSocket);
          FreeAndNil(IdSMTP);
          Exit;

         end
         else
         begin
            prEmail_Outlook(edt_REMETENTE.Text,edt_DESTINATARIO.Text,OpenDialog1.FileName);
            Exit;
         end;

      end;
    end;
  
    // Configura??o da mensagem
    IdMessage.From.Address := 'leodiasp@gmail.com';
    IdMessage.From.Name := 'Leonardo Dias';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.EMailAddresses := 'barratec.sistemas@gmail.com';
    IdMessage.Subject := 'Assunto do e-mail';
    IdMessage.Body.Text := 'Corpo do e-mail';


 
    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso.', mtInformation, [mbOK], 0);
    except
      On E:Exception do
        MessageDlg('Erro ao enviar a mensagem: ' +
                    E.Message, mtWarning, [mbOK], 0);

      //-> Erro no envio da mensagem, chama a procedure Outlook

    end;
  finally
    // libera??o dos objetos da mem?ria
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;



end;

procedure TfrmCliente.prEmail_Outlook(str_Remetente,
  str_Destinatario, str_Anexo: string);
var
  ole_Outlook: OleVariant;
  obj_Email: variant;
  str_corpo_email: TStringList;
const
  olMailItem = 0;
begin


  Screen.Cursor := crHourGlass;
  //-> Procedure criada em caso de Erro ao realizar o envio de e-mail via smtp.
  ole_Outlook := CreateOleObject('Outlook.Application');
  obj_Email := ole_Outlook.CreateItem(olMailItem);

  obj_Email.Recipients.Add(str_Destinatario);
  obj_Email.Subject := 'E-mail - Envio Dados XML - InfoSistemas';

  str_corpo_email := TStringList.Create;

  cds_principal.Active := True;
  cds_principal.First;

  str_corpo_email.Add(' SEGUE OS DADOS DO XML ');
  str_corpo_email.Add(' ');

  while not(cds_principal.Eof) do
   begin

    str_corpo_email.Add('Nome: ' + cds_principalTCLI_NOME.AsString + ' CPF: ' + cds_principalTCLI_CPF.AsString);
    cds_principal.Next;

   end;

   str_corpo_email.Add(' ');
   str_corpo_email.Add('Total - Registro(s): ' + IntToStr( cds_principal.RecordCount ));
   obj_Email.Body := str_corpo_email.Text;


  obj_Email.Attachments.Add(str_Anexo);
  obj_Email.GetInspector.Activate;
  obj_Email.Display(True);
  VarClear(ole_Outlook);

  Screen.Cursor := crDefault;
end;

procedure TfrmCliente.btnAnexarClick(Sender: TObject);
begin
  
  If OpenDialog1.Execute then
   begin

     edt_anexo.Text := OpenDialog1.FileName;

   end;

end;

procedure TfrmCliente.btnPesquisarClick(Sender: TObject);
var
   str_filtro: AnsiString;

begin

  if cmbPesquisar.ItemIndex =  -1 then
   begin
    MessageDlg('Favor Selecionar uma Op??o de Pesquisa !',mtInformation,[mbOK],0);

    pgPrincipal.TabIndex := 0;

    FocusControl(cmbPesquisar);
    Abort;
   
   end;

  if cds_principal.FieldByName(cmbPesquisar.Items.Strings[cmbPesquisar.ItemIndex]).FieldKind = fkData  THEN
   begin

    str_filtro :=   cmbPesquisar.Items.Strings[cmbPesquisar.ItemIndex] + ' LIKE ' +  QuotedStr('%' +  UpperCase(edit_Pesquisa.text) + '%') ;


    cds_principal.Filtered := false;
    cds_principal.Filter :=  str_filtro;
    cds_principal.Filtered := true;


   end;


end;

procedure TfrmCliente.edit_PesquisaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
   begin

     btnPesquisarClick(Self);

   end;
end;

end.

