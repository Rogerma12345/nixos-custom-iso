# nixos-custom-iso

一个面向 ESXi / headless VM 场景的 NixOS installer ISO 仓库。

当前提供两个 flake 输出：

- `.#installer-iso`
- `.#installer-custom-iso`

`main` 分支 README 以默认输出为主。目标是提供一个可公开构建、行为保守、便于审计的安装镜像。

## 默认输出

默认输出是 `.#installer-iso`，对应 `nix/profiles/installer-base.nix`。

特点：

- 基于 NixOS minimal installation CD
- 默认启用 EFI / USB 启动
- 默认使用 zstd squashfs 压缩
- 默认文件名为 `nixos-custom-iso-installer.iso`

默认配置来自 `config/default.nix`：

- `hostname = "nixos"`
- `timezone = "UTC"`
- `locale = "en_US.UTF-8"`
- `docker / python / proxy / wolfram` 全部关闭

这意味着默认镜像：

- 不创建普通用户
- 不预置个人 SSH 公钥
- 不包含代理配置
- 不包含私有依赖
- 适合作为公开仓库的默认交付物

## 基础行为

基础模块位于 `nix/modules/base.nix`，默认会：

- 启用 DHCP
- 锁定 root 密码
- 设置 `users.mutableUsers = false`
- 启用 `nix-command` 和 `flakes`
- 预装常用运维工具

仓库不会默认执行无人值守安装或自动清盘。

## GitHub Actions

默认 workflow：`.github/workflows/build-iso.yml`

触发方式：

- `workflow_dispatch`
- push 到 `main`

行为：

1. 构建 `.#installer-iso`
2. 上传 ISO artifact
3. 发布 prerelease

## 本地使用

查看输出：

```bash
nix flake show
```

校验：

```bash
nix flake check --print-build-logs
```

构建默认 ISO：

```bash
nix build -L .#installer-iso
```

如果安装了 `just`，也可以使用：

```bash
just flake-show
just flake-check
just build-installer-iso
```

## 自定义输出

仓库同时提供 `.#installer-custom-iso`，用于：

* 创建普通用户
* 预置 SSH 公钥登录
* 设置 `hostname / timezone / locale`
* 按需启用 Docker / Python / Proxy / Wolfram
* 通过 GitHub Actions 生成加密 artifact

这条路径建议在自定义分支 README 中单独维护，不与默认公开说明混写。

## 安全边界

`main` 分支的默认路径不包含：

* 个人账户信息
* SSH 公钥
* 代理地址与凭据
* 私有仓库 token
* Wolfram 私有安装资产

不要提交：

* `config/custom-installer.local.nix`
* 私钥、密码、token
* 带真实凭据的代理配置
