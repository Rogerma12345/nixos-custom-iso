{ lib, modulesPath, ... }:
let
  base = import ../../config/default.nix;
  proxyOverride = import ../../config/example-proxy.nix;
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../modules/base.nix
    ../modules/ssh.nix
    ../modules/proxy.nix
    ../modules/docker.nix
    ../modules/python.nix
    ../modules/wolfram.nix
  ];

  networking.hostName = lib.mkForce base.hostname;

  environment.etc."nixos-custom-iso/profile-info".text = ''
    This profile exists as a documented example.
    It reuses the default installer modules and is intended for local customization.
    Copy values from config/example-proxy.nix into config/default.nix before building if needed.
    Example proxy default: ${proxyOverride.proxy.default}
  '';

  image.fileName = "nixos-custom-iso-installer-with-options.iso";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
}
