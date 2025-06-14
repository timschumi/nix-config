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
          "ehci_pci"
          "ahci"
          "usb_storage"
          "sd_mod"
          "sr_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/e52285cc-2db2-4a6b-8064-75ca79f1058a";
          fsType = "ext4";
        };

        boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/51fe88b8-a5e9-434c-b171-2b06b21e6699";

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/4A40-5EA2";
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

        networking.hostName = "p2520la";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPEvlN0oGN2daJIZCg4ebTmVWg5IjeIrXv0mdI3lViv";
      }
    )
  ];
}
