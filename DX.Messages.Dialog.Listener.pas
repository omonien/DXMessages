unit DX.Messages.Dialog.Listener;

interface

uses
  System.Classes, System.SysUtils, System.Messaging, DX.Messages.Dialog;

type
  TMessageDialogListenerBase = class (TObject)
  strict private
    class var FInstance: TMessageDialogListenerBase;
  strict protected
    procedure Listener(const ASender: TObject; const AMessage: TMessage); virtual;
    procedure ShowMessageDialog(const AMessageRequest: TMessageDialogRequest); virtual; abstract;
  public
    constructor Create; virtual;
    class destructor Destroy;
    destructor Destroy; override;
    class procedure Register;
    class procedure Unregister;
  end;

implementation

uses
  System.UITypes;

{ TMessageDialogListenerBase }

constructor TMessageDialogListenerBase.Create;
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TMessageDialogRequest, Listener);
end;

destructor TMessageDialogListenerBase.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TMessageDialogRequest, Listener, true);
  inherited;
end;

class destructor TMessageDialogListenerBase.Destroy;
begin
  Unregister;
end;

procedure TMessageDialogListenerBase.Listener(const ASender: TObject; const AMessage: TMessage);
var
  LMessage: TMessageDialogRequest;
begin
  if AMessage is TMessageDialogRequest then
  begin
    LMessage := TMessageDialogRequest(AMessage);
    ShowMessageDialog(LMessage);
  end;
end;

class procedure TMessageDialogListenerBase.Register;
begin
  FInstance := Create;
end;

class procedure TMessageDialogListenerBase.Unregister;
begin
  FreeAndNil(FInstance);
end;

end.
