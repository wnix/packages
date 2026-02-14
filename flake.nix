{
  description = "Custom Nix packages and NixOS modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    # Per-system outputs
    (flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
    ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        seatsurfing = pkgs.callPackage ./pkgs/seatsurfing { };
        packages = {
          seatsurfing-server = seatsurfing.server;
          seatsurfing-ui = seatsurfing.ui;
        };
      in
      {
        inherit packages;
        checks = packages;
      }
    ))
    //
    # System-independent outputs
    {
      nixosModules.seatsurfing = import ./modules/seatsurfing self;
    };
}
