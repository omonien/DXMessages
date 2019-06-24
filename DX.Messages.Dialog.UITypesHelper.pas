unit DX.Messages.Dialog.UITypesHelper;

interface

uses
  System.Classes, System.SysUtils, System.UITypes,
  DX.Messages.Dialog.Types;

type
  TUITypesHelper = class(TObject)
  public
    class function MessageButtonFromDialogOption(AOption: TDialogOption): TMsgDlgBtn;
    class function MessageButtonsFromDialogOptions(AOptions: TDialogOptions): TMsgDlgButtons;
    class function DialogOptionFromModalResult(AResult: TModalResult): TDialogOption;
  end;

implementation

{ TUITypesHelper }

class function TUITypesHelper.DialogOptionFromModalResult(AResult: TModalResult): TDialogOption;
begin
  case AResult of
    mrOk:
      result := TDialogOption.OK;
    mrCancel:
      result := TDialogOption.Cancel;
    mrYes:
      result := TDialogOption.Yes;
    mrNo:
      result := TDialogOption.No
  else
    raise Exception.Create('Unknown Dialog Option');
  end;
end;

class function TUITypesHelper.MessageButtonFromDialogOption(AOption: TDialogOption): TMsgDlgBtn;
begin
  case AOption of
    Yes:
      result := TMsgDlgBtn.mbYes;
    No:
      result := TMsgDlgBtn.mbNo;
    OK:
      result := TMsgDlgBtn.mbOK;
    Cancel:
      result := TMsgDlgBtn.mbCancel;
    Close:
      result := TMsgDlgBtn.mbClose
  else
    raise Exception.Create('Unknown Dialog Option');
  end;
end;

class function TUITypesHelper.MessageButtonsFromDialogOptions(AOptions: TDialogOptions): TMsgDlgButtons;
var
  LOption: TDialogOption;
begin
  result := [];
  for LOption in AOptions do
  begin
    result := result + [MessageButtonFromDialogOption(LOption)];
  end;
end;

end.
