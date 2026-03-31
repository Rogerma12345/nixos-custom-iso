{
  hostname = "nixos";
  timezone = "UTC";
  locale = "en_US.UTF-8";

  features = {
    docker = false;
    python = false;
    proxy = false;
    wolfram = false;
  };
}
