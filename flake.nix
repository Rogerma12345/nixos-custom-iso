{
  description = "Safe custom NixOS installer ISO for headless ESXi VMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      mkInstaller = profile:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit self;
          };
          modules = [ profile ];
        };

      installerBase = mkInstaller ./nix/profiles/installer-base.nix;
      installerCustom = mkInstaller ./nix/profiles/installer-custom.nix;
    in
    {
      nixosConfigurations = {
        installer = installerBase;
        installer-custom = installerCustom;
      };

      packages.${system} = {
        default = installerBase.config.system.build.isoImage;
        iso = installerBase.config.system.build.isoImage;
        installer-iso = installerBase.config.system.build.isoImage;
        installer-custom-iso = installerCustom.config.system.build.isoImage;
      };

      checks.${system} = {
        default = self.packages.${system}.default;
        installer-iso = self.packages.${system}.installer-iso;
      };
    };
}
