builtins.mapAttrs (_: p: builtins.fromJSON (builtins.readFile p)) (import ./list.nix)
