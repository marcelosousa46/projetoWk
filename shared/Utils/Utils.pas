unit Utils;

interface

uses
  System.SysUtils, System.StrUtils;

function ConvertToCurrency(ValueStr: String): Currency;

implementation

function ConvertToCurrency(ValueStr: String): Currency;
begin
  ValueStr := StringReplace(ValueStr, 'R$', '', [rfReplaceAll]);
  ValueStr := StringReplace(ValueStr, '.', '', [rfReplaceAll]);
  ValueStr := StringReplace(ValueStr, ',', '.', [rfReplaceAll]);
  ValueStr := Trim(ValueStr);

  Result := StrToCurrDef(ValueStr, 0);
end;

end.

