procedure music;
const m:array[224..233] of byte = (121,145,106,122,161,137,145,161,178,4);
var i:integer;
begin
  for i:=224 to 233 do port[i]:=m[i];
  port[214]:=10;
  repeat until port[214]=0;
end;

procedure mus2;
begin
  port[224]:=121;port[225]:=4;port[214]:=2;
end;

