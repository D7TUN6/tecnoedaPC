{ config, lib, pkgs, inputs, ... }:
# Настройка интернета
{
  networking = {
    hostName = "icepeak";
    nameservers = [ # Несколько DNS серверов для надёжности
        "1.1.1.1" # Cloudflare
        "1.0.0.1"
        "8.8.8.8" # Google
        "8.8.4.4"
    ];
    networkmanager = { # Networkmanager - сердце сети
      enable = true;
    };
    wireless = {
      enable = true; # Включаем поддержку WiFi
    };
    firewall = {
      enable = false;
    };
  };
}
