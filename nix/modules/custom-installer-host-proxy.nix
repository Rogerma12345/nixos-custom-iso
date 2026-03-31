{ lib, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings { custom = true; };
in
{
  networking.hostName = lib.mkForce settings.hostname;
  time.timeZone = lib.mkForce settings.timezone;
  i18n.defaultLocale = lib.mkForce settings.locale;

  networking.proxy = lib.mkIf settings.features.proxy {
    default = settings.proxy.default;
    noProxy = settings.proxy.noProxy;
  };

  environment.variables =
    (lib.mkIf settings.features.proxy {
      http_proxy = settings.proxy.env.httpProxy;
      https_proxy = settings.proxy.env.httpsProxy;
      all_proxy = settings.proxy.env.allProxy;
      no_proxy = settings.proxy.env.noProxy;
      HTTP_PROXY = settings.proxy.env.httpProxy;
      HTTPS_PROXY = settings.proxy.env.httpsProxy;
      ALL_PROXY = settings.proxy.env.allProxy;
      NO_PROXY = settings.proxy.env.noProxy;
    })
    // (lib.mkIf (settings.features.docker && settings.features.proxy) {
      DOCKER_CONFIG = "/etc/docker";
    });

  environment.etc = lib.mkIf (settings.features.docker && settings.features.proxy) {
    "docker/config.json".text = builtins.toJSON {
      proxies.default = {
        httpProxy = settings.proxy.docker.httpProxy;
        httpsProxy = settings.proxy.docker.httpsProxy;
        noProxy = settings.proxy.docker.noProxy;
      };
    };
  };

  virtualisation.docker = lib.mkIf (settings.features.docker && settings.features.proxy) {
    daemon.settings.proxies = {
      http-proxy = settings.proxy.docker.httpProxy;
      https-proxy = settings.proxy.docker.httpsProxy;
      no-proxy = settings.proxy.docker.noProxy;
    };
  };
}
