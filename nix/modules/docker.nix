{ lib, pkgs, ... }:
let
  installerSettings = import ../lib/installer-settings.nix;
  settings = installerSettings { custom = true; };
  dockerProxyEnabled = settings.features.docker && settings.features.proxy;
  dockerConfigJson = builtins.toJSON {
    proxies.default = {
      httpProxy = settings.proxy.docker.httpProxy;
      httpsProxy = settings.proxy.docker.httpsProxy;
      noProxy = settings.proxy.docker.noProxy;
    };
  };
in
lib.mkIf settings.features.docker {
  virtualisation.docker = {
    enable = true;
  } // lib.optionalAttrs settings.features.proxy {
    daemon.settings.proxies = {
      http-proxy = settings.proxy.docker.httpProxy;
      https-proxy = settings.proxy.docker.httpsProxy;
      no-proxy = settings.proxy.docker.noProxy;
    };
  };

  users.groups.docker = {};

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  environment.etc = lib.optionalAttrs dockerProxyEnabled {
    "docker/config.json".text = dockerConfigJson;
  };

  environment.variables = lib.optionalAttrs dockerProxyEnabled {
    DOCKER_CONFIG = "/etc/docker";
  };
}
