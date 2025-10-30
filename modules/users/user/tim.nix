{ user, ... }@presets:
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) mkIf;
in
{
  config = mkIf config.extra.user."${user}".enable {
    home-manager.users."${user}" = {
      home = {
        username = user;
        homeDirectory = "/home/" + user;
        stateVersion = "23.11";
        packages = with pkgs; [
          dig.dnsutils
          dos2unix
          iftop
          iotop
          pwgen
        ];
      };

      xdg.userDirs = {
        enable = true;
      };
      xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

      programs.bash = {
        enable = true;
        enableCompletion = true;
        historySize = -1;
        historyFileSize = -1;
        historyControl = [ "ignoreboth" ];
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins; [
          {
            plugin = vim-lastplace;
            config = ''
              let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
              let g:lastplace_ignore_buftype = "quickfix,nofile,help"
            '';
          }
        ];
        extraConfig = ''
          set shada=!,'100,h
        '';
      };

      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            name = "Tim Schumacher";
            email = "timschumi@gmx.de";
          };
          alias = {
            c = "commit --verbose";
            ca = "c --amend";
            cad = "ca --date=now";
            graph = "log --oneline --graph";
            cu = "!env GIT_COMMITTER_DATE=\\\"$(date --utc +%Y-%m-%dT%H:%M:%S%z)\\\" git commit --verbose --date=\\\"$(date --utc +%Y-%m-%dT%H:%M:%S%z)\\\"";
            cau = "!env GIT_COMMITTER_DATE=\\\"$(date --utc +%Y-%m-%dT%H:%M:%S%z)\\\" git commit --verbose --date=\\\"$(date --utc +%Y-%m-%dT%H:%M:%S%z)\\\" --amend";
          };
          color = {
            ui = "auto";
          };
        };
      };

      programs.home-manager = {
        enable = true;
      };

      programs.tmux = {
        enable = true;
        historyLimit = 50000;
      };
    };
  };
}
