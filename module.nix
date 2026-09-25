{ lib, config, pkgs, ... }:
    
  let
    cfg = config.programs.septabee;
    pkg = pkgs.callPackage ./septabee.nix { inherit (cfg) waylandSupport offline; };
  in

{
  # this is based on the implementation on Ap6661/septabee-flake
  options = { 
    programs.septabee = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the Septabee DAW";
      };

      waylandSupport = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Septabee should have Wayland support";
      };

      offline = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to get Septabee with predownloaded dependencies (don't have to download LLVM when opening the program for the first time).";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkg;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkg ];

    security.wrappers.septabee = {
      owner = "root";
      group = "root";
      permissions = "u-rwx,g=rx,o=rx";
      capabilities = "cap_sys_nice+ep";
      source = "${cfg.package}/bin/septabee";
    };

    security.wrappers.septabee-sounds = {
      owner = "root";
      group = "root";
      permissions = "u-rwx,g=rx,o=rx";
      capabilities = "cap_sys_nice+ep";
      source = "${cfg.package}/bin/septabee-sounds";
    };
  };
}