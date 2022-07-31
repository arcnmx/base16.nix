{ inputs'self }: {
  evalSchemeData = {
    system ? builtins.currentSystem or "x86_64-linux"
  }: import "${inputs'self.packages.${system}.base16-schemes-json}";

  schemeData = inputs'self.lib.evalSchemeData { };
}
