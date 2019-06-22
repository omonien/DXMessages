program TestMessages;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
//FMX and VCL is mixed on purpos, which will hints about resource dupes
{$HINTS off}
uses
  System.SysUtils,
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
{$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Tests.DialogListener in 'Tests.DialogListener.pas',
  DX.Messages.Dialog in 'DX.Messages.Dialog.pas',
  DX.Messages.Dialog.UITypesHelper in 'DX.Messages.Dialog.UITypesHelper.pas',
  DX.Messages.Dialog.Listener in 'DX.Messages.Dialog.Listener.pas',
  DX.Messages.Dialog.Types in 'DX.Messages.Dialog.Types.pas',
  DX.Messages.Dialog.Listener.FMX in 'DX.Messages.Dialog.Listener.FMX.pas',
  DX.Messages.Dialog.Listener.VCL in 'DX.Messages.Dialog.Listener.VCL.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    // tell the runner how we will log things
    // Log to the console window
    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; // When true, Assertions must be made during tests;

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.