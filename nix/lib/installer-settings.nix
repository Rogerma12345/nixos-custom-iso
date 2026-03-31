{ custom ? false }:
let
  defaultSettings = import ../../config/default.nix;
  localPath = ../../config/custom-installer.local.nix;
  placeholderError = "Replace all CHANGE_ME_* placeholders in config/custom-installer.local.nix before building .#installer-custom-iso.";
  missingFileError = ''
Missing local custom installer config: config/custom-installer.local.nix
Copy config/custom-installer.example.nix to config/custom-installer.local.nix and replace all CHANGE_ME_* placeholders before building .#installer-custom-iso.
'';
  customSettings =
    if builtins.pathExists localPath then
      import localPath
    else
      throw missingFileError;
  merged = builtins.foldl' (acc: attrs: acc // attrs) defaultSettings [ customSettings ];
  mergedFeatures = (defaultSettings.features or {}) // (customSettings.features or {});
  mergedProxy = (defaultSettings.proxy or {}) // (customSettings.proxy or {});
  mergedProxyEnv = ((defaultSettings.proxy or {}).env or {}) // ((customSettings.proxy or {}).env or {});
  mergedProxyDocker = ((defaultSettings.proxy or {}).docker or {}) // ((customSettings.proxy or {}).docker or {});
  finalSettings = merged // {
    features = mergedFeatures;
    proxy = mergedProxy // {
      env = mergedProxyEnv;
      docker = mergedProxyDocker;
    };
  };
  isPlaceholder = value:
    builtins.isString value && builtins.match ".*CHANGE_ME_.*" value != null;
  assertCustom =
    if !custom then
      defaultSettings
    else if isPlaceholder finalSettings.username then
      throw placeholderError
    else if isPlaceholder finalSettings.hostname then
      throw placeholderError
    else if isPlaceholder finalSettings.timezone then
      throw placeholderError
    else if isPlaceholder finalSettings.locale then
      throw placeholderError
    else if builtins.any isPlaceholder (finalSettings.authorizedKeys or []) then
      throw placeholderError
    else if (finalSettings.features.proxy or false) && builtins.any isPlaceholder [
      (finalSettings.proxy.default or "")
      (finalSettings.proxy.env.httpProxy or "")
      (finalSettings.proxy.env.httpsProxy or "")
      (finalSettings.proxy.env.allProxy or "")
      (finalSettings.proxy.docker.httpProxy or "")
      (finalSettings.proxy.docker.httpsProxy or "")
    ] then
      throw placeholderError
    else
      finalSettings;
in
assertCustom
