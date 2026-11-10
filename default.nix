{
  pkgs ? import <nixpkgs> { },
  waylandSupport ? true,
  offline ? true,
}:

{
  septabee = pkgs.callPackage ./septabee.nix { inherit offline waylandSupport; };

  module = import ./module.nix;
}
