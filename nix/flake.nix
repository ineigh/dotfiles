{
  description = "NixOS configuration for e14g5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pano-scrobbler.url = "github:kawaiiDango/pano-scrobbler-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      cachyos-kernel,
      plasma-manager,
      pano-scrobbler,
      ...
    }:
    {
      nixosConfigurations.e14g5 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];

        specialArgs = {
          inherit
            cachyos-kernel
            plasma-manager
            pano-scrobbler
            ;
        };
      };
    };
}
