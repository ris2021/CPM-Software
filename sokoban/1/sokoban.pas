{$C-}
type s80 = string[80];
var t:text;
  s:string[250];
  f:array[1..24] of s80;
  x,y,mx,my,bc:byte;
  c:char;
  i,mv,mlvl,lvl:integer;
  msb,msp:integer;
  mspa:array[0..1]of byte absolute msp;

procedure rwr(y,x:byte;c:char);
begin
  f[y][x]:=c;
  gotoxy((x-1)*2+1,y+1);
  case c of
    '_':write('  ');
    '.':write('::');
    '#':write(#$f2#$f3);
    '@':write(#$f4#$f5);
    'M','m':write(#252#253);
  end;
{  write(c);
  bios(2);}
end;

function mvb(y,x:byte;dy,dx:integer):boolean;
var c:char;
begin
  mvb:=true;
  if not((msb=-1) or (msb and 1>0)) then exit;
  c:=f[y+dy][x+dx];
  if c in ['*','#','@','M','m'] then exit;
  if c='.' then begin c:='@';bc:=bc-1;end else c:='#';
  rwr(y+dy,x+dx,c);
  c:=f[y][x];
  if c='@' then begin c:='.';bc:=bc+1;end else c:='_';
  rwr(y,x,c);
  mvb:=false;
end;

procedure step(dy,dx:integer);
var c:char;
begin
  c:=f[my+dy][mx+dx];
  if c='*' then exit;
  if c in ['#','@'] then if mvb(my+dy,mx+dx,dy,dx) then exit;
  c:=f[my+dy][mx+dx];
  if c='_' then c:='M' else c:='m';
  rwr(my+dy,mx+dx,c);
  c:=f[my][mx];
  if c='M' then c:='_' else c:='.';
  rwr(my,mx,c);
  my:=my+dy;mx:=mx+dx;mv:=mv+1;
end;

procedure wscr;
begin
  clrscr;
  writeln(#30'SOKOBAN for CRISS CP/M, Level: ',lvl);
  for y:=1 to 23 do begin
    i:=0;
    for x:=1 to length(f[y]) do begin
      if (i>0) then begin
        if (f[y][x]='*') then write(#$db) else begin
          write(#$dd);i:=0;
        end;
      end;
      case f[y][x] of
        '_':write('  ');
        '*':begin if i=0 then write(#$de) else write(#$db); i:=1; end;
        '.':write('::');
        '#':begin write(#$f2#$f3);bc:=bc+1;end;
        '@':write(#$f4#$f5);
        'M','m':begin write(#252#253);mx:=x;my:=y;end;
      end;
    end;
    if y<23 then writeln;
  end;
end;

{$i music.pas}

procedure load;
var s1:string[10];
begin
  assign(t,'sokoban.txt'); reset(t);
  readln(t,mlvl);
  str(lvl:3,s1);{writeln('[',s1,']'); }
  repeat
    readln(t,s); {writeln(s);}
  until (copy(s,2,3)=s1) or eof(t);
  if eof(t) then begin close(t);exit;end;
  i:=1;
  repeat
    readln(t,s);
    if s[1]<>'L' then begin
      f[i]:=s;i:=i+1; {writeln(s);}
    end;
  until (i>23) or (s[1]='L') or eof(t);
  close(t);
  while i<24 do begin f[i]:='';i:=i+1;end;
  {halt;}
end;

function rmp(p:byte):integer;
const tlr=15360;{256*60;}
begin
  mspa[1]:=port[p]; rmp:=0;
  if msp>tlr then begin rmp:=1;msp:=msp-tlr; end;
  if msp<-tlr then begin rmp:=-1;msp:=msp+tlr; end;
  port[p]:=mspa[1];
  {write('   ',msp,'  ');}
end;

begin
  lvl:=1;c:=#0;
  port[215]:=$e0; delay(40);
  if port[215]<>0 then msb:=-1 else begin
    msb:=0;port[217]:=0;port[218]:=0;port[216]:=0;
  end;
  repeat
    if c<>'R' then begin load;mv:=0;end;
    bc:=0;wscr;
    repeat
      gotoxy(40,1);write('Boxes: ',bc,'  Moves: ',mv,'    ');
      if bios(1)=255 then c:=upcase(chr(bios(2))) else begin
        c:=#0;
        if msb<>-1 then begin
          port[215]:=$e1; delay(20);
          msb:=port[216]; if msb and $22=$20 then c:=' ';
          i:=rmp(217); if i=1 then c:=^D; if i=-1 then c:=^S;
          i:=rmp(218); if i=1 then c:=^E; if i=-1 then c:=^X;
        end;
      end;
      if c=^S then step(0,-1);
      if c=^D then step(0,1);
      if c=^E then step(-1,0);
      if c=^X then step(1,0);
      if bc=0 then begin music;c:='+';end;
    until c in [#27,^C,'+','-',#13,'L','*','E','Q','?','H','R',' '];
    if (c='+') and (lvl<mlvl) then lvl:=lvl+1;
    if (c='-') and (lvl>1) then lvl:=lvl-1;
    if (c in ['L','*']) then begin
      gotoxy(32,1);write('   '#8#8#8#31);
      i:=lvl;readln(i);
      if (i>0) and (i<=mlvl) then lvl:=i;
      write(#30);
    end;
    if c in ['?','H'] then begin
      assign(t,'sokoban.hlp');reset(t);
      clrscr;
      while not(eof(t)) do begin readln(t,s);writeln(s);end;
      close(t);
      bios(2);
      c:='R';
    end;
  until c in [#27,'E','Q',^C];
  clrscr;
  writeln('Bye-bye!');
  write(#31);
  port[215]:=$e4;
end.
