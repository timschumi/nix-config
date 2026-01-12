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
    (inputs.self + "/fragments/firefox.nix")
    (inputs.self + "/fragments/libvirt.nix")
    (inputs.self + "/fragments/plasma.nix")
    (inputs.self + "/fragments/pipewire.nix")
    (inputs.self + "/fragments/variant-desktop.nix")
    (inputs.self + "/fragments/yubikey.nix")

    (
      { ... }:
      {
        config = {
          extra = {
            user = {
              tim = {
                enable = true;
                roles = [
                  "android"
                  "cad"
                  "daw"
                  "dev-cpp"
                  "dev-dotnet"
                  "dev-java"
                  "dev-php"
                  "dev-py"
                  "dev-rust"
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
          device = "/dev/disk/by-uuid/150f7b2c-2e4b-4e0c-93db-1538e47ddb62";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/BBE7-3CF3";
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

        networking.hostName = "orion";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQHgBITJBi2Ajj3to/Ee3BJwPez62QIqLWEK3xqbO/6";

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
