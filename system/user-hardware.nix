{ config, lib, pkgs, inputs, ... }:

{
    hardware = {

    cpu = {
      intel = {
        updateMicrocode = true;
      };
    };
  };
}