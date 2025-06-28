{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # FIXME: ghidra-extensions.ghidra-firmware-utils: init at 2024.04.20 (#415414)
    (final: prev: {
      ghidra-firmware-utils = final.ghidra-extensions.buildGhidraExtension rec {
        pname = "ghidra-firmware-utils";
        version = "2024.04.20";

        src = final.fetchFromGitHub {
          owner = "al3xtjames";
          repo = "ghidra-firmware-utils";
          rev = version;
          hash = "sha256-BbPRSD1EzgMA3TCKHyNqLjzEgiOm67mLJuOeFOTvd0I=";
        };

        meta = {
          description = "Ghidra utilities for analyzing PC firmware";
          homepage = "https://github.com/al3xtjames/ghidra-firmware-utils";
          downloadPage = "https://github.com/al3xtjames/ghidra-firmware-utils/releases/tag/${version}";
          license = lib.licenses.asl20;
          maintainers = with lib.maintainers; [ timschumi ];
        };
      };
    })
  ];
}
