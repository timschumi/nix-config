[
  # honggfuzz: patch in support for gcc15 (#477016)
  (final: prev: {
    honggfuzz = prev.honggfuzz.overrideAttrs (
      finalAttrs: prevAttrs: {
        patches = [
          # [PATCH] mangle: support gcc-15 with __attribute__((nonstring))
          (final.fetchpatch2 {
            url = "https://github.com/google/honggfuzz/commit/4cfa62f4fdb56e3027c1cb3aecf04812e786f0fd.patch?full_index=1";
            hash = "sha256-79/GZfqTH1o/21P7At5ZPmvcCSYWAsVakSv5dNCT+XI=";
          })
        ];
      }
    );
  })
]
