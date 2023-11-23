{ stdenvNoCC
, base16-mustache'build
, yq'build
, lib
, flakelib'lib'Std
}: with lib; let
  slugFromSrc = src: removePrefix "base16-templates-" src.pname or src.name;
  isTemplateDataPath = templateData: isDerivation templateData || isPath templateData;
  readTemplateData = templateData:
    if isTemplateDataPath templateData then importJSON templateData
    else if isString templateData then builtins.fromJSON templateData
    else templateData;
  addPassthru = { passthru }: drv: {
    base16 = passthru.base16 // {
      template = mapAttrs (_: template: template // rec {
        path = "${drv}/${template.filename}";
        content = builtins.readFile path;
      }) passthru.base16.template;
    };
  };
in { pname ? "base16-template-${slug}" + optionalString (schemeSlug != null) "-${schemeSlug}"
, slug ? slugFromSrc src
, schemeSlug ? if isTemplateDataPath templateData then null else templateDataAttrs.scheme-slug or null
, templateDataAttrs ? readTemplateData templateData
, templateData
, src
, ... }@args: let
  templateDataIsPath = isTemplateDataPath templateData;
  templateConfig = src.base16.data.config or src.base16.data.import or (importJSON "${src}/templates/config.yaml");
  passthru.base16 = {
    kind = "templated";
    inherit slug;
    inherit templateDataAttrs;
    template = mapAttrs (_: config: rec {
      inherit config;
      extension = config.extension or templateConfig.default.extension or "";
      output = config.output or templateConfig.default.output or "";
      filename = optionalString (output != "") "${output}/" + "base16-${templateDataAttrs.scheme-slug}" + extension;
    }) templateConfig;
  };
  templated = stdenvNoCC.mkDerivation ({
    ${if args ? version then null else "name"} = pname;

    ${if templateDataIsPath then null else "templateData"} =
      if isString templateData then templateData
      else builtins.toJSON templateData;
    ${if templateDataIsPath then "templateDataPath" else null} = templateData;
    passAsFile = args.passAsFile or [ ] ++ optional (!templateDataIsPath) "templateData";
    nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [ base16-mustache'build yq'build ];
    preferLocalBuild = true;

    passthru = args.passthru or { } // {
      inherit (passthru) base16;
    };

    outputs = [ "out" ];

    buildPhase = ''
      runHook preBuild

      SCHEME_SLUG="$(yq -er '."scheme-slug"' "$templateDataPath")"

      BASE16_TEMPLATES=($(yq -er 'keys | .[]' templates/config.yaml))
      BASE16_OUTPUTS=()
      for template in "''${BASE16_TEMPLATES[@]}"; do
        template_extension="$(yq -er ".\"$template\".extension // .default.extension // \"\"" templates/config.yaml)"
        template_output="$(yq -er ".\"$template\".output // .default.output // \"\"" templates/config.yaml)"
        template_filename="$template_output''${template_output+/}base16-$SCHEME_SLUG$template_extension"
        BASE16_OUTPUTS+=("$template_filename")
        mkdir -p "$(dirname "$template_filename")"
        base16-mustache "$templateDataPath" "templates/$template.mustache" "$template_filename"
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      for template_filename in ''${BASE16_OUTPUTS[@]}; do
        outdir="$out/$(dirname "$template_filename")"
        install -Dt "$outdir" "$template_filename"
      done

      runHook postInstall
    '';
  } // removeAttrs args [ "templateData" "templateDataAttrs" "passAsFile" "nativeBuildInputs" "passthru" ]);
in flakelib'lib'Std.Drv.fixPassthru (addPassthru { inherit passthru; }) templated
