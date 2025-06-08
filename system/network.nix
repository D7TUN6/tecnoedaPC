{ config, lib, pkgs, inputs, ... }:

{
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

    firewall = {
      enable = true;
      allowedTCPPorts = [ 2001 80 443 25565 25575 44682 55793 ];
      allowedUDPPorts = [ 2001 80 443 25565 25575 44682 55793 ];
      rejectPackets = true;
    };

    nat = {
      enable = true;
      # Use "ve-*" when using nftables instead of iptables
      internalInterfaces = ["ve-+"];
      externalInterface = "enp4s0";
      enableIPv6 = true;
    };
  };

}
