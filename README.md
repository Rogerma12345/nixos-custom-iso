# nixos-custom-iso

这是自定义构建路径的说明文档，主线为 `.#installer-custom-iso`。

适用场景：

- 预置普通用户和 SSH 公钥
- 指定 `hostname / timezone / locale`
- 启用 Docker / Python / Proxy / Wolfram
- 通过 GitHub Actions 受控构建
- 只交付加密 artifact

## 自定义输出

自定义输出是 `.#installer-custom-iso`，对应 `nix/profiles/installer-custom.nix`。

该 profile 会加载：

- `base.nix`
- `docker.nix`
- `python.nix`
- `wolfram.nix`
- `ssh.nix`
- `custom-installer-user.nix`
- `custom-installer-host-proxy.nix`

默认文件名：

- `nixos-custom-iso-installer-custom.iso`

## 配置来源

自定义配置有两种来源：

1. 本地文件 `config/custom-installer.local.nix`
2. GitHub Actions 根据 secrets 运行时生成同名文件

统一读取逻辑在 `nix/lib/installer-settings.nix`：

- 先读 `config/default.nix`
- 再合并本地自定义配置
- 检查 `CHANGE_ME_*`
- 未替换占位值时直接失败

## 本地构建

复制示例：

```bash
cp config/custom-installer.example.nix config/custom-installer.local.nix
```

编辑后构建：

```bash
nix build -L .#installer-custom-iso
```

建议至少填写：

* `username`
* `hostname`
* `timezone`
* `locale`
* `authorizedKeys`

`locale` 建议使用完整值，例如：

* `zh_CN.UTF-8`
* `en_US.UTF-8`

## GitHub Actions 构建

workflow：`.github/workflows/build-custom-encrypted-iso.yml`

特点：

* 仅支持 `workflow_dispatch`
* job 绑定 `custom-iso-build` environment
* 构建完成后只上传加密产物
* artifact 保留时间较短，适合受控交付

## 正式 secrets 名称

基础字段：

* `CUSTOM_USERNAME`
* `CUSTOM_HOSTNAME`
* `CUSTOM_TIMEZONE`
* `CUSTOM_LOCALE`
* `CUSTOM_AUTHORIZED_KEYS`

功能开关：

* `CUSTOM_FEATURE_DOCKER`
* `CUSTOM_FEATURE_PYTHON`
* `CUSTOM_FEATURE_PROXY`
* `CUSTOM_FEATURE_WOLFRAM`

代理相关：

* `CUSTOM_PROXY_ENABLE`
* `CUSTOM_PROXY_HOST`
* `CUSTOM_PROXY_PORT`
* `CUSTOM_PROXY_USERNAME`
* `CUSTOM_PROXY_PASSWORD`

Wolfram：

* `WOLFRAM_REPO_PAT`

## 规则

布尔字段只能写：

* `true`
* `false`

必须满足：

* `CUSTOM_PROXY_ENABLE` 与 `CUSTOM_FEATURE_PROXY` 一致
* 启用代理时必须提供 `CUSTOM_PROXY_HOST` 和 `CUSTOM_PROXY_PORT`
* 代理认证时用户名和密码必须同时提供
* 启用 Wolfram 时必须提供 `WOLFRAM_REPO_PAT`

当前 Actions 路径只支持单条 SSH 公钥：

```nix
authorizedKeys = [ "<CUSTOM_AUTHORIZED_KEYS>" ];
```

## 功能说明

### SSH

* 启用 OpenSSH
* 禁止 root 登录
* 禁止密码认证
* 禁止键盘交互认证

### 用户

* 创建自定义普通用户
* 加入 `wheel`
* 启用 Docker 时再加入 `docker`

### Docker

* 启用 Docker
* 安装 `docker-compose`
* 代理开启时写入 Docker 代理配置

### Python

* 安装 `python3`

### Proxy

* 写入系统代理环境变量
* 启用 Docker 时同步写入 Docker 代理配置

### Wolfram

* 启用 `pkgs.wolfram-engine`
* 需要私有 release 资产和 `WOLFRAM_REPO_PAT`

## 安全说明

启用代理认证后，代理地址、用户名、密码会进入生成配置，并可能进入镜像内容。

因此这条路径只适合：

* 受控 workflow
* 受保护的 environment
* 加密 artifact 分发

不要公开发布未加密的自定义 ISO。

## 常见失败原因

缺少本地文件：

* `config/custom-installer.local.nix`

占位值未替换：

* 仍有 `CHANGE_ME_*`

代理配置不完整：

* 开启代理但缺 host / port
* 只填了用户名或只填了密码

Wolfram 依赖缺失：

* 启用了 Wolfram，但未提供 `WOLFRAM_REPO_PAT`

## 不要提交

* `config/custom-installer.local.nix`
* 私钥、密码、token
* 带认证信息的代理配置
* 未脱敏的个人化构建文件
