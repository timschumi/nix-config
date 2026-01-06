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
    users.users."${user}".extraGroups = [
      "adbusers"
      "dialout"
      "plugdev"
    ];

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        android-tools
        brotli
        bsdiff
        heimdall-gui
        mtkclient
        scrcpy
        sdat2img
      ];
    };
  };
}
