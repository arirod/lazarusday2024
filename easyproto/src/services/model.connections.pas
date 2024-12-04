unit model.connections;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  fpjson,
  jsonparser;

type

  { TModelConnection }

  TModelConnection = class
  private
    FOrigin: string;
  public
    constructor Create(AOrigin: string = '');
    destructor Destroy; override;
    function loadDS(const AFileJSON: string; inMemory: boolean = False): TJSONData;
  end;

implementation

constructor TModelConnection.Create(AOrigin: string = '');
begin
  if AOrigin = EmptyStr then
    FOrigin := '../db/'
  else
    FOrigin := AOrigin;
end;

destructor TModelConnection.Destroy;
begin
  inherited Destroy;
end;

function TModelConnection.loadDS(const AFileJSON: string; inMemory: boolean = False): TJSONData;
var
  absolutePath: string;
  fs: TFileStream;
begin
  absolutePath := IfThen(inMemory, AFileJSON, FOrigin + AFileJSON);
  try
    if inMemory then
      Result := GetJSON(AFileJSON)
    else
    begin
      fs := (TFileStream.Create(absolutePath, fmOpenRead or fmShareDenywrite));
      Result := GetJSON(fs);
    end;
  finally
    //fs.Free;
  end;
end;

end.
