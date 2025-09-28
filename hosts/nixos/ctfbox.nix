{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/docker.nix")
    (import (inputs.self + "/fragments/emulate.nix") [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-windows"
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
        nixpkgs.config.contentAddressedByDefault = true;
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "ctfbox";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGvQ1mK6DaV7jxmKPIamHw4gTaIFyAhlDiYrt+vWr8h";

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
