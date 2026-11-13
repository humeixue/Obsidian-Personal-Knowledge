# Obsidian AI 多项目文字进度记录与可视化系统

适用环境：Windows 10/11、Obsidian 桌面版、本地 Markdown Vault。

## 系统用途

本版本只处理文字输入，不包含截图监听、图片识别、OCR、Qwen 视觉 API 或截图自动整理。

日常流程：
1. 双击 `10-Automation/启动项目进度记录.bat`，或在 Obsidian 中为 PowerShell 脚本绑定快捷键。
2. 在弹窗中选择项目和进度类型。
3. 直接输入本次进展。
4. 配置 DeepSeek API 后，AI 将文字整理为统一结构；未配置 API 或调用失败时，原始文字仍会保存。
5. 每次进度生成一篇独立 Markdown 文件，自动进入对应项目的 `进度记录` 文件夹。
6. Dataview 自动更新全局项目进度中心和项目专属进度总览。

## 目录安装

将压缩包中的 `Personal-Knowledge` 文件夹合并到 Obsidian Vault 根目录。建议先备份 Vault；遇到同名文件时先比较再覆盖。

项目统一放在：`Personal-Knowledge/01-Learning-Topics/项目/`。每个子文件夹代表一个项目，例如 `AI视觉`、`AI视频生成`、`ComfyUI工作流`。新建项目文件夹后，记录窗口会自动识别；首次记录时会自动创建该项目的进度记录目录和项目进度总览。


## 必需插件

- **Dataview**：全局和项目进度总览、时间线及统计。

## AI 配置（可选）

1. 运行 `10-Automation/保存项目进度API密钥.ps1`，输入 DeepSeek API Key。
2. 将 `项目进度AI配置.example.json` 复制为 `项目进度AI配置.json`。
3. 检查模型 ID 与 API 服务地址是否符合你的 DeepSeek 账户当前可用配置。
4. 再次运行进度记录入口。

API Key 使用当前 Windows 用户 DPAPI 加密，保存在 `%LOCALAPPDATA%\ObsidianAI\progress-key.dpapi`，不写入 Vault 。每台 Windows 电脑/用户需要分别配置密钥。

默认配置：`deepseek-chat`。API 模型名称和可用性可能调整，以 DeepSeek 控制台为准。

## 多项目规则

- 每个项目有独立档案、独立进度记录目录和独立进度总览。
- 所有项目共用同一个文字输入窗口和同一套 AI 整理规则。
- 全局仪表盘自动汇总全部项目，不需要逐个维护。
- 每次记录保留原始输入；AI 失败不影响原文保存。
- 系统只记录项目进度，不包含任务分配、待办管理或复杂知识推理。

## 使用快捷键

最简单方式：双击 `10-Automation/启动项目进度记录.bat`。

如需从 Obsidian 内调用：安装社区插件 **Shell commands**，新增命令：
`powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "完整路径\Personal-Knowledge\10-Automation\项目进度记录.ps1"`
然后在 Obsidian 设置 → 快捷键中为该命令绑定快捷键。

## GitHub 版本管理说明

本项目使用 GitHub 管理系统文件和版本历史。

- GitHub 仓库保存公开的系统脚本、模板和说明文档。
- 使用 GitHub Desktop 提交和上传修改。
- 不要将个人项目进度记录、API Key 和私人资料上传到公开仓库。
- 每台 Windows 电脑需要单独配置本机 API Key。
- 使用前先获取最新版本，修改后提交并推送更新。

注意：GitHub 不是实时文件同步工具。

## 故障排查

- 仪表盘空白：检查 Dataview 是否启用，以及查询路径是否与 Vault 内目录一致。
- AI 整理失败：原始进度仍会保存；检查 API Key、BaseUrl、Model 和网络。
- 脚本无法弹窗：确认以 Windows 桌面会话运行，并使用 `.bat` 启动（脚本包含 `-STA`）。
