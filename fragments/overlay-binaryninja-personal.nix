{
  lib,
  pkgs,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    (final: prev: {
      binaryninja-personal = final.binaryninja-free.overrideAttrs (
        finalAttrs: previousAttrs: {
          pname = "binaryninja-personal";

          src = final.requireFile {
            name = "binaryninja_linux_${finalAttrs.version}_personal.zip";
            url = "https://portal.binary.ninja";
            hash = "sha256-BL7WnJgvCLbe4CeqyVQWrwbJPlJOdhcaUhfCmJBlXjc=";
          };

          buildInputs = previousAttrs.buildInputs ++ [
            pkgs.openssl
          ];

          # PySide6 depends on the Qt6 libraries in the main directory,
          # but auto-patchelf does not consider them due to the working directory.
          # Instead, just ignore missing dependencies errors for these,
          # we are sure they are present.
          autoPatchelfIgnoreMissingDeps = [
            "libQt6Qml.so.6"
            "libQt6ShaderTools.so.6"
            "libQt6PrintSupport.so.6"
            "libQt6QuickVectorImageGenerator.so.6"
            "libQt6Quick.so.6"
            "libQt6Qml.so.6"
          ];

          desktopItems = [
            ((builtins.elemAt previousAttrs.desktopItems 0).override {
              desktopName = "Binary Ninja Personal";
            })
          ];

          meta = previousAttrs.meta // {
            license = {
              fullName = "Binary Ninja Non-commercial / Student Software License";
              url = "https://docs.binary.ninja/about/license.html#non-commercial-student-license-named";
              free = false;
            };
            maintainers = with lib.maintainers; [ timschumi ];
          };
        }
      );
    })
  ];
}
