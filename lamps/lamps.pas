{$C-}
var s,n,d,x,y,x1,y1,i,f,lmp,g,stp:integer;
  b:array[1..2] of string[2];
  a:array[1..20,1..20] of integer;
  s2:string[4];
  k:char;

{$i music.pas}

procedure inversy1;
begin
  a[x,y]:=1-a[x,y];
  if x>1 then a[x-1,y]:=1-a[x-1,y];
  if x<n then a[x+1,y]:=1-a[x+1,y];
  if y>1 then a[x,y-1]:=1-a[x,y-1];
  if y<n then a[x,y+1]:=1-a[x,y+1];
end;

procedure inversy2;
begin
  gotoxy(x*2,y+1);write(b[a[x,y]+1]);
  if x>1 then begin gotoxy((x-1)*2,y+1);write(b[a[x-1,y]+1]);end;
  if x<n then begin gotoxy((x+1)*2,y+1);write(b[a[x+1,y]+1]);end;
  if y>1 then begin gotoxy(x*2,y-1+1);write(b[a[x,y-1]+1]);end;
  if y<n then begin gotoxy(x*2,y+1+1);write(b[a[x,y+1]+1]);end;
end;

procedure lamp1;
var i,f:integer;
begin
  lmp:=0;
  for i:=1 to n do for f:=1 to n do if a[i,f]=1 then lmp:=lmp+1;
end;

procedure lamp2;
var i,f:integer;
begin
  lmp:=0;
  for i:=1 to n do for f:=1 to n do if a[i,f]=1 then lmp:=lmp+1;
  gotoxy(57,1);write(lmp:3);
end;

procedure musicstop(m:integer);
begin
  if m=1 then music;
  if m=0 then port[214]:=255;
end;

procedure bingbong;
begin
  gotoxy(x*2,y+1);write('  ');
  port[222]:=25;
  repeat
    if keypressed then port[222]:=0;
  until port[222]=0;
  gotoxy(x*2,y+1);write(b[a[x,y]+1]);
  port[222]:=25;
  repeat
    if keypressed then port[222]:=0;
  until port[222]=0;
end;

procedure fieldart;
var x1,y1:integer;
begin
  for y1:=1 to n do begin
    gotoxy(2,y1+1);
    for x1:=1 to n do begin
      write(b[a[x1,y1]+1]);
    end;
    writeln;
  end;
end;

procedure step;
var g:integer;
begin
  stp:=stp+1;
  gotoxy(68,1);
  write(stp);
end;

begin
   b[1]:='Ўў';b[2]:='°∙';
   writeln('Игра "Лампочки" для CRISS CP/M, версия 2.2');
   writeln('(c) Решетников С.И., 2022');
   writeln('Пробел изменяет состояние лампочки и её 4 соседей,');
   writeln('задача погасить все лампочки. Удачи!');
   n:=5; write('Размер поля, от 3 до 20 (',n,'): ');
   readln(n);
   if (n<3) or (n>20) then begin if n<3 then n:=3;if n>20 then n:=20;end;
   d:=n;
   write('Сложность, от 1 до 99 (',d,'): ');
   readln(d); if d>99 then d:=99;
   write(#30#12);
   fillchar(a,sizeof(a),0);
   for i:=1 to d do begin
     x:=random(n)+1;
     y:=random(n)+1;
     inversy1;
   end;
   lamp1;stp:=0;
   write('Игра "Лампочки" для CRISS CP/M. Сложноcть: ',d:2,' Лампочек: ',lmp:3,' Ходов: ',stp);
   x:=1;y:=1;
   fieldart;
   repeat
     k:=#0;bingbong;
     if keypressed then begin
       read(KBD,k);
       case k of
         ^E:if y>1 then y:=y-1;
         ^X:if y<n then y:=y+1;
         ^S:if x>1 then x:=x-1;
         ^D:if x<n then x:=x+1;
         ' ':begin inversy1;inversy2;lamp2;mus2;step;end;
        { 'm':begin s:=1-s;musicstop(s);end;}
       end;
     end;
   until (k in [#27,'e','E','q','Q']) or (lmp=0);
   if lmp=0 then begin
     music;
   end;
   write(#12'Пока!');
   writeln(#31);
end.
