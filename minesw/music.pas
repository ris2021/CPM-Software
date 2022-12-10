procedure music;
const m:array[224..233] of byte = (121,145,106,122,161,137,145,161,178,4);
var i:integer;
begin
  for i:=224 to 233 do port[i]:=m[i];
  port[214]:=10;
end;
