[
  # vesktop: fix permission denied electron build (#476347)
  (final: prev: {
    vesktop = prev.vesktop.overrideAttrs (
      finalAttrs: prevAttrs: {
        preBuild = ''
          cp -r ${final.electron.dist} electron-dist
          chmod -R u+w electron-dist
        '';

        buildPhase =
          builtins.replaceStrings [ final.electron.dist ] [ "electron-dist" ]
            prevAttrs.buildPhase;
      }
    );
  })
]
