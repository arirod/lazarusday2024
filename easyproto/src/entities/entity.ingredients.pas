unit entity.ingredients;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type
  TIngredientsEntity = class
  private
    FTitle: string;
    FBestBefore: TDateTime;
    FUseBy: TDateTime;
  public
    constructor Create; overload;
    constructor Create(ATitle: string; ABestBefore: TDateTime; AUseBy: TDateTime); overload;
    destructor Destroy; override;
    property Title: string read FTitle write FTitle;
    property BestBefore: TDate read FBestBefore write FBestBefore;
    property UseBy: TDate read FUseBy write FUseBy;
  end;

implementation

constructor TIngredientsEntity.Create;
begin
  inherited Create;
end;

constructor TIngredientsEntity.Create(ATitle: string; ABestBefore: TDateTime; AUseBy: TDateTime);
begin
  FTitle := ATitle;
  FBestBefore := ABestBefore;
  FUseBy := AUseBy;
end;

destructor TIngredientsEntity.Destroy;
begin
  inherited Destroy;
end;

end.
