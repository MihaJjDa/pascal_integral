program integral3angle(output);
{$F+}

const
  a12 = 0.1;
  b12 = 0.4;
  a13 = -1.9;        {Диапазоны выбрал самые маленькие}
  b13 = -1.8;
  a23 = -1.3;
  b23 = -1.0;
  eps1 = 0.0001;     {Не включал eps как параметры функций, зачем?}
  eps2 = 0.0001;

type
  func = function(x: real): real;

var
  x12, x13, x23, s: real;

function f1(x: real): real;
  begin
    f1 := 0.35 * sqr(x) - 0.95 * x + 2.7;
  end;

function f2(x: real): real;
  begin
    f2 := exp(x * ln(3)) + 1;
  end;

function f3(x: real): real;
  begin
    f3 := 1 / (x + 2);
  end;

function df1(x: real): real;
  begin
    df1 := 0.7 * x - 0.95;
  end;

function df2(x: real): real;
  begin
    df2 := exp(x * ln(3)) * ln(3);
  end;

function df3(x: real): real;
  begin
    df3 := (-1) / sqr(x + 2);
  end;

function fmg(f, g: func; a: real): real;
  begin
    fmg := f(a) - g(a);
  end;

function cond(f, g: func; a, b: real): boolean;
  begin
    cond := (fmg(f, g, a) > 0) xor (fmg(f, g, (a + b) / 2) < (fmg(f, g, a) + fmg(f, g, b)) / 2);
  end;

procedure root(f, g, df, dg: func; a, b: real; var x: real);
  var
    c1, c2, d, eps: real;
    ok: boolean;
  begin
    ok := cond(f, g, a, b);
    if ok then
      begin
        c1 := a;
        eps := eps1;
      end
    else
      begin
        c1 := b;
        b := a;
        eps := -eps1;
      end;
    d := b;
    repeat
      c1 := (c1 * fmg(f, g, b) - b * fmg(f, g, c1)) / (fmg(f, g, b) - fmg(f, g, c1));
      c2 := d - fmg(f, g, d) / fmg(df, dg, d);
      d := c2;
    until (fmg(f, g, c2) * fmg(f, g, c2 - eps) < 0) or (fmg(f, g, c1) * fmg(f, g, c1 + eps) < 0);
    if fmg(f, g, c2) * fmg(f, g, c2 - eps1) < 0 then
      x := c2
    else
      x := c1;
  end;

function integral(f: func; a, b: real; var k: integer): real;
  var
    s1, s2n, sn, s2, h, x: real;
    i, n: integer;
  begin
    k := 0;
    n := 2;
    s1 := 0;
    s2n := 0;
    s2 := 2 * f(b - a) / 2;
    repeat
      inc(k);
      sn := s2n;
      n := n * 2;
      h := (b - a) / n;
      s2 := s2 + s1 / 2;
      s1 := 0;
      x := a - h;
      for i := 1 to n div 2 do
        begin
          x := x + 2 * h;
          s1 := s1 + f(x);
        end;
      s1 := s1 * 4;
      s2n := h / 3 * (s1 + s2 + f(a) + f(b));
    until abs(sn - s2n) / 15 < eps2;
    integral := s2n;
  end;

function max(a, b, c: real): real;
  begin
    if a > b then
      if a > c then
        max := a
      else
        max := c
    else
      if b > c then
        max := b
      else
        max := c;
  end;

var
  i1, i2, i3: integer;
  s1, s2, s3: real;
begin
  writeln('_________________________________________________________');
  writeln('Puchkin Daniel, group 112, Computing of definite integral');
  writeln('_________________________________________________________');
  root(f1, f2, df1, df2, a12, b12, x12);
  root(f2, f3, df2, df3, a23, b23, x23);
  root(f1, f3, df1, df3, a13, b13, x13);
  if x13 < x12 then
    s1 := integral(f1, x13, x12, i1)     {Условия для того,}
  else                                   {чтобы не менять параметры функций}
    s1 := integral(f1, x12, x13, i1);    {при изменении функций}
  if x23 < x12 then
    s2 := integral(f2, x23, x12, i2)
  else
    s2 := integral(f2, x12, x23, i2);
  if x13 < x23 then
    s3 := integral(f3, x13, x23, i3)
  else
    s3 := integral(f3, x23, x13, i3);
  s := s1 - s2 - s3;     {Необходимо изменять знаки при изменении функций}
  writeln('Roots of equations:');
  writeln('f1(x) = f2(x): ', x12);
  writeln('f2(x) = f3(x): ', x23);
  writeln('f1(x) = f3(x): ', x13);
  writeln('Definite integral: ', s);
  writeln('Number of iterations: ', i1 + i2 + i3);
  readln;
end.