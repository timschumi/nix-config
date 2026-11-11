{ inputs, ... }:
{
  system = "aarch64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/docker.nix")
    (import (inputs.self + "/fragments/emulate.nix") [
      "i686-linux"
      "x86_64-linux"
    ])
    (inputs.self + "/fragments/hw-cpu-a720.nix")
    (inputs.self + "/fragments/libvirt.nix")
    (inputs.self + "/fragments/variant-desktop.nix")

    (
      { ... }:
      {
        config = {
          extra = {
            user = {
              tim = {
                enable = true;
                roles = [
                  "hwtest"
                ];
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
          "nvme"
          "usb_storage"
          "usbhid"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/c92f8ab8-66dd-45a7-b177-02f74b8bf28f";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/5929-1577";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/8fe512b9-0ae8-4799-a33a-d6bffbefef4c"; } ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Very new hardware, let's run mainline Linux for now.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        networking.hostName = "orion";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNoq1Wz6zBBTtGqqL+DNVl1k/qkC9gKsRAz/0Run0OB";

        nix = {
          settings = {
            cores = 4;
            max-jobs = 2;
          };
        };
      }
    )
  ];
}
