{
  ...
}:
{
  nixpkgs.hostPlatform = {
    gcc.arch = "armv9.2-a";
    gcc.tune = "cortex-a720";
  };

  boot.kernelPatches = [
    # octeontx2 throws a lot of
    # Error: selected processor does not support `retaa'
    {
      name = "disable-octeontx2";
      patch = null;
      extraConfig = ''
        CRYPTO_DEV_OCTEONTX2_CPT n
        OCTEONTX2_AF n
        OCTEONTX2_PF n
      '';
    }
  ];
}
