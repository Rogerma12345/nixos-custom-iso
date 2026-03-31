{ lib, pkgs, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings {};
  wolframPackage = pkgs.wolfram-engine;
in
lib.mkIf settings.features.wolfram {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ (lib.getName wolframPackage) ];

  # This feature installs Wolfram Engine prerequisites only and does not perform activation.
  environment.systemPackages = [ wolframPackage ];
}
