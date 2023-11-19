{ writeShellScriptBin
, yq
, lib
}: let
  PATH = lib.makeBinPath [ yq ];
in writeShellScriptBin "base16-format-template" ''
  set -eu
  input=$1
  out=$2

  export PATH="${PATH}:$PATH"

  mkdir -p "$out"
  SOURCE_CONFIG="$(yq --sort-keys -M . "$input/config.yaml")"
  for templatefile in $(cd "$input" && shopt -s nullglob && echo *.mustache); do
    templatefile="''${templatefile%.*}"
    echo "$templatefile"
    if ! yq -e "has(\"$templatefile\")" "$input/config.yaml" > /dev/null; then
      echo "$templatefile.mustache does not have an associated config entry" >&2
      SOURCE_CONFIG="$(echo "$SOURCE_CONFIG" | yq --sort-keys -M ". + { \"$templatefile\": {} }")"
    fi

    cp "$input/$templatefile.mustache" "$out/"
  done
  printf '%s\n' "$SOURCE_CONFIG" > "$out/config.yaml"
''
