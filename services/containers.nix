{ config, lib, pkgs, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    oci-containers = {
      backend = "podman";
    };
  };

  networking = {
    firewall = {
      interfaces = {
        "podman+" = {
            allowedUDPPorts = [ 53 ];
        };
      };
    };
  };


  imports = [
    ./projects/comboxMC/comboxMC.nix 
    ./projects/Ilja/mc-1_2_6-alpha.nix
    ];
}
