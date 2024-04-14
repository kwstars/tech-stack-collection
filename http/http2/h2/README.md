## 如何使用 Wireshark 解密 TLS-SSL 报文?.

你的步骤已经很详细了，我将为你提供一个更详细的步骤：

1. **配置 Chrome 输出 DEBUG 日志**

   在启动 Chrome 之前，设置环境变量 `SSLKEYLOGFILE` 来指定日志文件的路径。例如，在 Linux 或 macOS 上，你可以在终端中运行以下命令：

   ```bash
   export SSLKEYLOGFILE=/path/to/sslkeylog.log
   ```

   在 Windows 上，你可以在命令提示符或 PowerShell 中运行以下命令：

   ```powershell
   set SSLKEYLOGFILE=C:\Users\Kira\sslkeylog\sslkeylog.log
   ```

   然后，启动 Chrome。Chrome 会将 TLS 密钥写入到指定的日志文件中。

2. **在 Wireshark 中配置解析 DEBUG 日志**

   打开 Wireshark，然后选择 "编辑" -> "首选项"。在首选项窗口中，展开 "协议" 列表，然后找到 "TLS"。

   在 "TLS" 配置选项中，找到 "(Pre)-Master-Secret log filename"，然后输入你的日志文件的路径（这应该与你在 `SSLKEYLOGFILE` 环境变量中设置的路径相同）。

   点击 "确定" 保存你的设置。

3. **捕获和解密 TLS 流量**

   现在，你可以开始在 Wireshark 中捕获流量了。只要你的流量通过 Chrome，并且使用了 TLS，Wireshark 就应该能够使用日志文件中的密钥来解密流量。

请注意，这种方法只能解密通过 Chrome 发送或接收的 TLS 流量。其他的浏览器或应用程序可能不支持 `SSLKEYLOGFILE` 功能。
