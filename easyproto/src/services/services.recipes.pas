unit services.recipes;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  fpjson,
  entity.recipes,
  services.ingredients;

type
  TRecipesService = class
  private
    function matchIngredient(AName: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure parseRecipes(const AData: TJSONData);
  end;

var
  RecipesList: specialize TObjectList<TRecipeEntity>;

implementation

constructor TRecipesService.Create;
begin
  RecipesList := specialize TObjectList<TRecipeEntity>.Create;
end;

destructor TRecipesService.Destroy;
begin
  RecipesList.Free;
  inherited Destroy;
end;

function TRecipesService.matchIngredient(AName: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Pred(IngredientsList.Count) do
  begin
    if AName = IngredientsList[i].Title then
      Result := True;
  end;
end;

procedure TRecipesService.parseRecipes(const AData: TJSONData);
var
  JSONArray, IngredientsArray: TJSONArray;
  RecipeObj: TJSONObject;
  Recipe: TRecipeEntity;
  i, j: integer;
  addInRecipeList: boolean = False;
begin
  try
    JSONArray := AData.FindPath('recipes') as TJSONArray;
    for i := 0 to JSONArray.Count - 1 do
    begin
      RecipeObj := JSONArray.Objects[i];
      Recipe := TRecipeEntity.Create;
      Recipe.Title := RecipeObj.Strings['title'];
      IngredientsArray := RecipeObj.Arrays['ingredients'] as TJSONArray;
      for j := 0 to IngredientsArray.Count - 1 do
      begin
        if matchIngredient(IngredientsArray.Strings[j]) then
        begin
          Recipe.Ingredients.Add(IngredientsArray.Strings[j]);
          addInRecipeList := True;
        end
        else
          addInRecipeList := False;
      end;
      if addInRecipeList then
        RecipesList.Add(Recipe);
    end;
  finally
    AData.Free;
  end;
end;

end.
