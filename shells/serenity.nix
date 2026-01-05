# This is essentially just a reexport of the SerenityOS devshell with my flake.lock.
{ pkgs, inputs, ... }: inputs.serenity.devShells."${pkgs.stdenvNoCC.hostPlatform.system}".default
