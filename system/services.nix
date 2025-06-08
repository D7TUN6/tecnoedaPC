{ config, lib, pkgs, inputs, ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
  };

  services = {

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    irqbalance = {
      enable = true;
    };

    openssh = {
      enable = true;
      ports = [ 2001 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "server" ];
        UseDns = true;
      X11Forwarding = false;
      };
    };
  };

}
