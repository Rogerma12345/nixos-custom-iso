{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../modules/base.nix
    ../modules/docker.nix
    ../modules/python.nix
    ../modules/wolfram.nix
  ];

  isoImage.isoName = "nixos-custom-iso-installer.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 8";

  documentation.enable = false;
}
