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
          device = "/dev/disk/by-uuid/376b8af8-74fa-4b5a-a3c0-ae9ddd29591e";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/6C1C-BA87";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Very new hardware, let's run mainline Linux for now.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        networking.hostName = "ms-r1";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyZUzfLZttL7j2w0Rie1VOrUOLE3uhW1FLo0rR+7sF6";

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
