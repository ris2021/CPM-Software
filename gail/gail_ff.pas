procedure ff;
var b:byte;
const cc1:array[0..15] of string [4]=
  (' ','º','º','º',#8'ÍÍ',#8'Í¼',#8'Í»',#8'Í¹','ÍÍ','ÈÍ','ÉÍ','ÌÍ',#8'ÍÍÍ',#8'ÍÊÍ',#8'ÍËÍ',#8'ÍÎÍ');
  cc2:array[0..15] of string [4]=
  (' ','³','³','³',#8'ÄÄ',#8'ÄÙ',#8'Ä¿',#8'Ä´','ÄÄ','ÀÄ','ÚÄ','ÃÄ',#8'ÄÄÄ',#8'ÄÁÄ',#8'ÄÂÄ',#8'ÄÅÄ');
begin
  for y:=0 to bs-1 do
    for x:=0 to bs-1 do begin
      b:=0; gotoxy(x*3+4,y+3);
      if r[y,x]='o' then begin
        if (y>0) and (r[y-1,x]='X') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='X') then b:=b or 2;
        if (x>0) and (r[y,x-1]='X') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='X') then b:=b or 8;
        if (y=0) and (b>0) then write(#26'Ë'#8#10);
        if (y=bs-1) and (b>0) then write(#10'Ê'#8#26);
        write(cc1[b]);
      end;
      if r[y,x]='*' then begin
        if (y>0) and (r[y-1,x]='#') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='#') then b:=b or 2;
        if (x>0) and (r[y,x-1]='#') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='#') then b:=b or 8;
        if (x=0) and (b>0) then write(#8#8#8'ÃÄÄ');
        if (x=bs-1) and (b>0) then write(#21'ÄÄ´'#8#8#8#8);
        write(cc2[b]);
      end;
    end;
end;
