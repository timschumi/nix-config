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

        fileSystems."/".device = lib.mkForce "/dev/disk/by-uuid/2598aea4-bfe9-433e-82fa-7bae4ba6ac45";

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        networking.hostName = "rpi02w";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9+FQHbqR2NsJhlU5pFFgsiiW9wXXIjRbvCBOOYykdH";

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
