{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      # System.
      ./hardware-configuration.nix
      # Production.
      ./containers.nix
    ];

  # Boot configuration.
  boot = {
    kernelPackages = pkgs.linuxPackages-rt_latest;
    kernelModules = [ "xt_multiport" ];
      loader = {
        grub = {
           efiSupport = false; # We use Legacy BIOS BTW.
           device = "/dev/sda";
        };
        efi = {
          canTouchEfiVariables = true;
        };   
      };
  };

  # System packages.
  environment.systemPackages = with pkgs; [
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

  # Network configuration.
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
      allowedTCPPorts = [ fuck_you! ]; # Super secret information.
    };
  };

  # Time configuration.
  time.timeZone = "Asia/Yekaterinburg";

  # User configuration.
  users = {
    users = {
      server = {
        isNormalUser = true;
	initialPassword = "fuck_you!"; # Super secret information.
        extraGroups = [ "wheel" "storage" "input" "plugdev" ];
        shell = pkgs.fish;
      };
    };
  }; 

  # Nix configuration.
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    optimise = {
      automatic = true;
      dates = [ "00:59" ];
    };
  };

  # Nixpkgs configuration.
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Programs configuration.
  programs = {
    fish = {
      enable = true;
    };
  };

  # Services configuration.
  services = {
    openssh = {
      enable = true;
      ports = [ fuck_you! ]; # Super secret information.
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
      port = fuck_you!; # Super secret information.
      settings = {
        WebService = {
          AllowUnencrypted = true;
        };
      };
    };
  };

  # Autoupgrade.
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos#Server1";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L"
    ];
    dates = "23:59";
  };

  # Zram configuration.
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
  };

  # Systemd configuration.
  systemd = {
    timers = {
      "gen-cleaner" = {
        wantedBy = [ "timers.target" ];
	  timerConfig = {
            OnCalendar = "Mon..Sun *-*-* 01:59:*";
	    Persistent = true;
	  };
      };
    };
    services = {
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
    };
  };

  # System version.
  system.stateVersion = "24.11";

}
