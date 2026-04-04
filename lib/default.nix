{ inputs }:
let
  importWithInherit =
    path:
    import path {
      inherit inputs;
    };
in
{
  brokenOn = importWithInherit ./brokenOn.nix;
  emptyDirectory = importWithInherit ./emptyDirectory.nix;
  enumerateNixFiles = importWithInherit ./enumerateNixFiles.nix;
}
