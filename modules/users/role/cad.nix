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
  inherit (inputs.self.lib) brokenOn;
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        (brokenOn stdenv.hostPlatform.isAarch64 blender)
        freecad
        gimp
        kicad
        krita
        orca-slicer
      ];
    };
  };
}
