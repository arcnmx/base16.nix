{ writeShellScriptBin
, yq
, lib
}: let
  PATH = lib.makeBinPath [ yq ];
in writeShellScriptBin "base16-format-scheme" ''
  set -eu
  input=$1
  out=$2

  export PATH="${PATH}:$PATH"

  mkdir -p "$out"
  for schemefile in $(cd $input && shopt -s nullglob && echo *.yaml *.yml); do
    base=''${schemefile%.*}
    echo "$base"
    yq --sort-keys -M . "$input/$schemefile" > "$out/$base.yaml"
  done
''
