{ runCommand
, base16-format-template'build
, base16-build-template
, yq'build
, lib
, flakelib'lib'Std
}: let
  addPassthru = { passthru }: template: {
    base16 = passthru.base16 // {
      build-template = lib.setFunctionArgs (args: base16-build-template ({
        src = template;
      } // args)) (lib.functionArgs base16-build-template);
      data = passthru.base16.data or { } // {
        import = lib.importJSON "${template}/templates/config.yaml";
      };
    };
    withTemplateData = templateData: template.base16.build-template {
      inherit templateData;
    };
  };
in { src
, name
, config ? { }
}: let
  passthru.base16 = {
    kind = "templates";
    slug = name;
    inherit config;
  };
  template = runCommand "base16-templates-${name}" {
    inherit src passthru;
    nativeBuildInputs = [ base16-format-template'build yq'build ];
    templateDir = config.root or "" + "/templates";
  } ''
    install -d "$out/templates"
    base16-format-template "$src$templateDir" "$out/templates"
  '';
in flakelib'lib'Std.Drv.fixPassthru (
  addPassthru { inherit passthru; }
) template
