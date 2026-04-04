{ inputs }:
let
  inherit (inputs.self.lib) emptyDirectory;
in
condition: deriv: if !condition then deriv else emptyDirectory
