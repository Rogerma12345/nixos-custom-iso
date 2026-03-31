# nixos-custom-iso

这是一个面向 ESXi headless 虚拟机场景的 NixOS installer ISO 仓库。

仓库提供两条明确路径：

- 默认输出：[`.#installer-iso`](flake.nix:31)
- 自定义输出：[`.#installer-custom-iso`](flake.nix:32)

## 默认输出

默认输出 [`.#installer-iso`](flake.nix:31) 的目标是：

- 保持中性
- 可直接在 GitHub Actions 中构建
- 不依赖本地未跟踪文件
- 不提供远程 SSH 登录
- 不创建普通用户
- 不读取个人 `hostname` / `timezone` / `locale` / `authorizedKeys` / `proxy`

默认配置入口是 [`config/default.nix`](config/default.nix)。

当前默认配置只保留中性系统字段：

- `hostname = "nixos"`
- `timezone = "UTC"`
- `locale = "en_US.UTF-8"`
- `features = { docker = false; python = false; proxy = false; wolfram = false; }`

## 自定义输出

自定义输出 [`.#installer-custom-iso`](flake.nix:32) 仅用于本地准备好自定义配置后再显式构建。

它依赖本地文件 [`config/custom-installer.local.nix`](config/custom-installer.local.nix)，该文件已被 [`.gitignore`](.gitignore) 忽略，不进入默认构建路径。

示例文件是 [`config/custom-installer.example.nix`](config/custom-installer.example.nix)。

使用步骤：

1. 复制 [`config/custom-installer.example.nix`](config/custom-installer.example.nix)
2. 保存为 [`config/custom-installer.local.nix`](config/custom-installer.local.nix)
3. 编辑以下内容：
   - `username`
   - `hostname`
   - `timezone`
   - `locale`
   - `authorizedKeys`
   - `features`
   - `proxy`
4. 构建 [`.#installer-custom-iso`](flake.nix:32)

如果缺少本地文件，或仍保留 `CHANGE_ME_*` 占位值，自定义输出会直接失败并给出明确提示。

## 模块边界

- [`nix/lib/installer-settings.nix`](nix/lib/installer-settings.nix) 统一读取默认配置或递归合并后的自定义配置
- [`nix/modules/base.nix`](nix/modules/base.nix) 读取最终 `hostname` / `timezone` / `locale`
- [`nix/modules/docker.nix`](nix/modules/docker.nix)、[`nix/modules/python.nix`](nix/modules/python.nix)、[`nix/modules/proxy.nix`](nix/modules/proxy.nix)、[`nix/modules/wolfram.nix`](nix/modules/wolfram.nix) 按最终 `features` 决定是否启用
- [`nix/modules/ssh.nix`](nix/modules/ssh.nix) 只负责 OpenSSH 服务与 SSH 安全策略，并且只在自定义输出中导入
- [`nix/lib/mk-user.nix`](nix/lib/mk-user.nix) 保持 helper 形态，不进入 `imports`
- [`nix/modules/custom-installer-user.nix`](nix/modules/custom-installer-user.nix) 只在自定义输出中创建 SSH 公钥登录用户，并为该用户提供无密码 sudo 所需的 `wheel` 组
- [`nix/modules/custom-installer-host-proxy.nix`](nix/modules/custom-installer-host-proxy.nix) 只在自定义输出中覆盖 `hostname` / `timezone` / `locale` / `proxy`

## GitHub Actions

默认 GitHub Actions 主路径只验证 [`.#installer-iso`](flake.nix:31)，不构建 [`.#installer-custom-iso`](flake.nix:32)。

## 安全说明

- 不要提交私钥、密码、token 或代理凭据
- 不要把真实个人配置写入仓库
- 占位值只应出现在 [`config/custom-installer.example.nix`](config/custom-installer.example.nix)
