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
        cdparanoia
        ffmpeg-full
        freac
        makemkv
        picard
      ];

      home.extraDependencies = with pkgs; [
        (brokenOn true handbrake)
      ];
    };
  };
}
