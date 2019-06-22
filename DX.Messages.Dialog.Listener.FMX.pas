unit DX.Messages.Dialog.Listener.FMX;

interface

uses
  System.Classes, System.SysUtils,
  DX.Messages.Dialog.Listener, DX.Messages.Dialog;

type
  TMessageDialogListener = class(TMessageDialogListenerBase)
  strict protected
    procedure ShowMessageDialog(const AMessageRequest: TMessageDialogRequest); override;
  public
  end;

implementation

uses
  System.UITypes,
  FMX.DialogService, DX.Messages.Dialog.Types, DX.Messages.Dialog.UITypesHelper;

procedure TMessageDialogListener.ShowMessageDialog(const AMessageRequest: TMessageDialogRequest);
begin
  TDialogService.MessageDialog(AMessageRequest.Message, TMsgDlgType.mtConfirmation, TUITypesHelper.MessageButtonsFromDialogOptions(AMessageRequest.Options),
    TUITypesHelper.MessageButtonFromDialogOption(AMessageRequest.Response), 0,
    procedure(const AResult: TModalResult)
    begin
      AMessageRequest.Response := TUITypesHelper.DialogOptionFromModalResult(AResult);
    end);
end;

end.
