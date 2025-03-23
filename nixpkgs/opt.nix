let
  homeDirectory = builtins.getEnv "HOME";  # 使用环境变量 HOME
  optConfig = if (builtins.pathExists "${homeDirectory}/opt-local.nix")
    then import "${homeDirectory}/opt-local.nix"
    else {};
in
{
  isGui = true;
} // optConfig
