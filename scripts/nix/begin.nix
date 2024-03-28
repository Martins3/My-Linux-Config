let
  x = 1;
  y = 2;
in
{
  inherit x y;
}  # 结果是 { x = 1; y = 2; }
