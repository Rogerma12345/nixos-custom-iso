{ lib, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings {};
in
lib.mkIf settings.features.proxy {
  networking.proxy = {
    default = settings.proxy.default;
    noProxy = settings.proxy.noProxy;
  };

  environment.variables = {
    http_proxy = settings.proxy.env.httpProxy;
    https_proxy = settings.proxy.env.httpsProxy;
    all_proxy = settings.proxy.env.allProxy;
    no_proxy = settings.proxy.env.noProxy;
    HTTP_PROXY = settings.proxy.env.httpProxy;
    HTTPS_PROXY = settings.proxy.env.httpsProxy;
    ALL_PROXY = settings.proxy.env.allProxy;
    NO_PROXY = settings.proxy.env.noProxy;
  };
}
