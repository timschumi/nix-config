{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins)
    attrNames
    concatLists
    foldl'
    map
    ;
  inherit (inputs.nixpkgs.lib.attrsets) mapAttrsToList;
  inherit (inputs.nixpkgs.lib.options) mkEnableOption mkOption;
  inherit (inputs.nixpkgs.lib.types) listOf nullOr str;
  inherit (inputs.self.lib) enumerateNixFiles;
  users = enumerateNixFiles ./user;
  roles = enumerateNixFiles ./role;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ concatLists (
    mapAttrsToList (
      user: userpath:
      [
        (import userpath {
          inherit user;
        })
      ]
      ++ mapAttrsToList (
        role: rolepath:
        import rolepath {
          inherit role user;
        }
      ) roles
    ) users
  );

  options.extra.user = foldl' (a: b: a // b) { } (
    map (user: {
      "${user}" = {
        enable = mkEnableOption "Create user ${user}";
        roles = mkOption {
          default = [ ];
          example = roles;
          type = listOf str;
        };
      };
    }) (attrNames users)
  );
}
