program easylunchtest;

{$mode objfpc}{$H+}

{$Define GuiRunner}

uses
  cmem,
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Classes,
  {$IfDef GuiRunner}
  Forms,
  GuiTestRunner,
  {$Else}
  TextTestRunner,
  {$EndIf}
  ///
  {$IFDEF FPCUnitTest}
  consoletestrunner,
  {$EndIf}
  easylunchtestcase,
  model.connections,
  services.recipes,
  services.ingredients,
  entity.recipes,
  entity.ingredients;


  {$IFDEF FPCUNITTest}
type
  PFCUnitTestRunner = class(TTestRunner)
  protected
    // override the protected methods of TTestRunner to customize its behavior
  end;
var
  Application: PFCUnitTestRunner;
  {$EndIf}

begin

  {$IFDEF FPCUNITTest}
  Application := PFCUnitTestRunner.Create(nil);
  Application.Initialize;
  Application.Run;
  Application.Free;
  {$Else}
  Application.Initialize;
  RunRegisteredTests;
  {$EndIf}
end.
