{ config, lib, pkgs, inputs, ... }:

{
  containers."mc-1215-combox-velocity" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.13";
    localAddress = "192.168.100.14";
    bindMounts = {
      "/home/user/data" = {
        hostPath = "/home/server/data/services/datas/combox-space/game-servers/mc-1_21_5-private/velocity";
        isReadOnly = false;
      };
    };

    config = { pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [
          jdk21_headless
          bash
          coreutils
        ];
    };
  
    networking = {
      useHostResolvConf = lib.mkForce false;
       nameservers = [ "8.8.8.8" "1.1.1.1" ];
      firewall = {
        enable = true;
        allowedTCPPorts = [ 25565 25575 44682 ];
	allowedUDPPorts = [ 25565 25575 44682 ];
      };
    };

    systemd.services.minecraft = {
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        jdk21_headless
        bash
        coreutils
      ];

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'cd /home/user/data/ && ${pkgs.jdk21_headless}/bin/java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar velocity.jar nogui'";
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
            home = "/home/user/data/";
            createHome = true;
          };
        };
      };
    };
  };

}

