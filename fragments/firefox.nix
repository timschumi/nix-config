{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nur.modules.nixos.default
  ];

  home-manager.users.tim = {
    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      profiles = {
        main = {
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            keepassxc-browser
            reddit-enhancement-suite
            sponsorblock
            ublock-origin
          ];
        };
      };
    };
  };
}
