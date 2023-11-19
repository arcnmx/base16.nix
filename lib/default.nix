{ inputs }: let
  inherit (inputs) self nixpkgs;
  inherit (self.lib) nixlib;
  base16-lib = self.lib;
in {
  overlay = import ./overlay.nix { inherit (inputs) base16-schemes; };
  nixlib = nixpkgs.lib.extend self.lib.overlay;
  inherit (nixlib) base16;
}
