{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/variant-desktop.nix")
    (import (inputs.self + "/fragments/wireguard-testnet.nix") {
      ip = "10.130.21.1/24";
    })

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

        boot.initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/ececa4d5-9bd7-4bf6-a001-3beb86b6600e";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/CA3E-A725";
          fsType = "vfat";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "m600";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGv/5pQ4z++nvLthWCrctYvRZ71smenYgQF/ixJDvPBG";

        nix = {
          settings = {
            cores = 2;
            max-jobs = 2;
          };
        };
      }
    )
  ];
}
