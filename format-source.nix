{ writeShellScriptBin
, yq
, lib
}: let
  PATH = lib.makeBinPath [ yq ];
in writeShellScriptBin "base16-format-source" ''
  set -eu
  input=$1
  out=$2

  export PATH="${PATH}:$PATH"

  yq -M --sort-keys . $input/list.yaml > $out
''
