# Semtech USP Examples for nRF Connect SDK v3.3.0

本文档说明如何把 Semtech USP / LR2021 的 Zephyr 示例放到 nRF Connect SDK v3.3.0 中，并通过 Nordic VS Code 插件或命令行编译。

## 目标目录

本次整理后的目录结构如下：

```text
C:/ncs/v3.3.0/
|-- modules/
|   |-- usp_zephyr/
|   `-- lib/
|       `-- usp/
`-- semtech_samples/
    |-- cmake/
    |-- lrfhss/
    |-- packet_error_rate_flrc/
    |-- packet_error_rate_fsk/
    |-- packet_error_rate_lora/
    |-- ping_pong/
    |-- ranging_demo/
    |-- rf_certification/
    |-- spectral_scan/
    `-- tx_cw/
```

`semtech_samples` 是 NCS v3.3.0 根目录下新增的示例目录。所有适配 NCS 的修改都限制在这个目录内。

## 拉取仓库

需要两个 GitHub 仓库，分支都是 `branch/v1.1.2-feature-202604`：

```powershell
cd C:/ncs/v3.3.0/modules

git clone -b branch/v1.1.2-feature-202604 https://github.com/Lora-net/usp_zephyr.git usp_zephyr

New-Item -ItemType Directory -Force C:/ncs/v3.3.0/modules/lib
cd C:/ncs/v3.3.0/modules/lib
git clone -b branch/v1.1.2-feature-202604 https://github.com/Lora-net/usp.git usp
```

最终模块目录必须是：

```text
C:/ncs/v3.3.0/modules/usp_zephyr
C:/ncs/v3.3.0/modules/lib/usp
```

这两个目录可以直接使用 GitHub 拉取下来的原始文件，不需要修改。

## 示例来源

`semtech_samples` 中的示例来自：

```text
C:/ncs/v3.3.0/modules/usp_zephyr/samples/
```

本目录对这些示例做了 NCS 适配：

- 自动加入 `modules/usp_zephyr` 和 `modules/lib/usp`
- 默认使用 `semtech_wio_lr2021` shield
- 每个示例带本地 `Kconfig` 兼容项，避免修改 `usp_zephyr` 模块
- 默认关闭实验性配置警告
- 对需要角色宏的示例补了默认角色

默认角色：

```text
packet_error_rate_flrc: ROLE=RECEIVER
packet_error_rate_fsk : ROLE=RECEIVER
packet_error_rate_lora: ROLE=RECEIVER
ranging_demo          : RANGING_DEVICE_MODE_SUBORDINATE
```

如果要改成发射端、initiator 或其它角色，只改对应示例目录下的 `CMakeLists.txt`。

## VS Code 插件编译

使用 Nordic nRF Connect for VS Code 插件时：

1. 选择 `Add Existing Application`
2. Application 目录选择某个示例，例如：

```text
C:/ncs/v3.3.0/semtech_samples/ping_pong
```

3. SDK 选择：

```text
nRF Connect SDK v3.3.0
```

4. Toolchain 选择：

```text
nRF Connect SDK Toolchain v3.3.0
```

5. Board target 选择：

```text
xiao_nrf54l15/nrf54l15/cpuapp
```

6. 关闭 Sysbuild
7. 以下配置保持为空：

```text
Base configuration files
Extra Kconfig fragments
Base Devicetree overlays
Extra Devicetree overlays
Extra CMake arguments
```

因为示例自己的 `CMakeLists.txt` 已经自动设置了 USP 模块路径和默认 shield，所以插件里不需要再手动添加 CMake 参数。

## 命令行编译

以 `ping_pong` 为例：

```powershell
nrfutil sdk-manager toolchain launch --ncs-version v3.3.0 -- west build -p always `
  -b xiao_nrf54l15/nrf54l15/cpuapp `
  --no-sysbuild `
  -d C:/ncs/v3.3.0/build/semtech_ping_pong `
  C:/ncs/v3.3.0/semtech_samples/ping_pong
```

以 `lrfhss` 为例：

```powershell
nrfutil sdk-manager toolchain launch --ncs-version v3.3.0 -- west build -p always `
  -b xiao_nrf54l15/nrf54l15/cpuapp `
  --no-sysbuild `
  -d C:/ncs/v3.3.0/build/semtech_lrfhss `
  C:/ncs/v3.3.0/semtech_samples/lrfhss
```

批量编译全部示例：

```powershell
$samples = @(
  'lrfhss',
  'packet_error_rate_flrc',
  'packet_error_rate_fsk',
  'packet_error_rate_lora',
  'ping_pong',
  'ranging_demo',
  'rf_certification',
  'spectral_scan',
  'tx_cw'
)

foreach ($s in $samples) {
  nrfutil sdk-manager toolchain launch --ncs-version v3.3.0 -- west build -p always `
    -b xiao_nrf54l15/nrf54l15/cpuapp `
    --no-sysbuild `
    -d "C:/ncs/v3.3.0/build/semtech_$s" `
    "C:/ncs/v3.3.0/semtech_samples/$s"

  if ($LASTEXITCODE -ne 0) {
    throw "Build failed: $s"
  }
}
```

## 编译结果

已在本机使用以下目标验证通过：

```text
SDK      : nRF Connect SDK v3.3.0
Toolchain: nRF Connect SDK Toolchain v3.3.0
Board    : xiao_nrf54l15/nrf54l15/cpuapp
Shield   : semtech_wio_lr2021
Sysbuild : disabled
```

9 个示例均已生成：

```text
zephyr.elf
zephyr.hex
zephyr.bin
```

输出目录示例：

```text
C:/ncs/v3.3.0/build/semtech_ping_pong/zephyr/
```

编译过程中可能看到 `PM` 或 `SSD1306` 相关的 Kconfig warning。当前目标板配置下这些 warning 不影响固件生成。

## nRF54L15 DK 说明

如果不是 Seeed XIAO nRF54L15，而是 Nordic nRF54L15 DK，需要选择 DK 的 board target，并按硬件连接情况添加对应 shield。常见组合是：

```text
semtech_nrf54l15dk_mbed_interface
semtech_mbed_wio_interface
semtech_wio_lr2021
```

XIAO nRF54L15 当前适配中已经默认使用 `semtech_wio_lr2021`，不需要在插件里额外选择 shield。
