{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  services.desktopManager.plasma6.enable = true;

  home-manager.users.tim = {
    imports = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];

    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
        cursor.theme = "Breeze";
        iconTheme = "breeze";
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Kay/contents/images_dark/5120x2880.png";
      };

      powerdevil = {
        AC = {
          autoSuspend.action = "nothing";
        };
      };

      configFile = {
        kxkbrc = {
          Layout = {
            LayoutList = "de";
            Use = true;
            VariantList = "nodeadkeys";
          };
        };

        baloofilerc = {
          "Basic Settings" = {
            Indexing-Enabled = false;
          };
        };

        krunnerrc = {
          Plugins = {
            baloosearchEnabled = false;
          };
        };
      };
    };

    home.packages = with pkgs; [
      glib.bin
      keepassxc
      (lib.meta.lowPrio python3)
      vlc
    ];
  };

  # Substitute lacking KIO functions with GVFS (in particular support for mounting avahi/dnssd/webdav).
  services.gvfs.enable = true;
  services.gvfs.package = pkgs.gvfs.override {
    avahi = pkgs.avahi; # Required for webdav
    samba = null;
    gnomeSupport = true; # Required for TLS support
    udevSupport = true; # Required for FUSE support
  };

  programs.kdeconnect.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;
}
