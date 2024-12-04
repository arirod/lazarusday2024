program easylunchprototype;

uses
  cmem,
  cthreads,
  Classes,
  SysUtils,
  CustApp,
  fpjson,
  jsonparser,
  StrUtils,
  model.connections,
  services.recipes,
  services.ingredients,
  entity.recipes,
  entity.ingredients;

type

  TEasyLunch = class(TCustomApplication)
  private

    C: TModelConnection;
    Ing: TIngredientsService;
    Rec: TRecipesService;
    dataParam: TDateTime;
    function printResultPrettyJSON: string;
  protected
    procedure InitDateFormats;
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure setUp;
  end;

  { ... implementation ...}
  procedure TEasyLunch.InitDateFormats;
  begin
    DefaultFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
    DefaultFormatSettings.DateSeparator := '-';
  end;

  constructor TEasyLunch.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    InitDateFormats;
  end;

  destructor TEasyLunch.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TEasyLunch.setUp;
  begin
    C := TModelConnection.Create;

    { ...Ingredients ... }
    Ing := TIngredientsService.Create;
    Ing.parseIngredients(C.loadDS('ingredients.json'), dataParam);

    { ... recipes  ... }
    Rec := TRecipesService.Create;
    Rec.parseRecipes(C.loadDS('receipes.json'));
  end;

  procedure TEasyLunch.DoRun;
  var
    jsonOutput: string;
  begin
    inherited DoRun;

    if HasOption('d', 'date') then
    begin
      WriteLn(GetOptionValue('d', 'date'));
      dataParam := StrToDate(GetOptionValue('d', 'date'));
    end
    else
    begin
      WriteLn(sLineBreak,sLineBreak,'Usage: ', ExtractFileName(ExeName), ' --date=[yyyy-mm-dd]',sLineBreak);
      WriteLn(' --date=2018-03-01 : Show All Recipes ');
      WriteLn(' --date=2018-03-07 : Show Selected', sLineBreak,sLineBreak);
    end;

    setUp;
    jsonOutput := printResultPrettyJSON;
    WriteLn(jsonOutput);
    WriteLn('..a copy was created in the /bin directory', sLineBreak);

    with TStringList.Create do
    begin
      Add(jsonOutput);
      SaveToFile('lunchresult.json');
    end;
    Terminate;
  end;

  function TEasyLunch.printResultPrettyJSON: string;
  var
    i, j: integer;
    jsonResult, IngredientsArray: TJSONArray;
    jsonFinal, RecipesObject: TJSONObject;
  begin
    jsonResult := TJSONArray.Create;
    jsonFinal := TJSONObject.Create;
    try
      for i := 0 to RecipesList.Count - 1 do
      begin
        IngredientsArray := TJSONArray.Create;
        RecipesObject := TJSONObject.Create;
        for j := 0 to RecipesList[i].Ingredients.Count - 1 do
          IngredientsArray.Add(RecipesList[i].Ingredients[j]);

        RecipesObject.Add('title', RecipesList[i].Title);
        RecipesObject.Add('ingredients', IngredientsArray);
        jsonResult.Add(RecipesObject);
      end;
      jsonFinal.Add('recipes', JsonResult);
      Result := jsonFinal.FormatJSON();
    finally
      ///
    end;

  end;

var
  App: TEasyLunch;
begin
  App := TEasyLunch.Create(nil);
  App.Title := 'Easy Lunch Prototype';

  if FileExists('heaptrc.trc') then
  begin
    DeleteFile('heaptrc.trc');
  end;
  {$IF Declared(heaptrc)}
  SetHeapTraceOutput('heaptrc.trc');
  {$ENDIF}

  App.Run;
  App.Free;
end.
