{ config, pkgs, ... }:

{  
  fileSystems = {
    "/" = { 
      options = [
        "subvol=@root"
        "compress-force=zstd:15"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2" 
        "commit=120" 
      ];
    };
    "/home" = {
      options = [
        "subvol=@home"
        "compress-force=zstd:15"
        "noatime"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "commit=120" 
      ];
    };
  };
}
