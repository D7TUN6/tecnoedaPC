{ config, lib, pkgs, inputs, ... }:

{
  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8"];
  };
}