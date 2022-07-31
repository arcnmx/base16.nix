{
  description = "base16 schemes";
  inputs = {
  };
  outputs = { self, ... }@inputs: {
    lib = {
      evalSchemeData = {
        system ? builtins.currentSystem or "x86_64-linux"
      }: import ./schemes;

      schemeData = self.lib.evalSchemeData { };
    };
  };
}
