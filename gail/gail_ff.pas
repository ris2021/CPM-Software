procedure ff;
var b:byte;
const cc1:array[0..15] of string [4]=
  (' ','�','�','�',#8'��',#8'ͼ',#8'ͻ',#8'͹','��','��','��','��',#8'���',#8'���',#8'���',#8'���');
  cc2:array[0..15] of string [4]=
  (' ','�','�','�',#8'��',#8'��',#8'Ŀ',#8'Ĵ','��','��','��','��',#8'���',#8'���',#8'���',#8'���');
begin
  for y:=0 to bs-1 do
    for x:=0 to bs-1 do begin
      b:=0; gotoxy(x*3+4,y+3);
      if r[y,x]='o' then begin
        if (y>0) and (r[y-1,x]='X') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='X') then b:=b or 2;
        if (x>0) and (r[y,x-1]='X') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='X') then b:=b or 8;
        if (y=0) and (b>0) then write(#26'�'#8#10);
        if (y=bs-1) and (b>0) then write(#10'�'#8#26);
        write(cc1[b]);
      end;
      if r[y,x]='*' then begin
        if (y>0) and (r[y-1,x]='#') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='#') then b:=b or 2;
        if (x>0) and (r[y,x-1]='#') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='#') then b:=b or 8;
        if (x=0) and (b>0) then write(#8#8#8'���');
        if (x=bs-1) and (b>0) then write(#21'�Ĵ'#8#8#8#8);
        write(cc2[b]);
      end;
    end;
end;
