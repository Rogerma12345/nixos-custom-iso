{
  username = "CHANGE_ME_USERNAME";
  hostname = "CHANGE_ME_HOSTNAME";
  timezone = "CHANGE_ME_TIMEZONE";
  locale = "CHANGE_ME_LOCALE";
  authorizedKeys = [
    "ssh-ed25519 CHANGE_ME_SSH_PUBLIC_KEY"
  ];

  features = {
    docker = false;
    python = false;
    proxy = false;
    wolfram = false;
  };

  proxy = {
    default = "http://CHANGE_ME_PROXY_URL:PORT";
    noProxy = "127.0.0.1,localhost,internal.domain";

    env = {
      httpProxy = "http://CHANGE_ME_PROXY_URL:PORT";
      httpsProxy = "http://CHANGE_ME_PROXY_URL:PORT";
      allProxy = "socks5://CHANGE_ME_PROXY_URL:PORT";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };

    docker = {
      httpProxy = "http://CHANGE_ME_PROXY_URL:PORT";
      httpsProxy = "http://CHANGE_ME_PROXY_URL:PORT";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };
}
