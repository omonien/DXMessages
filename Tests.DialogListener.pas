unit Tests.DialogListener;

interface

uses
  DUnitX.TestFramework;

type

  TTestDialogListenerBase = class(TObject)
  public
    [TEST]
    procedure TestDialog; virtual;
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
  LMessage := TMessageDialogRequest.Create([TDialogOption.OK, TDialogOption.cancel], TDialogOption.cancel);
  LMessage.Message := 'Test: Press OK';
  TMessageManager.DefaultManager.SendMessage(self, LMessage);
  LResult := LMessage.Response;
  Assert.IsTrue(LResult = TDialogOption.Ok);
end;

initialization

TDUnitX.RegisterTestFixture(TTestDialogListenerFMX);

end.
