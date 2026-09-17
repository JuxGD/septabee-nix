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

    nixosModules.default =
      { lib, config, ... }:
      let
        cfg = config.programs.septabee;
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
              default = true;
              description = "Whether Septabee should have Wayland support";
            };

            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.callPackage ./septabee.nix {
                waylandSupport = cfg.waylandSupport;
               };
            };
          };
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [ cfg.package ];

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
      };
  };
}