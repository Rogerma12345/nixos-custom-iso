{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../modules/base.nix
    ../modules/docker.nix
    ../modules/python.nix
    ../modules/wolfram.nix
    ../modules/ssh.nix
    ../modules/custom-installer-user.nix
    ../modules/custom-installer-host-proxy.nix
  ];

  image.fileName = "nixos-custom-iso-installer-custom.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 8";

  documentation.enable = false;
}
