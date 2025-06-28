{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # FIXME: python3Packages.shtab: Pick a fix for nargs="?" from upstream (#420858)
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          shtab = python-prev.shtab.overridePythonAttrs (oldAttrs: {
            patches = [
              # Fix bash error on optional nargs="?" (iterative/shtab#184)
              (final.fetchpatch2 {
                url = "https://github.com/iterative/shtab/commit/a04ddf92896f7e206c9b19d48dcc532765364c59.patch?full_index=1";
                hash = "sha256-H4v81xQLI9Y9R5OyDPJevCLh4gIUaiJKHVEU/eWdNbA=";
              })
            ];
          });
        })
      ];
    })
  ];
}
