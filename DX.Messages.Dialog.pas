unit DX.Messages.Dialog;

interface

uses
  System.Classes, System.SysUtils, System.Messaging,
  DX.Messages.Dialog.Types;

type
{$SCOPEDENUMS ON}
  TMessageDialogRequest = class(TMessage)
  strict private
    FMessage: string;
    FResult: TDialogOption;
    FOptions: TDialogOptions;
  public
    constructor Create(const AOptions: TDialogOptions; const ADefault: TDialogOption);
    property Message: string read FMessage write FMessage;
    property Response: TDialogOption read FResult write FResult;
    property Options: TDialogOptions read FOptions;
  end;

implementation

{ TMessageDialogRequest }

constructor TMessageDialogRequest.Create(const AOptions: TDialogOptions; const ADefault: TDialogOption);
begin
  FOptions := AOptions;
  FResult := ADefault;
end;

end.
