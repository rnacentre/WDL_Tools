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

示例代码块

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

~~~


# 请参考上面的 JSON 配置示例。
