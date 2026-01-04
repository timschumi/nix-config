[
  # httptunnel: Compile with C17 (#477010)
  (final: prev: {
    httptunnel = prev.httptunnel.overrideAttrs {
      env.NIX_CFLAGS_COMPILE = "-std=gnu17";
    };
  })
]
