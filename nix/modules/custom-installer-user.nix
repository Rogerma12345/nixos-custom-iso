{ lib, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings { custom = true; };
  mkUser = import ../lib/mk-user.nix { inherit lib; };
in
lib.recursiveUpdate
  (mkUser {
    username = settings.username;
    authorizedKeys = settings.authorizedKeys;
  })
  {
    users.groups.${settings.username} = {};
    users.users.${settings.username} = {
      group = settings.username;
      extraGroups = [ "wheel" ] ++ lib.optional settings.features.docker "docker";
    };
  }
