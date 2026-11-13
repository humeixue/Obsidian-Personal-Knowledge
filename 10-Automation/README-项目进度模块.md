# 多项目进度记录与可视化模块

本模块在现有 V3 Vault 上增加轻量级多项目进度记录，不引入任务管理、复杂知识图谱或自动决策。

## 功能
- 每次进度独立保存为 Markdown 文件。
- 一个全局进度中心汇总所有项目。
- 每个项目自动生成自己的进度总览。
- Dataview 自动显示最近记录、时间线和记录统计。
- 可通过 Windows 弹窗选择项目、选择类型并输入进度。
- 配置 DeepSeek API Key 后自动整理；未配置或 API 失败时仍保存原始内容，不丢失记录。

## 安装
1. 备份当前 Vault。
2. 将压缩包中的 `Personal-Knowledge` 内容合并到现有 Vault 对应的 `Personal-Knowledge` 文件夹；遇到同名文件先保留原文件，确认后再替换。
3. 在 Obsidian → 设置 → 社区插件中安装并启用 **Dataview**。
4. 确认项目目录为 Vault 根目录下的 `01-Learning-Topics/项目/`。
5. 在该目录下，每个项目建立一个文件夹，例如 `AI视觉`、`AI视频生成`。不要把项目放在 `项目模板` 文件夹内。
6. 运行 `10-Automation/启动项目进度记录.bat` 测试输入和保存。
7. 在 Obsidian 打开 `07-MOCs/AI项目进度中心.md`。如 Dataview 尚未刷新，切换一次笔记或重新打开。

## AI 配置（可选）
1. 运行 `10-Automation/保存项目进度API密钥.ps1`，输入 DeepSeek API Key。
2. 将 `项目进度AI配置.example.json` 复制为 `项目进度AI配置.json`。
3. 核对 BaseUrl、Model 是否与你的 API 服务账户当前可用配置一致。
4. 再次运行进度记录脚本。API Key 通过当前 Windows 用户 DPAPI 加密，保存在 `%LOCALAPPDATA%\ObsidianAI\progress-key.dpapi`，不会进入 Vault。

> 注意：密钥输入由 PowerShell Read-Host -AsSecureString 接收；在 Windows 控制台中不会显示明文。

## 快捷使用
- 最简单：双击 `启动项目进度记录.bat`。
- 若要从 Obsidian 内调用：安装社区插件 **Shell commands**，新增命令，执行 `powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "完整路径\Personal-Knowledge\10-Automation\项目进度记录.ps1"`，再为该命令绑定快捷键。路径中的 Vault 位置按你的电脑实际路径填写。

## 数据规则
- 记录文件保存在 `01-Learning-Topics/项目/项目名/进度记录/`。
- 文件名包含精确时间戳，避免同一天多次记录互相覆盖。
- 每条记录都保留原始输入。
- 全局和项目仪表盘通过 Dataview 查询，不复制记录内容，也不需要手工追加索引。
- 新增项目：在 `项目` 下新建文件夹即可；第一次记录时脚本会自动创建 `进度记录` 和 `项目进度总览.md`。
- 建议项目名称避免使用 `[]#^|\\/:` 等特殊字符，以保证 Obsidian 链接正常。

## GitHub 版本管理说明

本项目使用 GitHub 管理系统文件和版本历史。

- GitHub 仓库保存公开的系统脚本、模板和说明文档。
- 使用 GitHub Desktop 提交和上传修改。
- 不要将个人项目进度记录、API Key 和私人资料上传到公开仓库。
- 每台 Windows 电脑需要单独配置本机 API Key。
- 使用前先获取最新版本，修改后提交并推送更新。

注意：GitHub 不是实时文件同步工具。
## 排错
- 仪表盘空白：检查 Dataview 是否启用，确认项目目录路径与查询中的路径一致。
- AI 整理失败：原始进度仍会保存，检查 API Key、BaseUrl、Model 和网络，再次输入或手动补充整理。
- 无法运行脚本：右键 bat 运行；或在 PowerShell 中使用 `-STA` 参数启动。
