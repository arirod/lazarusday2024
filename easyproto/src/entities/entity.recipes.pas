unit entity.recipes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils;

type

  TRecipeEntity = class
  private
    FTitle: string;
    FIngredients: TStringList;
  public
    constructor Create; overload;
    constructor Create(const ATitle: string; const AIngredients: TStringList); overload;
    destructor Destroy; override;
    property Title: string read FTitle write FTitle;
    property Ingredients: TStringList read FIngredients write FIngredients;
  end;


implementation

constructor TRecipeEntity.Create;
begin
  FIngredients:= TStringList.Create;
end;

constructor TRecipeEntity.Create(const ATitle: string; const AIngredients: TStringList);
begin
  FTitle := ATitle;
  FIngredients := AIngredients;
end;

destructor TRecipeEntity.Destroy;
begin
  FIngredients.Free;
  inherited Destroy;
end;

end.
