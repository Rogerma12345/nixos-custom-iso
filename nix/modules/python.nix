{ lib, pkgs, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings { custom = true; };
in
lib.mkIf settings.features.python {
  environment.systemPackages = with pkgs; [
    python3
  ];
}
