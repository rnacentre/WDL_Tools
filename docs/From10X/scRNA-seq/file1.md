# file1

source: `{{ page.path }}`

# 示例代码块

以下是一个带行号的 JSON 代码块示例：

<pre class="highlight"><code class="language-json">
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
    "reference_genome_tar_gz": "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz",
    "run_id": "ERR8048237",
    "sample": "5891STDY8062334",
    "secondary": "False"
  }
}
</code></pre>


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

请参考上面的 JSON 配置示例。
