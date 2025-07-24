{
  inputs,
  pkgs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_full.override {
        # FIXME: ceph: fix build with arrow 20 (#426609)
        cephSupport = false;
      };
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  users.users.tim = {
    extraGroups = [ "libvirtd" ];
  };

  home-manager.users.tim = {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
