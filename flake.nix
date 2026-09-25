{
  description = "Nix flake for the Septabee DAW";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    packages.x86_64-linux = {
      septabee = pkgs.callPackage ./septabee.nix { };
    };

    nixosModules.default = import ./module.nix;
  };
}