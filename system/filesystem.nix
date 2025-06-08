{ config, pkgs, ... }:

{  
  fileSystems = {
    "/" = { 
      options = [
        "subvol=@root"
      ];
    };
    "/home" = {
      options = [
        "subvol=@home" 
      ];
    };
  };
}
