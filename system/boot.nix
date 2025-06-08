{ config, lib, pkgs, inputs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-lto;

    kernelParams = [
      "rootflags=noatime"
      "elevator=noop"
      "tsx_async_abort=off"
      "mitigrations=off"
    ];

    kernelPatches = [ {
        name = "selinux-config";
        patch = null;
        extraConfig = ''
                SECURITY_SELINUX y
                SECURITY_SELINUX_BOOTPARAM n
                SECURITY_SELINUX_DISABLE n
                SECURITY_SELINUX_DEVELOP y
                SECURITY_SELINUX_AVC_STATS y
                SECURITY_SELINUX_CHECKREQPROT_VALUE 0
                DEFAULT_SECURITY_SELINUX n
              '';
        } ];

    kernelModules = [
      "xt_multiport"
      "tcp_bbr"
    ];

    kernel = {
      sysctl = {
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      };
    };

    loader = {
      grub = {
        efiSupport = false;
        device = "/dev/sdb";
      };
    };
  };
   environment.systemPackages = with pkgs; [ policycoreutils ];
   systemd.package = pkgs.systemd.override { withSelinux = true; };
}
