{
  pkgs,
  ...
}:
{
  imports = [
    ./variant-base.nix
  ];

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];
  documentation.dev.enable = true;

  programs.nix-ld.enable = true;
}
