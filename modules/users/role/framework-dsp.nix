{
  role,
  user,
  ...
}@presets:
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins)
    baseNameOf
    elem
    isAttrs
    fromJSON
    readFile
    ;
  inherit (inputs.nixpkgs.lib)
    mapAttrs'
    nameValuePair
    mkIf
    replaceStrings
    ;

  repo-cab404 = pkgs.fetchFromGitHub {
    owner = "cab404";
    repo = "framework-dsp";
    rev = "6e5b8e7a5d1f422bcaa2f237f28223fe2292ca38";
    hash = "sha256-nqAFmeDfEOMwZArs4AKo2ANzcOVEkEV4dqLqKYlu5tk=";
  };

  repo-framework = pkgs.fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "linux-docs";
    rev = "dbdc4d0da06832dd363134b9f1de72256255704b";
    hash = "sha256-uyjLnOD48m+LWRknKJ8cvgCBkCmVWraNAJGobF/tSmM=";
  };

  packagePreset =
    {
      path,
      irsPath ? null,
      cfgPath ? null,
    }:
    let
      raw = fromJSON (readFile path);
      updateRecursive = mapAttrs' (
        name: value:
        if name == "kernel-path" then
          nameValuePair "kernel-path" (replaceStrings [ "%CFG%" ] [ cfgPath ] value)
        else if name == "kernel-name" then
          nameValuePair "kernel-path" (irsPath + "/" + value + ".irs")
        else if isAttrs value then
          nameValuePair name (updateRecursive value)
        else
          nameValuePair name value
      );
    in
    updateRecursive raw;

  packageCab404Preset =
    path:
    packagePreset {
      inherit path;
      cfgPath = "${repo-cab404}/config";
    };

  packageFrameworkPreset =
    path:
    packagePreset {
      inherit path;
      irsPath = "${repo-framework}/easy-effects/irs";
    };
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    programs.dconf.enable = true;
    home-manager.users."${user}" = {
      services.easyeffects.enable = true;
      services.easyeffects.extraPresets = {
        exciter = packageCab404Preset "${repo-cab404}/config/output/EEGuide+Exciter.json";
        gracefu = packageCab404Preset "${repo-cab404}/config/output/Gracefu's Edits.json";
        hifiscan = packageCab404Preset "${repo-cab404}/config/output/HifiScan+EEGuide.json";
        fw13 = packageFrameworkPreset "${repo-framework}/easy-effects/fw13-easy-effects.json";
        fw16 = packageFrameworkPreset "${repo-framework}/easy-effects/fw16-easy-effects.json";
      };
      services.easyeffects.preset = "fw13";
    };
  };
}
