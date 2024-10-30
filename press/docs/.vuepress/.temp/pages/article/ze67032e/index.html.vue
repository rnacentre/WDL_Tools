<template><div><p>为了便于工作流的可重复性，我们推荐您使用json文件来描述和存档您的实验参数。</p>
<h1 id="写在前面" tabindex="-1"><a class="header-anchor" href="#写在前面"><span>写在前面</span></a></h1>
<p>这里会涉及到BioOS文件管理的相关内容，请参考<RouteLink to="/BioOS/">BioOS文件管理</RouteLink></p>
<p>在这里，我们假设您已经对平台的使用有了基础的了解，并创建了必要的文件夹。如果还没有，请参考<RouteLink to="/BioOS/">动手学BioOS计算</RouteLink></p>
<p>请注意，我们不要求您对json文件、WDL文件或者云计算有深入的了解，您只需要知道如何使用json文件来描述您的实验参数。我们的目标是您只需要知道如何“复制、粘贴”就能完成您的实验。</p>
<p>让我们开始吧！</p>
<h2 id="对于一个典型的10x-genomics-scrna-seq实验-我们推荐使用如下的json文件" tabindex="-1"><a class="header-anchor" href="#对于一个典型的10x-genomics-scrna-seq实验-我们推荐使用如下的json文件"><span>对于一个典型的10X Genomics scRNA-seq实验，我们推荐使用如下的json文件：</span></a></h2>
<div class="language-json line-numbers-mode" data-ext="json" data-title="json"><button class="copy" title="复制代码" data-copied="已复制"></button><pre class="shiki shiki-themes light-plus aurora-x vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">{</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.chemistry</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">auto</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.cpu</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#098658;--shiki-dark:#F78C6C"> 32</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.disk_space</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">300 GB</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.fastq_file_paths</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#0000FF;--shiki-dark:#F78C6C"> null</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.memory</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">225 GB</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.no_bam</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">False</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.reference_genome_tar_gz</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.run_id</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#0000FF;--shiki-dark:#F78C6C"> null</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.sample</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#0000FF;--shiki-dark:#F78C6C"> null</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.secondary</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">False</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span></span>
<span class="line"><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">}</span></span></code></pre>

<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>看起来很复杂，但没关系。仔细观察，您会发现，这个json文件的部分参数已经自动设置好了，在大部分情况下，您只需要依次填写您自己的参数即可。</p>
<p>（markdown格式 引用 可折叠 或者 展开上标引用）注释：作为快速上手教程，我们不对具体的参数做出解释，具体的参数的解释请参考<a href="https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/count" target="_blank" rel="noopener noreferrer">10X Genomics官方文档</a>，在支持文档，我们也会对一些关键参数做出解释。</p>
<p>这里我们给出了填写示例：</p>
<blockquote>
<p><strong>注意这几个存在内容新增的部分</strong></p>
</blockquote>
<div class="language-json line-numbers-mode" data-ext="json" data-title="json"><button class="copy" title="复制代码" data-copied="已复制"></button><pre class="shiki shiki-themes light-plus aurora-x has-diff vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">{</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.chemistry</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">auto</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.cpu</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#098658;--shiki-dark:#F78C6C"> 32</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.disk_space</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">300 GB</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.fastq_file_paths</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF"> [</span><span style="--shiki-light:#000000;--shiki-dark:#BBBBBB"> </span></span>
<span class="line diff add"><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">    "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_I1_001.fastq.gz</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line diff add"><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">    "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_R1_001.fastq.gz</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line diff add"><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">    "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/ERR8048237/5891STDY8062334_S1_L001_R2_001.fastq.gz</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span></span>
<span class="line"><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">  ],</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.memory</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">225 GB</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.no_bam</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">False</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.reference_genome_tar_gz</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">s3://bioos-wcnjupodeig44rr6t02v0/Example_10X_data/RAW/refdata-cellranger-GRCh38-3.0.0.tar.gz</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line diff add"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.run_id</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">ERR8048237</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line diff add"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.sample</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">5891STDY8062334</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">,</span></span>
<span class="line"><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">  "</span><span style="--shiki-light:#0451A5;--shiki-dark:#C792EA">cellranger_count_workflow.secondary</span><span style="--shiki-light:#0451A5;--shiki-dark:#89DDFF">"</span><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">:</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF"> "</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">False</span><span style="--shiki-light:#A31515;--shiki-dark:#89DDFF">"</span></span>
<span class="line"><span style="--shiki-light:#000000;--shiki-dark:#89DDFF">}</span></span></code></pre>

<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><p>是的，就是这么简单。我们添加了文件路径，并填写了run_id和sample。这和您在本地计算的参数填写逻辑是一样的。我们已经准备好了，现在就提交任务吧！</p>
<h2 id="提交任务" tabindex="-1"><a class="header-anchor" href="#提交任务"><span>提交任务</span></a></h2>
<p>让我们回到BioOS平台，来到我们的cellrangerTest页面。试试看，找到页面上的&quot;运行参数&quot;选项卡&gt;输入参数&gt;&quot;上传JSON文件&quot;，将您的json文件上传。</p>
<p>然后，点击页面上的绿色按钮&quot;开始分析&quot;，等待任务完成。</p>
<ImageCard
  image="/Pics/scfig1_gif.gif"
  title="注意右上角的绿色按钮"
  description="注意右上角的绿色按钮，点击即可开始分析，并在3秒后自动跳转到分析历史界面。"
  href="/"
  author="Hughes"
  date="2024/10/30"
/>
<h2 id="查看结果" tabindex="-1"><a class="header-anchor" href="#查看结果"><span>查看结果</span></a></h2>
<p>任务完成后，您可以在分析历史中看到您的任务。点击任务名称，进入任务详情页面。在任务详情页面，您可以查看/下载结果。</p>
<ImageCard
  image="/Pics/scfig2_gif.gif"
  title="任务分析历史"
  description="现在这张图片展示了任务分析历史的详情，选中本次进行的实验。新的页面展示了本次实验的所有状态信息，你可以在这里再次查阅输入和输出参数。当然你也可以在这里查看或下载结果。"
  href="/"
  author="Hughes"
  date="2024/10/30"
/>
<p>点击&quot;查看&quot;，让我们来看看结果吧！所有的结果文件都会列出在这里，除了结果之外，也包括运行日志等文件，这取决于WDL文件的具体设置。</p>
<div class="language-bash line-numbers-mode" data-ext="bash" data-title="bash"><button class="copy" title="复制代码" data-copied="已复制"></button><pre class="shiki shiki-themes light-plus aurora-x vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"># 在本例中，你的文件结构是这个样子：</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">全部文件/analysis/$投递任务ID/$WDL_Task_ID/$workflow标识ID/call-$WDL_Task_ID/</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> execution</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> PRJNA693201_dlst000564_SRR13482541</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   │</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   └──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> outs</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   │</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">       ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> PRJNA693201_dlst000564_SRR13482541_filtered_feature_bc_matrix.h5ad</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   │</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">       ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> metrics_summary.csv</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   │</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">       ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> possorted_genome_bam.bam</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   │</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">       └──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> web_summary.html</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> PRJNA693201_dlst000564_SRR13482541_outs.tar.gz</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> log</span><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"> # cromwell 日志文件</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> rc</span><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"> # cromwell 运行时文件</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> script</span><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"> # cromwell 脚本文件</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   ├──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> stderr</span><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"> # cromwell 标准错误文件</span></span>
<span class="line"><span style="--shiki-light:#795E26;--shiki-dark:#FFCB6B">│</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D">   └──</span><span style="--shiki-light:#A31515;--shiki-dark:#C3E88D"> stdout</span><span style="--shiki-light:#008000;--shiki-light-font-style:inherit;--shiki-dark:#546E7A;--shiki-dark-font-style:italic"> # cromwell 标准输出文件</span></span></code></pre>

<div class="line-numbers" aria-hidden="true" style="counter-reset:line-number 0"><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div><div class="line-number"></div></div></div><blockquote>
<p>我们在这里展示的是一个多样本的分析结果（如果您按照上图的方法点击查看结果），所以您会看到多个样本的结果文件夹。让我们逐级打开文件夹，找到我们需要的文件。所有的日志以及结果文件都会列出在这里。</p>
</blockquote>
<p>在这个示例中，我们需要的文件在 <strong>&quot;outs&quot;</strong> 文件夹中，让我们逐渐深入文件夹，找到我们需要的文件。</p>
<ImageCard
  image="/Pics/scfig3_gif.gif"
  title="查看工作流的计算结果"
  description="让我们逐级打开文件夹，找到我们需要的文件。所有的日志以及结果文件都会列出在这里。"
  href="/"
  author="Hughes"
  date="2024/10/30"
/>
<h1 id="🤔-如果你想在本地查看结果" tabindex="-1"><a class="header-anchor" href="#🤔-如果你想在本地查看结果"><span>🤔 如果你想在本地查看结果？</span></a></h1>
<p>我们需要这里的 <strong>$ID_filtered_feature_bc_matrix.h5ad</strong> 文件，让我们点击下载。</p>
<ImageCard
  image="/Pics/scfig4_gif.gif"
  title="下载我们感兴趣的结果"
  description="这里我们展示了如何下载我们感兴趣的结果。我们逐级打开目录，到最后一层。然后在我们感兴趣的结果后面点击下载。"
  href="/"
  author="Hughes"
  date="2024/10/30"
/>
<p>🎊Bravo!🎊 到此为止，您已经掌握了BioOS的基本使用方法，并成功完成了一次10X Genomics scRNA-seq的分析。👏👏👏</p>
<h1 id="如果我有很多数据呢" tabindex="-1"><a class="header-anchor" href="#如果我有很多数据呢"><span>如果我有很多数据呢？</span></a></h1>
<p><strong>🤔好，那么好，这时候可能就会有人问了，如果我们有很多数据，也要像这样一个一个点击吗？</strong></p>
<blockquote>
<p>非常好的问题！当你尝试把一件简单的事情重复做上一万遍的时候，其复杂度将会指数增加📈。</p>
</blockquote>
<p><strong>当然不是</strong>，我们在这里只展示了BioOS的冰山一角，BioOS的真正能力将在您尝试构建数据模型/实体之后展现。下面，让我们从一个稍微复杂的例子开始，一步一步的学习如何调度BioOS强大的计算能力。</p>
</div></template>


