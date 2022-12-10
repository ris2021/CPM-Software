var
  d,x,y,i,j,a:byte;
  f:array[0..16,0..16] of integer;
  c:char;
label L1;

procedure print;
begin
  for y:=1 to d+1 do begin
    gotoxy(5,y*2+2);
    for x:=1 to d do begin
      if (y=1) and (x=1) then write('Ú');
      if (y=d+1) and (x=1) then write('À');
      if (y>1) and (y<=d) and (x=1) then write('Ã');
      write('ÄÄÄÄ');
      if (y=1) and (x=d) then write('¿');
      if (y=d+1) and (x=d) then write('Ù');
      if (y>1) and (y<=d) and (x=d) then write('´');
      if (y>1) and (y<=d) and (x<d) then write('Å');
      if (y=1) and (x<d) then write('Â');
      if (y=d+1) and (x<d) then write('Á');
    end;
    if y<=d then begin
      gotoxy(5,y*2+3);
      for x:=1 to d do begin
        if (f[x,y]>0) then write('³',f[x,y]:4) else write('³    ');
      end;
      write('³');
    end;
  end;
end;

procedure dshf(x0,y0,dx,dy:integer);
var x,y,n:integer;
begin
  repeat
    x:=x0;y:=y0;n:=0;
 {   writeln('>',x0:4,y0:4,x:4,y:4);}
    repeat
      x:=x+dx;y:=y+dy;n:=f[x,y];
    until (n>0) or (x<1) or (x>d) or (y<1) or (y>d);
    if n=0 then exit;
    if f[x0,y0]=0 then begin
      f[x0,y0]:=n;f[x,y]:=0;
    end else begin
      if f[x0,y0]=n then begin f[x0,y0]:=2*n;f[x,y]:=0;end;
      x0:=x0+dx;y0:=y0+dy;
    end;
{    writeln('<',x0:4,y0:4,x:4,y:4);}
  until false;
end;

procedure shft(dx,dy:integer);
var n:integer;
begin
  for n:=1 to d do begin
    if dx=-1 then dshf(1,n,1,0);
    if dx=1 then dshf(d,n,-1,0);
    if dy=-1 then dshf(n,1,0,1);
    if dy=1 then dshf(n,d,0,-1);
  end;
  n:=0;
  for x:=1 to d do begin
    for y:=1 to d do begin
      if f[x,y]=0 then n:=n+1;
    end;
  end;
  if n>0 then begin
    repeat
      x:=random(d)+1;y:=random(d)+1;
    until f[x,y]=0;
    f[x,y]:=a;
  end;
end;

begin
  d:=4;
  write('ˆ£à  2048, à §¬¥à ¤®áª¨? (',d,'): '); readln(d);
  clrscr;
  gotoxy(5,2);write(#30'ˆ£à  2048');
L1:
  fillchar(f,sizeof(f),0);a:=2;
  shft(0,0);shft(0,0);
  repeat
    print;
    c:=upcase(bios(2));
    case c of
      ^S:shft(-1,0);
      ^E:shft(0,-1);
      ^X:shft(0,1);
      ^D:shft(1,0);
      'R':goto L1;
      #27:begin end;
      else write(#7);
    end;
  until c=#27;
  write(#31);clrscr;
end.
