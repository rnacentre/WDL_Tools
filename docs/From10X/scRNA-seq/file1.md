
**注意事项：**
- 确保在代码块前后至少有一个空行或使用水平分隔符（如 `---` 或 `***`），以防止解析器将下方文本包含在代码块中。
- 使用三反引号（```）包裹代码，并在第一行反引号后指定代码语言（如 `json`）。

## 2. 在每个 Markdown 文件中添加内联样式

在每个需要显示代码块行号的 Markdown 文件顶部或适当的位置，添加一个 `<style>` 块，定义必要的 CSS 样式。这样可以确保每个文件独立地应用这些样式，而无需依赖外部 CSS 文件。

### 示例：

```markdown
---
title: "WDL_Tools的BioOS实践"
---

<style>
/* Rouge 行号样式 */
.highlight table {
  width: 100%;
  border-spacing: 0;
}

.highlight td.rouge-gutter {
  width: 2.5em;
  padding-right: 0.5em;
  text-align: right;
  vertical-align: top;
  color: #999;
  user-select: none;
}

.highlight td.rouge-code {
  width: 100%;
}

.highlight pre {
  margin: 0;
  padding: 0;
  background: none;
}

/* 自定义行号样式 */
.highlight pre {
  position: relative;
  padding-left: 3em; /* 为行号留出空间 */
  counter-reset: linenumber;
}

.highlight pre code {
  display: block;
  counter-reset: linenumber;
}

.highlight pre code .line {
  display: block;
  counter-increment: linenumber;
  position: relative;
  padding-left: 1em;
}

.highlight pre code .line::before {
  content: counter(linenumber);
  position: absolute;
  left: -1em;
  width: 1em;
  text-align: right;
  color: #999;
}
</style>

# 示例代码块

以下是一个带行号的 JSON 代码块示例：

```json
{
  "cellranger_count_workflow": {
    "chemistry": "auto",
    "cpu": 32,
    "disk_space": "300 GB",
    "fastq_file_paths": [
      "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_I1_001.fastq.gz",
      "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_R1_001.fastq.gz",
      "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_R2_001.fastq.gz"
    ],
    "memory": "225 GB",
    "no_bam": "False",
    "reference_genome_tar_gz": "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz",
    "run_id": "ERR8048237",
    "sample": "5891STDY8062334",
    "secondary": "False"
  }
}
```
请参考上面的 JSON 配置示例。
---
请参考上面的 JSON 配置示例。
