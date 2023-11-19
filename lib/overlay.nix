{ base16-schemes }: lib: super: with lib; let
  inherit (lib) base16;
in {
  base16 = {
    schemeData = base16-schemes.lib.schemeData.schemes;
    schemes = mapAttrs (slug: scheme: base16.evalScheme (
      scheme // {
        inherit slug;
      }
    )) base16.schemeData;
    names = map (c: "base0${toUpper c}") hexChars;
    types = import ./types.nix { inherit lib; };
    shell = import ./shell.nix { inherit lib; };
    evalScheme = schemeData: let
      module = { ... }: {
        config = {
          inherit schemeData;
        };
      };
      eval = evalModules {
        modules = base16.types.schemeModules ++ [
          module
        ];
        specialArgs = {
          name = data.slug or data.scheme or "unknown";
        };
      };
    in eval.config;
  };

  # hexadecimal
  hexChars = [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
  hexCharToInt = char: let
    pairs = imap0 (flip nameValuePair) hexChars;
    idx = listToAttrs pairs;
  in idx.${toLower char};
  hexToInt = str:
    foldl (value: chr: value * 16 + hexCharToInt chr) 0 (stringToCharacters str);
  toHex = toHexLower;
  toHexLower = int: let
    rest = int / 16;
  in optionalString (int >= 16) (toHexLower rest) + elemAt hexChars (mod int 16);
  toHexUpper = int: toUpper (toHexLower int);

  concatImap0Strings = f: list: concatStrings (imap0 f list);
  concatImap1Strings = concatImapStrings;
}
