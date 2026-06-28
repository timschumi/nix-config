{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins)
    filter
    length
    ;
  inherit (lib)
    attrValues
    concatMap
    concatStringsSep
    filterAttrs
    listToAttrs
    mkOption
    nameValuePair
    types
    ;
  users = config.users.users;
  pamsrv = config.security.pam.services;
  pampkg = config.security.pam.package;
in
{
  options = {
    users.users = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            extraDeviceAccess = mkOption {
              type = types.listOf types.str;
              example = [ "debug-appliance" ];
              default = [ ];
              description = ''
                Apply additional xaccess- device classes to sshd sessions of the user via XDG_SESSION_EXTRA_DEVICE_ACCESS.
              '';
            };
          };
        }
      );
    };
  };

  config =
    let
      usersWithDevices = filter (conf: conf.extraDeviceAccess != [ ]) (attrValues users);
      mkRules = baseRules: {
        session = listToAttrs (
          concatMap (conf: [
            (nameValuePair "extradev_${conf.name}_cond" {
              control = "[default=1 success=ignore]";
              modulePath = "${pampkg}/lib/security/pam_succeed_if.so";
              args = [
                "quiet"
                "user"
                "="
                conf.name
              ];
              order = baseRules.session.env.order + 10;
            })
            (nameValuePair "extradev_${conf.name}_env" {
              control = "required";
              modulePath = "${pampkg}/lib/security/pam_env.so";
              settings = {
                conffile = pkgs.writeTextFile {
                  name = "${conf.name}-extradev-env";
                  text = ''
                    XDG_SESSION_EXTRA_DEVICE_ACCESS DEFAULT="${concatStringsSep ":" conf.extraDeviceAccess}"
                  '';
                };
                readenv = 0;
              };
              order = baseRules.session.env.order + 11;
            })
          ]) usersWithDevices
        );
      };
    in
    {
      # The use of the rules option is experimental and subject to breaking changes without notice.
      security.pam.services.sshd.rules = mkRules pamsrv.sshd.rules;
    };
}
