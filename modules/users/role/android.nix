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
    users.groups.adbusers = { };
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

    services.udev.packages = with pkgs; [
      mtkclient
    ];

    services.udev.extraRules = ''
      # ID_DEBUG_APPLIANCE is set up by systemd's 70-uaccess.rules. We can rely on this because we are 99-local.rules.
      # Emulate the old android-udev-rules behavior for those, since uaccess does not work for remote sessions.
      ENV{ID_DEBUG_APPLIANCE}=="?*", MODE="0660", GROUP="adbusers", SYMLINK+="android", SYMLINK+="android%n"
    '';
  };
}
