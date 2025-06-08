{ config, lib, pkgs, inputs, ... }:

# Здесь ставятся программы и настраивается всё что с ними связано. Учти то, что некоторые программы устанавливаются через programs, services или Home-manager.

{    
    environment.systemPackages = with pkgs; [
      # БАЗА ДЛЯ ВЫЖИВАНИЯ
      strawberry # Плеер музыки
      mpv # Плеер видео
      imv # Просмотр изображений
      micro # Редактор текста в терминале
      xfce.mousepad # Простой редактор текста GUI
      pavucontrol # Лёгкий регулировщик звука и микрофона
      telegram-desktop # Телеграм десктоп
      chromium # Браузер Chromium
      pinta # Рисовалка простая
      git # Система контроля версий для твоего конфига
      qemu_full # Виртуалка QEMU
      # ИГРЫ
      nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge # Wine, но с улучшенной совместимостью
    ];

    programs = {
      steam = { # Steam, игровая платформа
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
      fish = { # Fish, лёгкий шелл для новичков с подсказками
        enable = true;
      };
      virt-manager = { # GUI для виртуалок
        enable = true;
      };
    };

    # Виртуализация
    virtualisation = {
      libvirtd = {
        enable = true;
      };
      spiceUSBRedirection = { # СПАААЙС
        enable = true;
      };
    };

    services = {
      gvfs = { # MTP и подобные
        enable = true;
      };
      pulseaudio.enable = false; # Отключаем старый pulseaudio
      printing = {
        enable = false; # Отключаем принтер
      };
      ananicy = { # Выставляет приоритеты для процессов, полезно для игр
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos_git;
      };
      irqbalance.enable = true; # Балансирует прерывания, полезно для отзывчивости
      pipewire = { # Современный, быстрый, лёгкий, low-latency, HiFi звук
        enable = true;
        # Включаем совместимость с другими звуковыми серверами, аля drop-in replacement
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

    zramSwap = { # Лучшая замена Swap, сжатый своп прямо внутри ОЗУ, быстрее чем обычный и не насилует диск
      enable = true;
      memoryPercent = 100; # Сколько % своп будет составлять от ОЗУ. 100% - своп равен ОЗУ
      algorithm = "zstd"; # Алгоритм сжатия, ZSTD - лучший
    };

    nixpkgs = { # Настройка Nixpkgs
      config = {
        allowUnfree = true; # Разрешить проприетарный софт
      };
    };

    security = { # Программы и параметры связанные с безопасностью
      rtkit = { # Позволяет получить права реального времени, улучшает задержки звука
        enable = true;
      };
      polkit = { # Policy Kit, нужен для окон аля "enter password for <program>"
        enable = true;
      };
      sudo = {
        enable = false; # фуфуфу, много весит
      };
      doas = {
        enable = true; # весит мало, делает то же
        extraRules = [{
          users = ["tecnoeda"]; # тут юзер
          noPass = true; # Не просить пароль
        }];
      };
    };

    # Home-manager, управляет конфигурацией всех пакетов с конфигами в ~/.config
    home = {
      username = "tecnoeda"; # Имя юзера
      homeDirectory = "/home/tecnoeda"; # Директория юзера
      stateVersion = "25.05"; # НЕ ТРОГАТЬ, ДАЖЕ ЕСЛИ ОБНОВИЛСЯ, используется для магии...
    };
    programs.home-manager.enable = true; # Дай хоум-манагеру поставить сам себя

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = { # Настройка GTK (интерфейс)
      enable = true;
      theme = { # Тема, мы используем Catpuccin Mocha
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };

      iconTheme = { # Иконки, мы используем Papirus
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = { # Шрифт
        name = "Sans";
        size = 11;
      };
    };


    nix = { # Настройка пакетника Nix
      settings = {
        download-buffer-size = "999999999999"; # Увеличить буфер для ускорения загрузки
        auto-optimise-store = true; # Автоматически удалять старые неиспользуемые версии пакетов после обновлений и ребилдов
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
}

