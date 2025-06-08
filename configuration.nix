{ config, lib, pkgs, inputs, ... }:

# Просто собираем все модули в кучу

{
  imports = [
    ./system/system.nix
    ./system/boot.nix
    ./system/users.nix
    ./system/network.nix
    ./system/locales.nix
    ./system/packages.nix
    ./system/filesystem.nix
    ./hardware-configuration.nix  # В ЭТОМ ФАЙЛЕ НИЧЕГО НЕ ТРОГАЙ! ОН САМ ИЗМЕНЯЕТСЯ
    ];
}

