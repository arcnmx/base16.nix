{ writeShellScriptBin
, mustache-go
, lib
}: let
  PATH = lib.makeBinPath [ mustache-go ];
in writeShellScriptBin "base16-mustache" ''
  set -eu
  data=$1
  input=$2
  out=$3

  export PATH="${PATH}:$PATH"

  mustache "$data" "$input" > "$out"
''
