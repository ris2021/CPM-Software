var bs,bs1,df,x,y,mc:byte;
  c:char;
  r:array[0..30,0..30] of char;
  rr:array[1..100,1..4] of byte;
  nn,nr,db,w:byte;
  nm:integer;

{$i music.pas}

procedure ff;
var b:byte;
const cc1:array[0..15] of string [4]=
  (' ','║','║','║',#8'══',#8'═╝',#8'═╗',#8'═╣','══','╚═','╔═','╠═',#8'═══',#8'═╩═',#8'═╦═',#8'═╬═');
  cc2:array[0..15] of string [4]=
  (' ','│','│','│',#8'──',#8'─┘',#8'─┐',#8'─┤','──','└─','┌─','├─',#8'───',#8'─┴─',#8'─┬─',#8'─┼─');
begin
  for y:=0 to bs-1 do
    for x:=0 to bs-1 do begin
      b:=0; gotoxy(x*3+4,y+3);
      if r[y,x]='o' then begin
        if (y>0) and (r[y-1,x]='X') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='X') then b:=b or 2;
        if (x>0) and (r[y,x-1]='X') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='X') then b:=b or 8;
        if (y=0) and (b>0) then write(#26'╦'#8#10);
        if (y=bs-1) and (b>0) then write(#10'╩'#8#26);
        write(cc1[b]);
      end;
      if r[y,x]='*' then begin
        if (y>0) and (r[y-1,x]='#') then b:=b or 1;
        if (y<bs-1) and (r[y+1,x]='#') then b:=b or 2;
        if (x>0) and (r[y,x-1]='#') then b:=b or 4;
        if (x<bs-1) and (r[y,x+1]='#') then b:=b or 8;
        if (x=0) and (b>0) then write(#8#8#8'├──');
        if (x=bs-1) and (b>0) then write(#21'──┤'#8#8#8#8);
        write(cc2[b]);
      end;
    end;
end;

procedure w1;
begin
  ff;gotoxy(1,23);write(#20'Поздравляю с выигрышем!');
  music; halt;
end;

procedure vrr;
var x:integer;
begin
  write(#27'B6');gotoxy(1,16);
  for x:=1 to nr do write(#22'[',x,' ',rr[x,1],' ',rr[x,2],'] ');
  write(#27'C6');
end;

procedure w2;
begin
  ff;gotoxy(1,23);write(#20'Увы, партия проиграна...');
  if df=1 then vrr;
  halt;
end;

procedure sr(j,v:byte);
var i:byte;
begin
  if (v=0) and (rr[j,1]=0) and (rr[j,2]=nn+1) then w1;
  if v=0 then for i:=1 to nr do if i<>j then begin
    if rr[j,2]=nn+1 then begin
      if rr[i,1]=rr[j,1] then rr[i,1]:=nn+1;
      if rr[i,2]=rr[j,1] then rr[i,2]:=nn+1;
    end else begin
      if rr[i,1]=rr[j,2] then rr[i,1]:=rr[j,1];
      if rr[i,2]=rr[j,2] then rr[i,2]:=rr[j,1];
    end;
  end;
  rr[j]:=rr[nr]; nr:=nr-1;
  i:=1;
  repeat
    if rr[i,1]=rr[i,2] then begin rr[i]:=rr[nr]; nr:=nr-1; end else i:=i+1;
  until i>nr;
  if db=1 then write(#27'B6'#27#132#170'SR: ',j,' ',v,' ',nr,' ',#27'C6');
end;

procedure srxy(x,y:byte);
var n1,n2,j,i:byte;
begin
  if (y mod 2=0) and ((x=0) or (x=bs-1)) then exit;
  if y mod 2=0 then begin
    n1:=((y-2) div 2)*(bs1-2) + (x-2) div 2 +1;
    n2:=n1+(bs1-2);
  end else begin
    if x=1 then begin
      n1:=0; n2:=((y-1) div 2)*(bs1-2)+1;
    end else if x=bs-2 then begin
      n1:=((y-1) div 2)*(bs1-2)+bs1-2; n2:=nn+1;
    end else begin
      n1:=((y-1) div 2)*(bs1-2)+((x-1) div 2); n2:=n1+1;
    end;
  end;
  i:=0;
  for j:=1 to nr do if (rr[j,3]=n1) and (rr[j,4]=n2) then i:=j;
  if i>0 then sr(i,0);
  if db=1 then write(#27'B6'#27#131#170'SRXY: ',n1,' ',n2,' ',i,#27'C6');
end;

procedure cw;
var s:set of byte;
  i:byte;
begin
  s:=[0];i:=1;
  repeat
    if (rr[i,1] in s) and not(rr[i,2] in s) then begin s:=s+[rr[i,2]];i:=1;end
    else if (rr[i,2] in s) and not(rr[i,1] in s) then begin s:=s+[rr[i,1]];i:=1;end
    else i:=i+1;
  until i>nr;
  if db=1 then begin gotoxy(1,16); for i:=0 to nn+1 do if i in s then write(i,' '); write(#22); end;
  if not((nn+1) in s) then w2;
end;


procedure mv(n,d:byte);
var x,y:byte;
begin
  n:=n-1; x:=(n mod (bs1-2)); y:=(n div (bs1-2));
  gotoxy(4+x*6+6,4+y*2); x:=x*2+2; y:=y*2+1;
  if d=3 then begin write(#10#8'═══');y:=y+1;end;
  if d=2 then begin write(#21#21#21'║');x:=x+1;end;
  if d=1 then begin write(#8#8#8'║');x:=x-1;end;
  r[y,x]:='X';
  n:=n+1;
  if db=1 then write(#27'B6'#27#130#170'MV: ',n,' ',d,#27'C6');
end;

procedure mm(y,x:byte);
var u:array[0..100] of real;
  i,j,s:byte;
  di,m:real;
begin
  gotoxy(1,24);write('Думаю...');
  for i:=0 to nn+1 do u[i]:=0;
  u[0]:=0;u[nn+1]:=100;
  for s:=1 to 20 do begin
    for i:=1 to nn do begin
      di:=0;
      for j:=1 to nr do begin
        if rr[j,1]=i then di:=di-(u[rr[j,2]]-u[rr[j,1]]);
        if rr[j,2]=i then di:=di+(u[rr[j,2]]-u[rr[j,1]]);
      end;
      u[i]:=u[i]-di/4;
    end;
{ gotoxy(1,16);write(#20);
 for i:=1 to nn do begin
  if (i-1) mod (bs1-2) = 0 then writeln;
  write(i,':',u[i]:4:2,'  ');
 end;
readln; }
  end;
  m:=0;j:=1;
  for i:=1 to nr do begin
    di:=abs(u[rr[i,2]]-u[rr[i,1]]);
    if di>m then begin if random(100)<df then j:=i;m:=di;end;
  end;
{  gotoxy(52,24); write(j:2,' ',m:4:2);}
  if rr[j,3]=0 then mv(rr[j,4],1)
  else if rr[j,4]=nn+1 then mv(rr[j,3],2)
  else if rr[j,4]-rr[j,3]>1 then mv(rr[j,3],3)
  else mv(rr[j,4],1);
  if db=1 then write(#27'B6'#27#133#170'MM: ',j,' ',rr[j,1],' ',rr[j,2],' ',rr[j,3],' ',rr[j,4],#27'C6');
  sr(j,1);
  cw;
end;

procedure arr(n1,n2:byte);
begin
  nr:=nr+1; rr[nr,1]:=n1; rr[nr,2]:=n2;
  rr[nr,3]:=n1; rr[nr,4]:=n2;
end;

begin
  writeln('Игра Гейла');
  bs1:=6; write('Размер поля (',bs1,')? '); readln(bs1);
  if bs>10 then bs:=10;
  if bs<3 then bs:=3;
  bs:=bs1*2-1;
  df:=90; write('Сложность (',df,')? '); readln(df);
  clrscr;
  writeln('Игра Гейля, в.0.1, Решетников С.И. для КРИСС');
  write(#$d5'══');for x:=1 to bs-1 do write('═══'); writeln('═══'#$b8);
  fillchar(r,sizeof(r),32); nn:=0;nr:=0;
  for y:=0 to bs-1 do begin
    write('│  ');
    for x:=0 to bs-1 do begin
      c:=' ';
      if (y mod 2=0) and (x mod 2=1) then begin c:='o';r[y,x]:=c;end;
      if (y mod 2=1) and (x mod 2=0) then begin
        c:='*'; r[y,x]:=c;
        if (x>0) and (x<bs-1) then nn:=nn+1;
        if x=2 then arr(0,nn);
        if x=bs-3 then arr(nn,(bs1-2)*(bs1-1)+1);
        if (x>2) and (x<bs-1) then arr(nn-1,nn);
        if (x>1) and (x<bs-1) and (y<bs-2) then arr(nn,nn+bs1-2);
      end;
      write(c,'  ');
    end;
    writeln('│');
  end;
  write(#$d4'══');for x:=1 to bs-1 do write('═══'); writeln('═══'#$be);

  gotoxy(1,23);write('Хотите ходить первым (Y/N)? ');readln(c);
  gotoxy(1,23);writeln('Ваша цель соединить правый и левый край поля, у компьютера - верхний и нижний.');

  x:=1;y:=1;nm:=1;db:=0;w:=0;
  gotoxy(1,24);write(#22'           Ходов:     Сложность: ',df:3);
  if (upcase(c)<>'Y') then mm(0,0);
  repeat
    gotoxy(1,24); write('Ваш ход!');
    if (y mod 2=1) then gotoxy(4+x*3,3+y) else gotoxy(4+x*3,3+y);
    c:=chr(bios(2));
    case c of
      ' ':if r[y,x]=' ' then begin
            if (y mod 2=1) then write(#8'───') else write('│');
            r[y,x]:='#'; srxy(x,y);
            mm(y,x);
            nm:=nm+1; gotoxy(19,24); write(nm);
          end else write(#7);
      ^D:if x<bs-2 then x:=x+2;
      ^S:if x>1 then x:=x-2;
      ^X:if y<bs-2 then begin y:=y+1;if x>0 then x:=x-1 else x:=x+1; end;
      ^E:if y>1 then begin y:=y-1;if x>0 then x:=x-1 else x:=x+1; end;
      'r':vrr;
      'c':cw;
      'm':mm(0,0);
      'd':db:=1-db;
    end;
  until c=#27;
  clrscr;
end.

