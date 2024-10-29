# scRNA-seq
您的位置：source: `{{ page.path }}`

# 10X Genomics scRNA-seq
为了便于工作流的可重复性，我们推荐您使用json文件来描述和存档您的实验参数。

# 写在前面
这里会涉及到BioOS文件管理的相关内容，请参考[BioOS文件管理（待完善）](../BioOS/README.md)

在这里，我们假设您已经对平台的使用有了基础的了解，并创建了必要的文件夹。如果还没有，请参考[动手学BioOS计算](../BioOS/README.md)

请注意，我们不要求您对json文件、WDL文件或者云计算有深入的了解，您只需要知道如何使用json文件来描述您的实验参数。我们的目标是您只需要知道如何“复制、粘贴”就能完成您的实验。

让我们开始吧！

# 对于一个典型的10X Genomics scRNA-seq实验，我们推荐使用如下的json文件：

~~~  json
{
  "cellranger_count_workflow.chemistry": "auto",
  "cellranger_count_workflow.cpu": 32,
  "cellranger_count_workflow.disk_space": "300 GB",
  "cellranger_count_workflow.fastq_file_paths": null,
  "cellranger_count_workflow.memory": "225 GB",
  "cellranger_count_workflow.no_bam": "False",
  "cellranger_count_workflow.reference_genome_tar_gz": "s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz",
  "cellranger_count_workflow.run_id": null,
  "cellranger_count_workflow.sample": null,
  "cellranger_count_workflow.secondary": "False"
}
~~~



