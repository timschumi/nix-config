[
  # ghidra: add missing in keyword in for loop (#479336)
  (final: prev: {
    ghidra = prev.ghidra.overrideAttrs (
      finalAttrs: previousAttrs: {
        postFixup =
          builtins.replaceStrings [ "for bin $out" ] [ "for bin in $out" ]
            previousAttrs.postFixup;
      }
    );
  })
]
