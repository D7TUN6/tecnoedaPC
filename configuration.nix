{ config, lib, pkgs, inputs, ... }:

{

  imports = [
      # System.
      ./hardware-configuration.nix
      # Production.
      ./containers.nix
    ];

  system = {
    stateVersion = "24.11";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest;
    kernelModules = [
      "xt_multiport"
    ];
      loader = {
        grub = {
           efiSupport = false; # We use Legacy BIOS BTW.
           device = "/dev/sda";
        };
      };
  };

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
            OnCalendar = "Mon..Sun *-*-* *:30:*";
            Persistent = true;
        };
      };
      "nixos-upgrader" = {
        wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "Mon..Sun *-*-* *:00:*";
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

  time = {
    timeZone = "Asia/Yekaterinburg";
  };

  powerManagement = {
    enable = false;
  };

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
        keepEnv = true;
      }];
    };
    polkit = {
      enable = true;
    };
  };

  networking = {
    hostName = "Server1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    networkmanager = {
      enable = true;
    };
    dhcpcd.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # System.
        2001 # SSH
        9090 # Cockpit
        25565 # Minecraft 1.7.10 ComBox game
        25575 # Minecraft 1.7.10 ComBox rcon
        25566 # Minecraft 1.16.5 D7TUN6 game
        25576 # Minecraft 1.16.5 D7TUN6 rcon
        25567 # Minecraft 1.20 D7TUN6 game
        25577 # Minecraft 1.20 D7TUN6 rcon
        25568 # Minecraft 1.20 ComBox game
        25578 # Minecraft 1.20 ComBox rcon
      ];
    };
  };
  # User configuration.
  users = {
    users = {
      server = {
        isNormalUser = true;
        initialPassword = "blablabla";
        extraGroups = [
        "wheel"
        "storage"
        "input"
        "plugdev"
        ];
        shell = pkgs.fish;
      };
    };
  };

  hardware = {
    cpu = {
      intel = {
        updateMicrocode = true;
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise = {
      automatic = true;
      dates = [
        "00:30"
        "01:30"
        "02:30"
        "03:30"
        "04:30"
        "05:30"
        "06:30"
        "07:30"
        "08:30"
        "09:30"
        "10:30"
        "11:30"
        "12:30"
        "13:30"
        "14:30"
        "15:30"
        "16:30"
        "17:30"
        "18:30"
        "19:30"
        "20:30"
        "21:30"
        "22:30"
        "23:30"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
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
      PermitRootLogin = "no";
      };
    };
    cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };
  };

  programs = {
    fish = {
      enable = true;
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      # System.
      neovim
      wget
      rsync
      btop
      htop
      fastfetch
      # Production.
      git
      compose2nix
      podman-compose
      dive
      cockpit
      # Development and runtime.
      jdk17_headless
      gcc
    ];
  };

}

