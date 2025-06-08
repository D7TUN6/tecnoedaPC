{ config, lib, pkgs, inputs, ... }:

{
  environment = {

    variables = {
      EDITOR = "nvim";
    };
  };
}