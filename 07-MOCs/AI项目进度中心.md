---
type: project_progress_hub
---

# AI项目进度中心

> 所有项目的进度记录自动汇总于此。每条进度独立保存为 Markdown 文件；本页通过 Dataview 自动读取，不需要手动维护。

## 项目概况
```dataview
TABLE length(rows) AS 累计记录, max(rows.date) AS 最近更新
FROM "01-Learning-Topics/项目"
WHERE type = "project_progress"
GROUP BY project AS 项目
SORT max(rows.date) DESC
```

## 最近进度
```dataview
TABLE date AS 日期, project AS 项目, category AS 类型, file.link AS 记录, summary AS 摘要
FROM "01-Learning-Topics/项目"
WHERE type = "project_progress"
SORT date DESC
LIMIT 50
```

## 各项目进度时间线
```dataview
TABLE date AS 日期, category AS 类型, file.link AS 记录, summary AS 摘要
FROM "01-Learning-Topics/项目"
WHERE type = "project_progress"
SORT date DESC
```

## 每周记录数量
```dataview
TABLE length(rows) AS 记录数
FROM "01-Learning-Topics/项目"
WHERE type = "project_progress"
GROUP BY dateformat(date, "kkkk-'W'WW") AS 周次
SORT key DESC
```

## 项目列表
```dataview
TABLE project_status AS 状态, file.link AS 项目档案
FROM "01-Learning-Topics/项目"
WHERE type = "project"
SORT file.name ASC
```
