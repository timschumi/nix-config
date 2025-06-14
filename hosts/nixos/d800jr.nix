{ inputs, ... }:
{
  system = "i686-linux";
  modules = [
    (inputs.self + "/fragments/variant-desktop.nix")

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
          "uhci_hcd"
          "ehci_pci"
          "ata_piix"
          "firewire_ohci"
          "usb_storage"
          "sd_mod"
          "sr_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.kernelParams = [
          "nomodeset"
          "forcepae"
          "processor.ignore_ppc=1"
          "console=ttyS0,115200n8"
        ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/42953ccb-90fe-4cf1-935e-4e851f1a3e9e";
          fsType = "ext4";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "i686-linux";
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.grub.enable = lib.mkDefault true;
        boot.loader.grub.device = "/dev/sda";

        networking.hostName = "d800jr";
      }
    )
  ];
}
