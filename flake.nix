{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, nixvim }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          nixvimPkg = nixvim.legacyPackages.${system}.makeNixvim (import ./nixvim.nix pkgs);
          texvim = pkgs.stdenv.mkDerivation {
            name = "texvim";
            dontUnpack = true;

            configurePhase = ''
              mkdir -p $out/bin
            '';
            installPhase = ''
              cp ${nixvimPkg}/bin/nvim $out/bin/tvim
            '';
          };
        in {
          packages.default = texvim;
        }
      );
}
