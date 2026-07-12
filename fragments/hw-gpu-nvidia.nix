{
  pkgs,
  ...
}:
{
  nixpkgs.config.cudaSupport = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = pkgs.stdenv.hostPlatform.isx86_64;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
