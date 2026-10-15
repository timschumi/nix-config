{
  pkgs,
  ...
}:
{
  # FIXME: Downgrade back to stable again once build works there.

  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.lix_2_96)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.lix_2_96.lix;
}
