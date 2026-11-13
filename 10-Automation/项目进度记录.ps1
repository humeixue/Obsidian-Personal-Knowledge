param([string]$VaultPath = '')
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$pkRoot = Split-Path -Parent $PSScriptRoot
if (-not $VaultPath) { $VaultPath = Split-Path -Parent $pkRoot }
$projectsRoot = Join-Path $pkRoot '01-Learning-Topics\项目'
if (-not (Test-Path $projectsRoot)) { throw "找不到项目目录：$projectsRoot" }
$projects = Get-ChildItem -LiteralPath $projectsRoot -Directory | Where-Object { $_.Name -ne '项目模板' }
if (-not $projects) { [System.Windows.Forms.MessageBox]::Show('请先在 01-Learning-Topics/项目 下创建至少一个项目文件夹。','项目进度记录') | Out-Null; exit }

$form = New-Object Windows.Forms.Form
$form.Text = '快速记录项目进度'
$form.Size = New-Object Drawing.Size(720,560)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true
$form.Font = New-Object Drawing.Font('Microsoft YaHei UI',10)

$lblP = New-Object Windows.Forms.Label; $lblP.Text='所属项目'; $lblP.Location='20,20'; $lblP.Size='100,25'; $form.Controls.Add($lblP)
$combo = New-Object Windows.Forms.ComboBox; $combo.Location='130,17'; $combo.Size='540,28'; $combo.DropDownStyle='DropDownList'
[void]$combo.Items.AddRange([object[]]@($projects.Name)); $combo.SelectedIndex=0; $form.Controls.Add($combo)
$lblC = New-Object Windows.Forms.Label; $lblC.Text='进度类型'; $lblC.Location='20,60'; $lblC.Size='100,25'; $form.Controls.Add($lblC)
$cat = New-Object Windows.Forms.ComboBox; $cat.Location='130,57'; $cat.Size='250,28'; $cat.DropDownStyle='DropDownList'
[void]$cat.Items.AddRange([object[]]@('项目建设','技术测试','问题排查','问题解决','方案调整','资料整理','阶段成果','其他')); $cat.SelectedIndex=0; $form.Controls.Add($cat)
$lblT = New-Object Windows.Forms.Label; $lblT.Text='本次进度'; $lblT.Location='20,100'; $lblT.Size='100,25'; $form.Controls.Add($lblT)
$body = New-Object Windows.Forms.TextBox; $body.Location='20,130'; $body.Size='650,320'; $body.Multiline=$true; $body.ScrollBars='Vertical'; $body.AcceptsReturn=$true; $body.AcceptsTab=$true; $form.Controls.Add($body)
$hint = New-Object Windows.Forms.Label; $hint.Text='直接写本次做了什么、结果如何、遇到什么问题；AI 会整理成独立记录。'; $hint.Location='20,460'; $hint.Size='650,25'; $form.Controls.Add($hint)
$ok = New-Object Windows.Forms.Button; $ok.Text='保存进度'; $ok.Location='480,490'; $ok.Size='90,32'; $ok.DialogResult='OK'; $form.Controls.Add($ok)
$cancel = New-Object Windows.Forms.Button; $cancel.Text='取消'; $cancel.Location='580,490'; $cancel.Size='90,32'; $cancel.DialogResult='Cancel'; $form.Controls.Add($cancel)
$form.AcceptButton=$ok; $form.CancelButton=$cancel
if ($form.ShowDialog() -ne 'OK') { exit }
$raw = $body.Text.Trim(); if (-not $raw) { [Windows.Forms.MessageBox]::Show('请先输入本次进度。','提示') | Out-Null; exit }
$projectName = [string]$combo.SelectedItem; $category = [string]$cat.SelectedItem
$projectDir = Join-Path $projectsRoot $projectName
$recordDir = Join-Path $projectDir '进度记录'; New-Item -ItemType Directory -Force -Path $recordDir | Out-Null
$now = Get-Date; $date = $now.ToString('yyyy-MM-dd'); $stamp = $now.ToString('yyyyMMdd-HHmmss')
$title = "$date 项目进度"
$summary = $raw -replace '\s+',' '
$completed=@(); $problems=@(); $results=@(); $next=@(); $aiStatus='pending'; $aiBody=$null
$keyFile = Join-Path $env:LOCALAPPDATA 'ObsidianAI\progress-key.dpapi'
$configPath = Join-Path $PSScriptRoot '项目进度AI配置.json'
if (-not (Test-Path $configPath)) { $configPath = Join-Path $PSScriptRoot '项目进度AI配置.example.json' }
if (Test-Path $keyFile) {
  try {
    $secure = Get-Content -Raw $keyFile | ConvertTo-SecureString
    $ptr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { $apiKey=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
    $cfg=Get-Content -Raw $configPath | ConvertFrom-Json
    $systemPrompt=Get-Content -Raw (Join-Path $PSScriptRoot '项目进度AI整理提示词.md')
    $payload=@{model=$cfg.Model;temperature=$cfg.Temperature;messages=@(@{role='system';content=$systemPrompt},@{role='user';content="项目：$projectName`n记录类型：$category`n日期：$date`n原始进度：`n$raw"})} | ConvertTo-Json -Depth 8
    $resp=Invoke-RestMethod -Uri $cfg.BaseUrl -Method Post -Headers @{Authorization="Bearer $apiKey"} -ContentType 'application/json; charset=utf-8' -Body ([Text.Encoding]::UTF8.GetBytes($payload)) -TimeoutSec ([int]$cfg.TimeoutSeconds)
    $content=[string]$resp.choices[0].message.content
    $content=$content -replace '^\s*```(?:json)?\s*','' -replace '\s*```\s*$',''
    $obj=$content | ConvertFrom-Json
    if ($obj.title) {$title=[string]$obj.title}; if ($obj.summary) {$summary=[string]$obj.summary}
    if ($obj.completed) {$completed=@($obj.completed)}; if ($obj.problems) {$problems=@($obj.problems)}; if ($obj.results) {$results=@($obj.results)}; if ($obj.next_steps) {$next=@($obj.next_steps)}
    if ($obj.body) {$aiBody=[string]$obj.body} else {$aiBody=$null}
    if ($obj.category) {$category=[string]$obj.category}; $aiStatus='processed'
  } catch { $aiStatus='pending'; $aiBody=$null; $aiError=$_.Exception.Message }
} else { $aiError='尚未配置 API Key。' }
function MdList($arr) { if (-not $arr -or $arr.Count -eq 0) { return '- 暂无记录' }; return (($arr | ForEach-Object { '- ' + [string]$_ }) -join "`n") }
if ($aiBody) { $contentBody=$aiBody } else { $contentBody="## 本次进度`n`n$raw`n`n## AI整理状态`n`nAI 尚未完成整理；原始内容已安全保存。配置 API Key 后可重新整理。" }
$safeTitle=($title -replace '[\\/:*?"<>|]','-' -replace '\s+',' ').Trim()
$file=Join-Path $recordDir ("$stamp-$safeTitle.md")
$yamlProject='"[['+$projectName+']]"'
$summaryYaml=ConvertTo-Json -InputObject $summary -Compress
$md=@"
---
type: project_progress
project: $yamlProject
date: $date
created: $($now.ToString('yyyy-MM-dd HH:mm:ss'))
category: $category
ai_status: $aiStatus
source: quick-capture
summary: $summaryYaml
tags:
  - 项目进度
---

# $title

$contentBody

## 原始记录

$raw
"@
Set-Content -LiteralPath $file -Value $md -Encoding UTF8
# create project dashboard if absent; Dataview query uses this project's own folder
$dash=Join-Path $projectDir '项目进度总览.md'
if (-not (Test-Path $dash)) {
  $relative = "01-Learning-Topics/项目/$projectName/进度记录"
  $dashText=@"
---
type: project_progress_dashboard
project_name: "$projectName"
---

# $projectName｜项目进度总览

## 最近进度
````dataview
TABLE date AS 日期, category AS 类型, file.link AS 记录, summary AS 摘要
FROM "$relative"
WHERE type = "project_progress"
SORT date DESC
LIMIT 30
````

## 全部进度时间线
````dataview
TABLE date AS 日期, category AS 类型, file.link AS 记录, summary AS 摘要
FROM "$relative"
WHERE type = "project_progress"
SORT date DESC
````
"@
  Set-Content -LiteralPath $dash -Value $dashText -Encoding UTF8
}
$hub=Join-Path $pkRoot '07-MOCs\AI项目进度中心.md'
if (-not (Test-Path $hub)) { [Windows.Forms.MessageBox]::Show("进度已保存：`n$file`n`n全局进度中心文件缺失，请重新解压升级包中的 07-MOCs/AI项目进度中心.md。",'保存成功') | Out-Null }
else { [Windows.Forms.MessageBox]::Show("进度已保存：`n$title`n项目：$projectName`nAI整理状态：$aiStatus",'保存成功') | Out-Null }
