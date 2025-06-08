{ config, lib, pkgs, inputs, ... }:
# Файл с локализацией и таймзоной (как языки и время в Windows)
{
  # Основные настройки локализации
  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8" # Английская локаль
      "ru_RU.UTF-8/UTF-8" # Русская локаль
      "C.UTF-8/UTF-8" # Стандартная системная локаль
    ];
    
    extraLocaleSettings = { # Форматы времени, валюты и дат для России
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };

  # Настройки Xorg 
  services.xserver = {
    layout = "us,ru"; # Основная раскладка: us, дополнительная: ru
    xkbVariant = ""; # Вариант раскладки
    xkbOptions = "grp:alt_shift_toggle,grp_led:scroll"; # Alt Shift для переключения, индикация Scroll Lock
  };

  # Настройки времени
  time = {
    timeZone = "Europe/Moscow"; # Часовой пояс
    hardwareClockInLocalTime = true; # Использовать локальное время в BIOS
  };

  # Шрифты
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Основные шрифты
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      
      # Дополнительные русские шрифты
      ubuntu_font_family
      fira-code
      fira-code-symbols
      
      # Шрифты для консоли
      terminus_font
      unifont
    ];
    
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Code" "Noto Mono" ];
        sansSerif = [ "Noto Sans" "Ubuntu" ];
        serif = [ "Noto Serif" "Liberation Serif" ];
      };
    };
  };

  # Переменные окружения для корректного отображения
  environment.sessionVariables = {
    # Для работы русского 
    LANG = "ru_RU.UTF-8";
    LANGUAGE = "ru_RU";
    LC_CTYPE = "ru_RU.UTF-8";
    
    # Для Wayland-приложений
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    
    # Исправление для Electron-приложений
    NIXOS_OZONE_WL = "1";
  };
}
