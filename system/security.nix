{ config, lib, pkgs, inputs, ... }:

{
  security = {

    rtkit = {
      enable = true;
    };

    sudo = {
      enable = false;
    };

    doas = {
      enable = true;
      extraRules = [{
        users = ["server"];
        keepEnv = false;
        persist = false;
      }];
    };

    polkit = {
      enable = true;
    };
  };

}