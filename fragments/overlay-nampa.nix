{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    # FIXME: python3Packages.nampa: 1.0 -> 1.0-unstable-2024-12-18 (#419243)
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          nampa = python-prev.nampa.overridePythonAttrs (
            oldAttrs: {
              version = "1.0-unstable-2024-12-18";

              src = final.fetchFromGitHub {
                owner = "thebabush";
                repo = "nampa";
                rev = "cb6a63aae64324f57bdc296064bc6aa2b99ff99a";
                hash = "sha256-4NEfrx5cR6Zk713oBRZBe52mrbHKhs1doJFAdjnobig=";
              };

              postPatch = null;
              dependencies = [ ];
            }
          );
        })
      ];
    })
  ];
}
