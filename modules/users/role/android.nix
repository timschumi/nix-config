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
  imports = [
    (inputs.self + "/fragments/overlay-mtkclient.nix")
  ];

  config = mkIf (elem role config.extra.user."${user}".roles) {
    programs.adb.enable = true;
    users.users."${user}".extraGroups = [
      "adbusers"
      "dialout"
      "plugdev"
    ];

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
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
