(*$U-,C-*)
type dtt=array[0..5,0..5] of byte;
var s:array[0..23,0..21] of byte;
  ss:array[0..23] of byte;
  d,d1,dn:dtt;
  w,lvl,x,y,dx,dy,score:integer;
  g,c:char;
  SC:array[1..24,1..80] of char;
  fm:byte;

procedure new;
begin
  fillchar(dn,sizeof(dn),0);
  case random(fm) of
    0:begin dn[2,1]:=1;dn[2,2]:=1;dn[2,3]:=1;dn[2,4]:=1;end;
    1:begin dn[2,2]:=1;dn[2,3]:=1;dn[3,3]:=1;dn[3,2]:=1;end;
    2:begin dn[2,1]:=1;dn[2,2]:=1;dn[2,3]:=1;dn[3,3]:=1;end;
    3:begin dn[3,1]:=1;dn[3,2]:=1;dn[3,3]:=1;dn[2,3]:=1;end;
    4:begin dn[1,2]:=1;dn[2,2]:=1;dn[3,2]:=1;dn[2,3]:=1;end;
    5:begin dn[2,1]:=1;dn[2,2]:=1;dn[3,2]:=1;dn[3,3]:=1;end;
    6:begin dn[3,1]:=1;dn[3,2]:=1;dn[2,2]:=1;dn[2,3]:=1;end;
    7:begin dn[2,2]:=1;dn[2,3]:=1;dn[2,4]:=1;end;
    8:begin dn[2,2]:=1;dn[2,3]:=1;dn[3,3]:=1;end;
    9:begin dn[2,2]:=1;dn[2,3]:=1;end;
    10:begin dn[2,2]:=1;end;
  end;
  x:=(w div 2)-2;y:=0;
end;

procedure rotate;
var i,j,b:byte;
begin
  d1:=d;
  writeln;
  for i:=1 to 4 do begin
    d[1,i]:=d1[i,4];d[i,1]:=d1[1,5-i];d[4,i]:=d1[i,1];d[i,4]:=d1[4,5-i];
  end;
  d[2,2]:=d1[2,3];d[3,2]:=d1[2,2];d[2,3]:=d1[3,3];d[3,3]:=d1[3,2];
end;

procedure draw(x,y:byte);
var i,j,b:byte;
const t:array[0..15] of char=(
  #21,'┌','┐','┬','└','├','┼','┼',
  '┘','┼','┤','┼','┴','┼','┼','┼');
