---
sort: 1
---

# Quick_Start_in_BioOs


# SRA_Analysis_WDL
- An Auto Pipeline
- Robustness
- Designed for Bio-os

Here, we need a script, a program or an other things, to meet our need. 

[![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Courier+New&pause=1000&color=6B4DF7&multiline=true&random=false&width=435&height=80&lines=%E7%AB%99++%E5%9C%A8++%E5%B7%A8++%E4%BA%BA++%E7%9A%84++%E8%82%A9++%E8%86%80++;Stand+on+the+shoulders+of+giants)](https://git.io/typing-svg)

What we need?
-----------------------
We have a platform built for fetch raw sequencing data to our system. Once the data is under our gover, we will get our pipline on woring. Given the complexity of the situation, our tools should be packaged as stand-alone toolkits, or they should take advantage of infrastructure that is readily available.


What we have,now
-----------------------
  - 10X Cellranger count WDL
  - 10X Cellranger ATAC count WDL
  - 10X Cellranger VDJ WDL
  - 10X Spaceranger WDL
  - 10X Cellranger multi WDL (for GEX + VDJ-T/VDJ-B or both of them)
  - SeqWell & Drop-seq & BD WDL (STARsolo)
  - SMART-seq WDL (STARsolo, too)
`Praise the god of STAR`

  - Dockers at here: `https://hub.docker.com/repositories/ooaahhdocker`


Update
-----------------------

### 2024.10.10 : let's have a try
Try using rust as an encapsulation for the command part of the wdl, replacing python.
The results are here: `_SRAtoFastqgz/2.0_rust`. 

I'm looking forward to this being a start, a start to be able to judge the type of vdj files (or any other files) quickly.

### 2024.10.9 : ATTENTON!
All of those images' name should be replaced as followed.
  - **registry-vpc.miracle.ac.cn/gznl/**
    - registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/ooaahhdocker/python_pigz:1.0
    - registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/py39_scanpy1-10-1
    - registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/starsolo2:3.0
    - registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/starsolo2:2.0
    - registry-vpc.miracle.ac.cn/gznl/python:3.9.19-slim-bullseye

### 2024.5.14 : Function added
  - For cellranger count WDL, updated naming conventions of h5ad files.
    - `filtered_feature_bc_matrix.h5ad` convert to `~{sample}_filtered_feature_bc_matrix.h5ad`

### 2024.5.11 : Refining Code Logic
  - When handling the extraction of SRA files to fastq files, an issue with file attribution was encountered, making it difficult to accurately determine the correct naming of the extracted fastq files. Solution: The R1 data contains a large number of duplicate sequences composed of barcodes and UMIs. When performing high compression ratio file compression, the size of the R1 data file should be smaller than that of R2.
  - Simply reverse the order of the file compression and renaming logic.

### 2024.5.9 : multi need to set NA as []
  - Array[File] Cannot accept input with an empty string, use [] as insted.


### 2024.5.4 : Updated naming logic for files
  - The extent of the impact "SRA > fastq.gz"

### 2024.4.28 : Added unplanned WDL files
  - 10X Cellranger multi WDL

### 2024.4.28 : Bugs fix
  - For VDJ files(SRA), we have to use parameters: "`--split-file` combined with `--include-technologies`".
  - ps. For SpaceRanger, we need to use parameters `--split-3`. Therefore, in the case of 10X, we need to choose the appropriate workflow for the specific situation.

### 2024.4.26 : Function added
  - For local fastq files, I had added `cellranger_singleFile.wdl`.

### 2024.4.23 : Function added
  - Increased the output of h5ad&bam files as much as possible.

### 2024.4.22 : Added STARsolo WDL files, which could used in BD&SeqWell&Dropseq, without umitools.
  - ps. Set `--soloBarcodeReadLength=0` to skip the barcode and umi checks.
  - Docker pull: ooaahhdocker/starsolo2:3.0, with python3.9/scanpy1.10.1/star2.7.11 inside.
  - Attention!
    - To make the agreement between STARsolo and CellRanger even more perfect, you can add
    
    `args_dict['--genomeSAsparseD'] = ['3']`
    
    - CellRanger 3.0.0 use advanced filtering based on the EmptyDrop algorithm developed by Lun et al. This algorithm calls extra cells compared to the knee filtering, allowing for       cells that have relatively fewer UMIs but are transcriptionally different from the ambient RNA. In STARsolo, this filtering can be activated by:
    
    `args_dict['--soloCellFilter'] =['EmptyDrops_CR']`

### 2024.4.16 : Must come with full image information, slide number, etc.
  - For spaceranger, complete image information is a must, and the data provided by some authors is incomplete.

### 2024.4.12 : The technical roadmap has been updated, and sra files are now reused using fasterq-dump
  - Docker pull: ooaahhdocker/python_pigz:1.0 with python3.9/pigz, which meet fastq file to fastq compressed file fast implementation.

### 2024.4.11 : Resolving compatibility issues
  - Lower versions of cellranger(2.9.6) are unable to handle newer 10X scRNA-seq data.
  - Added a way to externally import the cellranger package

## 音频
<audio controls>
  <source src="music/Retirement.mp3" type="audio/mp3">
</audio>

## 视频youtobe
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/mgbjhzDndOY?si=n7WVtwtU2q5XKxft" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

## 视频bilibili
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="//player.bilibili.com/player.html?isOutside=true&aid=113350260297623&bvid=BV1QvyHYeEuE&cid=26410156129&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>
</div>
