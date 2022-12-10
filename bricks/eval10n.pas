program Evas10n;
{$C-}

{
  EVAS10N.PAS 1.1

  A Turbo Pascal rewrite of Evas10n,
  a BASIC 10-Liner breakout game for the ZX Spectrum.

  Marco's Retrobits
  https://retrobits.altervista.org
  https://retrobits.itch.io

  2022.02.01 Version for CRISS CP/M computer, http://criss.fun
  2020.06.04 Version 1.1:
             * show bales-1
             * constants for ball, bat and brick characters
  2020.06.02 First release
}

const

  BallChar: String[2] = 'ö÷';
  BatChars: String[8] = 'ÍÍÍÍÍÍÍÍ';
  BrickChar:String[2] = 'òó';

{
  BallChar: Char = ' ';
  BatChars: String[3] = '   ';
  BrickChar : Char = '_';
}

var
  del, code, bat, batDir, balls, v, w, x, y: Integer;
  bricks: array[3..8] of array[1..32] of Boolean;
  exit, lostBall: Boolean;
  ch: Char;
  param: String[5];

procedure WriteBricks;
  var
    r, c: Integer;
  begin
    {LowVideo;}
    for r := 3 to 8 do
      for c := 1 to 32 do
        begin
          GotoXY(c*2+1,r);
          Write(BrickChar);
        end;
    {NormVideo;}
  end;

procedure WriteBat;
  begin
    {LowVideo;}
    GotoXY(2*bat+1, 22);
    Write(BatChars);
    {NormVideo;}
    {GotoXY(1, 1);}
  end;

procedure DeleteBat;
  begin
    NormVideo;
    GotoXY(2*bat+1, 22);
    Write('        ');
    {GotoXY(1, 1);}
  end;

procedure WriteBall;
  begin
    {LowVideo;}
    GotoXY(2*x+1, y);
    Write(BallChar);
    {NormVideo;
    GotoXY(1, 1);}
  end;

procedure DeleteBall;
  begin
    {NormVideo;}
    GotoXY(2*x+1, y);
    Write('  ');
  end;

procedure Help;
  begin
    ClrScr;
    Writeln('EVAS10N.PAS v. 1.2');
    Writeln;
    Writeln('A Turbo Pascal rewrite of Evas10n,');
    Writeln('a BASIC 10-Liner breakout game for the ZX Spectrum.');
    Writeln;
    Writeln('Synopsis:');
    Writeln(' EVAS10N [DELAY]');
    Writeln(' DELAY: game loop iteration delay in milliseconds.');
    Writeln('        Default: 114 (assuming 4MHz CPU)');
    Writeln;
    Writeln('Control keys:');
    Writeln(' ESC:       quit');
    Writeln(' ^S, <- :   move bat left');
    Writeln(' ^D, -> :   move bat right');
    Writeln(' any other: stop bat');
    Writeln;
    Writeln('Marco''s Retrobits');
    Writeln('https://retrobits.altervista.org');
    Writeln('https://retrobits.itch.io');
    Writeln('CRISS CP/M http://criss.fun');
    Writeln;
    Writeln('Press any key to start');
    bios(2);
  end;

procedure Init;
  var
    r, c: Integer;
  begin
    balls := 6;
    bat := 15;
    x := 16;
    y := 21;
    v := 1;
    batDir := 1;
    exit := False;
    ClrScr;
    Writeln;
    Write('ÞÜ');
    for c := 1 to 32 do
      Write('ÛÜ');
    Writeln('ÛÝ');
    for r:=3 to 22 do begin
      write('ÞÝ'); gotoxy(32*2+3,r); writeln('ÞÝ');
    end;
    Write('ÞÜ');
    for c := 1 to 32 do
      Write('ÛÜ');
    Writeln('ÛÝ');
    for r := 3 to 8 do
      for c := 1 to 32 do
        begin
          bricks[r, c] := true;
        end;
    WriteBricks;
    GotoXY(17, 24);
    Write('EVAS10N.PAS by Marco V. 2020  Adopted for CRISS 2022');
  end;

begin
  del := 114; { 4 MHz assumed }
  if (ParamCount > 0) then
    begin
      param := ParamStr(1);
      Val(param, del, code);
      if (code <> 0) then
        begin
          Help;
          Halt;
        end;
    end;
  Help;
  Write(#30);
  repeat
    Init;
    gotoxy(1,1); Write('Starting!');
    repeat
      GotoXY(1, 24);
      for x:=1 to 6 do if x>=balls then Write(' ') else Write('øù');
      {Write(balls-1);}
      w := -1;
      x := bat + 1;
      y := 21;
      WriteBat;
      lostBall := False;
      WriteBall;
      gotoxy(15,1);
      delay(del*32);
      Write('Key to start!');
      if keypressed then read(kbd,ch);
      repeat until keypressed;
      gotoxy(1,1); Write(#22);
      repeat
        Delay(del);
        DeleteBall;
        x := x + v;
        y := y + w;
        WriteBall;
        { Continuous bat movement }
        if KeyPressed then
        begin
          Read(Kbd, ch);
          if (ch = #27) then
            exit := True;
          if (ch = ^D) then
            batDir := 1
          else if (ch = ^S) then
            batDir := -1
          else batDir := 0;
        end;
        if ((batDir = 1) and (bat < 29)) or
           ((batDir = -1) and (bat > 1)) then begin
          DeleteBat;
          bat := bat + 2*batDir;
          WriteBat;
        end;
        { Standard bat movement }
        {
        if KeyPressed then
        begin
          Read(Kbd, ch);
          if (ch = 'q') then
            exit := True
          else if (ch = ^D) and (bat < 29) then
            begin
              DeleteBat;
              bat := bat + 2;
              WriteBat;
            end
          else if (ch = ^S) and (bat > 1) then
            begin
              DeleteBat;
              bat := bat - 2;
              WriteBat;
            end;
        end;
        }
        {WriteBall;}
        if (y = 22) then
          begin
            balls := balls - 1;
            lostBall := True;
            gotoxy(1,1); Write('Ball is lost');
            if (balls = 0) then
              begin
                GotoXY(14, 1);
                Write('Game over... You lost...');
                {GotoXY(1, 24);
                Write(' ');}
                repeat until keypressed;
              end;
            DeleteBall;
          end
        else
          begin
            if (y >= 3) and (y <= 8) then
              bricks[y, x] := false;
            if (x > 1) and (x < 32) and (y >= 3) and (y <= 8)
            and (bricks[y, x + v]) then
              begin
                bricks[y, x + v] := False;
                GotoXY(2*(x + v)+1, y);
                Write('  ');
                {GotoXY(1, 1);}
                v := -v;
                w := 1;
              end
            else
              begin
                if (y > 3) and (y <= 9) and bricks[y - 1, x] then
                begin
                  bricks[y - 1, x] := False;
                  GotoXY(2*x+1, y - 1);
                  Write('  ');
                  {GotoXY(1, 1);}
                  {Write('Ball '); Write(x);Write(y);}
                  w := 1;
                end;
              end;
            if (y = 21) then
              begin
                if (x >= bat - 1) and (x <= bat + 4) then
                  w := -1;
                if (x = bat - 1) then
                  v := -1
                else if (x = bat + 4) then
                  v := 1;
              end;
            if (y = 2) then
              begin
                GotoXY(14, 1);
                Write('Free! You did it!!!');
                Delay(del * 8);
                repeat until keypressed;
                exit := True;
              end;
            if (x = 1) or (x = 32) then
              v := -v;
          end;
      until exit or lostBall;
    until exit or (balls = 0);
  until exit;
  Writeln(#31#12'Bye!');
end.