{ config, lib, pkgs, inputs, ... }:

{
  containers."mc-126-alpha" = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "192.168.100.15";
    localAddress = "192.168.100.16";
    hostAddress6 = "fc00::5";
    localAddress6 = "fc00::6";
    bindMounts = {
      "/home/user/data" = {
        hostPath = "/home/server/data/services/datas/Ilja-space/mc-1_2_6-alpha";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, libs, inputs, ... }: {
      environment = {
        systemPackages = with pkgs; [
          jdk21_headless
          bash
          coreutils
        ];
    };
  
    networking = {
      useHostResolvConf = lib.mkForce false;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 55793 ];
	allowedUDPPorts = [ 55793 ];
      };
    };

    services.resolved.enable = true;
    system.stateVersion = "25.11";
    systemd.services.minecraft = {
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        jdk8
        bash
        coreutils
      ];

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'cd /home/user/data/ && ${pkgs.jdk8}/bin/java -jar server.jar nogui'";
        ExecStop = "${pkgs.bash}/bin/bash -c 'echo save-all > /proc/1/fd/0 && echo stop > /proc/1/fd/0'";
        WorkingDirectory = "/home/user/data/";
        #Restart = "always";
        #RestartSec = "5s";
        User = "user";
        };
      };
      
      users.groups.minecraft = {};

      users = {
        users = {
          user = {
            isSystemUser = true;
            group = "minecraft";
            #home = "/home/user/data/";
            createHome = true;
          };
        };
      };
    };
  };

}
