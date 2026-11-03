{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs.self.lib) brokenOn;
in
{
  home-manager.users.tim = {
    home.packages = with pkgs; [
      (brokenOn true (
        lutris.override {
          extraPkgs = pkgs: [
            wine-staging
          ];
        }
      ))
    ];
  };

  hardware.graphics.enable32Bit = true;
}
