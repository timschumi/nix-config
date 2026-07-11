{
  ...
}:
{
  nixpkgs.hostPlatform = {
    gcc.arch = "alderlake";
    gcc.tune = "alderlake";
  };
}
