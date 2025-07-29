{
  lib,
  ...
}:
{
  # TODO: Find a better place for overlays.
  nixpkgs.overlays = [
    (final: prev: {
      audacity = prev.audacity.overrideAttrs (
        finalAttrs: previousAttrs: {
          patches = [
            (final.fetchpatch2 {
              url = "https://raw.githubusercontent.com/ryand56/nixpkgs/4965a358b19647194580c09da7fbf1ae3d017217/pkgs/by-name/au/audacity/rapidjson.patch";
              hash = "sha256-jZiQ6Vg0V+OC5q1bT+MDiTT5hWi0rbeyfz492VRPRe8=";
            })
          ];
        }
      );
    })
  ];
}
