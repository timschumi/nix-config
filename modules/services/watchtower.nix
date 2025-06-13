{
  config,
  inputs,
  ...
}:
let
  inherit (builtins) attrNames;
  inherit (inputs.nixpkgs.lib) mkIf optionals;
  inherit (inputs.nixpkgs.lib.attrsets) genAttrs;
  inherit (inputs.nixpkgs.lib.options) mkEnableOption mkOption;
  inherit (inputs.nixpkgs.lib.types)
    attrsOf
    nullOr
    submodule
    str
    ;
  cfg = config.extra.services.watchtower;
in
{
  options.extra.services.watchtower = {
    enable = mkEnableOption "Enable the `watchtower` service";
    config = mkOption {
      type = nullOr str;
    };
  };

  # HACK: Force adding a default label without getting infinite recursion.
  options = {
    virtualisation.oci-containers.containers = mkOption {
      type = attrsOf (submodule {
        config.labels = {
          "com.centurylinklabs.watchtower.scope" = "nix";
        };
      });
    };
  };

  config = mkIf config.extra.services.watchtower.enable {
    virtualisation.oci-containers.containers."watchtower-nix" = {
      image = "docker.io/containrrr/watchtower:latest";
      volumes =
        [
          "/var/run/docker.sock:/var/run/docker.sock:rw"
        ]
        ++ optionals (cfg.config != null) [
          "${cfg.config}:/config.json:ro"
        ];
      log-driver = "journald";
      cmd = [
        "--scope"
        "nix"
        "--no-restart"
        "--cleanup"
        "--interval"
        "300"
      ];
    };

    virtualisation.oci-containers.containers."watchtower-unscoped" = {
      image = "docker.io/containrrr/watchtower:latest";
      volumes =
        [
          "/var/run/docker.sock:/var/run/docker.sock:rw"
        ]
        ++ optionals (cfg.config != null) [
          "${cfg.config}:/config.json:ro"
        ];
      log-driver = "journald";
      cmd = [
        "--scope"
        "none"
        "--cleanup"
        "--interval"
        "300"
      ];
    };
  };
}