begin
  for j:=1 to 5 do begin
    gotoxy(x+26,y+j);
    for i:=1 to 5 do begin
      b:=0;
      if d[i,j]=1 then b:=b or 1;
      if d[i-1,j]=1 then b:=b or 2;
      if d[i,j-1]=1 then b:=b or 4;
      if d[i-1,j-1]=1 then b:=b or 8;
      {write(t[b]);}bios(3,ord(t[b]));
      if (d[i,j]=1) or (d[i,j-1]=1) then write('─') else bios(3,21);{write(#21);}
    end;
  end;
end;

procedure fix(x,y:byte);
var i,j,b:byte;
const t:array[0..15] of char=(
  #21,#24,#20,#28,#18,#26,#22,#30,
  #17,#25,#21,#29,#19,#27,#23,#31);
  t2:array[0..3]of char=(#21,#28,#19,#31);
begin
  for j:=1 to 5 do begin
    gotoxy(x+26,y+j);
    for i:=1 to 5 do begin
      b:=0;
      if d[i,j]=1 then b:=b or 1;
      if d[i-1,j]=1 then b:=b or 2;
      if d[i,j-1]=1 then b:=b or 4;
      if d[i-1,j-1]=1 then b:=b or 8;
      if b>0 then begin bios(3,27);bios(3,ord('\'));bios(3,ord(t[b]));end{write(#27'\',t[b])} else bios(3,21);{write(#21);}
      b:=d[i,j]+(d[i,j-1] shl 1);
      if b>0 then begin bios(3,27);bios(3,ord('\'));bios(3,ord(t2[b]));end{write(#27'\',t2[b])} else bios(3,21);{write(#21);}
    end;
  end;
end;

procedure clear(x,y:byte);
var i,j,b:byte;
begin
  for j:=1 to 5 do begin
    gotoxy(x+26,y+j);
    for i:=1 to 5 do begin
      b:=0;
      if d[i,j]=1 then b:=b or 1;
      if d[i-1,j]=1 then b:=b or 2;
      if d[i,j-1]=1 then b:=b or 4;
      if d[i-1,j-1]=1 then b:=b or 8;
      if b>0 then write(' ') else write(#21);
      if (d[i,j]=1) or (d[i,j-1]=1) then write(' ') else write(#21);
    end;
  end;
end;

procedure stakan;
var i,j,b,x1,y1:integer;
const t:array[0..15] of char=(
  #21,#24,#20,#28,#18,#26,#22,#30,
  #17,#25,#21,#29,#19,#27,#23,#31);
  t2:array[0..3]of char=(#21,#28,#19,#31);
begin
  for j:=1 to 23 do begin
    gotoxy(24,j);
    for i:=0 to w do begin
      b:=0;
      if s[j,i]=1 then b:=b or 1;
      if s[j,i-1]=1 then b:=b or 2;
      if s[j-1,i]=1 then b:=b or 4;
      if s[j-1,i-1]=1 then b:=b or 8;
      if b>0 then begin bios(3,27);bios(3,ord('\'));bios(3,ord(t[b]));end else bios(3,32);
      b:=s[j,i]+(s[j-1,i] shl 1);
      if b>0 then begin bios(3,27);bios(3,ord('\'));bios(3,ord(t2[b]));end else if i<w then bios(3,ord(g));
      {write(s[j,i],b,':');}
    end;
  end;
end;

function check(x,y:integer):boolean;
var i,j,b,x1,y1:integer;
begin
  check:=false;
  for j:=1 to 5 do begin
    for i:=1 to 5 do begin
      if d[i,j]=1 then begin
        x1:=x+i;y1:=y+j;
        if (x1<0) or (x1>w-1) or (y1>22) then exit;
        if s[y1,x1]=1 then exit;
      end;
    end;
  end;
  check:=true;
end;

procedure put;
var i,j,x1,y1:integer;
begin
  for j:=1 to 5 do begin
    for i:=1 to 5 do begin
      if d[i,j]=1 then begin
        x1:=x+i;y1:=y+j;
        s[y1,x1]:=1;ss[y1]:=ss[y1]+1;
      end;
    end;
  end;
end;

procedure clean;
var i:integer;
begin
  for i:=1 to 23 do if ss[i]=w then begin
    fillchar(s[i],sizeof(s[i]),0);stakan;delay(lvl*2);
    gotoxy(1,10);score:=score+1;write('Результат: ',score);
    if score mod 10=0 then begin
      if lvl>5 then lvl:=lvl-5;gotoxy(1,11);write('Уровень: ',lvl);
    end;
    move(ss[0],ss[1],i);
    move(s[0],s[1],i*sizeof(s[0]));
  end;
end;

begin
  writeln('TetCRISS v.0.2');
  w:=10; write('Ширина стакана? (',w,'): '); readln(w);
  lvl:=50;write('Уровень 10-250 (',lvl,'): ');readln(lvl);
  g:='.';{write('Сетка (',g,'): ');readln(g);}
  fm:=7; write('Игра: 7-тетрис, 9-с тримино, 10-с дoмино, 11-с одном. (',fm,'): '); readln(fm);
  if fm>11 then fm:=11;
  clrscr;write(#30);
  writeln;
  writeln('TetCRISS v.0.1');
  writeln;
  writeln('6 - вправо');
  writeln('4 - влево');
  writeln('5 - поворот');
  writeln('пробел - сброс');
  writeln('ESC - выход');
  gotoxy(1,13);
  writeln('Следующая фигура');
  writeln('╔═══════════════╗');
  writeln('║               ║');
  writeln('║               ║');
  writeln('║               ║');
  writeln('║               ║');
  writeln('║               ║');
  writeln('╚═══════════════╝');
  for y:=2 to 23 do begin
    gotoxy(20,y);write(#$de#$db#$db#$dd);
    gotoxy(20+2*w+1+4,y);write(#$de#$db#$db#$dd,24-y);
  end;
  gotoxy(20,24);write(#$de);
  for x:=21 to 21+w*2+1+5 do write(#$db);
  write(#$dd);
  fillchar(s,sizeof(s),0);
  fillchar(ss,sizeof(ss),0);
  stakan;new;d:=dn;new;draw(x*2,y);score:=0;
  repeat
    dx:=0;dy:=0;
    if c=#0 then port[222]:=lvl;
    if c<>' ' then c:=#0;
    repeat
      if (bios(1)=255) then c:=upcase(chr(bios(2)));
    until (port[222]=0) or (c<>#0);
    case c of
      #0:dy:=1;
      '2',^X,' ':begin dy:=1;c:=' ';end;
      '4',^S:dx:=-1;
      '6',^D:dx:=1;
      '5',^E:begin clear(x*2,y);rotate;end;
      'P':bios(2);
      'F':fix(x*2,y);
      'S':stakan;
    end;
    if check(x+dx,y+dy) then begin
      if (dx<>0) or (dy<>0) then clear(x*2,y);
      if dx<>0 then begin
        draw(x*2+dx,y+dy);clear(x*2+dx,y);
        port[222]:=port[222]+3;
      end;
      x:=x+dx;y:=y+dy;
      draw(x*2,y);
    end else begin
      if c in ['5',^E] then d:=d1;
      fix(x*2,y);
      if c in [#0,' '] then begin
        put;clean;stakan;
        gotoxy(1,15);
        writeln('║           ');
        writeln('║           ');
        writeln('║           ');
        writeln('║           ');
        writeln('║           ');
        d:=dn;new;d1:=d;d:=dn;draw(-21,14);d:=d1;
        c:=#0;
        if check(x,y) then draw(x*2,y) else c:=#27;
      end else begin
        write(#7);delay(lvl);draw(x*2,y);
      end;
    end;
  until c=#27;
  {port[208]:=24 shl 3;}
  clrscr;write(#31);
  writeln('Вот и всё...');
  writeln('Результат: уровень ',lvl,', результат ',score);
end.

