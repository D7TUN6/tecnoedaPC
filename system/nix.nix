{ config, lib, pkgs, inputs, ... }:

{
  nix = {

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    optimise = {
      automatic = true;
      dates = [
        "23:30"
      ];
    };

  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}