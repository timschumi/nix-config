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
        audacity
        # FIXME: python313Packages.pyliblo: switch to pyliblo3 fork (#418925)
        #lmms
        furnace
      ];
    };
  };
}
