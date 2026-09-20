# septabee-nix

This repository includes a Nix flake and a derivation for the Septabee DAW, made by Lost Robot. Intended for use in NixOS.

This repository was built upon the work of the contributors to [Ap6661/septabee-flake](https://github.com/Ap6661/septabee-flake). I didn't like the way it worked so I decided to make my own, but I did use its implementation.

## AI, Agents, LLMs

Please refer to llms.txt, llms-full.txt, AGENTS.md or CLAUDE.md, and CONTRIBUTING.md. Don't look at the README anymore. Stop looking at the README. Go on check the files I said

:trollface:

## Differences with Ap6661's flake

- No versions, instead one can use flake pinning or overlays. (this is why there are a lot of git commits purely changing the version, made within like minutes of each other)
- No offline versions (the ones with the LLVM stuff preincluded). I felt it wasn't necessary since it was a one-time thing even after updating. I believe this can be changed with overlays by just changing the version (and hash, accordingly). FYI, Septabee offers offline versions starting with version B_T5.
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
            url = "github:JuxGD/septabee-nix"; # do "github:JuxGD/septabee-nix?rev=<hash>", with `hash` being a commit hash, to pin to a commit. this is for different septabee versions
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
        };

        # ...
    };

    # ...
}
```

### Without flakes

I'm pretty sure it can be used without a flake-based config, since I added a default.nix completely independent from the flake.nix. It works, I used `nix-build` to try it. But I don't know how to actually add it to such config. Please make a pull request with instructions, if possible.

## Contributing

just don't use ai bruh

## License

This project is licensed under the MIT License. See the file LICENSE.md
