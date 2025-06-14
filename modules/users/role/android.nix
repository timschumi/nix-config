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
  inherit (builtins) elem filter;
  inherit (inputs.nixpkgs.lib) mkIf;
  inherit (inputs.nixpkgs.lib.strings) concatLines hasInfix splitString;
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    programs.adb.enable = true;
    users.users."${user}".extraGroups = [
      "adbusers"
      "dialout"
    ];

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        brotli
        bsdiff
        heimdall-gui
        scrcpy
        sdat2img
      ];
    };
  };
}
