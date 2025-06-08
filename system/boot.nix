{ config, lib, pkgs, inputs, ... }:

# Файл с настройкой ядра Linux и загрузчика

{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto; # Оптимизированное ядро от проекта CachyOS для игр и повышения отзывчивости, собранно с оптимизацией LTO

    kernelParams = [ 
      "tsx_async_abort=off"
      "mitigrations=off" # Отключение исправлений уязвимостей процессора для повышения скорости (spectre, meltdown)
    ];

    # Модули ядра
    kernelModules = [
      "xt_multiport"
      "tcp_bbr" # Улучшенный стек TCP для повышения производительности и закрытия уязвимостей
    ];

    kernel = {
      sysctl = { # Параметры задаваемые при запуске с помощью sysctl
        "net.ipv4.tcp_fastopen" = 3; # TCP fast open для снижения пинга
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
        "net.core.rmem_max" = 268435456; # Повышение лимитов
        "net.core.wmem_max" = 268435456;
      };
    };

    # Загрузчик
    loader = {
      # В качестве загрузчика мы используем GRUB на legacy BIOS 
      grub = {
        enable = true;
        device = "/dev/sda"; # Накопитель на который установится загрузчик
      };
    };
  };
}
