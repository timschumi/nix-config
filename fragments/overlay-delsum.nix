{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # FIXME: delsum: init at 1.0.0 (#418463)
    (final: prev: {
      delsum = final.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "delsum";
        version = "1.0.0";

        src = final.fetchFromGitHub {
          owner = "8051Enthusiast";
          repo = "delsum";
          tag = "v${finalAttrs.version}";
          hash = "sha256-trCH2LIC3hjm3MMEoVGO2AY33eYTfn4N2mm2rOfUwt4=";
        };

        cargoHash = "sha256-Flz7h2/i4WIGr8CgVjpbCGHUkkGKSiHw5wlOIo7uuXo=";

        buildInputs = [
          final.gf2x
        ];

        meta = {
          homepage = "https://github.com/8051Enthusiast/delsum";
          description = "Reverse engineer's checksum toolbox";
          license = final.lib.licenses.mit;
          maintainers = with final.lib.maintainers; [ timschumi ];
          mainProgram = "delsum";
        };
      });
    })
  ];
}
