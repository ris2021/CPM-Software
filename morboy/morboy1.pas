(*$I-*)
var
  f:array[0..1,'@'..'K',0..11] of char;
  c:char;
  i,j:integer;
  s:string[10];
  ss:array[0..10] of char absolute s;
const
  rls:array[1..16] of byte = (4,3,3,2,2,2,1,1,1,1,0,0,0,0,0,0);
label
  l1;

procedure gotoxy(x:byte; y:byte);
begin
  write(#27,chr(127+y),chr(127+x));
end;

procedure drawf(n:byte);
var x:byte;
  y:char;
begin
  for y:='A' to 'J' do begin
    gotoxy(6+n*27,6+ord(y)-ord('A'));
    for x:=1 to 10 do write(f[n,y,x],' ');
  end;
end;

procedure drawff(n:byte);
var x:byte;
  y:char;
begin
  for y:='A' to 'J' do begin
    gotoxy(6+n*27,6+ord(y)-ord('A'));
    for x:=1 to 10 do if f[n,y,x]<>#127 then write(f[n,y,x],' ') else write('. ');
  end;
end;

procedure start;
var x:byte;
  y:char;
begin
  for y:='@' to 'K' do begin
    for x:=0 to 11 do begin f[0,y,x]:='.'; f[1,y,x]:='.'; end;
  end;
end;

function iswin(n:byte):boolean;
var x:byte;
  y:char;
begin
  iswin:=true;
  for y:='A' to 'J' do begin
    for x:=1 to 10 do if (f[n,y,x]=#127) then iswin:=false;
  end;
end;

function ch(n,x:byte; y:char):boolean;
begin
  ch:=true;
  if (x<1) or (x>10) or (y<'A') or (y>'J') then exit;
  if f[n,y,x]<>'.' then ch:=false;
end;

function echeck(n,x:byte; y:char):boolean;
begin
  echeck:= (x>=1) and (x<=10) and (y>='A') and (y<='J') and
    ch(n,x,y) and ch(n,x-1,y) and ch(n,x+1,y) and
    ch(n,x,chr(ord(y)-1)) and ch(n,x,chr(ord(y)+1)) and
    ch(n,x-1,chr(ord(y)-1)) and ch(n,x-1,chr(ord(y)+1)) and
    ch(n,x+1,chr(ord(y)-1)) and ch(n,x+1,chr(ord(y)+1));
end;

function setship(n,l,d,x:byte;y:char):boolean;
var b:boolean;
  i:byte;
begin
  b:=echeck(n,x,y);
  for i:=1 to l-1 do begin
    if (d=0) then b:=b and echeck(n,x+i,y);
    if (d=1) then b:=b and echeck(n,x,chr(ord(y)+i));
  end;
  if b then begin
    f[n,y,x]:=chr(127);
    for i:=1 to l-1 do begin
      if (d=0) then x:=x+1;
      if (d=1) then y:=chr(ord(y)+1);
      f[n,y,x]:=chr(127);
    end;
  end;
  setship:=b;
end;

procedure putship(l:byte);
var k,y,c:char;
  x,d,i:byte;
  b:boolean;
begin
  gotoxy(1,18); write(#22,l,'-¯ «ã¡­¨ª áâ ¢¨¬...');
  c:=#0; d:=0; x:=1; y:='A';
  while (c<>#13) do begin
    drawf(1);
    gotoxy(6+27-2+x*2,6+ord(y)-ord('A'));
    write('N ');
    for i:=1 to l-1 do begin
      if (d=1) then
        gotoxy(6+27-2+x*2,i+6+ord(y)-ord('A'));
      write('N ');
    end;
    c:=chr(bios(2));
    case c of
      '4': if x>1 then x:=x-1;
      '8': if y>'A' then y:=chr(ord(y)-1);
      '5': begin
             d:=1-d;
             if (d=0) and (x>10-l+1) then x:=10-l;
             if (d=1) and (y>chr(ord('J')-l+1)) then y:=chr(ord('J')-l+1);
           end;
      '6': begin
             if (d=0) and (x<10-l+1) then x:=x+1;
             if (d=1) and (x<10) then x:=x+1;
           end;
      '2': begin
             if (d=0) and (y<'J') then y:=chr(ord(y)+1);
             if (d=1) and (y<chr(ord('J')-l+1)) then y:=chr(ord(y)+1);
           end;
      #13: begin
             if not(setship(1,l,d,x,y)) then begin
               write(#7);
               c:=#0;
             end;
           end;
    end;
  end;
end;

procedure autoship(n:byte);
var i:byte;
begin
  for i:=1 to 16 do if rls[i]>0 then begin
    while(not(setship(n,rls[i],random(2),random(10)+1,chr(ord('A')+random(10))))) do;
  end;
end;

function iskill(n,x:byte;y:char):boolean;
var
  xx:byte;
  yy:char;
begin
  iskill:=false;
  xx:=x; while f[n,y,xx]='X' do xx:=xx+1; if f[n,y,xx]=#127 then exit;
  xx:=x; while f[n,y,xx]='X' do xx:=xx-1; if f[n,y,xx]=#127 then exit;
  yy:=y; while f[n,yy,x]='X' do yy:=chr(ord(yy)-1); if f[n,yy,x]=#127 then exit;
  yy:=y; while f[n,yy,x]='X' do yy:=chr(ord(yy)+1); if f[n,yy,x]=#127 then exit;
  iskill:=true;
end;

procedure mark(n,x:byte; y:char);
begin
  if (f[n,y,x]='.') and (x>=1) and (x<=10) and (y>='A') and (y<='J') then
    f[n,y,x]:=':';
end;

procedure markkill(n,x:byte;y:char);
var x0,y0:byte;
  y1:char;
begin
{  writeln('n=',n,' x=',x,' y=',y,' d=',d,' f=',f[n,y,x]); bios(2); }
  x0:=1; y0:=1;
  while f[n,y,x-1]='X' do begin x:=x-1; end;
  if f[n,y,x+1]='X' then y0:=0;
  while f[n,chr(ord(y)-1),x]='X' do begin y:=chr(ord(y)-1); end;
  if f[n,chr(ord(y)+1),x]='X' then x0:=0;
{  writeln(x,' ',y,' ',x0,' ',y0); }
  while f[n,y,x]='X' do begin
    mark(n,x-1,y);
    mark(n,x+1,y);
    y1:=chr(ord(y)+1);
    mark(n,x-1,y1);
    mark(n,x,y1);
    mark(n,x+1,y1);
    y1:=chr(ord(y)-1);
    mark(n,x-1,y1);
    mark(n,x,y1);
    mark(n,x+1,y1);
    f[n,y,x]:='Z';
    x:=x+x0; y:=chr(ord(y)+y0);
  end;
end;

begin
  start;
  randomize;
  write(#12);
  writeln('                  Œ®àáª®© ®©');
  writeln;
  writeln('           Š®¬¯ìîâ¥à                     ‚ë');
  writeln('     1 2 3 4 5 6 7 8 9 10       1 2 3 4 5 6 7 8 9 10');
  writeln('   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  writeln(' A ³ . . . . . . . . . . ³  A ³ . . . . . . . . . . ³');
  writeln(' B ³ . . . . . . . . . . ³  B ³ . . . . . . . . . . ³');
  writeln(' C ³ . . . . . . . . . . ³  C ³ . . . . . . . . . . ³');
  writeln(' D ³ . . . . . . . . . . ³  D ³ . . . . . . . . . . ³');
  writeln(' E ³ . . . . . . . . . . ³  E ³ . . . . . . . . . . ³');
  writeln(' F ³ . . . . . . . . . . ³  F ³ . . . . . . . . . . ³');
  writeln(' G ³ . . . . . . . . . . ³  G ³ . . . . . . . . . . ³');
  writeln(' H ³ . . . . . . . . . . ³  H ³ . . . . . . . . . . ³');
  writeln(' I ³ . . . . . . . . . . ³  I ³ . . . . . . . . . . ³');
  writeln(' J ³ . . . . . . . . . . ³  J ³ . . . . . . . . . . ³');
  writeln('   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  writeln;
  writeln;
  writeln;
  writeln;
  write('à ¢¨« : ');
  for i:=1 to 16 do if rls[i]>0 then write(rls[i],'-¯ «., ');
  writeln(' á ¤¨áâ.');
  gotoxy(1,18); write(#22' ááâ ¢¨âì ‚ è¨ ª®à ¡«¨  ¢â®¬ â¨ç¥áª¨? ');
  c:=upcase(chr(bios(2)));
  if c='Y' then autoship(1) else
    for i:=1 to 16 do if rls[i]>0 then
      putship(rls[i]);
  drawf(1);
  gotoxy(1,18); write(#22'‘â ¢«î á¢®¨ ª®à ¡«¨, ¬¨­ãâ®çªã...');
  autoship(0);
  if 1=2 then drawf(0);
  c:=#0;
  while(c<>'X') do begin
    C:=#0;
    gotoxy(1,18); write(#22'’¢®© å®¤ (A1-J12): '); read(s);
    {write(#7);}
    if (ioresult<>0) or (length(s)<2) then begin
      c:=#0; write(#7);
    end else begin
      c:=upcase(s[1]);
      s[1]:='0';
      val(s,i,j);
      {write(s,':',c,':',i,':',j);}
      if j<>0 then i:=0;
    end;
    write(' ');
    if (c<='J') and (c>='A') and (i>=1) and (i<=10) then begin
      if f[0,c,i]=#127 then begin
        f[0,c,i]:='X'; write(#7'¯®¯ «!');
        if iskill(0,i,c) then begin
          write(' ¨ ¯®â®¯¨«!');
          markkill(0,i,c);
        end;
      end else
      if f[0,c,i]='.' then begin
        f[0,c,i]:='o'; write('¬¨¬®...'); c:=#1;
      end else
        write('áî¤  ã¦¥ áâà¥«ï«');
      drawff(0);
    end else begin
      write('íâ® ªã¤ , ¯à®áâ¨?');
    end;
    if iswin(0) then begin
      gotoxy(1,18); write(#22'®§¤à ¢«ïî! ’ë ¢ë¨£à « ¬¥­ï!!!'); c:='X';
    end;
    while (c=#1) do begin
      gotoxy(1,19); write(#22' ¦¬¨ ET ¤«ï ¯à®¤®«¦¥­¨ï'); c:=chr(bios(2));
      gotoxy(1,19); write(#22);
      gotoxy(1,18); write(#22'Œ®© å®¤: ');
      repeat
        for c:='A' to 'J' do for i:=1 to 10 do
          if (f[1,c,i]='X') and (random(10)<>1) then begin
          if (f[1,c,i+1]='X') then begin
            if (i>1) and (f[1,c,i-1] in ['.',#127]) then i:=i-1 else begin
              i:=i+2;
              while not(f[1,c,i] in ['.',#127]) do i:=i+1;
            end;
          end else
          if f[1,chr(ord(c)+1),i]='X' then begin
            if (c>'A') and (f[1,chr(ord(c)-1),i] in ['.',#127]) then c:=chr(ord(c)-1) else begin
              c:=chr(ord(c)+2);
              while not(f[1,c,i] in ['.',#127]) do c:=chr(ord(c)+1);
            end;
          end else begin
            case random(4) of
              0:i:=i-1;
              1:i:=i+1;
              2:c:=chr(ord(c)-1);
              3:c:=chr(ord(c)+1);
            end;
          end;
          goto l1;
        end;
        c:=chr(ord('A')+random(10)); i:=1+random(10);
L1:
      until (i>=1) and (i<=10) and (c>='A') and (c<='J') and ((f[1,c,i]='.') or (f[1,c,i]=#127));
      write(c,i,' ');
      if f[1,c,i]=#127 then begin
        f[1,c,i]:='X'; write(#7'¯®¯ «!');
        if iskill(1,i,c) then begin
          write(' ¨ ãâ®¯¨«!');
          markkill(1,i,c);
        end;
        c:=#1;
      end else
      if f[1,c,i]='.' then begin
        f[1,c,i]:='o'; write('¬¨¬®...');
      end;
      drawf(1);
      if iswin(1) then begin
        gotoxy(1,18); write(#22'“à , ï ¢ë¨£à « â¥¡ï!!!'); c:='X';
      end;
    end;
    gotoxy(1,19); write(#22' ¦¬¨ ET ¤«ï ¯à®¤®«¦¥­¨ï ¨«¨ <X> ¤«ï ¢ëå®¤ ');
    if c='X' then bios(2) else c:=upcase(chr(bios(2)));
    gotoxy(1,19); write(#22);
  end;
  writeln(#12'¤® ¢áâà¥ç¨, á¯ á¨¡® §  ¨£àã!');
end.

