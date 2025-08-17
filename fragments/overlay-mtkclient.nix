{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    (final: prev: {
      # FIXME: mtkclient: init at 0-unstable-2025-06-08 (#432318)
      mtkclient = final.python3Packages.buildPythonApplication rec {
        pname = "mtkclient";
        version = "0-unstable-2025-06-08";
        pyproject = true;

        src = final.fetchFromGitHub {
          owner = "bkerler";
          repo = "mtkclient";
          rev = "3093e652339352dca0806b9f3d6a2b4384a992ae";
          hash = "sha256-7fCX7NyvNAlz6ikGjHjoXblHfNrl6PUnG2jHfit71vk=";
        };

        build-system = [ final.python3Packages.setuptools ];

        dependencies = with final.python3Packages; [
          colorama
          fusepy
          hatchling
          mock
          pycryptodome
          pycryptodomex
          pyserial
          pyside6
          pyusb
          shiboken6
        ];

        pythonImportsCheck = [ "mtkclient" ];

        meta = {
          description = "MTK reverse engineering and flash tool";
          homepage = "https://github.com/bkerler/mtkclient";
          mainProgram = "mtk";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.timschumi ];
        };
      };
    })
  ];
}
