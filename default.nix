{ pkgs ? import <nixpkgs> { }, waylandSupport ? true }: let

  # thanks nix-systems
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  forAllSystems =
    function:
    pkgs.lib.genAttrs (import systems) (
      system: function pkgs.legacyPackages.${system}
    );

in
rec {
  septabee = pkgs.callPackage ./septabee.nix { inherit waylandSupport; };
}