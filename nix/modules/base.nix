{ lib, pkgs, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings {};
in
{
  networking.hostName = lib.mkDefault settings.hostname;
  networking.useDHCP = lib.mkDefault true;

  time.timeZone = lib.mkDefault settings.timezone;
  i18n.defaultLocale = lib.mkDefault settings.locale;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";

  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    htop
    jq
    nano
    rsync
    tmux
    vim
    wget
  ];

  services.getty.helpLine = "Safe custom NixOS installer ISO. No unattended disk wipe or auto-install is enabled by default.";

  security.sudo.wheelNeedsPassword = false;

  services.qemuGuest.enable = lib.mkDefault true;
  services.spice-vdagentd.enable = lib.mkDefault false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
