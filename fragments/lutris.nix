{
  inputs,
  pkgs,
  ...
}:
{
  home-manager.users.tim = {
    home.packages = with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [
          wine-staging
        ];
      })
    ];
  };

  hardware.graphics.enable32Bit = true;
}
