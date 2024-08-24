{inputs, ...}: {
  system = "x86_64-linux";
  modules = [
    (inputs.self + "/fragments/comma.nix")
    (inputs.self + "/fragments/home.nix")
    (inputs.self + "/fragments/variant-desktop.nix")

    (
      {
        config,
        lib,
        pkgs,
        modulesPath,
        ...
      }: {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
        boot.initrd.kernelModules = [];
        boot.kernelModules = ["kvm-intel"];
        boot.extraModulePackages = [];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/b9bf772a-fe7e-4e0a-82a5-b7186ab232c6";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/3959-DCD2";
          fsType = "vfat";
          options = ["fmask=0077" "dmask=0077"];
        };

        swapDevices = [];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "m720q";
      }
    )
  ];
}
