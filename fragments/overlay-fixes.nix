{
  lib,
  pkgs,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # imhex: fix build (#461461)
    (final: prev: {
      imhex = prev.imhex.override {
        fmt = final.fmt_11;
      };
    })
  ];
}
