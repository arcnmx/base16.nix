{ pkgs, lib, ... }: with pkgs; with lib; let
  inherit (import ../shell.nix {
    inherit pkgs;
  }) update;
  branches = [ "generate" ];
in {
  name = "base16-schemes-json-generate";
  ci.gh-actions = {
    enable = true;
    checkoutOptions = {
      fetch-depth = 0;
      ref = "generate";
    };
  };
  ci.version = "nix2.4-broken";
  gh-actions.on = {
    push = {
      inherit branches;
    };
    pull_request = {
      inherit branches;
    };
    schedule = singleton {
      cron = "0 0 * * *";
    };
  };
  tasks.generate.inputs = singleton (ci.command {
    name = "generate";
    command = ''
      ${update}/bin/update
    '';
    impure = true;
    environment = [ "CI_PLATFORM" "GITHUB_REF" "GITHUB_EVENT_NAME" ];
  });
}
