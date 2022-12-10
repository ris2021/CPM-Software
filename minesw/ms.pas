{$A-}
var f:array[0..39,0..23] of byte;
  i,x,y,fx,fy,fm:byte;
  fo:integer;
  c:char;

procedure lose;
begin
  write(#255);
  f[x,y]:=255;
  for x:=1 to fx do for y:=1 to fy do begin
    if (f[x,y] and (128+64))=128 then begin
      gotoxy(x*2+1,y+2);write('*');
    end;
    if (f[x,y] and (128+64))=64 then begin
      gotoxy(x*2+1,y+2);write('E');
    end;
  end;
  gotoxy(1,23);write(#20'Увы, тут была мина...');
  halt;
end;

procedure open(x,y:byte);
begin
  if (x<1) or (x>fx) or (y<1) or (y>fy) or ((f[x,y] and 64)<>0) then exit;
  if (f[x,y] and 128)<>0 then lose;
  gotoxy(x*2+1,y+2);
  if f[x,y]=0 then begin
    write(' ');f[x,y]:=255;fo:=fo-1;
    open(x-1,y);open(x-1,y-1);open(x-1,y+1);
    open(x+1,y);open(x+1,y-1);open(x+1,y+1);
    open(x,y-1);open(x,y+1);
  end else begin
    write(chr(ord('0')+f[x,y]));
    f[x,y]:=255;fo:=fo-1;
  end;
end;

{$i music.pas}

procedure win;
begin
  music;
  gotoxy(1,23);write(#20'Поздравляю с победой!');
  halt;
end;

begin
  fillchar(f,sizeof(f),0);
  writeln('Сапёр для КРИСС CP/M');
  fx:=20;fy:=10;fm:=20;
  write('Уровень? 1=новичок, 2=любитель, 3=профи, 4=настройка: ');c:=chr(bios(2));
  writeln;
  case c of
    '1':begin fx:=9;fy:=9;fm:=10;end;
    '2':begin fx:=16;fy:=16;fm:=40;end;
    '3':begin fx:=30;fy:=16;fm:=99;end;
    else begin
      write('Введите размер x, y и число мин через пробел :');readln(fx,fy,fm);
      if fx>38 then fx:=38;
      if fy>22 then fy:=22;
      if fx<2 then fx:=2;
      if fy<2 then fy:=2;
      if fm<1 then fm:=1;
    end;
  end;
  i:=1;
  repeat
    x:=random(fx)+1;
    y:=random(fy)+1;
    if f[x,y]<128 then begin
      f[x,y]:=f[x,y]+128;
      f[x+1,y]:=f[x+1,y]+1;
      f[x-1,y]:=f[x-1,y]+1;
      f[x+1,y+1]:=f[x+1,y+1]+1;
      f[x+1,y-1]:=f[x+1,y-1]+1;
      f[x-1,y+1]:=f[x-1,y+1]+1;
      f[x-1,y-1]:=f[x-1,y-1]+1;
      f[x,y+1]:=f[x,y+1]+1;
      f[x,y-1]:=f[x,y-1]+1;
      i:=i+1;
    end;
  until i>fm;
  clrscr;
  writeln('Сапёр для КРИСС, в.0.1 (c) Решетников С.И.');
  write('╔');for x:=1 to fx do write('══');writeln('═╗');
  for y:=1 to fy do begin
    write('║');for x:=1 to fx do write(' .');writeln(' ║');
  end;
  write('╚');for x:=1 to fx do write('══');writeln('═╝');
  fo:=fx*fy;
  gotoxy(1,24);write('Мин: ',fm:2,' Ячеек: ',fo);
  x:=fx div 2;y:=fy div 2;c:=#0;
  repeat
    gotoxy(x*2+1,y+2);
    c:=chr(bios(2));
    case c of
      ^E:if y>1 then y:=y-1;
      ^X:if y<fy then y:=y+1;
      ^S:if x>1 then x:=x-1;
      ^D:if x<fx then x:=x+1;
      '?','.':write(c);
      #13:if (fm>0) or ((f[x,y] and 64)<>0) then begin
            f[x,y]:=f[x,y] xor 64;
            if (f[x,y] and 64)<>0 then begin fm:=fm-1;fo:=fo-1;write(#254); end
            else begin fm:=fm+1;fo:=fo+1;write('.');end;
            gotoxy(6,24);write(fm:2);
            gotoxy(16,24);write(fo,'   ');
          end else write(#7);
      ' ':begin
            port[$f6]:=23;i:=port[$f7];
            if (i and 1)=0 then begin
              {if (f[x,y] and 64)=0 then }open(x,y);
            end else begin
              open(x-1,y);open(x-1,y-1);open(x-1,y+1);
              open(x+1,y);open(x+1,y-1);open(x+1,y+1);
              open(x,y-1);open(x,y+1);
            end;
            gotoxy(16,24);write(fo,'   ');
          end;
      'q':write(f[x,y]);
    end;
    if (fm=0) and (fo=0) then win;
  until c=#27;
  gotoxy(1,23);write(#20'Жалко, уходите не доиграв...');
end.




