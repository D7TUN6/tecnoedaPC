{ config, lib, pkgs, inputs, ... }:

{
  users = {

    users = {

      server = {
        isNormalUser = true;
        extraGroups = [
        "wheel"
        "storage"
        "input"
        "plugdev"
        "networkmanager"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
