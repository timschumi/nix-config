{ ... }:
{
  imports = [
    ./variant-base.nix
  ];

  networking = {
    firewall.enable = true;
    firewall.rejectPackets = false;
  };

  services.openssh = {
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
