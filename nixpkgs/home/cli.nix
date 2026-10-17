{
  config,
  pkgs,
  ...
}:

let
in
{
  home.stateVersion = "23.11";
  home.username = "martins3";
  home.homeDirectory = builtins.getEnv "HOME";


  home.packages = import ./tools.nix { inherit pkgs; };

  programs.fish = {
    enable = false;
  };

  programs.zsh = {
    enable = true;
    shellAliases = { };
    initContent = "
    source ${config.home.homeDirectory}/.dotfiles/config/zsh
    ";

    plugins = [
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  home.file.gitconfig = {
    source = ../../config/gitconfig;
    target = ".gitconfig";
  };

  home.file.gdbinit = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/7b9b1260a8b3e9dd57b6cbf302bdfba71cec4014/.gdbinit";
      hash = "sha256-U83w4tm6FJRtLbeBb+GH/JP9DY+uhWyPUQv19cY5XpI=";
      name = "gdbinit";
    };
    target = ".gdbinit";
  };

  home.file.gdb_dashboard_init = {
    source = ../../config/gdbinit;
    target = ".gdbinit.d/init";
  };

  home.file.npm = {
    source = ../../config/npmrc;
    target = ".npmrc";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
