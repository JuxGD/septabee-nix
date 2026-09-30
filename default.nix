{ pkgs ? import <nixpkgs> { } }:

{
  septabee = pkgs.callPackage ./septabee.nix { waylandSupport = true; offline = true; };

  module = import ./module.nix;
}
