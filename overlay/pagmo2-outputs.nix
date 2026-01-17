[
  # pagmo2: do not split outputs (#480871)
  (final: prev: {
    pagmo2 = prev.pagmo2.overrideAttrs (
      finalAttrs: previousAttrs: {
        outputs = [ "out" ];
      }
    );
  })
]
