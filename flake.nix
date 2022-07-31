{
  description = "base16 schemes";
  inputs = {
    flakelib = {
      url = "github:flakelib/fl";
      inputs.std.follows = "std";
    };
    std.url = "github:flakelib/std";
    nixpkgs = { };
    base16-schemes = {
      url = "github:base16-project/base16-schemes";
      flake = false;
    };
  };
  outputs = { flakelib, ... }@inputs: flakelib {
    inherit inputs;

    packages = {
      base16-schemes = { callPackage }: callPackage ./schemes.nix {
        src = inputs.base16-schemes.outPath;
        version = inputs.base16-schemes.lastModifiedDate;
      };
      base16-schemes-json = { callPackage, base16-schemes }: callPackage ./json {
        inherit base16-schemes;
      };
    };
    lib = ./lib.nix;
  };
}
