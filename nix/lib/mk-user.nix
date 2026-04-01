{ lib }: { username, authorizedKeys ? [] }: {
  users.users.${username} = {
    isNormalUser = true;
    description = "Default installer user";
    extraGroups = [ "wheel" ];
    hashedPassword = "!";
    openssh.authorizedKeys.keys = authorizedKeys;
  };
}
