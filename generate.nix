{ writeShellScriptBin
, schemes-source
, templates-source
, inputs'base16-schemes-source
, inputs'base16-templates-source
, lib'makeBinPath
, self'lib
}: let
  inherit (self'lib) flakePath genPath;
  nix = "nix --extra-experimental-features nix-command,flakes";
  cp = "cp --no-preserve=all --dereference";
in writeShellScriptBin "base16-generate" ''
  set -eu

  SCHEMES_SOURCE=${schemes-source}
  TEMPLATES_SOURCE=${templates-source}
  SCHEMES_FLAKE_NIX=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath}#schemes-flake" \
    ''${FLAKE_OPTS-}
  )
  TEMPLATES_FLAKE_NIX=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath}#templates-flake" \
    ''${FLAKE_OPTS-}
  )

  mkdir -p "${genPath}/data/sources/"{schemes,templates} "${genPath}/"{schemes,templates}
  ${cp} "$SCHEMES_SOURCE/list.yaml" "${genPath}/data/sources/schemes/list.yaml"
  ${cp} "$TEMPLATES_SOURCE/list.yaml" "${genPath}/data/sources/templates/list.yaml"
  ${cp} "$SCHEMES_FLAKE_NIX" "${genPath}/schemes/flake.nix"
  ${cp} "$TEMPLATES_FLAKE_NIX" "${genPath}/templates/flake.nix"
  # TODO: pull this in from base16.json as an input flake maybe..?
  ${cp} "${./outputs.nix}" "${genPath}/outputs.nix"

  ${nix} flake lock "${flakePath.schemes}"
  SCHEMES_JSON=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath.schemes}#base16-schemes-all" \
    ''${FLAKE_OPTS-}
  )
  ${nix} flake lock "${flakePath.templates}"
  TEMPLATES_JSON=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath.templates}#base16-templates-all" \
    ''${FLAKE_OPTS-}
  )

  SCHEMES_NIX=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath.schemes}#nix-outputs" \
    ''${FLAKE_OPTS-}
  )
  TEMPLATES_NIX=$(${nix} \
    build --no-link --print-out-paths \
    "${flakePath.templates}#nix-outputs" \
    ''${FLAKE_OPTS-}
  )

  mkdir -p "${genPath}/data/"{schemes,templates}
  ${cp} -R "$SCHEMES_JSON"/* "${genPath}/data/schemes/"
  ${cp} -R "$TEMPLATES_JSON"/* "${genPath}/data/templates/"
  ${cp} "$TEMPLATES_NIX" "${genPath}/templates.nix"
  ${cp} "$SCHEMES_NIX" "${genPath}/schemes.nix"
  ${cp} "${./data.nix}" "${genPath}/flake.nix"
  ${nix} flake lock "${genPath}"
''
