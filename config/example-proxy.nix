{
  username = "CHANGE_ME_USERNAME";
  hostname = "CHANGE_ME_HOSTNAME";
  timezone = "UTC";
  locale = "en_US.UTF-8";
  authorizedKeys = [
    "ssh-ed25519 CHANGE_ME_SSH_PUBLIC_KEY"
  ];

  features = {
    docker = true;
    python = true;
    proxy = true;
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
