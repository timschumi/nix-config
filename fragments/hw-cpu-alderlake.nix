{
  ...
}:
{
  nix.settings.system-features = [ "gccarch-alderlake" ];
  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
  };
}
