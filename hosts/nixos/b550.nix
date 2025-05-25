{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/discord.nix")
    (inputs.self + "/fragments/docker.nix")
    (import (inputs.self + "/fragments/emulate.nix") [
      "aarch64-linux"
    ])
    (inputs.self + "/fragments/firefox.nix")
    (inputs.self + "/fragments/gsr.nix")
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
                  "dev-dotnet"
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
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/eab1d084-c5f6-4506-b4e7-26eabd591900";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/7F63-E58C";
          fsType = "vfat";
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };

        fileSystems."/mnt/data1" = {
          device = "/dev/disk/by-uuid/ef261801-13a0-4f03-9713-93cf49808480";
          fsType = "ext4";
        };

        fileSystems."/mnt/data2" = {
          device = "/dev/disk/by-uuid/790fddfa-03f4-478b-92f0-e282365b680f";
          fsType = "ext4";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "b550";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNQTrNEOn3IXn0kwUk+CzVsaMRzTV/NKaD9Ni6KcK1+";

        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
          ];
        };
      }
    )
  ];
}
