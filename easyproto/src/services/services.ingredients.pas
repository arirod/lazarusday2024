unit services.ingredients;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  fpjson
  ,
  entity.ingredients;

type
  TIngredientsService = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure parseIngredients(const AData: TJSONData; ADateParam: TDateTime = 0);
  end;

var
  IngredientsList: specialize TObjectList<TIngredientsEntity>;

implementation

uses
  DateUtils;

constructor TIngredientsService.Create;
begin
  IngredientsList := specialize TObjectList<TIngredientsEntity>.Create;
end;

destructor TIngredientsService.Destroy;
begin
  IngredientsList.Free;
  inherited Destroy;
end;

procedure TIngredientsService.parseIngredients(const AData: TJSONData; ADateParam: TDateTime);
var
  LArray: TJSONArray;
  LObject: TJSONObject;
  i: integer;
  Title: string;
  BestBefore, UseBy: TDateTime;

  function parseDate(ADate: string): TDateTime;
  var
    y, m, d: longint;
  begin
    y := StrToInt(copy(ADate, 0, 4));
    m := StrToInt(copy(ADate, 6, 2));
    d := StrToInt(copy(ADate, 9, 2));
    Result := EncodeDate(y, m, d);
  end;

begin
  LArray := AData.FindPath('ingredients') as TJSONArray;
  try
    for i := 0 to LArray.Count - 1 do
    begin
      LObject := LArray.Items[i] as TJSONObject;
      try
        Title := LObject.Get('title', '');
        BestBefore := parseDate(LObject.Get('best-before', ''));
        UseBy := parseDate(LObject.Get('use-by', ''));

        { ... criteria ...}
        if (BestBefore > ADateParam) and (ADateParam <> 0) then
          IngredientsList.Add(TIngredientsEntity.Create(Title, BestBefore, UseBy));
      finally
        ///
      end;
    end;
  finally
    AData.Free;
  end;
end;

end.
