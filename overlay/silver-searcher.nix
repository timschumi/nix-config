[
  (final: prev: {
    # silver-searcher-ng: Bring back silver-searcher with PCRE2 support (#530882)
    silver-searcher-ng = final.stdenv.mkDerivation (finalAttrs: {
      pname = "silver-searcher-ng";
      version = "3.0.0";

      src = final.fetchFromGitHub {
        owner = "silver-searcher";
        repo = "silver-searcher-ng";
        rev = finalAttrs.version;
        hash = "sha256-IiVFbS9XGmqcGN4NRXFC07cV6bGKDs9C2y5XxJKdvFk=";
      };

      env = final.lib.optionalAttrs final.stdenv.hostPlatform.isLinux {
        NIX_LDFLAGS = "-lgcc_s";
      };

      nativeBuildInputs = with final; [
        autoreconfHook
        pkg-config
      ];

      buildInputs = with final; [
        pcre2
        zlib
        xz
      ];

      doCheck = true;
      nativeCheckInputs = with final; [
        python3Packages.cram
        git
      ];
      checkPhase = ''
        runHook preCheck

        make test

        runHook postCheck
      '';

      strictDeps = true;
      __structuredAttrs = true;

      meta = {
        homepage = "https://github.com/silver-searcher/silver-searcher-ng";
        description = "Code-searching tool similar to ack, but faster";
        maintainers = with final.lib.maintainers; [ timschumi ];
        mainProgram = "ag";
        platforms = final.lib.platforms.all;
        license = final.lib.licenses.asl20;
      };
    });
  })
]
