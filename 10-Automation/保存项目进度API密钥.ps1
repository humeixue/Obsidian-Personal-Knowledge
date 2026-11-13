$ErrorActionPreference = 'Stop'
$dir = Join-Path $env:LOCALAPPDATA 'ObsidianAI'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$key = Read-Host '请输入 DeepSeek API Key（输入内容不会显示）' -AsSecureString
$key | ConvertFrom-SecureString | Set-Content -Encoding UTF8 (Join-Path $dir 'progress-key.dpapi')
Write-Host '密钥已使用当前 Windows 用户 DPAPI 加密保存到本机，不会写入 Vault 。'
