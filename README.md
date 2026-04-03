# nixos-custom-iso

这是一个面向 ESXi、headless 虚拟机和远程安装场景的 NixOS installer ISO 仓库。

本仓库当前提供两个 flake 输出：

- 默认输出：`.#installer-iso`
- 自定义输出：`.#installer-custom-iso`

`main` 分支的 README 以默认输出为主，用于公开说明仓库用途、默认构建路径和安全边界。自定义加密构建的详细说明建议放到自定义分支 README 中维护。

## 仓库目标

本仓库的目标是提供一个可重复构建、适合远程安装场景、默认行为保守的 NixOS installer ISO。

默认设计原则：

- 默认输出保持中性
- 默认输出可以直接在 GitHub Actions 中构建
- 默认输出不依赖未跟踪的本地配置文件
- 默认输出不创建普通用户
- 默认输出不开放基于个人 SSH 公钥的远程登录入口
- 默认输出不读取个人 `hostname`、`timezone`、`locale`、`authorizedKeys`、`proxy` 等配置

## 输出概览

### 1. 默认输出：`.#installer-iso`

这是公开仓库的默认交付物，适合作为：

- 公共分支自动构建产物
- 基础安装介质
- 无个人凭据、无代理凭据、无私有依赖的安全默认镜像

默认输出对应的 profile 是：

- `nix/profiles/installer-base.nix`

该 profile 基于 NixOS minimal installation CD，并启用：

- EFI 启动
- USB 启动
- zstd squashfs 压缩

默认文件名为：

- `nixos-custom-iso-installer.iso`

### 2. 自定义输出：`.#installer-custom-iso`

这是显式自定义构建路径，适合：

- 需要预置普通用户
- 需要预置 SSH 公钥登录
- 需要指定 `hostname` / `timezone` / `locale`
- 需要启用 Docker / Python / Proxy / Wolfram
- 需要通过 GitHub Actions 受控构建并交付加密产物

自定义输出对应的 profile 是：

- `nix/profiles/installer-custom.nix`

`main` 分支保留该输出与对应 workflow，但详细使用说明建议在自定义分支单独维护。

## 默认输出的当前行为

默认配置入口：

- `config/default.nix`

当前默认配置为：

```nix
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
