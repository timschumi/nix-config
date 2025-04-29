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

    # FIXME: NixOS/nixpkgs#402739
    (final: prev: {
      libblake3 = prev.libblake3.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = [
            # build(cmake): Use tbb32 pkgconfig package on 32-bit builds (BLAKE3-team/BLAKE3#482)
            (final.fetchpatch {
              url = "https://github.com/BLAKE3-team/BLAKE3/commit/dab799623310c8f4be6575002d5c681c09a0e209.patch";
              hash = "sha256-npCtM8nOFU8Tcu//IykjMs8aLU12d93+mIfKuxHkuaQ=";
              relative = "c";
            })
          ];
        }
      );
    })
  ];
}
