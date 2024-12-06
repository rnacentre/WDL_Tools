version 1.0

task rename_fastq_files_based_on_size {
  input {
    Array[File] fastq_file_paths
    String sample_name
    String disk_space = "150 GB"
    Int cpu = 1 
  }

  command <<<
    python3 <<CODE
    import os
    import shutil

    # Convert file paths from WDL array to Python list
    files = ["~{sep='", "' fastq_file_paths}"]
    sample_name = "~{sample_name}"

    # Calculate file sizes and sort them
    file_sizes = [(f, os.path.getsize(f)) for f in files]
    file_sizes.sort(key=lambda x: x[1])

    # Initialize variables to hold file paths
    i1_file, r1_file, r2_file = None, None, None

    # Determine the number of files and assign accordingly
    if len(files) == 2:
        r1_file, r2_file = file_sizes[0][0], file_sizes[1][0]
    elif len(files) == 3:
        i1_file, r1_file, r2_file = file_sizes[0][0], file_sizes[1][0], file_sizes[2][0]

    # Define new filenames
    i1_new_filename = f"{sample_name}_S1_L001_I1_001.fastq.gz" if i1_file else None
    r1_new_filename = f"{sample_name}_S1_L001_R1_001.fastq.gz"
    r2_new_filename = f"{sample_name}_S1_L001_R2_001.fastq.gz"

    # Copy and rename files
    if i1_file:
        shutil.copy2(i1_file, i1_new_filename)
    shutil.copy2(r1_file, r1_new_filename)
    shutil.copy2(r2_file, r2_new_filename)

    # Output new filenames for verification
    if i1_new_filename:
        print(i1_new_filename)
    print(r1_new_filename)
    print(r2_new_filename)
    CODE
    ls -l
  >>>

  output {
    String sample_name_out = sample_name
    File r1 = "${sample_name}_S1_L001_R1_001.fastq.gz"
    File r2 = "${sample_name}_S1_L001_R2_001.fastq.gz"
    File? i1 = "${sample_name}_S1_L001_I1_001.fastq.gz"
    # 如果有时候没有I1数据，就在命令中不处理或生成空文件，让其存在但不影响结果
    Array[File] renamed_fastq_files = select_all([i1, r1, r2])
  }

  runtime {
    docker: "registry-vpc.miracle.ac.cn/gznl/ooaahhdocker/python_pigz:1.0"
    cpu: cpu
    disk: disk_space
  }
}

