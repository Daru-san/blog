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
      src = ./.;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [ruby jekyll bundler bundix rubyPackages.jekyll-sitemap];
      };
      packages.default = pkgs.stdenv.mkDerivation {
        name = "blog";
        inherit src;
        buildInputs = with pkgs; [ruby jekyll bundler rubyPackages.jekyll-sitemap];
        buildPhase = ''
          jekyll build
        '';
        installPhase = ''
          mkdir -p $out
          cp -r _site $out/site
        '';
      };
    });
}
