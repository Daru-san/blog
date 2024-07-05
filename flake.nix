{
  description = "My personal blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      inherit (nixpkgs) lib;
      gem = {
        src = ./.;
        deps = with pkgs; [
          ruby
          jekyll
          bundler
          bundix
          rubyPackages.jekyll-sitemap
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = lib.flatten [
          gem.deps
          self.packages.${system}.launch
        ];
      };
      packages = {
        default = self.packages.${system}.build;
        build = pkgs.stdenv.mkDerivation {
          name = "build-site";
          inherit (gem) src;
          buildInputs = gem.deps;
          buildPhase = ''
            bundler exec jekyll build
          '';
          installPhase = ''
            mkdir -p $out
            cp -r _site $out/site
          '';
        };
        launch = pkgs.writeShellApplication {
          name = "launch-site";
          runtimeInputs = gem.deps;
          text = ''
            bundler exec jekyll serve -w
          '';
        };
      };
    });
}
