{
  description = "sdl2-image";
  inputs = {
    flake-parts = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    lint-utils.url = "git+https://gitlab.homotopic.tech/nix/lint-utils";
    hs-techlab-platform.url = "git+https://gitlab.homotopic.tech/nix/hs-techlab-platform/ghc-9.4";
    haskell-flake.url = "github:srid/haskell-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    inputs@{ self
    , flake-parts
    , haskell-flake
    , hs-techlab-platform
    , lint-utils
    , nixpkgs
    , ...
    }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = [ "x86_64-linux" ];
      imports = [
        haskell-flake.flakeModule
      ];
      perSystem = { config, pkgs, system, ... }: {
        haskellProjects = {
          sdl2-image = {
            root = ./.;
            haskellPackages = pkgs.haskell.packages.ghc941;
            buildTools = hp: {
              cabal-doctest = null;
              cabal-install = null;
              ghcid = null;
              haskell-language-server = null;
              hedgehog = null;
              hlint = null;
              hoogle = null;
              hoogle-with-packages = null;
              warp = null;
            };
            source-overrides = { };
            overrides = hs-techlab-platform.overlays.${system}.default;
          };
        };
        devShells.default = config.devShells.sdl2-image;
        packages.default = config.packages.sdl2-image;
        checks = {
          hlint = lint-utils.outputs.linters.${system}.hlint self;
          hpack = lint-utils.outputs.linters.${system}.hpack self;
          nixpkgs-fmt = lint-utils.outputs.linters.${system}.nixpkgs-fmt self;
          stylish-haskell = lint-utils.outputs.linters.${system}.stylish-haskell self;
        };
      };
    };
}
