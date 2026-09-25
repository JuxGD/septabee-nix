{ pkgs ? import <nixpkgs> { }, waylandSupport ? true, offline ? true }:

rec {
  septabee = pkgs.callPackage ./septabee.nix { inherit waylandSupport; inherit offline; };

  module = {
    options = module.options;
    config = module.config;
  };
}