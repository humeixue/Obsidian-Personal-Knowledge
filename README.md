# Obsidian 个人知识库

一套基于 **Obsidian + Markdown** 的个人知识库模板，内置「多项目进度记录」系统：在 Windows 弹窗里写下今天的进展，脚本自动整理成结构化的 Markdown，再由 Dataview 汇总成全局仪表盘。

> 本仓库只包含模板、脚本和说明文档，**不包含任何个人笔记、进度记录或 API Key**。

## 目录结构

| 目录 | 用途 |
| --- | --- |
| `00-Inbox` | 快速记录入口，随手记下的东西先丢这里 |
| `01-Learning-Topics` | 学习主题与项目档案，每个子文件夹是一个项目 |
| `02-Learning-Events` | 学习事件记录 |
| `03-Breakthroughs` | 知识突破 / 卡点复盘 |
| `04-Knowledge` | 原子化知识卡片 |
| `05-Explorations` | 待探索的问题 |
| `06-Reviews/Weekly` | 每周复盘 |
| `07-MOCs` | 知识地图与 AI 项目进度中心（Dataview 仪表盘） |
| `08-AI-Analysis` | AI 整理结果、研究建议、Copilot 提示词 |
| `09-Templates` | 各类笔记模板 |
| `10-Automation` | 进度记录脚本与配置说明 |

## 快速开始

1. 下载仓库，把内容合并进你的 Obsidian Vault 根目录（建议先备份）。
2. 在 Obsidian 中安装并启用社区插件 **Dataview**。
3. 在 `01-Learning-Topics/项目/` 下新建项目文件夹，例如 `AI视觉`、`AI视频生成`。
4. 双击 `10-Automation/启动项目进度记录.bat`，选择项目 → 选择类型 → 输入本次进展 → 保存。
5. 打开 `07-MOCs/AI项目进度中心.md`，查看自动汇总的进度、时间线与统计。

详细说明见 [`README-先看这里.md`](README-先看这里.md)。

## 核心特性

- **一次记录一个文件**：文件名带时间戳，同一天多次记录也不会互相覆盖。
- **自动仪表盘**：全局进度中心 + 每个项目自己的进度总览，全部由 Dataview 查询生成，无需手工维护索引。
- **AI 整理可选**：配置 DeepSeek API 后自动整理成统一结构；未配置或调用失败时，原始文字依然完整保存。
- **多项目并行**：所有项目共用同一个输入窗口和同一套规则，新增项目只需新建文件夹。
- **纯本地**：不监听截图、不做 OCR，笔记始终以纯 Markdown 存在本地。

## 环境要求

- Windows 10 / 11
- [Obsidian](https://obsidian.md/) 桌面版
- 社区插件 **Dataview**（仪表盘必需）
- 可选：DeepSeek API Key（启用 AI 整理），本地加密保存在 `%LOCALAPPDATA%\ObsidianAI\`，不写入 Vault

## 说明

- 项目进度默认记录在 `01-Learning-Topics/项目/<项目名>/进度记录/`，该目录已被 `.gitignore` 排除。
- API 密钥通过当前 Windows 用户的 DPAPI 加密，每台电脑需单独配置。
- GitHub 只用于管理版本，不是实时同步工具。

## 相关文档

- [`README-先看这里.md`](README-先看这里.md) —— 系统总览与日常流程
- [`10-Automation/README-项目进度模块.md`](10-Automation/README-项目进度模块.md) —— 进度记录模块安装与排错
