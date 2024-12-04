unit easylunchtestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Dialogs,
  {$IFDEF FPCUnitTest}
  fpcunit,
  testutils,
  testregistry,
  {$Else}
  TestFramework,
  {$EndIf}
  ///
  fpjson,
  model.connections,
  entity.recipes,
  entity.ingredients,
  services.recipes,
  services.ingredients;

const
  jsonRecipes = '{"recipes":[{"title":"Ham and Cheese Toastie","ingredients":["Ham","Cheese","Bread","Butter"]},' +
    '{"title":"Fry-up","ingredients":["Bacon","Eggs","Baked Beans","Mushrooms","Sausage","Bread"]},' +
    '{"title":"Salad","ingredients":["Lettuce","Tomato","Cucumber","Beetroot","Salad Dressing"]},' +
    '{"title":"Hotdog","ingredients":["Hotdog Bun","Sausage","Ketchup","Mustard"]}]}';

  jsonIngredients = '{"ingredients":[{"title":"Ham","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Cheese","best-before":"2018-03-08","use-by":"2018-03-13"},{"title":"Bread","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Butter","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Bacon","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Eggs","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Mushrooms","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Sausage","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Hotdog Bun","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Ketchup","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Mustard","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Lettuce","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Tomato","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Cucumber","best-before":"2018-03-25","use-by":"2018-03-27"},{"title":"Beetroot","best-before":"2018-03-25","use-by":"2018-03-27"},' +
    '{"title":"Salad Dressing","best-before":"2018-03-06","use-by":"2018-03-07"}]}';

type

  { TLunchClassesTestCase }

  TLunchClassesTestCase = class(TTestCase)
  private
    C: TModelConnection;
    Ing: TIngredientsService;
    Rec: TRecipesService;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCountRecipe;
    procedure TestCountIngredients;
    procedure TestFindRecipes;
    procedure TestFindIngredient;

  end;

  { TLunchJSONTestCase }

  TLunchJSONTestCase = class(TTestCase)
  private
    C: TModelConnection;
    Ing: TIngredientsService;
    Rec: TRecipesService;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestJSONCountRecipe;
    procedure TestJSONCountIngredients;
    procedure TestJSONFindRecipes;
    procedure TestJSONFindIngredient;
  end;

var
  dataParam: TDateTime = 1;

implementation

procedure TLunchClassesTestCase.TestCountRecipe;
var
  Expected: integer = 4;
begin
  AssertEquals('Number of Items in Receipt Array Object is Wrong', Expected, RecipesList.Count);
end;

procedure TLunchClassesTestCase.TestCountIngredients;
var
  Expected: integer = 16;
begin
  AssertEquals('Number of Items in Ingredients Array Object is Wrong', Expected, IngredientsList.Count);
end;

procedure TLunchClassesTestCase.TestFindRecipes;
var
  i: integer;
begin
  for i := 0 to RecipesList.Count do
    if (RecipesList[i].Title = 'Hotdog') then
    begin
      Check(True);
      Exit;
    end;
end;

procedure TLunchClassesTestCase.TestFindIngredient;
var
  i: integer;
begin
  for i := 0 to IngredientsList.Count do
    if (IngredientsList[i].Title = 'Mushrooms') then
    begin
      Check(True);
      Exit;
    end;
end;

procedure TLunchClassesTestCase.SetUp;
begin
  inherited SetUp;
  C := TModelConnection.Create('../../db/');

  { ...Ingredients ... }
  Ing := TIngredientsService.Create;
  Ing.parseIngredients(C.loadDS('ingredients.json'), dataParam);

  { ... recipes  ... }
  Rec := TRecipesService.Create;
  Rec.parseRecipes(C.loadDS('receipes.json'));
end;

procedure TLunchClassesTestCase.TearDown;
begin
  Rec.Free;
  Ing.Free;
  C.Free;
end;

{ TLunchJSONTestCase }

procedure TLunchJSONTestCase.SetUp;
begin
  inherited SetUp;
  C := TModelConnection.Create('../../db/');

  { ...Ingredients ... }
  Ing := TIngredientsService.Create;
  Ing.parseIngredients(C.loadDS('ingredients.json'), dataParam);

  { ... recipes  ... }
  Rec := TRecipesService.Create;
  Rec.parseRecipes(C.loadDS('receipes.json'));
end;

procedure TLunchJSONTestCase.TearDown;
begin
  inherited TearDown;
  Rec.Free;
  Ing.Free;
  C.Free;
end;

procedure TLunchJSONTestCase.TestJSONCountRecipe;
var
  AData: TJSONData;
  JSONArray: TJSONArray;
  Expected: integer = 3;
begin
  AData := C.loadDS(jsonRecipes, True);
  JSONArray := AData.FindPath('recipes') as TJSONArray;
  AssertEquals('Number of Items in Receipt JSON Array Object is Wrong', Expected, JSONArray.Count);
end;

procedure TLunchJSONTestCase.TestJSONCountIngredients;
begin
  Fail('not yet implemented');
end;

procedure TLunchJSONTestCase.TestJSONFindRecipes;
var
  AData: TJSONData;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Title: TJSONStringType;
  i: integer;
  found: boolean = False;
begin
  JSONObject := TJSONObject.Create;
  AData := C.loadDS(jsonRecipes, True);

  JSONArray := AData.FindPath('recipes') as TJSONArray;
  for i := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Items[i] as TJSONObject;
    Title := JSONObject.Get('title', '');
    if Title = 'Fry-up' then
    begin
      Found := True;
      Exit;
    end;
  end;
  Check(Found, 'Item in Recipes not Found in JSON Array');
end;

procedure TLunchJSONTestCase.TestJSONFindIngredient;
var
  AData: TJSONData;
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Title: TJSONStringType;
  i: integer;
  found: boolean = False;
begin
  JSONObject := TJSONObject.Create;
  AData := C.loadDS(jsonIngredients, True);

  JSONArray := AData.FindPath('ingredients') as TJSONArray;
  for i := 0 to JSONArray.Count - 1 do
  begin
    JSONObject := JSONArray.Items[i] as TJSONObject;
    Title := JSONObject.Get('title', '');
    if Title = 'Bacon' then
    begin
      Found := True;
      Exit;
    end;
  end;
  Check(Found, 'Item in Ingredients' + sLineBreak + ' not Found in JSON Array');
end;

initialization
  {$IFDEF FPCUnitTest}
  RegisterTest(TLunchClassesTestCase);
  {$Else}
  TestFramework.RegisterTest('Lazarus Unit Tests Example', TLunchClassesTestCase.Suite);
  TestFramework.RegisterTest(TLunchJSONTestCase.Suite);
  {$EndIf}
end.
