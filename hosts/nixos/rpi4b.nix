{ inputs, ... }:
{
  system = "aarch64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/variant-desktop.nix")

    (
      { ... }:
      {
        config = {
          extra = {
            user = {
              tim = {
                enable = true;
              };
            };
          };
        };
      }
    )

    (
      {
        config,
        lib,
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = [ "xhci_pci" ];
        boot.initrd.kernelModules = [
          "vc4"
          "bcm2835_dma"
          "i2c_bcm2835"
        ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/".device = lib.mkForce "/dev/disk/by-uuid/efd22b39-bcb7-41d1-b9b4-2d45c35e6220";

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        networking.hostName = "rpi4b";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJqVWq5kKUnpgLdBtAdcTKrvkOlOKeyxPPrfmuyg4JwF";

        nix = {
          settings = {
            cores = 1;
            max-jobs = 2;
          };
        };
      }
    )
  ];
}
