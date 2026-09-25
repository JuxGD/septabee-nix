{ pkgs ? import <nixpkgs> { }, waylandSupport ? true, offline ? true }:

{
  septabee = pkgs.callPackage ./septabee.nix { inherit waylandSupport; inherit offline; };

  module = import ./module.nix;
}