{
  ...
}:
{
  nix.settings.system-features = [ "gccarch-armv9.2-a" ];
  nixpkgs.hostPlatform = {
    system = "aarch64-linux";
  };
}
