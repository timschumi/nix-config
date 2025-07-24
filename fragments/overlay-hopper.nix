{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    (final: prev: {
      hopper = prev.hopper.overrideAttrs (
        finalAttrs: previousAttrs: {
          preFixup = ''
            mkdir -p "$out/lib"
            ln -s "${lib.getLib final.libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
          '';
        }
      );
    })
  ];
}
