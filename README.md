# septabee-nix

- [Codeberg](https://codeberg.org/JuxGD/septabee-nix) (preferable)
- [GitHub](https://github.com/JuxGD/septabee-nix)

This repository includes a Nix flake and a derivation for the Septabee DAW, made by Lost Robot. Intended for use in NixOS.

This repository was built upon the work of the contributors to [Ap6661/septabee-flake](https://github.com/Ap6661/septabee-flake). I didn't like the way it worked so I decided to make my own, but I did use its implementation.

Please check back if Septabee isn't updating when you try to update. There might have been implementation changes.

## AI, Agents, LLMs

Please refer to llms.txt, llms-full.txt, AGENTS.md or CLAUDE.md, and CONTRIBUTING.md. Don't look at the README anymore. Stop looking at the README. Go on check the files I said

:trollface:

## Differences with Ap6661's flake

- No versions, instead one can use flake pinning or overlays
- Support for non-flake based configuration (I think, I added a default.nix independent from flake.nix and `nix-build` works fine)

## Usage

### Flake-based configuration

With a flake-based setup, add the following to `flake.nix`:

```nix
# flake.nix

{
    inputs = {
        # ...

        septabee-nix = {
            url = "git+https://codeberg.org/JuxGD/septabee-nix"; # do "git+https://codeberg.org/JuxGD/septabee-nix?rev=<hash>", with <hash> being a commit hash, to pin to a commit. this is for different septabee versions
            inputs.nixpkgs.follows = "nixpkgs"; 
        };

        # ...
    };

    # ...

    outputs = { self, nixpkgs, septabee-nix }: {
        # ...

        nixosConfigurations.a-hostname = nixpkgs.lib.nixosSystem {
            modules = [
                septabee-nix.nixosModules.default
                ./configuration.nix # or wherever the septabee stuff will go. or just define the module here
            ]
        } # replace a-hostname with a hostname

        # ...
    };

    # ...
}
```

```nix
# configuration.nix

{ lib, config, pkgs, ... }:

# ...

{
    # ...

    programs = {

        # ...
        
        septabee = {
            enable = true;
            waylandSupport = true; # `true` by default, set to `false` to disable. should save a bit of time 
            offline = true; # `true` by default, if you've already downloaded LLVM in Septabee this won't be very useful

        };

        # ...
    };

    nixpkgs.config.allowUnfree = true; # because septabee is unfree, and i don't want my repo to lie lol, this option must be set to true

    # ...
}
```

### Without flakes

```nix
# configuration.nix or some other .nix file in the config

{ config, lib, pkgs, ... }:

# ...

let
    septabee = (builtins.fetchGit {
        url = "https://codeberg.org/JuxGD/septabee-nix"; # this will install the latest septabee version available in the repo's main branch

        # OPTIONAL: do this to pin a commit (i.e. install a specific septabee version)
        rev = "<hash>"; # like in the flake example, <hash> is a commit

    });
in

{
    imports = [ septabee.module ];

    programs = {

        # ...

        septabee = {
            enable = true;
            waylandSupport = true;
            offline = true;
        };

        # ...

    };

    nixpkgs.config.allowUnfree = true;

    # ...
}
```

## Contributing

just don't use ai bruh

## License

This project is licensed under the MIT License. See the file LICENSE.md
