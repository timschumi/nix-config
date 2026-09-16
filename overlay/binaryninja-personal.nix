[
  (final: prev: {
    binaryninja-personal = final.binaryninja-free.overrideAttrs (
      finalAttrs: previousAttrs: {
        pname = "binaryninja-personal";

        src = final.requireFile (
          {
            url = "https://portal.binary.ninja";
          }
          // {
            x86_64-linux = {
              name = "binaryninja_linux_${finalAttrs.version}_personal.zip";
              hash = "sha256-OOuY5Pw6I5iL3CrDDEPDj2UysjD2ZlADAw7L+SGVRMc=";
            };
            aarch64-linux = {
              name = "binaryninja_linux-arm_${finalAttrs.version}_personal.zip";
              hash = "sha256-u/1r7fmqgpDJ5NH8qLF7BrjdVYrYPndPPx72CnnnOWs=";
            };
          }
          .${final.stdenv.hostPlatform.system}
        );

        buildInputs = previousAttrs.buildInputs ++ [
          final.libuuid.lib
          final.openssl
          final.sqlite.out
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
          maintainers = with final.lib.maintainers; [ timschumi ];
        };
      }
    );
  })
]
