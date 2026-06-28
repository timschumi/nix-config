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

  # udev: Tag debug appliance nodes as xaccess-debug-appliance (#42780)
  extraUaccessRules = pkgs.writeTextFile {
    name = "extra-uaccess-rules";
    text = ''
      # Made available via xaccess additionally to support scenarios like headless testing machines.
      ENV{ID_DEBUG_APPLIANCE}=="?*", TAG+="xaccess-debug-appliance" 
    '';
    destination = "/etc/udev/rules.d/72-uaccess-extra.rules";
  };

in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    users.users."${user}" = {
      extraDeviceAccess = [ "debug-appliance" ];
    };

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
      extraUaccessRules
      mtkclient
    ];
  };
}
