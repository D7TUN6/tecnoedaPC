{ config, lib, pkgs, inputs, ... }:
# Настройка пользователей
{
  users = {
    users = {
      tecnoeda = {
        isNormalUser = true;
        extraGroups = [ # Группы пользователя
        "wheel"
        "storage"
        "input"
        "plugdev"
        "networkmanager"
        ];
        shell = pkgs.fish; # Шелл пользователя
      };
    };
  };
  users.groups.libvirtd.members = ["tecnoeda"]; # Для virt-manager
}
