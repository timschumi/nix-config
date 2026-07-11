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
      inputs.plasma-manager.homeModules.plasma-manager
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
      (vlc.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = previousAttrs.patches ++ [
            # access: sftp: add public key auth options
            (fetchpatch2 {
              url = "https://github.com/videolan/vlc/commit/3b506f55e0038644a24ab2b015cfe09ed0a65ad0.patch?full_index=1";
              hash = "sha256-oZAen8AiTkVse1/SAfp3UUiKwOdC36zeaOJ/foqJw3w=";
            })
            # access: sftp: add ED25519 hostkey support
            (fetchpatch2 {
              url = "https://github.com/videolan/vlc/commit/6368db7b66414ce73db066c373021f1706113dee.patch?full_index=1";
              hash = "sha256-eEsoHRWNtjt/KqajMU+Ld9cRLJlxFpqAHWjanB3ohdU=";
            })
            # access: sftp: store creds on successful pubkey auth
            (fetchpatch2 {
              url = "https://github.com/videolan/vlc/commit/dcc36360256dfa11bf57880c063ca02d8bdf4d90.patch?full_index=1";
              hash = "sha256-g7nTwYsoejfYusElsxod5d485Q2q94ON7HKMmGw9/Go=";
            })
          ];
        }
      ))
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

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
