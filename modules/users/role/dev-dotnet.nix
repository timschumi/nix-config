{
  role,
  user,
  ...
}@presets:
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins) elem;
  inherit (inputs.nixpkgs.lib) mkIf;
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        # FIXME: jetbrains-jdk: fix with structured attrs (#425529)
        #jetbrains.rider
        msbuild
      ];
    };

    nixpkgs.config.permittedInsecurePackages = [
      # FIXME: Required by msbuild (#326335).
      "dotnet-runtime-6.0.36"
      "dotnet-sdk-6.0.428"
    ];
  };
}
