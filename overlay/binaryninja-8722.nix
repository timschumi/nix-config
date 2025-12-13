[
  # binaryninja-free: 5.2.8614 -> 5.2.8722 (#468801)
  (final: prev: {
    binaryninja-free = prev.binaryninja-free.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "5.2.8722";

        src = final.fetchurl {
          url = "https://github.com/Vector35/binaryninja-api/releases/download/stable/${finalAttrs.version}/binaryninja_free_linux.zip";
          hash = "sha256-YlBr/Cdjev7LWY/VsKgv/i3zHj4YR49RX69zmhhie7U=";
        };
      }
    );
  })
]
