{
  inputs,
  pkgs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
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
