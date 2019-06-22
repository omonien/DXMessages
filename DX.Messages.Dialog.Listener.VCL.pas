unit DX.Messages.Dialog.Listener.VCL;

interface

uses
  System.Classes, System.SysUtils,
  DX.Messages.Dialog.Listener, DX.Messages.Dialog;

type
  TMessageDialogListener = class(TMessageDialogListenerBase)
  strict protected
    procedure ShowMessageDialog(const AMessageRequest: TMessageDialogRequest); override;
  public
    constructor Create; override;
  end;

implementation

uses
  System.UITypes, VCL.Dialogs, DX.Messages.Dialog.Types, DX.Messages.Dialog.UITypesHelper;

{ TMessageDialogListener }
constructor TMessageDialogListener.Create;
begin
  inherited;
end;

procedure TMessageDialogListener.ShowMessageDialog(const AMessageRequest: TMessageDialogRequest);
var
  LResult: TModalResult;
begin
  LResult := MessageDlg(AMessageRequest.Message, TMsgDlgType.mtConfirmation,
    TUITypesHelper.MessageButtonsFromDialogOptions(AMessageRequest.Options), 0,
    TUITypesHelper.MessageButtonFromDialogOption(AMessageRequest.Response));
  AMessageRequest.Response := TUITypesHelper.DialogOptionFromModalResult(LResult);
end;

end.
