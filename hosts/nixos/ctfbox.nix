{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/docker.nix")
    (import (inputs.self + "/fragments/emulate.nix") [
      "aarch64-linux"
    ])
    (inputs.self + "/fragments/libvirt.nix")
    (inputs.self + "/fragments/variant-server.nix")

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
          "xhci_pci"
          "ahci"
          "nvme"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/31f00aa2-544a-41c0-8e89-c6d88366fe29";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/A97E-0FBE";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "ctfbox";
      }
    )
  ];
}
