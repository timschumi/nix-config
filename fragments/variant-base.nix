{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "tim"
      ];
    };
    registry = {
      self.flake = inputs.self;
    };
  };
  networking.nftables.enable = true;
  networking.firewall = {
    logRefusedConnections = false;
    logRefusedPackets = false;
  };

  nixpkgs.config.allowUnfree = true;
  # This gets enabled on a target-by-target basis.
  nixpkgs.config.contentAddressedByDefault = false;
  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1-nodeadkeys";
  };

  users.users.tim = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      htop
      silver-searcher
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWSvBiQLNvqFY4iCzJ7scnstK872QOS5VtzuyXlXNzV tim@b550"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVEVylmxWUFCRuBOCz0wTjwfjot649TDoH9hQIWflXZ tim@framework"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO5h6N1XE2wls4aqdzzpnPgIq7XlPwz/xMYxHgu5tduhAAAABHNzaDo= tim@yubikey"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfiExYrWTfGtNn+2+vPYplnWgJeRLmSifc+aEgPNMJH tim@p2520la"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpHDHOvHS88FMuC3vapC7202aXJ+Y8xWefLeB5z+hZ/ tim@fogos"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO5h6N1XE2wls4aqdzzpnPgIq7XlPwz/xMYxHgu5tduhAAAABHNzaDo= tim@yubikey"
    ];
  };

  services.openssh.enable = true;

  services.logind = {
    settings.Login.HandleLidSwitch = "ignore";
    settings.Login.HandleLidSwitchDocked = "ignore";
  };

  services.cron = {
    enable = true;
  };

  systemd.tmpfiles.rules = [
    "q /var/ntmp 1777 root root"
  ];

  boot.loader.systemd-boot.memtest86.enable = pkgs.stdenv.hostPlatform.isx86;
  boot.loader.grub.memtest86.enable = pkgs.stdenv.hostPlatform.isx86;

  system.stateVersion = "23.11";
}
