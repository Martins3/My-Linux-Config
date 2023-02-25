# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
let-env PATH = ($env.PATH | split row (char esep) | prepend /home/martins3/.npm-packages/bin )
let-env PATH = ($env.PATH | split row (char esep) | prepend /home/martins3/.cargo/bin )
