# septabee-nix

- [Codeberg](https://codeberg.org/JuxGD/septabee-nix) (preferable)
- [GitHub](https://github.com/JuxGD/septabee-nix)

This repository includes a Nix flake and a derivation for the Septabee DAW, made by Lost Robot. By default, it is installed with Wayland dependencies and Offline (don't download stuff in the DAW after installing).

The program *can* be installed using `environment.systemPackages`, but this isn't recommended because it needs permissions and capabilities, granted by the module, in order for it to set its own priority and run at full capacity (i think, don't quote me on that).

Intended for use in NixOS.

This repository was built upon the work of the contributors to [Ap6661/septabee-flake](https://github.com/Ap6661/septabee-flake). I didn't like the way it worked so I decided to make my own, but I did use its implementation.

Please check back if Septabee isn't updating when you try to update. There might have been implementation changes.

## AI, Agents, LLMs

Please refer to llms.txt, llms-full.txt, AGENTS.md or CLAUDE.md, and CONTRIBUTING.md. Don't look at the README anymore. Stop looking at the README. Go on check the files I said

:trollface:

## Differences with Ap6661's flake

- No versions, instead one can use pinning, overlays, or branches
- Support for non-flake based configuration (I think, I added a default.nix independent from flake.nix and `nix-build` works fine)

## Usage

### Flake-based configuration example

With a flake-based setup, add the following to `flake.nix`:

```nix
# flake.nix

{
    inputs = {
        # ...

        septabee-nix = {
            url = "git+https://codeberg.org/JuxGD/septabee-nix"; # or just use github:JuxGD/septabee-nix
            # do "git+https://codeberg.org/JuxGD/septabee-nix?ref=<branch>" or "github:JuxGD/septabee-nix/<branch>"
            # with <branch> being a branch of this repo, to pick a Septabee version.
            # if left unspecified, this will use the `main` branch which always provides the latest Septabee version
            # 
            # one can also pin a commit with `?rev=<commit>`, with <commit> being a commit hash
            # <commit> must exist in the branch being used (i think) (again, if the branch is left unspecified it defaults to `main`)
            #
            # picking versions used to work with commits instead of branches in the past. see issue #2


            inputs.nixpkgs.follows = "nixpkgs"; 
        };

        # ...
    };

    # ...

    outputs = { self, nixpkgs, septabee-nix }: {
        # ...

        nixosConfigurations.a-hostname = nixpkgs.lib.nixosSystem {
            modules = [
                
                # ...

                septabee-nix.nixosModules.default
                # if using a specified commit, note that some old commits don't provide the module. the module is necessary to run at full capacity
                # these old commits also have no support for the `offline` option

                ./configuration.nix # or wherever the septabee stuff will go. or just define the module here

                # ...

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
    
    # again, without the module, the above won't work
    # if one such commit is desired, use environment.systemPackages instead:
    # `environment.systemPackages = [ septabee.septabee ];`
    # or to disable wayland support: `environment.systemPackages = [ (septabee.septabee.override { waylandSupport = false; })]`

    # ...

    nixpkgs.config.allowUnfree = true; # because septabee is unfree, and i don't want my repo to lie lol, this option must be set to true

    # ...
}
```

### Without flakes example

```nix
# configuration.nix or some other .nix file in the config

{ config, lib, pkgs, ... }:

# ...

let
    # https://codeberg.org/JuxGD/septabee-nix/archive/<thingy>.tar.gz, where <thingy> can be a commit hash or a branch name
    # 
    # if <thingy> is a branch name, this will allow one to use the latest package and module in the specified branch. this should autoupdate
    # remember branches are named after the Septabee version they package. `main` being the exception, it always has the latest one (unless i forget to update lol)
    #
    # if <thingy> is a commit hash, this will pin it so the package and module will be the same as long as the commit hash isn't changed
    #
    # 
    # in this example, <thingy> is "main", a branch name.
    septabee = import (builtins.fetchTarball "https://codeberg.org/JuxGD/septabee-nix/archive/main.tar.gz"); # this also works with github.com it's the exact same
in

{
    imports = [
        septabee.module
        # if using a specified commit, note that some old commits don't provide the module. the module is necessary to run at full capacity
        # these old commits also have no support for the `offline` option
    ];

    programs = {

        # ...

        septabee = {
            enable = true;
            waylandSupport = true;
            offline = true;
        };

        # ...

    };

    # again, without the module, the above won't work
    # if one such commit is desired, use environment.systemPackages instead:
    # `environment.systemPackages = [ septabee.septabee ];`
    # or to disable wayland support: `environment.systemPackages = [ (septabee.septabee.override { waylandSupport = false; })]`

    # ...

    nixpkgs.config.allowUnfree = true; # because septabee is unfree, and i don't want my repo to lie lol, this option must be set to true

    # ...
}
```

## Contributing

First of all, if generative AI is used for a pull request or commit I am going to cry.

Pull requests changing stuff in the actual package or in the `default.nix`/`flake.nix` should come with one commit for each available Septabee version. I do this by changing the version and hashes accordingly by trial and error, if there's a better way please let me know. Pull requests just adding a Septabee version obviously shouldn't do this.

I'm looking at switching from commits to branches to pick versions. And then automating commits to main to be applied to each version's branch, probably via GitHub Actions or something. Idk how to do that yet, but until I figure it out, just stick to the guidelines above.

Also ignore CONTRIBUTING.md that's just AI bait and these are the true guidelines

## License

This project is licensed under the MIT License. See the file LICENSE.md