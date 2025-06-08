{ config, lib, pkgs, inputs, ... }:

# boot.nix                    kernel.nix   nix.nix              programs.nix  systemd.nix  user-hardware.nix
#environment.nix             locales.nix  packages.nix         security.nix  system.nix   users.nix
#hardware-configuration.nix  network.nix  powermanagement.nix  services.nix  time.nix


{
  imports = [
    # System.
    ./system/system.nix
    ./system/boot.nix
    ./system/environment.nix
    ./system/nix.nix
    ./system/programs.nix
    ./system/security.nix
    ./system/services.nix
    ./system/user-hardware.nix
    ./system/users.nix
    ./system/network.nix
    ./system/locales.nix
    ./system/time.nix
    ./system/powermanagement.nix
    ./system/systemd.nix
    ./system/packages.nix
    ./system/filesystem.nix
    ./hardware-configuration.nix  # DO NOT EDIT!
    # Services.
    ./services/containers.nix
    ];
}

