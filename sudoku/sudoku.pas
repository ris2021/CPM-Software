type ta=array[0..15,0..15] of byte;
var m1,m2,m3:ta;
  x,y,n,cpl,i,b,tm1,tm2,tm3:byte;
  c:char;
  nn,err,mvs,rst:integer;
label L1;

procedure field;
var x,y,yy,i,j:byte;
begin
  yy:=3;
  for y:=1 to n+1 do begin
    gotoxy(5,yy);
    if y=1 then write('┌')
    else if y>n then write('└')
    else write('├');
    for x:=1 to n-1 do begin
      for i:=1 to n do write('───');
      if y=1 then write('┬')
      else if y>n then write('┴')
      else write('┼');
    end;
    for i:=1 to n do write('───');
    if y=1 then write('┐')
    else if y>n then write('┘')
    else write('┤');
    if y<=n then for j:=1 to n do begin
      yy:=yy+1;gotoxy(5,yy);
      for i:=1 to n do begin
        write('│');
        for x:=1 to n do begin
          write(' . ');
        end;
      end;
      write('│');
    end;
    yy:=yy+1;
  end;
end;

procedure print;
var x,y,xx,yy:byte;
begin
  yy:=3;write(#30);
  for y:=0 to nn-1 do begin
    if (y mod n)=0 then yy:=yy+1;
    xx:=5+2-1;
    for x:=0 to nn-1 do begin
      if (x mod n)=0 then xx:=xx+1;
      gotoxy(xx,yy);
      if m2[x,y]<>0 then write(m2[x,y],':')
      else if m1[x,y]<>0 then write(m1[x,y])
      else write('.');
      xx:=xx+3;
    end;
    yy:=yy+1;
  end;
end;

function ge(x,y:integer):integer;
var xx,yy,m:integer;
  ea:array[0..15] of integer;
begin
  m:=0;
  for yy:=y*n to y*n+n-1 do
    for xx:=x*n to x*n+n-1 do
      if m2[xx,yy]=0 then begin
        ea[m]:=(xx shl 8)+yy; m:=m+1;
      end;
  ge:=ea[random(m)];
end;

procedure start;
var x,y,i,j,k1,k2,v,vv,b,xx,yy:integer;
{  mn,mn2:set of byte;}
const ss:array[0..4] of string[32]=('сейчас-сейчас',
  'что-то сегодня медленно',
  'ещё немного, почти получилось',
  'терпение, только терпение',
  'сейчас ещё раз попробую');
label L1;
begin
L1:
  fillchar(m1,sizeof(m1),0);
  fillchar(m2,sizeof(m2),0);
  fillchar(m3,sizeof(m3),0);
  y:=0;
  repeat
    x:=0;vv:=0;
    repeat
      for i:=0 to n-1 do fillchar(m2[x*n+i,y*n],n,0);
      {print;}write('.');
      {mn2:=[1,2,3,4,5,6,7,8,9];}
      i:=1; repeat
       {if i in mn2 then begin}
        v:=0;
        repeat
          j:=ge(x,y);xx:=hi(j);yy:=lo(j);
          j:=0;{mn:=[1,2,3,4,5,6,7,8,9];}
          repeat
            if m2[xx,j]=i then j:=nn;
            if m2[j,yy]=i then j:=nn;
            j:=j+1; {mn:=mn-[m2[xx,j]]-[m2[j,yy]];}
          until j>=nn;
          {for b:=1 to nn do if mn=[b] then begin
            m2[xx,yy]:=b;
            mn2:=mn2-[b];v:=250;i:=i-1;
          end;}
 {         gotoxy(5,23);write(j:4,x:4,y:4,xx:4,yy:4,v:4);}
          if bios(1)=255 then begin write(#31);halt;end;
          if (m2[xx,yy]=0) and (j=nn) then begin m2[xx,yy]:=i;v:=250;end;
          v:=v+1;
        until v>50;
        if v=51 then begin
          vv:=vv+1;
          if random(20)=1 then begin
            writeln;writeln(ss[random(5)]);
          end;
          if (vv=10) or (x=n-1) and (y=n-1) then goto L1; i:=nn+1;x:=x-1;
        end;
        {print;}
       {end;}
       i:=i+1;
      until i>nn;
      x:=x+1;
    until x=n;
    y:=y+1;
  until y=n;
end;

procedure music;
const m:array[224..233] of byte = (121,145,106,122,161,137,145,161,178,4);
var i:integer;
begin
  for i:=224 to 233 do port[i]:=m[i];
  port[214]:=10;
end;

begin
  randomize;
  writeln('Игра СУДОКУ');
  n:=3;
{  write('Судоку. Введите размер квадрата 2-4 (',n,'): '); readln(n);}
  nn:=n*n;
  repeat
    cpl:=40;
    write('Сложность 10-99 (',cpl,')? :'); readln(cpl);
    if (cpl<10) or (cpl>99) then writeln('Внимательнее! Ещё раз спрашиваю:');
  until (cpl<100) and (cpl>9);
  writeln('Создаю пазл, это займёт некоторое время...');start;
  m3:=m2; rst:=0;
  for x:=0 to nn-1 do for y:=0 to nn-1 do begin
    if random(100)<cpl then begin
      m2[x,y]:=0;rst:=rst+1;
    end;
  end;
L1:
  clrscr;
  write('Игра СУДОКУ версия 0.2 для КРИСС (c) Решетников С.И.');
  gotoxy(1,23);write('слож.: ',cpl,'   ошибок:     ходов:     осталось:     время:  ');
  gotoxy(46,23);write(rst,' ');
  field;x:=0;y:=0;err:=0;mvs:=0;tm1:=0;tm2:=0;tm3:=0;
  write(#7);print;c:=^S;
  repeat
    if port[222]=0 then begin
      port[222]:=100;
      tm1:=tm1+1;
      if tm1>59 then begin tm1:=0;tm2:=tm2+1; end;
      if tm2>59 then begin tm2:=0;tm3:=tm3+1; end;
      write(#30);gotoxy(56,23);write(tm3:2,':',(tm2 div 10),(tm2 mod 10),':',(tm1 div 10),(tm1 mod 10));
      c:=^S;
    end;
    if c in [^S,^D,^E,^X] then begin
      gotoxy(x*3+7+(x div n),y+4+(y div n));write(#31);
    end;
{    print;}
{    gotoxy(x*3+7+(x div n),y+4+(y div n));write(#31);}
    c:=#0; if bios(1)=255 then c:=upcase(chr(bios(2)));
    case c of
      '1'..'9':if m2[x,y]<>0 then c:=#127 else begin
            if m1[x,y]>0 then rst:=rst+1;
            m1[x,y]:=0;b:=ord(c)-ord('0');
            for i:=0 to nn-1 do begin
              if (m1[x,i]=b) or (m2[x,i]=b)
                  or (m1[i,y]=b) or (m2[i,y]=b)
                  or (m1[(x div n)*n+(i mod n),(y div n)*n+(i div n)]=b)
                  or (m2[(x div n)*n+(i mod n),(y div n)*n+(i div n)]=b)
                  then begin
                c:=#127;b:=255;
              end;
            end;
            if (b<>255) then begin m1[x,y]:=b;rst:=rst-1;end;
          end;
      ^H,^G:if m2[x,y]<>0 then c:=#127 else begin
            if m1[x,y]>0 then rst:=rst+1;
            m1[x,y]:=0;
          end;
      '?',' ','+','-':if m2[x,y]=0 then begin write(#30#21,c,#8#8#31);end;
      'R':begin fillchar(m1,sizeof(m1),0);goto L1;end;
      'P':begin
            gotoxy(70,23);write('пауза');
            bios(2);
            gotoxy(70,23);write('     ');
          end;
      ^S:if x>0 then x:=x-1;
      ^D:if x<nn-1 then x:=x+1;
      ^E:if y>0 then y:=y-1;
      ^X:if y<nn-1 then y:=y+1;
      #27: begin end;
{      else write(#7);}
    end;
    if c=#127 then begin
      write(#7); err:=err+1;
      gotoxy(21,23);write(err);
    end;
    if c in [^H,^G,'1'..'9'] then begin
      print;mvs:=mvs+1;
      gotoxy(32,23);write(mvs);
      gotoxy(46,23);write(rst,' ');
      if rst=0 then begin
        music;bios(2);c:=#27;
      end;
    end;
  until c=#27;
  clrscr;
  write(#31);
end.