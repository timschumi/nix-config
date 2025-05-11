{
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # FIXME: #389211
    (final: prev: {
      lklWithFirewall = prev.lklWithFirewall.overrideAttrs (
        finalAttrs: previousAttrs: {
          src = final.fetchFromGitHub {
            owner = "lkl";
            repo = "linux";
            rev = "fd33ab3d21a99a31683ebada5bd3db3a54a58800";
            sha256 = "sha256-3uPkOyL/hoA/H2gKrEEDsuJvwOE2x27vxY5Y2DyNNxU=";
          };
          version = "2025-03-20";
          buildInputs = [
            final.fuse3
            final.libarchive
          ];
        }
      );
      lkl = prev.lkl.overrideAttrs (
        finalAttrs: previousAttrs: {
          src = final.fetchFromGitHub {
            owner = "lkl";
            repo = "linux";
            rev = "fd33ab3d21a99a31683ebada5bd3db3a54a58800";
            sha256 = "sha256-3uPkOyL/hoA/H2gKrEEDsuJvwOE2x27vxY5Y2DyNNxU=";
          };
          version = "2025-03-20";
          buildInputs = [
            final.fuse3
            final.libarchive
          ];
        }
      );
    })
  ];
}
