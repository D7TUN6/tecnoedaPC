{ config, lib, pkgs, inputs, ... }:

{
    systemd = {

        oomd = {
        enable = true;
        };

        timers = {

        fstrim = {
            enable = true;
        };

        "gen-cleaner" = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
                OnCalendar = "Mon..Sun *-*-* 02:00:*";
                Persistent = true;
            };
        };

        "nixos-upgrader" = {
            wantedBy = [ "timers.target" ];
            timerConfig = {
                OnCalendar = "Mon..Sun *-*-* 03:00:*";
                Persistent = true;
            };
        };
        };

        targets = {

        sleep = {
            enable = false;
        };

        suspend = {
            enable = false;
        };

        hibernate = {
        enable = false;
        };

        hybrid-sleep = {
            enable = false;
        };
        };

        services = {

        NetworkManager-wait-online = {
            enable = false;
        };

        "gen-cleaner" = {
            script = ''
            set -eu
            /run/current-system/sw/bin/nix-collect-garbage -d
            '';
            serviceConfig = {
            Type = "oneshot";
            User = "root";
            };
        };

        "nixos-upgrader" = {
            script = ''
            set -eu
            /run/current-system/sw/bin/nixos-rebuild switch --upgrade --flake /etc/nixos#Server1
            '';
            serviceConfig = {
                Type = "oneshot";
                User = "root";
            };
            };
        };
	};

}
