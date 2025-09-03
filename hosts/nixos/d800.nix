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
        ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/7dd0fbaf-3641-41e5-b074-40c5962b361c";
          fsType = "ext4";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "i686-linux";
        networking.enableIntel2200BGFirmware = true;
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.grub.enable = lib.mkDefault true;
        boot.loader.grub.device = "/dev/sda";

        networking.hostName = "d800";
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGm3D08mu5rHgV39OXduViY5OFY8l8m0ZKvgs/Ow2UMX";

        nix = {
          settings = {
            cores = 1;
            max-jobs = 1;
          };
        };
      }
    )
  ];
}
