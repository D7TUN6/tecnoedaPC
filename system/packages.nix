{ config, lib, pkgs, inputs, ... }:

{    
    environment.systemPackages = with pkgs; [
      e2fsprogs
      btrfs-progs
      dosfstools
      neovim
      wget
      rsync
      btop
      fastfetch
      podman
      podman-compose
      dive
      git
    ];
}
