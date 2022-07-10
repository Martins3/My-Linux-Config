# object inherit


```nix
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
```

```nix
          let
            object = {
              foo = "foo val";
              bar = "bar val";
            };
          in
          with object; [
            foo
            bar
          ]
```

nix-repl> nixpkgs = import <nixpkgs> {}

nix-repl> nixpkgs.lib.stringLength "hello"
5
