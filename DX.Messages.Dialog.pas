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
    FOnResultCallback: TProc<TDialogOption>;
    FDefault: TDialogOption;
    procedure SetResult(const Value: TDialogOption);
    procedure SetDefault(const Value: TDialogOption);
  public
    constructor Create(const AMessage: string; const AOptions: TDialogOptions); overload;
    constructor Create(const AMessage: string; const AOptions: TDialogOptions; const ADefault: TDialogOption); overload;

    class function CreateAndSend(const AMessage: string; const AOptions: TDialogOptions = [];
      const ADefault: TDialogOption = TDialogOption.Close; AResultCallback: TProc < TDialogOption >= nil)
      : TMessageDialogRequest;

    property Message: string read FMessage write FMessage;
    property Default: TDialogOption read FDefault write SetDefault;
    property Response: TDialogOption read FResult write SetResult;
    property Options: TDialogOptions read FOptions;
    function OnResult(ACallback: TProc<TDialogOption>): TMessageDialogRequest;
  end;

implementation

{ TMessageDialogRequest }

constructor TMessageDialogRequest.Create(const AMessage: string; const AOptions: TDialogOptions;
  const ADefault: TDialogOption);
begin
  inherited Create;

  FMessage := AMessage;
  if AOptions = [] then
  begin
    //No option selected, it's gona be a simple OK-Dialog
    FOptions := [TDialogOption.OK];
    FDefault := TDialogOption.OK;
  end
  else
  begin
    FOptions := AOptions;
    FDefault := ADefault;
  end;
  // Result is initialized with Default
  FResult := FDefault;
end;

class function TMessageDialogRequest.CreateAndSend(const AMessage: string; const AOptions: TDialogOptions = [];
  const ADefault: TDialogOption = TDialogOption.Close; AResultCallback: TProc < TDialogOption >= nil)
  : TMessageDialogRequest;
begin
  result := Create(AMessage, AOptions, ADefault);
  result.OnResult(AResultCallback);
  TMessageManager.DefaultManager.SendMessage(nil, result, false);
end;

function TMessageDialogRequest.OnResult(ACallback: TProc<TDialogOption>): TMessageDialogRequest;
begin
  FOnResultCallback := ACallback;
  result := self;
end;

constructor TMessageDialogRequest.Create(const AMessage: string; const AOptions: TDialogOptions);
begin
  Create(AMessage, AOptions, TDialogOption.Close);
end;

procedure TMessageDialogRequest.SetDefault(const Value: TDialogOption);
begin
  FDefault := Value;
  FResult := FDefault;
end;

procedure TMessageDialogRequest.SetResult(const Value: TDialogOption);
begin
  FResult := Value;
  if Assigned(FOnResultCallback) then
  begin
    FOnResultCallback(FResult);
  end;
end;

end.
