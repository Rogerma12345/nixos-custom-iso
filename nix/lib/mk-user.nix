{ lib }:
{ username, authorizedKeys ? [] }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = "Default installer user";
    extraGroups = [ "wheel" ];
    shell = lib.mkDefault null;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = authorizedKeys;
  };
}
