{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.Server1 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
      ];
    };
  };
}
