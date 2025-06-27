{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    (final: prev: {
      binaryninja-free = prev.binaryninja-free.overrideAttrs (
        finalAttrs: previousAttrs: {
          # FIXME: Fix libxml2 breakage in binaryninja-free (#420487)
	  preFixup = ''
	    mkdir -p "$out/lib"
	    ln -s "${lib.getLib final.libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
	  '';
        }
      );
    })
  ];
}
