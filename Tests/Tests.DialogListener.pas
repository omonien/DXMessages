unit Tests.DialogListener;

interface

uses
  DUnitX.TestFramework;

type

  TTestDialogListenerBase = class(TObject)
  public
    [TEST]
    procedure TestDialog; virtual;
    [TEST]
    procedure TestDialogCallback; virtual;

  end;

  [TestFixture]
  TTestDialogListenerFMX = class(TTestDialogListenerBase)
  public
    [SetupFixture]
    procedure Setup;
    [TearDownFixture]
    procedure TearDown;
  end;

type

  [TestFixture]
  TTestDialogListenerVCL = class(TTestDialogListenerBase)
  public
    [SetupFixture]
    procedure Setup;
    [TearDownFixture]
    procedure TearDown;
  end;

implementation

uses
  System.Messaging,
  DX.Messages.Dialog,
  DX.Messages.Dialog.Listener.FMX,
  DX.Messages.Dialog.Listener.VCL, DX.Messages.Dialog.Types;

{ TTestDialogListenerFMX }

procedure TTestDialogListenerFMX.Setup;
begin
  DX.Messages.Dialog.Listener.FMX.TMessageDialogListener.Register;
end;

procedure TTestDialogListenerFMX.TearDown;
begin
  DX.Messages.Dialog.Listener.FMX.TMessageDialogListener.UnRegister;

end;

{ TTestDialogListenerVCL }

procedure TTestDialogListenerVCL.Setup;
begin
  DX.Messages.Dialog.Listener.VCL.TMessageDialogListener.Register;
end;

procedure TTestDialogListenerVCL.TearDown;
begin
  DX.Messages.Dialog.Listener.VCL.TMessageDialogListener.UnRegister;
end;

{ TTestDialogListenerBase }

procedure TTestDialogListenerBase.TestDialog;
var
  LMessage: TMessageDialogRequest;
  LResult: TDialogOption;
begin
  LMessage := TMessageDialogRequest.Create('Test: Press OK', [TDialogOption.OK, TDialogOption.cancel]);
  LMessage.Default := TDialogOption.Cancel;
  TMessageManager.DefaultManager.SendMessage(self, LMessage);
  LResult := LMessage.Response;
  Assert.IsTrue(LResult = TDialogOption.OK);
end;

procedure TTestDialogListenerBase.TestDialogCallback;
var
  LMessage: TMessageDialogRequest;
  LResult: TDialogOption;
begin
  LMessage := TMessageDialogRequest.Create('Test: Press OK', [TDialogOption.OK, TDialogOption.cancel]);
  LMessage.Default := TDialogOption.Cancel;
  //This is only suitable for synchronous message handling.
  //Tessing async messages, requires some sort of a busy loop here
  TMessageManager.DefaultManager.SendMessage(self, LMessage.OnResult(
    procedure(AResult: TDialogOption)
    begin
      LResult := LMessage.Response;
      Assert.IsTrue(LResult = TDialogOption.OK);
    end));
end;

initialization

TDUnitX.RegisterTestFixture(TTestDialogListenerFMX);
TDUnitX.RegisterTestFixture(TTestDialogListenerVCL);

end.
