{ pkgs ? import <nixpkgs> { } }: with pkgs; let
  update = writeShellScriptBin "update" ''
    export CHECKOUT=${toString ./.}
    exec ${runtimeShell} ${./json/update.sh} "$@"
  '';
in mkShell {
  inherit update;
  nativeBuildInputs = [ update ];
}
