{
  config,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) mkIf;
  inherit (inputs.nixpkgs.lib.options) mkEnableOption mkOption;
  inherit (inputs.nixpkgs.lib.types) str;
  cfg = config.extra.services.blog;
in
{
  options.extra.services.blog = {
    enable = mkEnableOption "Enable the `blog` service";
    domain = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."blog" = {
      image = "ghcr.io/timschumi/blog:latest";
      login = {
        username = "timschumi";
        registry = "ghcr.io";
        passwordFile = "/secrets/ghcr-token";
      };
      environment = {
        TZ = "Europe/Berlin";
      };
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.blog.entrypoints" = "public-https";
        "traefik.http.routers.blog.rule" = "Host(`${cfg.domain}`)";
      };
      log-driver = "journald";
    };
  };
}
