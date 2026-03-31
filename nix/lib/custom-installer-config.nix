let
  localPath = ../../config/custom-installer.local.nix;
  examplePath = ../../config/custom-installer.example.nix;
in
if builtins.pathExists localPath then
  import localPath
else
  throw ''
Missing local custom installer config: config/custom-installer.local.nix
Copy config/custom-installer.example.nix to config/custom-installer.local.nix and replace all CHANGE_ME_* placeholders before building .#installer-custom-iso.
''
