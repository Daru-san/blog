# Blog

The backend of my personal blog page.

This was set up on NixOS, I hope
to help you learn how to get it done.

## Set up

Since we are using Nix, I would recommend creating
a dev shell for Hugo, but you do not have to. A system-wide
installation would work just as well.

### Nix flake

```bash
cd my-site
nix flake init .

# Git aswell(optional)
git init .
git remote set-url origin git@YOUR-REPO
```

In `flake.nix`

```nix
# Example
{
  description = "Some blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
          ];
        };
      }
    );
}
```

Then, of course, enter your dev shell.

```bash
nix develop
```

### Hugo site

Create a project directory using Hugo.

```bash
hugo new site "my-site" -d src
```

Configure Hugo, I personally use `JSON` but `toml` and `yaml`
are also options for configuration.

```bash
cd src/

# Choose your preferred file format
# You will have to convert the original file, which is in the toml format
vi hugo.json
vi hugo.toml
vi hugo.yml
```

Once you have set up your page you can start getting
content creation done.

This is a great place to start: <https://gohugo.io/getting-started/quick-start/>.

## What is this?

This is a public version of my blog, none of my content is stored here. This repo
acts as a template for anybody who wants to start blogging on NixOS using Hugo.
