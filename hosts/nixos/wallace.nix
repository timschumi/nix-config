{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/firefox.nix")
    (inputs.self + "/fragments/lix.nix")
    (inputs.self + "/fragments/plasma.nix")
    (inputs.self + "/fragments/pipewire.nix")
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
          device = "/dev/disk/by-uuid/b9bf772a-fe7e-4e0a-82a5-b7186ab232c6";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/3959-DCD2";
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

        networking.hostName = "wallace";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJsrXHfPy8biXpDJBwSt9dXpIC/c+q3SeYI6ewRYZsA";

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
