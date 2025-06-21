{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/discord.nix")
    (inputs.self + "/fragments/docker.nix")
    (import (inputs.self + "/fragments/emulate.nix") [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-windows"
    ])
    (inputs.self + "/fragments/firefox.nix")
    (inputs.self + "/fragments/libvirt.nix")
    (inputs.self + "/fragments/lutris.nix")
    (inputs.self + "/fragments/opentabletdriver.nix")
    (inputs.self + "/fragments/plasma.nix")
    (inputs.self + "/fragments/pipewire.nix")
    (inputs.self + "/fragments/printing.nix")
    (inputs.self + "/fragments/spotify.nix")
    (inputs.self + "/fragments/steam.nix")
    (inputs.self + "/fragments/thunderbird.nix")
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
                  "ctf"
                  "daw"
                  "dev-cpp"
                  "dev-dotnet"
                  "dev-java"
                  "dev-php"
                  "dev-py"
                  "dev-rust"
                  "hwtest"
                  "rip"
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
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/432c262e-55e8-47b3-8c8a-f7febfaf6551";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/AB29-2241";
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

        networking.hostName = "framework";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsX/D+lYIOI+88Cp3RCYJmNhPdJVckb1K5XBC+hFbrX";

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            intel-compute-runtime
            intel-media-driver
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            intel-media-driver
          ];
        };
      }
    )
  ];
}
