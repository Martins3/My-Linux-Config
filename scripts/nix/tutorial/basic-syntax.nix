let
  object = {
    foo = "foo val";
    bar = "bar val";
  };
in

{
  inherit object foo;

  baz = "baz val";
}

/* let */
/* object = { */
/* foo = "foo val"; */
/* bar = "bar val"; */
/* }; */
/* in */
/* with object; [ */
/* foo */
/* bar */
/* ] */
